const std = @import("std");
const log = std.log.scoped(.jni);
const android = @import("android-support.zig");

/// Wraps JNIEnv to provide a better Zig API.
/// *android.JNIEnv can be directly cast to `*JNI`. For example:
/// ```
/// const jni = @ptrCast(*JNI, jni_env);
/// ```
pub const JNI = opaque {
    // Underlying implementation
    fn JniReturnType(comptime function: @TypeOf(.literal)) type {
        @setEvalBranchQuota(10_000);
        return @typeInfo(@typeInfo(std.meta.fieldInfo(android.JNINativeInterface, function).type).Pointer.child).Fn.return_type.?;
    }

    pub inline fn invokeJniNoException(jni: *JNI, comptime function: @TypeOf(.literal), args: anytype) JniReturnType(function) {
        const env = @ptrCast(*android.JNIEnv, @alignCast(@alignOf(*android.JNIEnv), jni));
        return @call(
            .auto,
            @field(env.*, @tagName(function)),
            .{env} ++ args,
        );
    }

    /// Possible JNI Errors
    const Error = error{
        ExceptionThrown,
        ClassNotDefined,
    };

    pub inline fn invokeJni(jni: *JNI, comptime function: @TypeOf(.literal), args: anytype) Error!JniReturnType(function) {
        const value = jni.invokeJniNoException(function, args);
        if (jni.invokeJniNoException(.ExceptionCheck, .{}) == android.JNI_TRUE) {
            log.err("Encountered exception while calling: {s} {any}", .{ @tagName(function), args });
            return Error.ExceptionThrown;
        }
        return value;
    }

    // Convenience functions

    pub fn findClass(jni: *JNI, class: [:0]const u8) Error!android.jclass {
        return jni.invokeJni(.FindClass, .{class.ptr}) catch {
            log.err("Class Not Found: {s}", .{class});
            return Error.ClassNotDefined;
        };
    }

    pub fn getClassNameString(jni: *JNI, object: android.jobject) Error!String {
        const object_class = try jni.invokeJni(.GetObjectClass, .{object});
        const ClassClass = try jni.findClass("java/lang/Class");
        const getName = try jni.invokeJni(.GetMethodID, .{ ClassClass, "getName", "()Ljava/lang/String;" });
        const name = try jni.invokeJni(.CallObjectMethod, .{ object_class, getName });
        return String.init(jni, name);
    }

    pub fn printToString(jni: *JNI, object: android.jobject) void {
        const string = try String.init(jni, try jni.callObjectMethod(object, "toString", "()Ljava/lang/String;", .{}));
        defer string.deinit(jni);
        log.info("{any}: {}", .{ object, std.unicode.fmtUtf16le(string.slice) });
    }

    pub fn newString(jni: *JNI, string: [*:0]const u8) Error!android.jstring {
        return jni.invokeJni(.NewStringUTF, .{string});
    }

    pub fn getLongField(jni: *JNI, object: android.jobject, field_id: android.jfieldID) !android.jlong {
        return jni.invokeJni(.GetLongField, .{ object, field_id });
    }

    pub fn callObjectMethod(jni: *JNI, object: android.jobject, name: [:0]const u8, signature: [:0]const u8, args: anytype) Error!JniReturnType(.CallObjectMethod) {
        const object_class = try jni.invokeJni(.GetObjectClass, .{object});
        const method_id = try jni.invokeJni(.GetMethodID, .{ object_class, name, signature });
        return jni.invokeJni(.CallObjectMethod, .{ object, method_id } ++ args);
    }

    pub const String = struct {
        jstring: android.jstring,
        slice: []const u16,

        pub fn init(jni: *JNI, string: android.jstring) Error!String {
            const len = try jni.invokeJni(.GetStringLength, .{string});
            const ptr = try jni.invokeJni(.GetStringChars, .{ string, null });
            const slice = ptr[0..@intCast(usize, len)];
            return String{
                .jstring = string,
                .slice = slice,
            };
        }

        pub fn deinit(string: String, jni: *JNI) void {
            jni.invokeJniNoException(.ReleaseStringChars, .{ string.jstring, string.slice.ptr });
        }
    };
};
