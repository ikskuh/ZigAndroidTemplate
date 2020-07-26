const std = @import("std");

const c = @cImport({
    @cInclude("EGL/egl.h");
    @cInclude("GLES3/gl3.h");
});

const android = @import("android-bind.zig");
const build_options = @import("build_options");

// extern fn __system_property_get(name: [*:0]const u8, value: [*]u8) callconv(.C) c_int;

//     {
//         var sdk_ver_str: [92]u8 = undefined;
//         const len = __system_property_get("ro.build.version.sdk", &sdk_ver_str);
//         if (len <= 0) {
//             android_sdk_version = 0;
//         } else {
//             const str = sdk_ver_str[0..@intCast(usize, len)];
//             android_sdk_version = try std.fmt.parseInt(c_int, str, 10);
//         }
//     }

//     std.log.debug(.app, "Starting on Android Version {}\n", .{
//         android_sdk_version,
//     });

const AndroidApp = struct {
    const Self = @This();

    allocator: *std.mem.Allocator,
    activity: *android.ANativeActivity,

    thread: ?*std.Thread = null,
    running: bool = true,

    egl_lock: std.Mutex = std.Mutex.init(),
    egl: ?EGLContext = null,
    egl_init: bool = true,

    fn initRestore(allocator: *std.mem.Allocator, activity: *android.ANativeActivity, stored_state: []const u8) !Self {
        return Self{
            .allocator = allocator,
            .activity = activity,
        };
    }

    fn initFresh(allocator: *std.mem.Allocator, activity: *android.ANativeActivity) !Self {
        return Self{
            .allocator = allocator,
            .activity = activity,
        };
    }

    fn start(self: *Self) !void {
        self.thread = try std.Thread.spawn(self, mainLoop);
    }

    fn deinit(self: *Self) void {
        @atomicStore(bool, &self.running, false, .SeqCst);
        if (self.thread) |thread| {
            thread.wait();
            self.thread = null;
        }
        self.* = undefined;
    }

    fn onDestroy(self: *Self) void {
        const allocator = self.allocator;
        self.deinit();
        allocator.destroy(self);
    }

    fn onNativeWindowCreated(self: *Self, window: *android.ANativeWindow) void {
        var held = self.egl_lock.acquire();
        defer held.release();

        if (self.egl) |*old| {
            old.deinit();
        }

        self.egl = EGLContext.init(window) catch |err| blk: {
            std.log.err(.app, "Failed to initialize EGL for window: {}\n", .{err});
            break :blk null;
        };
        self.egl_init = true;
    }

    fn onNativeWindowDestroyed(self: *Self, window: *android.ANativeWindow) void {
        var held = self.egl_lock.acquire();
        defer held.release();

        if (self.egl) |*old| {
            old.deinit();
        }
        self.egl = null;
    }

    fn mainLoop(self: *Self) !void {
        var loop: usize = 0;
        std.log.notice(.app, "mainLoop() started\n", .{});
        while (@atomicLoad(bool, &self.running, .SeqCst)) {
            {
                var held = self.egl_lock.acquire();
                defer held.release();
                if (self.egl) |egl| {
                    try egl.makeCurrent();

                    if (self.egl_init) {
                        std.log.info(.app,
                            \\GL Vendor:     {}
                            \\GL Renderer:   {}
                            \\GL Version:    {}
                            \\GL Extensions: {}
                            \\
                        , .{
                            std.mem.span(c.glGetString(c.GL_VENDOR)),
                            std.mem.span(c.glGetString(c.GL_RENDERER)),
                            std.mem.span(c.glGetString(c.GL_VERSION)),
                            std.mem.span(c.glGetString(c.GL_EXTENSIONS)),
                        });

                        self.egl_init = false;
                    }

                    c.glClearColor(0.0, 0.0, @intToFloat(f32, (loop % 256)) / 255.0, 1.0);
                    c.glClear(c.GL_COLOR_BUFFER_BIT);

                    // TODO: Render loop here

                    try egl.swapBuffers();
                }
            }
            loop += 1;

            std.time.sleep(10 * std.time.ns_per_ms);
        }
        std.log.notice(.app, "mainLoop() finished\n", .{});
    }
};

