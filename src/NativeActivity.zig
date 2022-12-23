const std = @import("std");
const log = std.log.scoped(.jni);
const android = @import("android-support.zig");

const Self = @This();

activity: *android.ANativeActivity,
jni: *android.JNI,
activity_class: android.jclass,

pub fn init(activity: *android.ANativeActivity) Self {
    var env: *android.JNIEnv = undefined;
    _ = activity.vm.*.AttachCurrentThread(activity.vm, &env, null);
    return fromJniEnv(activity, env);
}

/// Get the JNIEnv associated with the current thread.
pub fn get(activity: *android.ANativeActivity) Self {
    var env: *android.JNIEnv = undefined;
    _ = activity.vm.*.GetEnv(activity.vm, @ptrCast(*?*anyopaque, &env), android.JNI_VERSION_1_6);
    return fromJniEnv(activity, env);
}

fn fromJniEnv(activity: *android.ANativeActivity, env: *android.JNIEnv) Self {
    var activityClass = env.*.FindClass(env, "android/app/NativeActivity");

    return Self{
        .activity = activity,
        .jni = @ptrCast(*android.JNI, env),
        .activity_class = activityClass,
    };
}

pub fn deinit(self: *Self) void {
    _ = self.activity.vm.*.DetachCurrentThread(self.activity.vm);
    self.* = undefined;
}

pub fn AndroidGetUnicodeChar(self: *Self, keyCode: c_int, metaState: c_int) !u21 {
    // https://stackoverflow.com/questions/21124051/receive-complete-android-unicode-input-in-c-c/43871301
    const eventType = android.AKEY_EVENT_ACTION_DOWN;

    const class_key_event = try self.jni.findClass("android/view/KeyEvent");

    const method_get_unicode_char = try self.jni.invokeJni(.GetMethodID, .{ class_key_event, "getUnicodeChar", "(I)I" });
    const eventConstructor = try self.jni.invokeJni(.GetMethodID, .{ class_key_event, "<init>", "(II)V" });
    const eventObj = try self.jni.invokeJni(.NewObject, .{ class_key_event, eventConstructor, eventType, keyCode });

    const unicodeKey = try self.jni.invokeJni(.CallIntMethod, .{ eventObj, method_get_unicode_char, metaState });

    return @intCast(u21, unicodeKey);
}

pub fn AndroidMakeFullscreen(self: *Self) !void {
    // Partially based on
    // https://stackoverflow.com/questions/47507714/how-do-i-enable-full-screen-immersive-mode-for-a-native-activity-ndk-app

    // Get android.app.NativeActivity, then get getWindow method handle, returns
    // view.Window type
    const activityClass = try self.jni.findClass("android/app/NativeActivity");
    const getWindow = try self.jni.invokeJni(.GetMethodID, .{ activityClass, "getWindow", "()Landroid/view/Window;" });
    const window = try self.jni.invokeJni(.CallObjectMethod, .{ self.activity.clazz, getWindow });

    // Get android.view.Window class, then get getDecorView method handle, returns
    // view.View type
    const windowClass = try self.jni.findClass("android/view/Window");
    const getDecorView = try self.jni.invokeJni(.GetMethodID, .{ windowClass, "getDecorView", "()Landroid/view/View;" });
    const decorView = try self.jni.invokeJni(.CallObjectMethod, .{ window, getDecorView });

    // Get the flag values associated with systemuivisibility
    const viewClass = try self.jni.findClass("android/view/View");
    const flagLayoutHideNavigation = try self.jni.invokeJni(.GetStaticIntField, .{ viewClass, try self.jni.invokeJni(.GetStaticFieldID, .{ viewClass, "SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION", "I" }) });
    const flagLayoutFullscreen = try self.jni.invokeJni(.GetStaticIntField, .{ viewClass, try self.jni.invokeJni(.GetStaticFieldID, .{ viewClass, "SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN", "I" }) });
    const flagLowProfile = try self.jni.invokeJni(.GetStaticIntField, .{ viewClass, try self.jni.invokeJni(.GetStaticFieldID, .{ viewClass, "SYSTEM_UI_FLAG_LOW_PROFILE", "I" }) });
    const flagHideNavigation = try self.jni.invokeJni(.GetStaticIntField, .{ viewClass, try self.jni.invokeJni(.GetStaticFieldID, .{ viewClass, "SYSTEM_UI_FLAG_HIDE_NAVIGATION", "I" }) });
    const flagFullscreen = try self.jni.invokeJni(.GetStaticIntField, .{ viewClass, try self.jni.invokeJni(.GetStaticFieldID, .{ viewClass, "SYSTEM_UI_FLAG_FULLSCREEN", "I" }) });
    const flagImmersiveSticky = try self.jni.invokeJni(.GetStaticIntField, .{ viewClass, try self.jni.invokeJni(.GetStaticFieldID, .{ viewClass, "SYSTEM_UI_FLAG_IMMERSIVE_STICKY", "I" }) });

    const setSystemUiVisibility = try self.jni.invokeJni(.GetMethodID, .{ viewClass, "setSystemUiVisibility", "(I)V" });

    // Call the decorView.setSystemUiVisibility(FLAGS)
    try self.jni.invokeJni(.CallVoidMethod, .{
        decorView,
        setSystemUiVisibility,
        (flagLayoutHideNavigation | flagLayoutFullscreen | flagLowProfile | flagHideNavigation | flagFullscreen | flagImmersiveSticky),
    });

    // now set some more flags associated with layoutmanager -- note the $ in the
    // class path search for api-versions.xml
    // https://android.googlesource.com/platform/development/+/refs/tags/android-9.0.0_r48/sdk/api-versions.xml

    const layoutManagerClass = try self.jni.findClass("android/view/WindowManager$LayoutParams");
    const flag_WinMan_Fullscreen = try self.jni.invokeJni(.GetStaticIntField, .{ layoutManagerClass, try self.jni.invokeJni(.GetStaticFieldID, .{ layoutManagerClass, "FLAG_FULLSCREEN", "I" }) });
    const flag_WinMan_KeepScreenOn = try self.jni.invokeJni(.GetStaticIntField, .{ layoutManagerClass, try self.jni.invokeJni(.GetStaticFieldID, .{ layoutManagerClass, "FLAG_KEEP_SCREEN_ON", "I" }) });
    const flag_WinMan_hw_acc = try self.jni.invokeJni(.GetStaticIntField, .{ layoutManagerClass, try self.jni.invokeJni(.GetStaticFieldID, .{ layoutManagerClass, "FLAG_HARDWARE_ACCELERATED", "I" }) });
    //    const int flag_WinMan_flag_not_fullscreen =
    //    env.GetStaticIntField(layoutManagerClass,
    //    (env.GetStaticFieldID(layoutManagerClass, "FLAG_FORCE_NOT_FULLSCREEN",
    //    "I") ));
    // call window.addFlags(FLAGS)
    try self.jni.invokeJni(.CallVoidMethod, .{
        window,
        try self.jni.invokeJni(.GetMethodID, .{ windowClass, "addFlags", "(I)V" }),
        (flag_WinMan_Fullscreen | flag_WinMan_KeepScreenOn | flag_WinMan_hw_acc),
    });
}

