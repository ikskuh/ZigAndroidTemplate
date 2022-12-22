const std = @import("std");

const android = @import("android");

pub const panic = android.panic;
pub const log = android.log;

const EGLContext = android.egl.EGLContext;
const JNI = android.JNI;
const c = android.egl.c;
const NativeInvocationHandler = android.NativeInvocationHandler;

const app_log = std.log.scoped(.app);
comptime {
    _ = android.ANativeActivity_createFunc;
    _ = @import("root").log;
}

pub fn timerInvoke(_: ?*anyopaque, jni: JNI, method: android.jobject, args: android.jobjectArray) void {
    _ = jni;
    _ = method;
    _ = args;
    std.log.info("Running timer!", .{});
}

pub const AndroidApp = struct {
    allocator: std.mem.Allocator,
    activity: *android.ANativeActivity,
    thread: ?std.Thread = null,
    running: bool = true,

    // The JNIEnv of the UI thread
    uiJni: JNI = undefined,
    // The JNIEnv of the app thread
    mainJni: JNI = undefined,

    invocation_handler: NativeInvocationHandler = undefined,

    // This is needed because to run a callback on the UI thread Looper you must
    // react to a fd change, so we use a pipe to force it
    pipe: [2]std.os.fd_t = undefined,
    // This is used with futexes so that runOnUiThread waits until the callback is completed
    // before returning.
    uiThreadCondition: std.atomic.Atomic(u32) = std.atomic.Atomic(u32).init(0),
    uiThreadLooper: *android.ALooper = undefined,
    uiThreadId: std.Thread.Id = undefined,

    pub fn init(allocator: std.mem.Allocator, activity: *android.ANativeActivity, stored_state: ?[]const u8) !AndroidApp {
        _ = stored_state;

        return AndroidApp{
            .allocator = allocator,
            .activity = activity,
        };
    }

    pub fn start(self: *AndroidApp) !void {
        // Initialize the variables we need to execute functions on the UI thread
        self.uiThreadLooper = android.ALooper_forThread().?;
        self.uiThreadId = std.Thread.getCurrentId();
        self.pipe = try std.os.pipe();
        android.ALooper_acquire(self.uiThreadLooper);

        var jni = JNI.init(self.activity);
        self.uiJni = jni;

        // Get the window object attached to our activity
        const activityClass = jni.findClass("android/app/NativeActivity");
        const getWindow = jni.invokeJni(.GetMethodID, .{ activityClass, "getWindow", "()Landroid/view/Window;" });
        const activityWindow = jni.invokeJni(.CallObjectMethod, .{ self.activity.clazz, getWindow });
        const WindowClass = jni.findClass("android/view/Window");

        try self.runTimer(jni);

        // This disables the surface handler set by default by android.view.NativeActivity
        // This way we let the content view do the drawing instead of us.
        const takeSurface = jni.invokeJni(.GetMethodID, .{ WindowClass, "takeSurface", "(Landroid/view/SurfaceHolder$Callback2;)V" });
        jni.invokeJni(.CallVoidMethod, .{
            activityWindow,
            takeSurface,
            @as(android.jobject, null),
        });

        // Do the same but with the input queue. This allows the content view to handle input.
        const takeInputQueue = jni.invokeJni(.GetMethodID, .{ WindowClass, "takeInputQueue", "(Landroid/view/InputQueue$Callback;)V" });
        jni.invokeJni(.CallVoidMethod, .{
            activityWindow,
            takeInputQueue,
            @as(android.jobject, null),
        });
        self.thread = try std.Thread.spawn(.{}, mainLoop, .{self});
    }

    /// Run the given function on the Android UI thread. This is necessary for manipulating the view hierarchy.
    /// Note: this function is not thread-safe, but could be made so simply using a mutex
    pub fn runOnUiThread(self: *AndroidApp, comptime func: anytype, args: anytype) !void {
        if (std.Thread.getCurrentId() == self.uiThreadId) {
            // runOnUiThread has been called from the UI thread.
            @call(.auto, func, args);
            return;
        }

        const Args = @TypeOf(args);
        const allocator = self.allocator;

        const Data = struct { args: Args, self: *AndroidApp };

        const data_ptr = try allocator.create(Data);
        data_ptr.* = .{ .args = args, .self = self };
        errdefer allocator.destroy(data_ptr);

        const Instance = struct {
            fn callback(_: c_int, _: c_int, data: ?*anyopaque) callconv(.C) c_int {
                const data_struct = @ptrCast(*Data, @alignCast(@alignOf(Data), data.?));
                const self_ptr = data_struct.self;
                defer self_ptr.allocator.destroy(data_struct);

                @call(.auto, func, data_struct.args);
                std.Thread.Futex.wake(&self_ptr.uiThreadCondition, 1);
                return 0;
            }
        };

        const result = android.ALooper_addFd(
            self.uiThreadLooper,
            self.pipe[0],
            0,
            android.ALOOPER_EVENT_INPUT,
            Instance.callback,
            data_ptr,
        );
        std.debug.assert(try std.os.write(self.pipe[1], "hello") == 5);
        if (result == -1) {
            return error.LooperError;
        }

        std.Thread.Futex.wait(&self.uiThreadCondition, 0);
    }

    pub fn getJni(self: *AndroidApp) JNI {
        return JNI.get(self.activity);
    }

    pub fn deinit(self: *AndroidApp) void {
        @atomicStore(bool, &self.running, false, .SeqCst);
        if (self.thread) |thread| {
            thread.join();
            self.thread = null;
        }
        android.ALooper_release(self.uiThreadLooper);
        self.uiJni.deinit();
    }

    fn setAppContentView(self: *AndroidApp) void {
        const jni = self.getJni();

        // We create a new TextView..
        std.log.warn("Creating android.widget.TextView", .{});
        const TextView = jni.findClass("android/widget/TextView");
        const textViewInit = jni.invokeJni(.GetMethodID, .{ TextView, "<init>", "(Landroid/content/Context;)V" });
        const textView = jni.invokeJni(.NewObject, .{ TextView, textViewInit, self.activity.clazz });

        // .. and set its text to "Hello from Zig!"
        const setText = jni.invokeJni(.GetMethodID, .{ TextView, "setText", "(Ljava/lang/CharSequence;)V" });
        jni.invokeJni(.CallVoidMethod, .{ textView, setText, jni.newString("Hello from Zig!") });

        // And then we use it as our content view!
        std.log.err("Attempt to call NativeActivity.setContentView()", .{});
        const activityClass = jni.findClass("android/app/NativeActivity");
        const setContentView = jni.invokeJni(.GetMethodID, .{ activityClass, "setContentView", "(Landroid/view/View;)V" });
        jni.invokeJni(.CallVoidMethod, .{
            self.activity.clazz,
            setContentView,
            textView,
        });
    }

    fn mainLoop(self: *AndroidApp) !void {
        self.mainJni = JNI.init(self.activity);
        defer self.mainJni.deinit();

        try self.runOnUiThread(setAppContentView, .{self});
        while (self.running) {
            std.time.sleep(1 * std.time.ns_per_s);
        }
    }

    fn runTimer(self: *AndroidApp, jni: JNI) !void {
        // Get class loader
        // const activityClass = self.activity.clazz;
        const activityClass = jni.findClass("android/app/NativeActivity");
        std.log.info("activityclass {any}", .{activityClass});
        const getClassLoader = jni.invokeJni(.GetMethodID, .{ activityClass, "getClassLoader", "()Ljava/lang/ClassLoader;" });
        std.log.info("getClassLoader {*}", .{getClassLoader});
        const cls = jni.invokeJni(.CallObjectMethod, .{ self.activity.clazz, getClassLoader });
        std.log.info("class_loader instance {any}", .{cls});

        const classLoader = jni.findClass("java/lang/ClassLoader");

        const invocation_handler_class = jni.findClass("NativeInvocationHandler");
        var result = jni.invokeJni(.ExceptionCheck, .{});
        std.log.info("invocation_handler_class {any}, {}", .{ invocation_handler_class, result });
        if (result != 0) jni.invokeJni(.ExceptionClear, .{});
        const invocation_handler_class_full = jni.findClass("net/random_projects/zig_android_template/NativeInvocationHandler");
        result = jni.invokeJni(.ExceptionCheck, .{});
        std.log.info("invocation_handler_class_full {any}, {}", .{ invocation_handler_class_full, result });
        if (result != 0) jni.invokeJni(.ExceptionClear, .{});
        const invocation_handler_class_dot = jni.findClass("net.random_projects.zig_android_template.NativeInvocationHandler");
        result = jni.invokeJni(.ExceptionCheck, .{});
        std.log.info("invocation_handler_class_dot {any}, {}", .{ invocation_handler_class_dot, result });
        if (result != 0) jni.invokeJni(.ExceptionClear, .{});

        const getPackages = jni.invokeJni(.GetMethodID, .{ classLoader, "getPackages", "()[Ljava/lang/Package;" });
        const packages = jni.invokeJni(.CallObjectMethod, .{ cls, getPackages });
        const array_length = jni.invokeJni(.GetArrayLength, .{packages});
        std.log.info("There are {} packages", .{array_length});

        const findClass = jni.invokeJni(.GetMethodID, .{ classLoader, "loadClass", "(Ljava/lang/String;)Ljava/lang/Class;" });
        const strClassName = jni.invokeJni(.NewStringUTF, .{"net/random_projects/zig_android_template/NativeInvocationHandler"});
        const class = jni.invokeJni(.CallObjectMethod, .{ cls, findClass, strClassName });
        jni.invokeJni(.DeleteLocalRef, .{strClassName});

        // Get invocation handler factory
        std.log.info("Creating invocation handler", .{});
        self.invocation_handler = NativeInvocationHandler.init(jni, class);

        // Create a TimerTask invoker
        std.log.info("Creating timer task invoker", .{});
        const TimerTaskInvoker = try self.invocation_handler.createAlloc(jni, self.allocator, null, &timerInvoke);

        std.log.info("Creating proxy class", .{});
        const Proxy = jni.findClass("java/lang/reflect/Proxy");
        const newProxyInstance = jni.invokeJni(.GetMethodID, .{ Proxy, "newProxyInstance", "(Ljava/lang/reflect/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)" });

        std.log.info("Creating Interface array", .{});
        const interface_array = jni.invokeJni(.NewObjectArray, .{
            1,
            jni.findClass("java/lang/Class"),
            jni.findClass("java/util/TimerTask"),
        });

        // Create the proxy object
        std.log.info("Creating timer task proxy", .{});
        const timer_task_proxy = jni.invokeJni(.CallStaticObjectMethod, .{ Proxy, newProxyInstance, cls, interface_array, TimerTaskInvoker });

        std.log.info("Creating timer", .{});
        const Timer = jni.findClass("java/util/Timer");
        const timerInit = jni.invokeJni(.GetMethodID, .{ Timer, "<init>", "()V" });
        const timer = jni.invokeJni(.NewObject, .{ Timer, timerInit });

        std.log.info("Scheduling task", .{});
        const schedule = jni.invokeJni(.GetMethodID, .{ Timer, "schedule", "(Ljava/util/TimerTask;J)V" });

        const Long = jni.findClass("java/lang/Long");
        const longInit = jni.invokeJni(.GetMethodID, .{ Long, "<init>", "(J)V" });
        const delay: u64 = 10000;
        const delay_long = jni.invokeJni(.NewObject, .{ Long, longInit, delay }) orelse return error.LongInit;

        jni.invokeJni(.CallVoidMethod, .{ timer, schedule, timer_task_proxy, delay_long });
    }
};