const EGLContext = struct {
    const Self = @This();

    display: c.EGLDisplay,
    surface: c.EGLSurface,
    context: c.EGLContext,

    fn init(window: *android.ANativeWindow) !Self {
        const EGLint = c.EGLint;

        var egl_display = c.eglGetDisplay(c.EGL_DEFAULT_DISPLAY);
        if (egl_display == c.EGL_NO_DISPLAY) {
            std.log.err(.egl, "Error: No display found!\n", .{});
            return error.FailedToInitializeEGL;
        }

        var egl_major: EGLint = undefined;
        var egl_minor: EGLint = undefined;
        if (c.eglInitialize(egl_display, &egl_major, &egl_minor) == 0) {
            std.log.err(.egl, "Error: eglInitialise failed!\n", .{});
            return error.FailedToInitializeEGL;
        }

        std.log.info(.egl,
            \\EGL Version:    {}
            \\EGL Vendor:     {}
            \\EGL Extensions: {}
            \\
        , .{
            std.mem.span(c.eglQueryString(egl_display, c.EGL_VERSION)),
            std.mem.span(c.eglQueryString(egl_display, c.EGL_VENDOR)),
            std.mem.span(c.eglQueryString(egl_display, c.EGL_EXTENSIONS)),
        });

        const config_attribute_list = [_]EGLint{
            c.EGL_RED_SIZE,
            8,
            c.EGL_GREEN_SIZE,
            8,
            c.EGL_BLUE_SIZE,
            8,
            c.EGL_ALPHA_SIZE,
            8,
            c.EGL_BUFFER_SIZE,
            32,
            c.EGL_STENCIL_SIZE,
            0,
            c.EGL_DEPTH_SIZE,
            16,
            // c.EGL_SAMPLES, 1,
            c.EGL_RENDERABLE_TYPE,
            if (build_options.android_sdk_version >= 28) c.EGL_OPENGL_ES3_BIT else c.EGL_OPENGL_ES2_BIT,
            c.EGL_NONE,
        };

        var config: c.EGLConfig = undefined;
        var num_config: c.EGLint = undefined;
        if (c.eglChooseConfig(egl_display, &config_attribute_list, &config, 1, &num_config) == c.EGL_FALSE) {
            std.log.err(.egl, "Error: eglChooseConfig failed: 0x{X:0>4}\n", .{c.eglGetError()});
            return error.FailedToInitializeEGL;
        }

        std.log.info(.egl, "Config: {}\n", .{num_config});

        const context_attribute_list = [_]EGLint{ c.EGL_CONTEXT_CLIENT_VERSION, 2, c.EGL_NONE };

        var context = c.eglCreateContext(egl_display, config, c.EGL_NO_CONTEXT, &context_attribute_list);
        if (context == c.EGL_NO_CONTEXT) {
            std.log.err(.egl, "Error: eglCreateContext failed: 0x{X:0>4}\n", .{c.eglGetError()});
            return error.FailedToInitializeEGL;
        }
        errdefer _ = c.eglDestroyContext(egl_display, context);

        std.log.info(.egl, "Context created: {}\n", .{context});

        var native_window: c.EGLNativeWindowType = @ptrCast(c.EGLNativeWindowType, window); // this is safe, just a C import problem

        const android_width = android.ANativeWindow_getWidth(window);
        const android_height = android.ANativeWindow_getHeight(window);

        std.log.info(.egl, "Screen Resolution: {}x{}\n", .{ android_width, android_height });

        const window_attribute_list = [_]EGLint{c.EGL_NONE};
        const egl_surface = c.eglCreateWindowSurface(egl_display, config, native_window, &window_attribute_list);

        std.log.info(.egl, "Got Surface: {}\n", .{egl_surface});

        if (egl_surface == c.EGL_NO_SURFACE) {
            std.log.err(.egl, "Error: eglCreateWindowSurface failed: 0x{X:0>4}\n", .{c.eglGetError()});
            return error.FailedToInitializeEGL;
        }
        errdefer _ = c.eglDestroySurface(egl_display, context);

        return Self{
            .display = egl_display,
            .surface = egl_surface,
            .context = context,
        };
    }

    fn deinit(self: *Self) void {
        _ = c.eglDestroySurface(self.display, self.surface);
        _ = c.eglDestroyContext(self.display, self.context);
        self.* = undefined;
    }

    fn swapBuffers(self: Self) !void {
        if (c.eglSwapBuffers(self.display, self.surface) == c.EGL_FALSE) {
            std.log.err(.egl, "Error: eglMakeCurrent failed: 0x{X:0>4}\n", .{c.eglGetError()});
            return error.EglFailure;
        }
    }

    fn makeCurrent(self: Self) !void {
        if (c.eglMakeCurrent(self.display, self.surface, self.surface, self.context) == c.EGL_FALSE) {
            std.log.err(.egl, "Error: eglMakeCurrent failed: 0x{X:0>4}\n", .{c.eglGetError()});
            return error.EglFailure;
        }
    }
};