pub fn AndroidDisplayKeyboard(self: *Self, show: bool) !bool {
    // Based on
    // https://stackoverflow.com/questions/5864790/how-to-show-the-soft-keyboard-on-native-activity
    var lFlags: android.jint = 0;

    // Retrieves Context.INPUT_METHOD_SERVICE.
    const ClassContext = try self.jni.findClass("android/content/Context");
    const FieldINPUT_METHOD_SERVICE = try self.jni.invokeJni(.GetStaticFieldID, .{ ClassContext, "INPUT_METHOD_SERVICE", "Ljava/lang/String;" });
    const INPUT_METHOD_SERVICE = try self.jni.invokeJni(.GetStaticObjectField, .{ ClassContext, FieldINPUT_METHOD_SERVICE });

    // Runs getSystemService(Context.INPUT_METHOD_SERVICE).
    const ClassInputMethodManager = try self.jni.findClass("android/view/inputmethod/InputMethodManager");
    const MethodGetSystemService = try self.jni.invokeJni(.GetMethodID, .{ self.activity_class, "getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;" });
    const lInputMethodManager = try self.jni.invokeJni(.CallObjectMethod, .{ self.activity.clazz, MethodGetSystemService, INPUT_METHOD_SERVICE });

    // Runs getWindow().getDecorView().
    const MethodGetWindow = try self.jni.invokeJni(.GetMethodID, .{ self.activity_class, "getWindow", "()Landroid/view/Window;" });
    const lWindow = try self.jni.invokeJni(.CallObjectMethod, .{ self.activity.clazz, MethodGetWindow });
    const ClassWindow = try self.jni.findClass("android/view/Window");
    const MethodGetDecorView = try self.jni.invokeJni(.GetMethodID, .{ ClassWindow, "getDecorView", "()Landroid/view/View;" });
    const lDecorView = try self.jni.invokeJni(.CallObjectMethod, .{ lWindow, MethodGetDecorView });

    if (show) {
        // Runs lInputMethodManager.showSoftInput(...).
        const MethodShowSoftInput = try self.jni.invokeJni(.GetMethodID, .{ ClassInputMethodManager, "showSoftInput", "(Landroid/view/View;I)Z" });
        return 0 != try self.jni.invokeJni(.CallBooleanMethod, .{ lInputMethodManager, MethodShowSoftInput, lDecorView, lFlags });
    } else {
        // Runs lWindow.getViewToken()
        const ClassView = try self.jni.findClass("android/view/View");
        const MethodGetWindowToken = try self.jni.invokeJni(.GetMethodID, .{ ClassView, "getWindowToken", "()Landroid/os/IBinder;" });
        const lBinder = try self.jni.invokeJni(.CallObjectMethod, .{ lDecorView, MethodGetWindowToken });

        // lInputMethodManager.hideSoftInput(...).
        const MethodHideSoftInput = try self.jni.invokeJni(.GetMethodID, .{ ClassInputMethodManager, "hideSoftInputFromWindow", "(Landroid/os/IBinder;I)Z" });
        return 0 != try self.jni.invokeJni(.CallBooleanMethod, .{ lInputMethodManager, MethodHideSoftInput, lBinder, lFlags });
    }
}

