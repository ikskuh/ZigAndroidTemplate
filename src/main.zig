const std = @import("std");

// const c = @cImport({
//     // @cInclude("android_native_app_glue.h");
//     @cInclude("android/log.h");
//     @cInclude("android/configuration.h");
//     @cInclude("android/looper.h");
//     @cInclude("android/native_activity.h");
// });

const c = @import("android-bind.zig");

const android_app = @Type(.Opaque);

extern var android_sdk_version: c_int;

extern fn __system_property_get(name: [*:0]const u8, value: [*]u8) callconv(.C) c_int;

extern fn zig_main(app: *android_app) callconv(.C) void;

fn main(app: *android_app) !void {
    {
        var sdk_ver_str: [92]u8 = undefined;
        const len = __system_property_get("ro.build.version.sdk", &sdk_ver_str);
        if (len <= 0) {
            android_sdk_version = 0;
        } else {
            const str = sdk_ver_str[0..@intCast(usize, len)];
            android_sdk_version = try std.fmt.parseInt(c_int, str, 10);
        }
    }

    std.log.debug(.app, "Starting on Android Version {}\n", .{
        android_sdk_version,
    });

    return zig_main(app);
}

export fn android_main(app: *android_app) callconv(.C) void {
    return main(app) catch |err| {
        std.log.emerg(.app, "Failed not execute main(): {}\n", .{
            err,
        });
    };
}

var suspended: bool = false;

export fn IsSuspended() callconv(.C) bool {
    return @atomicLoad(bool, &suspended, .SeqCst);
}

export fn HandleResume() callconv(.C) void {
    std.log.debug(.app, "Resuming app", .{});
    @atomicStore(bool, &suspended, false, .SeqCst);
}

export fn HandleSuspend() callconv(.C) void {
    std.log.debug(.app, "Suspending app", .{});
    @atomicStore(bool, &suspended, true, .SeqCst);
}

export fn HandleDestroy() callconv(.C) void {
    std.log.debug(.app, "Destroying app", .{});
}

// Required by C code for now…
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
    _ = c.__android_log_write(switch (message_level) {
        //  => .ANDROID_LOG_VERBOSE,
        .debug => c.ANDROID_LOG_DEBUG,
        .info, .notice => c.ANDROID_LOG_INFO,
        .warn => c.ANDROID_LOG_WARN,
        .err => c.ANDROID_LOG_ERROR,
        .crit, .alert, .emerg => c.ANDROID_LOG_FATAL,
    }, "ziggy", msg0.ptr);
}

export fn ANativeActivity_onCreate(activity: *c.ANativeActivity, savedState: ?[*]u8, savedStateSize: usize) callconv(.C) void {
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

    activity.instance = app;
}

/// Returns a wrapper implementation for the given App type which implements all
/// ANativeActivity callbacks.
fn ANativeActivityGlue(comptime App: type) type {
    return struct {
        pub fn init() c.ANativeActivityCallbacks {
            return c.ANativeActivityCallbacks{
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

        fn invoke(activity: *c.ANativeActivity, comptime func: []const u8, args: anytype) void {
            if (@hasDecl(App, func)) {
                if (activity.instance) |instance| {
                    @call(.{}, @field(App, func), .{@ptrCast(*App, @alignCast(@alignOf(App), instance))} ++ args);
                }
            } else {
                std.log.debug(.app_glue, "ANativeActivity callback {} not available on {}", .{ func, @typeName(App) });
            }
        }

        // return value must be created with malloc(), so we pass the c_allocator to App.onSaveInstanceState
        fn onSaveInstanceState(activity: *c.ANativeActivity, outSize: *usize) callconv(.C) ?[*]u8 {
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

        fn onDestroy(activity: *c.ANativeActivity) callconv(.C) void {
            invoke(activity, "onDestroy", .{});
        }
        fn onStart(activity: *c.ANativeActivity) callconv(.C) void {
            invoke(activity, "onStart", .{});
        }
        fn onResume(activity: *c.ANativeActivity) callconv(.C) void {
            invoke(activity, "onResume", .{});
        }
        fn onPause(activity: *c.ANativeActivity) callconv(.C) void {
            invoke(activity, "onPause", .{});
        }
        fn onStop(activity: *c.ANativeActivity) callconv(.C) void {
            invoke(activity, "onStop", .{});
        }
        fn onConfigurationChanged(activity: *c.ANativeActivity) callconv(.C) void {
            invoke(activity, "onConfigurationChanged", .{});
        }
        fn onLowMemory(activity: *c.ANativeActivity) callconv(.C) void {
            invoke(activity, "onLowMemory", .{});
        }
        fn onWindowFocusChanged(activity: *c.ANativeActivity, hasFocus: c_int) callconv(.C) void {
            invoke(activity, "onWindowFocusChanged", .{(hasFocus != 0)});
        }
        fn onNativeWindowCreated(activity: *c.ANativeActivity, window: ?*c.ANativeWindow) callconv(.C) void {
            invoke(activity, "onNativeWindowCreated", .{window});
        }
        fn onNativeWindowResized(activity: *c.ANativeActivity, window: ?*c.ANativeWindow) callconv(.C) void {
            invoke(activity, "onNativeWindowResized", .{window});
        }
        fn onNativeWindowRedrawNeeded(activity: *c.ANativeActivity, window: ?*c.ANativeWindow) callconv(.C) void {
            invoke(activity, "onNativeWindowRedrawNeeded", .{window});
        }
        fn onNativeWindowDestroyed(activity: *c.ANativeActivity, window: ?*c.ANativeWindow) callconv(.C) void {
            invoke(activity, "onNativeWindowDestroyed", .{window});
        }
        fn onInputQueueCreated(activity: *c.ANativeActivity, input_queue: ?*c.AInputQueue) callconv(.C) void {
            invoke(activity, "onInputQueueCreated", .{input_queue});
        }
        fn onInputQueueDestroyed(activity: *c.ANativeActivity, input_queue: ?*c.AInputQueue) callconv(.C) void {
            invoke(activity, "onInputQueueDestroyed", .{input_queue});
        }
        fn onContentRectChanged(activity: *c.ANativeActivity, rect: *const c.ARect) callconv(.C) void {
            invoke(activity, "onContentRectChanged", .{rect});
        }
    };
}

const AndroidApp = struct {
    const Self = @This();

    allocator: *std.mem.Allocator,
    activity: *c.ANativeActivity,

    fn initRestore(allocator: *std.mem.Allocator, activity: *c.ANativeActivity, stored_state: []const u8) !Self {
        return Self{
            .allocator = allocator,
            .activity = activity,
        };
    }

    fn initFresh(allocator: *std.mem.Allocator, activity: *c.ANativeActivity) !Self {
        return Self{
            .allocator = allocator,
            .activity = activity,
        };
    }

    fn onDestroy(self: *Self) void {
        self.allocator.destroy(self);
    }
};