// // Required by C code for now…
threadlocal var errno: c_int = 0;
export fn __errno_location() *c_int {
    return &errno;
}

// Android Logging implementation

pub fn log(
    comptime message_level: std.log.Level,
    comptime scope: @Type(.EnumLiteral),
    comptime format: []const u8,
    args: anytype,
) void {
    var buffer: [8192]u8 = undefined;
    const msg = std.fmt.bufPrint(&buffer, format ++ "\x00", args) catch {
        // TODO: Handle missing format here…
        return;
    };

    // Make slice 0-terminated with added nul terminator
    const msg0 = msg[0..(msg.len - 1) :0];

    // Using the function from liblog to write to the actual debug output
    _ = android.__android_log_write(switch (message_level) {
        //  => .ANDROID_LOG_VERBOSE,
        .debug => android.ANDROID_LOG_DEBUG,
        .info, .notice => android.ANDROID_LOG_INFO,
        .warn => android.ANDROID_LOG_WARN,
        .err => android.ANDROID_LOG_ERROR,
        .crit, .alert, .emerg => android.ANDROID_LOG_FATAL,
    }, "ziggy", msg0.ptr);
}

export fn ANativeActivity_onCreate(activity: *android.ANativeActivity, savedState: ?[*]u8, savedStateSize: usize) callconv(.C) void {
    const app = std.heap.c_allocator.create(AndroidApp) catch {
        std.log.emerg(.app_glue, "Could not create new AndroidApp: OutOfMemory!\n", .{});
        return;
    };

    activity.callbacks.* = ANativeActivityGlue(AndroidApp).init();

    if (savedState) |state| {
        app.* = AndroidApp.initRestore(std.heap.c_allocator, activity, state[0..savedStateSize]) catch |err| {
            std.log.emerg(.app_glue, "Failed to restore app state: {}\n", .{err});
            std.heap.c_allocator.destroy(app);
            return;
        };
    } else {
        app.* = AndroidApp.initFresh(std.heap.c_allocator, activity) catch |err| {
            std.log.emerg(.app_glue, "Failed to restore app state: {}\n", .{err});
            std.heap.c_allocator.destroy(app);
            return;
        };
    }

    app.start() catch |err| {
        std.log.emerg(.app_glue, "Failed to start app state: {}\n", .{err});
        app.deinit();
        std.heap.c_allocator.destroy(app);
        return;
    };

    activity.instance = app;

    std.log.debug(.app_glue, "Successfully started the app.\n", .{});
}