/// Move the task containing this activity to the back of the activity stack.
/// The activity's order within the task is unchanged.
/// nonRoot: If false then this only works if the activity is the root of a task; if true it will work for any activity in a task.
/// returns: If the task was moved (or it was already at the back) true is returned, else false.
pub fn AndroidSendToBack(self: *Self, nonRoot: bool) !bool {
    const ClassActivity = try self.jni.findClass("android/app/Activity");
    const MethodmoveTaskToBack = try self.jni.invokeJni(.GetMethodID, .{ ClassActivity, "moveTaskToBack", "(Z)Z" });

    return 0 != try self.jni.invokeJni(.CallBooleanMethod, .{ self.activity.clazz, MethodmoveTaskToBack, if (nonRoot) @as(c_int, 1) else 0 });
}

pub fn AndroidHasPermissions(self: *Self, perm_name: [:0]const u8) !bool {
    if (android.sdk_version < 23) {
        log.err(
            "Android SDK version {} does not support AndroidRequestAppPermissions\n",
            .{android.sdk_version},
        );
        return false;
    }

    const ls_PERM = try self.jni.invokeJni(.NewStringUTF, .{perm_name});

    const PERMISSION_GRANTED = blk: {
        var ClassPackageManager = try self.jni.findClass("android/content/pm/PackageManager");
        var lid_PERMISSION_GRANTED = try self.jni.invokeJni(.GetStaticFieldID, .{ ClassPackageManager, "PERMISSION_GRANTED", "I" });
        break :blk try self.jni.invokeJni(.GetStaticIntField, .{ ClassPackageManager, lid_PERMISSION_GRANTED });
    };

    const ClassContext = try self.jni.findClass("android/content/Context");
    const MethodcheckSelfPermission = try self.jni.invokeJni(.GetMethodID, .{ ClassContext, "checkSelfPermission", "(Ljava/lang/String;)I" });
    const int_result = try self.jni.invokeJni(.CallIntMethod, .{ self.activity.clazz, MethodcheckSelfPermission, ls_PERM });
    return (int_result == PERMISSION_GRANTED);
}

pub fn AndroidRequestAppPermissions(self: *Self, perm_name: [:0]const u8) !void {
    if (android.sdk_version < 23) {
        log.err(
            "Android SDK version {} does not support AndroidRequestAppPermissions\n",
            .{android.sdk_version},
        );
        return;
    }

    const perm_array = try self.jni.invokeJni(.NewObjectArray, .{
        1,
        try self.jni.findClass("java/lang/String"),
        try self.jni.invokeJni(.NewStringUTF, .{perm_name}),
    });

    const MethodrequestPermissions = try self.jni.invokeJni(.GetMethodID, .{ self.activity_class, "requestPermissions", "([Ljava/lang/String;I)V" });

    // Last arg (0) is just for the callback (that I do not use)
    try self.jni.invokeJni(.CallVoidMethod, .{ self.activity.clazz, MethodrequestPermissions, perm_array, @as(c_int, 0) });
}

pub fn getFilesDir(self: *Self, allocator: std.mem.Allocator) ![:0]const u8 {
    const getFilesDirMethod = try self.jni.invokeJni(.GetMethodID, .{ self.activity_class, "getFilesDir", "()Ljava/io/File;" });

    const files_dir = try self.jni.*.CallObjectMethod(try self.jni, self.activity.clazz, getFilesDirMethod);

    const fileClass = try self.jni.findClass("java/io/File");

    const getPathMethod = try self.jni.invokeJni(.GetMethodID, .{ fileClass, "getPath", "()Ljava/lang/String;" });

    const path_string = try self.jni.*.CallObjectMethod(try self.jni, files_dir, getPathMethod);

    const utf8_or_null = try self.jni.invokeJni(.GetStringUTFChars, .{ path_string, null });

    if (utf8_or_null) |utf8_ptr| {
        defer self.jni.invokeJniNoException(.ReleaseStringUTFChars, .{ path_string, utf8_ptr });

        const utf8 = std.mem.sliceTo(utf8_ptr, 0);

        return try allocator.dupeZ(u8, utf8);
    } else {
        return error.OutOfMemory;
    }
}

comptime {
    _ = AndroidGetUnicodeChar;
    _ = AndroidMakeFullscreen;
    _ = AndroidDisplayKeyboard;
    _ = AndroidSendToBack;
    _ = AndroidHasPermissions;
    _ = AndroidRequestAppPermissions;
}
