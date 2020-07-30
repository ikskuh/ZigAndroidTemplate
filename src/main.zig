const std = @import("std");

const c = @import("c.zig");
const EGLContext = @import("egl.zig").EGLContext;
const JNI = @import("jni.zig").JNI;

const android = @import("android-support.zig");
const build_options = @import("build_options");

pub const panic = android.panic;
pub const log = android.log;

/// Entry point for our application.
/// This struct provides the interface to the android support package.
pub const AndroidApp = struct {
    const Self = @This();

    const TouchPoint = struct {
        /// if null, then fade out
        index: ?i32,
        intensity: f32,
        x: f32,
        y: f32,
        age: i64,
    };

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

    touch_points: [16]?TouchPoint = [1]?TouchPoint{null} ** 16,
    screen_width: f32 = undefined,
    screen_height: f32 = undefined,

    /// This is the entry point which initializes a application
    /// that has stored its previous state.
    /// `stored_state` is that state, the memory is only valid for this function.
    pub fn initRestore(allocator: *std.mem.Allocator, activity: *android.ANativeActivity, stored_state: []const u8) !Self {
        return Self{
            .allocator = allocator,
            .activity = activity,
        };
    }

    /// This is the entry point which initializes a application
    /// that has no previous state.
    pub fn initFresh(allocator: *std.mem.Allocator, activity: *android.ANativeActivity) !Self {
        return Self{
            .allocator = allocator,
            .activity = activity,
        };
    }

    /// This function is called when the application is successfully initialized.
    /// It should create a background thread that processes the events and runs until
    /// the application gets destroyed.
    pub fn start(self: *Self) !void {
        // This code somehow crashes yet. Needs more investigations
        // {
        //     var jni = JNI.init(self.activity);
        //     defer jni.deinit();

        //     // Must be called from main thread…
        //     _ = jni.AndroidMakeFullscreen();
        // }
        self.thread = try std.Thread.spawn(self, mainLoop);
    }

    /// Uninitialize the application.
    /// Don't forget to stop your background thread here!
    pub fn deinit(self: *Self) void {
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

    pub fn onNativeWindowCreated(self: *Self, window: *android.ANativeWindow) void {
        var held = self.egl_lock.acquire();
        defer held.release();

        if (self.egl) |*old| {
            old.deinit();
        }

        self.screen_width = @intToFloat(f32, android.ANativeWindow_getWidth(window));
        self.screen_height = @intToFloat(f32, android.ANativeWindow_getHeight(window));

        self.egl = EGLContext.init(window) catch |err| blk: {
            std.log.err(.app, "Failed to initialize EGL for window: {}\n", .{err});
            break :blk null;
        };
        self.egl_init = true;
    }

    pub fn onNativeWindowDestroyed(self: *Self, window: *android.ANativeWindow) void {
        var held = self.egl_lock.acquire();
        defer held.release();

        if (self.egl) |*old| {
            old.deinit();
        }
        self.egl = null;
    }

    pub fn onInputQueueCreated(self: *Self, input: *android.AInputQueue) void {
        var held = self.input_lock.acquire();
        defer held.release();

        self.input = input;
    }

    pub fn onInputQueueDestroyed(self: *Self, input: *android.AInputQueue) void {
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

    fn insertPoint(self: *Self, point: TouchPoint) void {
        std.debug.assert(point.index != null);
        var oldest: *TouchPoint = undefined;

        for (self.touch_points) |*opt, i| {
            if (opt.*) |*pt| {
                if (pt.index != null and pt.index.? == point.index.?) {
                    pt.* = point;
                    return;
                }

                if (i == 0) {
                    oldest = pt;
                } else {
                    if (pt.age < oldest.age) {
                        oldest = pt;
                    }
                }
            } else {
                opt.* = point;
                return;
            }
        }
        oldest.* = point;
    }

    fn processMotionEvent(self: *Self, event: *android.AInputEvent) !bool {
        const event_type = @intToEnum(android.AMotionEventActionType, android.AMotionEvent_getAction(event));

        {
            var jni = JNI.init(self.activity);
            defer jni.deinit();

            // Show/Hide keyboard
            // _ = jni.AndroidDisplayKeyboard(true);

            // this allows you to send the app in the background
            // const success = jni.AndroidSendToBack(true);
            // std.log.debug(.app, "SendToBack() = {}\n", .{success});

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
                \\  RawX:        {d}
                \\  RawY:        {d}
                \\  X:           {d}
                \\  Y:           {d}
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

            self.insertPoint(TouchPoint{
                .x = android.AMotionEvent_getX(event, i),
                .y = android.AMotionEvent_getY(event, i),
                .index = android.AMotionEvent_getPointerId(event, i),
                .age = android.AMotionEvent_getEventTime(event),
                .intensity = 1.0,
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

        const GLuint = c.GLuint;

        var program: GLuint = undefined;
        var uPos: c.GLint = undefined;
        var uAspect: c.GLint = undefined;
        var uIntensity: c.GLint = undefined;

        while (@atomicLoad(bool, &self.running, .SeqCst)) {

            // Input process
            {
                // we lock the handle of our input so we don't have a race condition
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
                // same for the EGL context
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

                        program = c.glCreateProgram();
                        {
                            var ps = c.glCreateShader(c.GL_VERTEX_SHADER);
                            var fs = c.glCreateShader(c.GL_FRAGMENT_SHADER);

                            var ps_code =
                                \\attribute vec2 vPosition;
                                \\varying vec2 uv;
                                \\void main() {
                                \\  uv = vPosition;
                                \\  gl_Position = vec4(2.0 * uv - 1.0, 0.0, 1.0);
                                \\}
                                \\
                            ;
                            var fs_code =
                                \\varying vec2 uv;
                                \\uniform vec2 uPos;
                                \\uniform float uAspect;
                                \\uniform float uIntensity;
                                \\void main() {
                                \\  vec2 rel = uv - uPos;
                                \\  rel.x *= uAspect;
                                \\  gl_FragColor = vec4(vec3(pow(uIntensity * clamp(1.0 - 10.0 * length(rel), 0.0, 1.0), 2.2)), 1.0);
                                \\}
                                \\
                            ;

                            c.glShaderSource(ps, 1, @ptrCast([*c]const [*c]const u8, &ps_code), null);
                            c.glShaderSource(fs, 1, @ptrCast([*c]const [*c]const u8, &fs_code), null);

                            c.glCompileShader(ps);
                            c.glCompileShader(fs);

                            c.glAttachShader(program, ps);
                            c.glAttachShader(program, fs);

                            c.glBindAttribLocation(program, 0, "vPosition");
                            c.glLinkProgram(program);

                            c.glDetachShader(program, ps);
                            c.glDetachShader(program, fs);
                        }

                        uPos = c.glGetUniformLocation(program, "uPos");
                        uAspect = c.glGetUniformLocation(program, "uAspect");
                        uIntensity = c.glGetUniformLocation(program, "uIntensity");

                        c.glEnable(c.GL_BLEND);
                        c.glBlendFunc(c.GL_ONE, c.GL_ONE);
                        c.glBlendEquation(c.GL_FUNC_ADD);

                        self.egl_init = false;
                    }

                    const t = @intToFloat(f32, loop) / 100.0;

                    c.glClearColor(
                        0.5 + 0.5 * std.math.sin(t + 0.0),
                        0.5 + 0.5 * std.math.sin(t + 1.0),
                        0.5 + 0.5 * std.math.sin(t + 2.0),
                        1.0,
                    );
                    c.glClear(c.GL_COLOR_BUFFER_BIT);

                    c.glUseProgram(program);

                    const vVertices = [_]c.GLfloat{
                        0.0, 0.0,
                        1.0, 0.0,
                        0.0, 1.0,
                        1.0, 1.0,
                    };

                    c.glVertexAttribPointer(0, 2, c.GL_FLOAT, c.GL_FALSE, 0, &vVertices);
                    c.glEnableVertexAttribArray(0);

                    for (self.touch_points) |*pt| {
                        if (pt.*) |*point| {
                            c.glUniform1f(uAspect, self.screen_width / self.screen_height);
                            c.glUniform2f(uPos, point.x / self.screen_width, 1.0 - point.y / self.screen_height);
                            c.glUniform1f(uIntensity, point.intensity);
                            c.glDrawArrays(c.GL_TRIANGLE_STRIP, 0, 4);

                            point.intensity -= 0.05;
                            if (point.intensity <= 0.0) {
                                pt.* = null;
                            }
                        }
                    }

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
