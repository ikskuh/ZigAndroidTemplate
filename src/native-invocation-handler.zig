const std = @import("std");
const android = @import("android-support.zig");
const Self = @This();

class: android.jobject,
initFn: android.jmethodID,

pub fn init(jni: android.JNI, class: android.jobject) Self {
    // const native_invocation_handler_buffer = @embedFile("NativeInvocationHandler.dex");
    // TODO: define class is not implemented on android
    // const NativeInvocationHandler = jni.invokeJni(.DefineClass, .{ "NativeInvocationHandler", class_loader, @ptrCast([*]const i8, &native_invocation_handler_buffer), native_invocation_handler_buffer.len });
    // const NativeInvocationHandler = jni.findClass("NativeInvocationHandler");
    // const NativeInvocationHandler = jni.findClass("net/random_projects/zig_android_template/NativeInvocationHandler");
    return Self{
        .class = class,
        .initFn = jni.invokeJni(.GetMethodID, .{ class, "<init>", "(J)V" }),
    };
}

pub fn createAlloc(self: Self, jni: android.JNI, alloc: std.mem.Allocator, pointer: ?*anyopaque, function: InvokeFn) !*InvocationHandler {
    // Create a InvocationHandler struct
    var handler = try alloc.create(InvocationHandler);
    errdefer alloc.destroy(handler);
    handler.* = .{
        .pointer = pointer,
        .function = function,
    };

    const handler_value = @ptrToInt(handler);
    std.debug.assert(handler_value <= 0x7fffffffffffffff);

    // Call handler constructor
    const result = jni.invokeJni(.NewObject, .{ self.class, self.initFn, handler_value }) orelse return error.InvocationHandlerInitError;
    // if (result != null) return error.InvocationHandlerInitError;
    _ = result;

    return handler;
}

/// Function signature for invoke functions
pub const InvokeFn = *const fn (?*anyopaque, android.JNI, android.jobject, android.jobjectArray) void;

/// InvocationHandler Technique found here https://groups.google.com/g/android-ndk/c/SRgy93Un8vM
const InvocationHandler = struct {
    pointer: ?*anyopaque,
    function: InvokeFn,

    /// Called by java class NativeInvocationHandler
    pub fn invoke0(jni: *android.JNIEnv, this: android.jobject, method: android.jobject, args: android.jobjectArray) android.jobject {
        const Class = jni.invokeJni(.GetObjectClass, .{this});
        const ptrField = jni.invokeJni(.GetFieldID, .{ Class, "ptr", "J" });
        const jptr = jni.GetLongField(this, ptrField);
        const h = @intToPtr(*InvocationHandler, jptr);
        return h.function(h.pointer, jni, method, args);
    }
};
