const std = @import("std");

const android = @import("android");

pub const panic = android.panic;
pub const log = android.log;

const EGLContext = android.egl.EGLContext;
const JNI = android.jni.JNI;
const c = android.egl.c;
const NativeInvocationHandler = android.NativeInvocationHandler;

const app_log = std.log.scoped(.app);
comptime {
    _ = android.ANativeActivity_createFunc;
    _ = @import("root").log;
}

const ButtonData = struct {
    count: usize = 0,
};

pub fn timerInvoke(data: ?*anyopaque, jni: *android.jni.JNI, method: android.jobject, args: android.jobjectArray) android.jobject {
    var btn_data = @ptrCast(*ButtonData, @alignCast(@alignOf(*ButtonData), data));
    btn_data.count += 1;
    std.log.info("Running invoke!", .{});
    const method_name = android.jni.JNI.String.init(jni, jni.callObjectMethod(method, "getName", "()Ljava/lang/String;", .{}));
    defer method_name.deinit(jni);
    std.log.info("Method {}", .{std.unicode.fmtUtf16le(method_name.slice)});

    const length = jni.invokeJni(.GetArrayLength, .{args});
    var i: i32 = 0;
    while (i < length) : (i += 1) {
        const object = jni.invokeJni(.GetObjectArrayElement, .{ args, i });
        const string = android.jni.JNI.String.init(jni, jni.callObjectMethod(object, "toString", "()Ljava/lang/String;", .{}));
        defer string.deinit(jni);
        std.log.info("Arg {}: {}", .{ i, std.unicode.fmtUtf16le(string.slice) });

        if (i == 0) {
            const Button = jni.findClass("android/widget/Button");
            const setText = jni.invokeJni(.GetMethodID, .{ Button, "setText", "(Ljava/lang/CharSequence;)V" });
            var buf: [256:0]u8 = undefined;
            const str = std.fmt.bufPrintZ(&buf, "Pressed {} times!", .{btn_data.count}) catch "formatting bug";
            jni.invokeJni(.CallVoidMethod, .{ object, setText, jni.newString(str) });
        }
    }

    return null;
}

