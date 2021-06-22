const std = @import("std");

const c = @import("c.zig");

const android = @import("android-bind.zig");
const build_options = @import("build_options");

pub const egl = @import("egl.zig");
pub const JNI = @import("jni.zig").JNI;

const app_log = std.log.scoped(.app_glue);

// Export the flat functions for now
// pub const native = android;
pub usingnamespace android;

const AndroidApp = @import("root").AndroidApp;

pub var sdk_version: c_int = 0;

/// Actual application entry point
export fn ANativeActivity_onCreate(activity: *android.ANativeActivity, savedState: ?[*]u8, savedStateSize: usize) callconv(.C) void {
    {
        var sdk_ver_str: [92]u8 = undefined;
        const len = android.__system_property_get("ro.build.version.sdk", &sdk_ver_str);
        if (len <= 0) {
            sdk_version = 0;
        } else {
            const str = sdk_ver_str[0..@intCast(usize, len)];
            sdk_version = std.fmt.parseInt(c_int, str, 10) catch 0;
        }
    }

    app_log.debug("Starting on Android Version {}\n", .{
        sdk_version,
    });

    const app = std.heap.c_allocator.create(AndroidApp) catch {
        app_log.emerg("Could not create new AndroidApp: OutOfMemory!\n", .{});
        return;
    };

    activity.callbacks.* = ANativeActivityGlue(AndroidApp).init();

    if (savedState) |state| {
        app.* = AndroidApp.initRestore(std.heap.c_allocator, activity, state[0..savedStateSize]) catch |err| {
            std.emerg("Failed to restore app state: {}\n", .{err});
            std.heap.c_allocator.destroy(app);
            return;
        };
    } else {
        app.* = AndroidApp.initFresh(std.heap.c_allocator, activity) catch |err| {
            std.emerg("Failed to restore app state: {}\n", .{err});
            std.heap.c_allocator.destroy(app);
            return;
        };
    }

    app.start() catch |err| {
        std.log.emerg("Failed to start app state: {}\n", .{err});
        app.deinit();
        std.heap.c_allocator.destroy(app);
        return;
    };

    activity.instance = app;

    app_log.debug("Successfully started the app.\n", .{});
}

// // Required by C code for now…
threadlocal var errno: c_int = 0;
export fn __errno_location() *c_int {
    return &errno;
}

// Android Panic implementation
pub fn panic(message: []const u8, stack_trace: ?*std.builtin.StackTrace) noreturn {
    std.log.emerg("PANIC: {s}\n", .{message});

    std.os.exit(1);
}

// Android Logging implementation
pub fn log(
    comptime message_level: std.log.Level,
    comptime scope: @Type(.EnumLiteral),
    comptime format: []const u8,
    args: anytype,
) void {
    var buffer: [8192]u8 = undefined;
    const msg = std.fmt.bufPrint(&buffer, "{s}: " ++ format ++ "\x00", .{@tagName(scope)} ++ args) catch {
        // TODO: Handle missing format here…
        return;
    };

    // Make slice 0-terminated with added nul terminator
    const msg0 = msg[0..(msg.len - 1) :0];

    // Using the function from liblog to write to the actual debug output
    _ = android.__android_log_write(
        switch (message_level) {
            //  => .ANDROID_LOG_VERBOSE,
            .debug => android.ANDROID_LOG_DEBUG,
            .info, .notice => android.ANDROID_LOG_INFO,
            .warn => android.ANDROID_LOG_WARN,
            .err => android.ANDROID_LOG_ERROR,
            .crit, .alert, .emerg => android.ANDROID_LOG_FATAL,
        },
        build_options.app_name.ptr,
        msg0.ptr,
    );
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
                app_log.debug("ANativeActivity callback {s} not available on {s}", .{ func, @typeName(App) });
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
                app_log.debug("ANativeActivity callback onSaveInstanceState not available on {s}", .{@typeName(App)});
            }
            return null;
        }

        fn onDestroy(activity: *android.ANativeActivity) callconv(.C) void {
            if (activity.instance) |instance| {
                const app = @ptrCast(*App, @alignCast(@alignOf(App), instance));
                app.deinit();
                std.heap.c_allocator.destroy(app);
            }
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
