const std = @import("std");

const c = @cImport({
    @cInclude("EGL/egl.h");
    @cInclude("GLES3/gl3.h");
});

const android = @import("android-bind.zig");
const build_options = @import("build_options");

const AndroidApp = struct {
    const Self = @This();

    allocator: *std.mem.Allocator,
    activity: *android.ANativeActivity,

    thread: ?*std.Thread = null,
    running: bool = true,

    egl_lock: std.Mutex = std.Mutex.init(),
    egl: ?EGLContext = null,
    egl_init: bool = true,

    input_lock: std.Mutex = std.Mutex.init(),
    input: ?*android.AInputQueue = null,

    config: ?*android.AConfiguration = null,

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
        if (self.config) |config| {
            android.AConfiguration_delete(config);
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

    fn onInputQueueCreated(self: *Self, input: *android.AInputQueue) void {
        var held = self.input_lock.acquire();
        defer held.release();

        self.input = input;
    }

    fn onInputQueueDestroyed(self: *Self, input: *android.AInputQueue) void {
        var held = self.input_lock.acquire();
        defer held.release();

        self.input = null;
    }

    fn printConfig(config: *android.AConfiguration) void {
        var lang: [2]u8 = undefined;
        var country: [2]u8 = undefined;

        android.AConfiguration_getLanguage(config, &lang);
        android.AConfiguration_getCountry(config, &country);

        std.log.debug(.app,
            \\MCC:         {}
            \\MNC:         {}
            \\Language:    {}
            \\Country:     {}
            \\Orientation: {}
            \\Touchscreen: {}
            \\Density:     {}
            \\Keyboard:    {}
            \\Navigation:  {}
            \\KeysHidden:  {}
            \\NavHidden:   {}
            \\SdkVersion:  {}
            \\ScreenSize:  {}
            \\ScreenLong:  {}
            \\UiModeType:  {}
            \\UiModeNight: {}
            \\
        , .{
            android.AConfiguration_getMcc(config),
            android.AConfiguration_getMnc(config),
            &lang,
            &country,
            android.AConfiguration_getOrientation(config),
            android.AConfiguration_getTouchscreen(config),
            android.AConfiguration_getDensity(config),
            android.AConfiguration_getKeyboard(config),
            android.AConfiguration_getNavigation(config),
            android.AConfiguration_getKeysHidden(config),
            android.AConfiguration_getNavHidden(config),
            android.AConfiguration_getSdkVersion(config),
            android.AConfiguration_getScreenSize(config),
            android.AConfiguration_getScreenLong(config),
            android.AConfiguration_getUiModeType(config),
            android.AConfiguration_getUiModeNight(config),
        });
    }

    fn processKeyEvent(self: *Self, event: *android.AInputEvent) !bool {
        const event_type = @intToEnum(android.AKeyEventActionType, android.AKeyEvent_getAction(event));
        std.log.debug(.input,
            \\Key Press Event: {}
            \\Flags:       {}
            \\KeyCode:     {}
            \\ScanCode:    {}
            \\MetaState:   {}
            \\RepeatCount: {}
            \\DownTime:    {}
            \\EventTime:   {}
            \\
        , .{
            event_type,
            android.AKeyEvent_getFlags(event),
            android.AKeyEvent_getKeyCode(event),
            android.AKeyEvent_getScanCode(event),
            android.AKeyEvent_getMetaState(event),
            android.AKeyEvent_getRepeatCount(event),
            android.AKeyEvent_getDownTime(event),
            android.AKeyEvent_getEventTime(event),
        });

        if (event_type == .AKEY_EVENT_ACTION_DOWN) {
            var jni = JNI.init(self.activity);
            defer jni.deinit();

            var codepoint = jni.AndroidGetUnicodeChar(
                android.AKeyEvent_getKeyCode(event),
                android.AKeyEvent_getMetaState(event),
            );
            var buf: [8]u8 = undefined;

            var len = std.unicode.utf8Encode(codepoint, &buf) catch 0;
            var key_text = buf[0..len];

            std.log.info(.input, "Pressed key: '{}' U+{X}", .{ key_text, codepoint });
        }

        return false;
    }

    fn processMotionEvent(self: *Self, event: *android.AInputEvent) !bool {
        const event_type = @intToEnum(android.AMotionEventActionType, android.AMotionEvent_getAction(event));

        {
            var jni = JNI.init(self.activity);
            defer jni.deinit();

            // Must be called from main thread…
            // _ = jni.AndroidMakeFullscreen();

            // _ = jni.AndroidDisplayKeyboard(true);

            // this allows you to send the app in the background
            const success = jni.AndroidSendToBack(true);
            std.log.debug(.app, "SendToBack() = {}\n", .{success});

            // This is a demo on how to request permissions:
            // if (event_type == .AMOTION_EVENT_ACTION_UP) {
            //     if (!JNI.AndroidHasPermissions(self.activity, "android.permission.RECORD_AUDIO")) {
            //         JNI.AndroidRequestAppPermissions(self.activity, "android.permission.RECORD_AUDIO");
            //     }
            // }
        }

        std.log.debug(.input,
            \\Motion Event {}
            \\Flags:        {}
            \\MetaState:    {}
            \\ButtonState:  {}
            \\EdgeFlags:    {}
            \\DownTime:     {}
            \\EventTime:    {}
            \\XOffset:      {}
            \\YOffset:      {}
            \\XPrecision:   {}
            \\YPrecision:   {}
            \\PointerCount: {}
            \\
        , .{
            event_type,
            android.AMotionEvent_getFlags(event),
            android.AMotionEvent_getMetaState(event),
            android.AMotionEvent_getButtonState(event),
            android.AMotionEvent_getEdgeFlags(event),
            android.AMotionEvent_getDownTime(event),
            android.AMotionEvent_getEventTime(event),
            android.AMotionEvent_getXOffset(event),
            android.AMotionEvent_getYOffset(event),
            android.AMotionEvent_getXPrecision(event),
            android.AMotionEvent_getYPrecision(event),
            android.AMotionEvent_getPointerCount(event),
        });

        var i: usize = 0;
        var cnt = android.AMotionEvent_getPointerCount(event);
        while (i < cnt) : (i += 1) {
            std.log.debug(.input,
                \\Pointer {}:
                \\  PointerId:   {}
                \\  ToolType:    {}
                \\  RawX:        {}
                \\  RawY:        {}
                \\  X:           {}
                \\  Y:           {}
                \\  Pressure:    {}
                \\  Size:        {}
                \\  TouchMajor:  {}
                \\  TouchMinor:  {}
                \\  ToolMajor:   {}
                \\  ToolMinor:   {}
                \\  Orientation: {}
                \\
            , .{
                i,
                android.AMotionEvent_getPointerId(event, i),
                android.AMotionEvent_getToolType(event, i),
                android.AMotionEvent_getRawX(event, i),
                android.AMotionEvent_getRawY(event, i),
                android.AMotionEvent_getX(event, i),
                android.AMotionEvent_getY(event, i),
                android.AMotionEvent_getPressure(event, i),
                android.AMotionEvent_getSize(event, i),
                android.AMotionEvent_getTouchMajor(event, i),
                android.AMotionEvent_getTouchMinor(event, i),
                android.AMotionEvent_getToolMajor(event, i),
                android.AMotionEvent_getToolMinor(event, i),
                android.AMotionEvent_getOrientation(event, i),
            });
        }

        return false;
    }

    fn mainLoop(self: *Self) !void {
        var loop: usize = 0;
        std.log.notice(.app, "mainLoop() started\n", .{});

        self.config = blk: {
            var cfg = android.AConfiguration_new() orelse return error.OutOfMemory;
            android.AConfiguration_fromAssetManager(cfg, self.activity.assetManager);
            break :blk cfg;
        };

        if (self.config) |cfg| {
            printConfig(cfg);
        }

        while (@atomicLoad(bool, &self.running, .SeqCst)) {

            // Input process
            {
                var held = self.input_lock.acquire();
                defer held.release();
                if (self.input) |input| {
                    var event: ?*android.AInputEvent = undefined;
                    while (android.AInputQueue_getEvent(input, &event) >= 0) {
                        std.debug.assert(event != null);
                        if (android.AInputQueue_preDispatchEvent(input, event) != 0) {
                            continue;
                        }

                        const event_type = @intToEnum(android.AInputEventType, android.AInputEvent_getType(event));
                        const handled = switch (event_type) {
                            .AINPUT_EVENT_TYPE_KEY => try self.processKeyEvent(event.?),
                            .AINPUT_EVENT_TYPE_MOTION => try self.processMotionEvent(event.?),
                            else => blk: {
                                std.log.debug(.input, "Unhandled input event type ({})\n", .{event_type});
                                break :blk false;
                            },
                        };

                        // if (app.onInputEvent != NULL)
                        //     handled = app.onInputEvent(app, event);
                        android.AInputQueue_finishEvent(input, event, if (handled) @as(c_int, 1) else @as(c_int, 0));
                    }
                }
            }

            // Render process
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

const JNI = struct {
    const Self = @This();

    activity: *android.ANativeActivity,
    env: *android.JNIEnv,
    activity_class: android.jclass,

    pub fn init(activity: *android.ANativeActivity) Self {
        var env: *android.JNIEnv = undefined;
        _ = activity.vm.*.AttachCurrentThread(activity.vm, &env, null);

        var activityClass = env.*.FindClass(env, "android/app/NativeActivity");

        return Self{
            .activity = activity,
            .env = env,
            .activity_class = activityClass,
        };
    }

    pub fn deinit(self: *Self) void {
        _ = self.activity.vm.*.DetachCurrentThread(self.activity.vm);
        self.* = undefined;
    }

    fn JniReturnType(comptime function: []const u8) type {
        @setEvalBranchQuota(10_000);
        return @typeInfo(std.meta.fieldInfo(android.JNINativeInterface, function).field_type).Fn.return_type.?;
    }

    fn invokeJni(self: *Self, comptime function: []const u8, args: anytype) JniReturnType(function) {
        return @call(
            .{},
            @field(self.env.*, function),
            .{self.env} ++ args,
        );
    }

    fn findClass(self: *Self, class: [:0]const u8) android.jclass {
        return self.invokeJni("FindClass", .{class.ptr});
    }

    pub fn AndroidGetUnicodeChar(self: *Self, keyCode: c_int, metaState: c_int) u21 {
        // https://stackoverflow.com/questions/21124051/receive-complete-android-unicode-input-in-c-c/43871301
        const eventType = android.AKEY_EVENT_ACTION_DOWN;

        const class_key_event = self.findClass("android/view/KeyEvent");

        const method_get_unicode_char = self.invokeJni("GetMethodID", .{ class_key_event, "getUnicodeChar", "(I)I" });
        const eventConstructor = self.invokeJni("GetMethodID", .{ class_key_event, "<init>", "(II)V" });
        const eventObj = self.invokeJni("NewObject", .{ class_key_event, eventConstructor, eventType, keyCode });

        const unicodeKey = self.invokeJni("CallIntMethod", .{ eventObj, method_get_unicode_char, metaState });

        return @intCast(u21, unicodeKey);
    }

    fn AndroidMakeFullscreen(self: *Self) void {
        // Partially based on
        // https://stackoverflow.com/questions/47507714/how-do-i-enable-full-screen-immersive-mode-for-a-native-activity-ndk-app

        // Get android.app.NativeActivity, then get getWindow method handle, returns
        // view.Window type
        const activityClass = self.findClass("android/app/NativeActivity");
        const getWindow = self.invokeJni("GetMethodID", .{ activityClass, "getWindow", "()Landroid/view/Window;" });
        const window = self.invokeJni("CallObjectMethod", .{ self.activity.clazz, getWindow });

        // Get android.view.Window class, then get getDecorView method handle, returns
        // view.View type
        const windowClass = self.findClass("android/view/Window");
        const getDecorView = self.invokeJni("GetMethodID", .{ windowClass, "getDecorView", "()Landroid/view/View;" });
        const decorView = self.invokeJni("CallObjectMethod", .{ window, getDecorView });

        // Get the flag values associated with systemuivisibility
        const viewClass = self.findClass("android/view/View");
        const flagLayoutHideNavigation = self.invokeJni("GetStaticIntField", .{ viewClass, self.invokeJni("GetStaticFieldID", .{ viewClass, "SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION", "I" }) });
        const flagLayoutFullscreen = self.invokeJni("GetStaticIntField", .{ viewClass, self.invokeJni("GetStaticFieldID", .{ viewClass, "SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN", "I" }) });
        const flagLowProfile = self.invokeJni("GetStaticIntField", .{ viewClass, self.invokeJni("GetStaticFieldID", .{ viewClass, "SYSTEM_UI_FLAG_LOW_PROFILE", "I" }) });
        const flagHideNavigation = self.invokeJni("GetStaticIntField", .{ viewClass, self.invokeJni("GetStaticFieldID", .{ viewClass, "SYSTEM_UI_FLAG_HIDE_NAVIGATION", "I" }) });
        const flagFullscreen = self.invokeJni("GetStaticIntField", .{ viewClass, self.invokeJni("GetStaticFieldID", .{ viewClass, "SYSTEM_UI_FLAG_FULLSCREEN", "I" }) });
        const flagImmersiveSticky = self.invokeJni("GetStaticIntField", .{ viewClass, self.invokeJni("GetStaticFieldID", .{ viewClass, "SYSTEM_UI_FLAG_IMMERSIVE_STICKY", "I" }) });

        const setSystemUiVisibility = self.invokeJni("GetMethodID", .{ viewClass, "setSystemUiVisibility", "(I)V" });

        // Call the decorView.setSystemUiVisibility(FLAGS)
        self.invokeJni("CallVoidMethod", .{
            decorView,
            setSystemUiVisibility,
            (flagLayoutHideNavigation | flagLayoutFullscreen | flagLowProfile | flagHideNavigation | flagFullscreen | flagImmersiveSticky),
        });

        // now set some more flags associated with layoutmanager -- note the $ in the
        // class path search for api-versions.xml
        // https://android.googlesource.com/platform/development/+/refs/tags/android-9.0.0_r48/sdk/api-versions.xml

        const layoutManagerClass = self.findClass("android/view/WindowManager$LayoutParams");
        const flag_WinMan_Fullscreen = self.invokeJni("GetStaticIntField", .{ layoutManagerClass, self.invokeJni("GetStaticFieldID", .{ layoutManagerClass, "FLAG_FULLSCREEN", "I" }) });
        const flag_WinMan_KeepScreenOn = self.invokeJni("GetStaticIntField", .{ layoutManagerClass, self.invokeJni("GetStaticFieldID", .{ layoutManagerClass, "FLAG_KEEP_SCREEN_ON", "I" }) });
        const flag_WinMan_hw_acc = self.invokeJni("GetStaticIntField", .{ layoutManagerClass, self.invokeJni("GetStaticFieldID", .{ layoutManagerClass, "FLAG_HARDWARE_ACCELERATED", "I" }) });
        //    const int flag_WinMan_flag_not_fullscreen =
        //    env.GetStaticIntField(layoutManagerClass,
        //    (env.GetStaticFieldID(layoutManagerClass, "FLAG_FORCE_NOT_FULLSCREEN",
        //    "I") ));
        // call window.addFlags(FLAGS)
        self.invokeJni("CallVoidMethod", .{ window, self.invokeJni("GetMethodID", .{ windowClass, "addFlags", "(I})V" }), (flag_WinMan_Fullscreen | flag_WinMan_KeepScreenOn | flag_WinMan_hw_acc) });
    }

    pub fn AndroidDisplayKeyboard(self: *Self, show: bool) bool {
        // Based on
        // https://stackoverflow.com/questions/5864790/how-to-show-the-soft-keyboard-on-native-activity
        var lFlags: android.jint = 0;

        // Retrieves Context.INPUT_METHOD_SERVICE.
        const ClassContext = self.findClass("android/content/Context");
        const FieldINPUT_METHOD_SERVICE = self.invokeJni("GetStaticFieldID", .{ ClassContext, "INPUT_METHOD_SERVICE", "Ljava/lang/String;" });
        const INPUT_METHOD_SERVICE = self.invokeJni("GetStaticObjectField", .{ ClassContext, FieldINPUT_METHOD_SERVICE });

        // Runs getSystemService(Context.INPUT_METHOD_SERVICE).
        const ClassInputMethodManager = self.findClass("android/view/inputmethod/InputMethodManager");
        const MethodGetSystemService = self.invokeJni("GetMethodID", .{ self.activity_class, "getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;" });
        const lInputMethodManager = self.invokeJni("CallObjectMethod", .{ self.activity.clazz, MethodGetSystemService, INPUT_METHOD_SERVICE });

        // Runs getWindow().getDecorView().
        const MethodGetWindow = self.invokeJni("GetMethodID", .{ self.activity_class, "getWindow", "()Landroid/view/Window;" });
        const lWindow = self.invokeJni("CallObjectMethod", .{ self.activity.clazz, MethodGetWindow });
        const ClassWindow = self.findClass("android/view/Window");
        const MethodGetDecorView = self.invokeJni("GetMethodID", .{ ClassWindow, "getDecorView", "()Landroid/view/View;" });
        const lDecorView = self.invokeJni("CallObjectMethod", .{ lWindow, MethodGetDecorView });

        if (show) {
            // Runs lInputMethodManager.showSoftInput(...).
            const MethodShowSoftInput = self.invokeJni("GetMethodID", .{ ClassInputMethodManager, "showSoftInput", "(Landroid/view/View;I)Z" });
            return 0 != self.invokeJni("CallBooleanMethod", .{ lInputMethodManager, MethodShowSoftInput, lDecorView, lFlags });
        } else {
            // Runs lWindow.getViewToken()
            const ClassView = self.findClass("android/view/View");
            const MethodGetWindowToken = self.invokeJni("GetMethodID", .{ ClassView, "getWindowToken", "()Landroid/os/IBinder;" });
            const lBinder = self.invokeJni("CallObjectMethod", .{ lDecorView, MethodGetWindowToken });

            // lInputMethodManager.hideSoftInput(...).
            const MethodHideSoftInput = self.invokeJni("GetMethodID", .{ ClassInputMethodManager, "hideSoftInputFromWindow", "(Landroid/os/IBinder;I)Z" });
            return 0 != self.invokeJni("CallBooleanMethod", .{ lInputMethodManager, MethodHideSoftInput, lBinder, lFlags });
        }
    }

    /// Move the task containing this activity to the back of the activity stack.
    /// The activity's order within the task is unchanged.
    /// nonRoot: If false then this only works if the activity is the root of a task; if true it will work for any activity in a task.
    /// returns: If the task was moved (or it was already at the back) true is returned, else false.
    pub fn AndroidSendToBack(self: *Self, nonRoot: bool) bool {
        const ClassActivity = self.findClass("android/app/Activity");
        const MethodmoveTaskToBack = self.invokeJni("GetMethodID", .{ ClassActivity, "moveTaskToBack", "(Z)Z" });

        return 0 != self.invokeJni("CallBooleanMethod", .{ self.activity.clazz, MethodmoveTaskToBack, if (nonRoot) @as(c_int, 1) else 0 });
    }

    pub fn AndroidHasPermissions(self: *Self, perm_name: [:0]const u8) bool {
        if (android_sdk_version < 23) {
            std.log.err(
                .jni,
                "Android SDK version {} does not support AndroidRequestAppPermissions\n",
                .{android_sdk_version},
            );
            return false;
        }

        const ls_PERM = self.invokeJni("NewStringUTF", .{perm_name});

        const PERMISSION_GRANTED = blk: {
            var ClassPackageManager = self.findClass("android/content/pm/PackageManager");
            var lid_PERMISSION_GRANTED = self.invokeJni("GetStaticFieldID", .{ ClassPackageManager, "PERMISSION_GRANTED", "I" });
            break :blk self.invokeJni("GetStaticIntField", .{ ClassPackageManager, lid_PERMISSION_GRANTED });
        };

        const ClassContext = self.findClass("android/content/Context");
        const MethodcheckSelfPermission = self.invokeJni("GetMethodID", .{ ClassContext, "checkSelfPermission", "(Ljava/lang/String;)I" });
        const int_result = self.invokeJni("CallIntMethod", .{ self.activity.clazz, MethodcheckSelfPermission, ls_PERM });
        return (int_result == PERMISSION_GRANTED);
    }

    pub fn AndroidRequestAppPermissions(self: *Self, perm_name: [:0]const u8) void {
        if (android_sdk_version < 23) {
            std.log.err(
                .jni,
                "Android SDK version {} does not support AndroidRequestAppPermissions\n",
                .{android_sdk_version},
            );
            return;
        }

        const perm_array = self.invokeJni("NewObjectArray", .{
            1,
            self.findClass("java/lang/String"),
            self.invokeJni("NewStringUTF", .{perm_name}),
        });

        const MethodrequestPermissions = self.invokeJni("GetMethodID", .{ self.activity_class, "requestPermissions", "([Ljava/lang/String;I)V" });

        // Last arg (0) is just for the callback (that I do not use)
        self.invokeJni("CallVoidMethod", .{ self.activity.clazz, MethodrequestPermissions, perm_array, @as(c_int, 0) });
    }

    comptime {
        _ = AndroidGetUnicodeChar;
        _ = AndroidMakeFullscreen;
        _ = AndroidDisplayKeyboard;
        _ = AndroidSendToBack;
        _ = AndroidHasPermissions;
        _ = AndroidRequestAppPermissions;
    }
};

// int hasperm = AndroidHasPermission(env, "android.permission.RECORD_AUDIO" );
// if( !hasperm )
// {
//         AndroidRequestAppPermissions(env, "android.permission.RECORD_AUDIO" );
// }

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

var android_sdk_version: c_int = 0;

/// Actual application entry point
export fn ANativeActivity_onCreate(activity: *android.ANativeActivity, savedState: ?[*]u8, savedStateSize: usize) callconv(.C) void {
    {
        var sdk_ver_str: [92]u8 = undefined;
        const len = android.__system_property_get("ro.build.version.sdk", &sdk_ver_str);
        if (len <= 0) {
            android_sdk_version = 0;
        } else {
            const str = sdk_ver_str[0..@intCast(usize, len)];
            android_sdk_version = std.fmt.parseInt(c_int, str, 10) catch 0;
        }
    }

    std.log.debug(.app, "Starting on Android Version {}\n", .{
        android_sdk_version,
    });

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

/// Handles panic on android
pub fn panic(message: []const u8, stack_trace: ?*std.builtin.StackTrace) noreturn {
    std.log.emerg(.panic, "PANIC: {}\n", .{message});

    if (stack_trace) |trace| {
        if (std.builtin.strip_debug_info) {
            std.log.err(.panic, "Unable to dump stack trace: debug info stripped\n", .{}) catch {};
        } else {
            var frame_index: usize = 0;
            var frames_left: usize = std.math.min(trace.index, trace.instruction_addresses.len);

            while (frames_left != 0) : ({
                frames_left -= 1;
                frame_index = (frame_index + 1) % trace.instruction_addresses.len;
            }) {
                const return_address = trace.instruction_addresses[frame_index];
                std.log.info(.panic, "[{}] 0x{X:8>0}\n", .{
                    frame_index,
                    return_address,
                });
            }
        }
    }

    std.os.exit(1);
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