pub const AndroidApp = struct {
    allocator: std.mem.Allocator,
    activity: *android.ANativeActivity,
    thread: ?std.Thread = null,
    running: bool = true,

    // The JNIEnv of the UI thread
    uiJni: android.jni.NativeActivity = undefined,
    // The JNIEnv of the app thread
    mainJni: android.jni.NativeActivity = undefined,

    invocation_handler: NativeInvocationHandler = undefined,

    // This is needed because to run a callback on the UI thread Looper you must
    // react to a fd change, so we use a pipe to force it
    pipe: [2]std.os.fd_t = undefined,
    // This is used with futexes so that runOnUiThread waits until the callback is completed
    // before returning.
    uiThreadCondition: std.atomic.Atomic(u32) = std.atomic.Atomic(u32).init(0),
    uiThreadLooper: *android.ALooper = undefined,
    uiThreadId: std.Thread.Id = undefined,

    btn_data: ButtonData = .{},

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

        var native_activity = android.jni.NativeActivity.init(self.activity);
        var jni = native_activity.jni;
        self.uiJni = native_activity;

        // Get the window object attached to our activity
        const activityClass = jni.findClass("android/app/NativeActivity");
        const getWindow = jni.invokeJni(.GetMethodID, .{ activityClass, "getWindow", "()Landroid/view/Window;" });
        const activityWindow = jni.invokeJni(.CallObjectMethod, .{ self.activity.clazz, getWindow });
        const WindowClass = jni.findClass("android/view/Window");

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
        const native_activity = android.jni.NativeActivity.get(self.activity);
        const jni = native_activity.jni;

        // We create a new Button..
        std.log.warn("Creating android.widget.Button", .{});
        const Button = jni.findClass("android/widget/Button");
        // methods
        const buttonInit = jni.invokeJni(.GetMethodID, .{ Button, "<init>", "(Landroid/content/Context;)V" });
        const setOnClickListener = jni.invokeJni(.GetMethodID, .{ Button, "setOnClickListener", "(Landroid/view/View$OnClickListener;)V" });
        const setText = jni.invokeJni(.GetMethodID, .{ Button, "setText", "(Ljava/lang/CharSequence;)V" });
        // invocations
        // init
        const button = jni.invokeJni(.NewObject, .{ Button, buttonInit, self.activity.clazz });

        // .. and set its text to "Hello from Zig!"
        jni.invokeJni(.CallVoidMethod, .{ button, setText, jni.newString("Hello from Zig!") });
        // set onclick callback
        const listener = self.getOnClickListener(jni) catch @panic("help");
        std.log.info("Listener {any}", .{listener});
        jni.invokeJni(.CallVoidMethod, .{ button, setOnClickListener, listener });

        // And then we use it as our content view!
        std.log.err("Attempt to call NativeActivity.setContentView()", .{});
        const activityClass = jni.findClass("android/app/NativeActivity");
        const setContentView = jni.invokeJni(.GetMethodID, .{ activityClass, "setContentView", "(Landroid/view/View;)V" });
        jni.invokeJni(.CallVoidMethod, .{
            self.activity.clazz,
            setContentView,
            button,
        });
    }

    fn mainLoop(self: *AndroidApp) !void {
        self.mainJni = android.jni.NativeActivity.init(self.activity);
        defer self.mainJni.deinit();

        try self.runOnUiThread(setAppContentView, .{self});
        while (self.running) {
            std.time.sleep(1 * std.time.ns_per_s);
        }
    }

    fn getOnClickListener(self: *AndroidApp, jni: *JNI) !android.jobject {
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
        std.log.info("invocation_handler_class_full {any}, {}", .{ invocation_handler_class_full, result });
        result = jni.invokeJni(.ExceptionCheck, .{});
        if (result != 0) jni.invokeJni(.ExceptionClear, .{});

        const getPackages = jni.invokeJni(.GetMethodID, .{ classLoader, "getPackages", "()[Ljava/lang/Package;" });
        const packages = jni.invokeJni(.CallObjectMethod, .{ cls, getPackages });
        const array_length = jni.invokeJni(.GetArrayLength, .{packages});
        std.log.info("There are {} packages", .{array_length});

        const findClass = jni.invokeJni(.GetMethodID, .{ classLoader, "loadClass", "(Ljava/lang/String;)Ljava/lang/Class;" });
        const strClassName = jni.invokeJni(.NewStringUTF, .{"NativeInvocationHandler"});
        const class = jni.invokeJni(.CallObjectMethod, .{ cls, findClass, strClassName });
        result = jni.invokeJni(.ExceptionCheck, .{});
        if (result != 0) {
            std.log.info("Exception while calling loadClass", .{});
            jni.invokeJni(.ExceptionDescribe, .{});
        }
        jni.invokeJni(.DeleteLocalRef, .{strClassName});

        // Get invocation handler factory
        self.invocation_handler = NativeInvocationHandler.init(jni, class);

        // Create a TimerTask invoker
        const invocation_handler = try self.invocation_handler.createAlloc(jni, self.allocator, &self.btn_data, &timerInvoke);

        std.log.info("Creating Interface array", .{});
        const interface_array = jni.invokeJni(.NewObjectArray, .{
            1,
            jni.findClass("java/lang/Class"),
            jni.findClass("android/view/View$OnClickListener"),
        });

        std.log.info("Creating proxy class", .{});
        const Proxy = jni.findClass("java/lang/reflect/Proxy");
        const newProxyInstance = jni.invokeJni(.GetStaticMethodID, .{ Proxy, "newProxyInstance", "(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;" });
        const proxy = jni.invokeJni(.CallStaticObjectMethod, .{ Proxy, newProxyInstance, cls, interface_array, invocation_handler });

        std.log.info("newProxyInstance {any}, cls {any}, interfaceArray {any}, invocationHandler {any}", .{ cls, newProxyInstance, interface_array, invocation_handler });

        return proxy;
    }
};
