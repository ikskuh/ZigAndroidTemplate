const std = @import("std");

const c = @import("c.zig");
const EGLContext = @import("egl.zig").EGLContext;
const JNI = @import("jni.zig").JNI;

const android = @import("android-support.zig");
const build_options = @import("build_options");

pub const panic = android.panic;
pub const log = android.log;

pub const AndroidApp = struct {
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

    pub fn initRestore(allocator: *std.mem.Allocator, activity: *android.ANativeActivity, stored_state: []const u8) !Self {
        return Self{
            .allocator = allocator,
            .activity = activity,
        };
    }

    pub fn initFresh(allocator: *std.mem.Allocator, activity: *android.ANativeActivity) !Self {
        return Self{
            .allocator = allocator,
            .activity = activity,
        };
    }

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

    pub fn onDestroy(self: *Self) void {
        const allocator = self.allocator;
        self.deinit();
        allocator.destroy(self);
    }

    pub fn onNativeWindowCreated(self: *Self, window: *android.ANativeWindow) void {
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
