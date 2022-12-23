const std = @import("std");
const android = @import("android-support.zig");
const Self = @This();

class: android.jobject,
initFn: android.jmethodID,

pub fn init(jni: android.jni.JNI, class: android.jobject) Self {
    const methods = [_]android.JNINativeMethod{
        .{
            .name = "invoke0",
            .signature = "(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;",
            .fnPtr = InvocationHandler.invoke0,
        },
    };
    _ = jni.invokeJni(.RegisterNatives, .{ class, &methods, methods.len });
    return Self{
        .class = class,
        .initFn = jni.invokeJni(.GetMethodID, .{ class, "<init>", "(J)V" }),
    };
}

pub fn createAlloc(self: Self, jni: android.jni.JNI, alloc: std.mem.Allocator, pointer: ?*anyopaque, function: InvokeFn) !android.jobject {
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
    // _ = result;
    return result;

    // return handler;
}

/// Function signature for invoke functions
pub const InvokeFn = *const fn (?*anyopaque, android.jni.JNI, android.jobject, android.jobjectArray) android.jobject;

/// InvocationHandler Technique found here https://groups.google.com/g/android-ndk/c/SRgy93Un8vM
const InvocationHandler = struct {
    pointer: ?*anyopaque,
    function: InvokeFn,

    /// Called by java class NativeInvocationHandler
    pub fn invoke0(jni_env: *android.JNIEnv, this: android.jobject, proxy: android.jobject, method: android.jobject, args: android.jobjectArray) android.jobject {
        _ = proxy; // This is the proxy object. Calling anything on it will cause invoke to be called. If this isn't explicitly handled, it will recurse infinitely
        const jni = android.jni.JNI.init(jni_env);
        const Class = jni.invokeJni(.GetObjectClass, .{this});
        const ptrField = jni.invokeJni(.GetFieldID, .{ Class, "ptr", "J" });
        const jptr = jni.getLongField(this, ptrField);
        const h = @intToPtr(*InvocationHandler, @intCast(usize, jptr));
        return h.function(h.pointer, jni, method, args);
    }
};