/// Returns a wrapper implementation for the given App type which implements all
/// ANativeActivity callbacks.
fn ANativeActivityGlue(comptime App: type) type {
    return struct {
        pub fn init() android.ANativeActivityCallbacks {
            return android.ANativeActivityCallbacks{
                .onStart = onStart,
                .onResume = onResume,
                .onSaveInstanceState = onSaveInstanceState,
                .onPause = onPause,
                .onStop = onStop,
                .onDestroy = onDestroy,
                .onWindowFocusChanged = onWindowFocusChanged,
                .onNativeWindowCreated = onNativeWindowCreated,
                .onNativeWindowResized = onNativeWindowResized,
                .onNativeWindowRedrawNeeded = onNativeWindowRedrawNeeded,
                .onNativeWindowDestroyed = onNativeWindowDestroyed,
                .onInputQueueCreated = onInputQueueCreated,
                .onInputQueueDestroyed = onInputQueueDestroyed,
                .onContentRectChanged = onContentRectChanged,
                .onConfigurationChanged = onConfigurationChanged,
                .onLowMemory = onLowMemory,
            };
        }

        fn invoke(activity: *android.ANativeActivity, comptime func: []const u8, args: anytype) void {
            if (@hasDecl(App, func)) {
                if (activity.instance) |instance| {
                    @call(.{}, @field(App, func), .{@ptrCast(*App, @alignCast(@alignOf(App), instance))} ++ args);
                }
            } else {
                std.log.debug(.app_glue, "ANativeActivity callback {} not available on {}", .{ func, @typeName(App) });
            }
        }

        // return value must be created with malloc(), so we pass the c_allocator to App.onSaveInstanceState
        fn onSaveInstanceState(activity: *android.ANativeActivity, outSize: *usize) callconv(.C) ?[*]u8 {
            outSize.* = 0;
            if (@hasDecl(App, "onSaveInstanceState")) {
                if (activity.instance) |instance| {
                    const optional_slice = @ptrCast(*App, @alignCast(@alignOf(App), instance)).onSaveInstanceState(std.heap.c_allocator);
                    if (optional_slice) |slice| {
                        outSize.* = slice.len;
                        return slice.ptr;
                    }
                }
            } else {
                std.log.debug(.app_glue, "ANativeActivity callback onSaveInstanceState not available on {}", .{@typeName(App)});
            }
            return null;
        }

        fn onDestroy(activity: *android.ANativeActivity) callconv(.C) void {
            invoke(activity, "onDestroy", .{});
        }
        fn onStart(activity: *android.ANativeActivity) callconv(.C) void {
            invoke(activity, "onStart", .{});
        }
        fn onResume(activity: *android.ANativeActivity) callconv(.C) void {
            invoke(activity, "onResume", .{});
        }
        fn onPause(activity: *android.ANativeActivity) callconv(.C) void {
            invoke(activity, "onPause", .{});
        }
        fn onStop(activity: *android.ANativeActivity) callconv(.C) void {
            invoke(activity, "onStop", .{});
        }
        fn onConfigurationChanged(activity: *android.ANativeActivity) callconv(.C) void {
            invoke(activity, "onConfigurationChanged", .{});
        }
        fn onLowMemory(activity: *android.ANativeActivity) callconv(.C) void {
            invoke(activity, "onLowMemory", .{});
        }
        fn onWindowFocusChanged(activity: *android.ANativeActivity, hasFocus: c_int) callconv(.C) void {
            invoke(activity, "onWindowFocusChanged", .{(hasFocus != 0)});
        }
        fn onNativeWindowCreated(activity: *android.ANativeActivity, window: *android.ANativeWindow) callconv(.C) void {
            invoke(activity, "onNativeWindowCreated", .{window});
        }
        fn onNativeWindowResized(activity: *android.ANativeActivity, window: *android.ANativeWindow) callconv(.C) void {
            invoke(activity, "onNativeWindowResized", .{window});
        }
        fn onNativeWindowRedrawNeeded(activity: *android.ANativeActivity, window: *android.ANativeWindow) callconv(.C) void {
            invoke(activity, "onNativeWindowRedrawNeeded", .{window});
        }
        fn onNativeWindowDestroyed(activity: *android.ANativeActivity, window: *android.ANativeWindow) callconv(.C) void {
            invoke(activity, "onNativeWindowDestroyed", .{window});
        }
        fn onInputQueueCreated(activity: *android.ANativeActivity, input_queue: *android.AInputQueue) callconv(.C) void {
            invoke(activity, "onInputQueueCreated", .{input_queue});
        }
        fn onInputQueueDestroyed(activity: *android.ANativeActivity, input_queue: *android.AInputQueue) callconv(.C) void {
            invoke(activity, "onInputQueueDestroyed", .{input_queue});
        }
        fn onContentRectChanged(activity: *android.ANativeActivity, rect: *const android.ARect) callconv(.C) void {
            invoke(activity, "onContentRectChanged", .{rect});
        }
    };
}
