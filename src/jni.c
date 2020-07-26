#include <jni.h>
#include <android/native_activity.h>

void AndroidMakeFullscreen()
{
  //Partially based on https://stackoverflow.com/questions/47507714/how-do-i-enable-full-screen-immersive-mode-for-a-native-activity-ndk-app
  const struct JNINativeInterface *env = 0;
  const struct JNINativeInterface **envptr = &env;
  const struct JNIInvokeInterface **jniiptr = gapp->activity->vm;
  const struct JNIInvokeInterface *jnii = *jniiptr;

  jnii->AttachCurrentThread(jniiptr, &envptr, NULL);
  env = (*envptr);

  //Get android.app.NativeActivity, then get getWindow method handle, returns view.Window type
  jclass activityClass = env->FindClass(envptr, "android/app/NativeActivity");
  jmethodID getWindow = env->GetMethodID(envptr, activityClass, "getWindow", "()Landroid/view/Window;");
  jobject window = env->CallObjectMethod(envptr, gapp->activity->clazz, getWindow);

  //Get android.view.Window class, then get getDecorView method handle, returns view.View type
  jclass windowClass = env->FindClass(envptr, "android/view/Window");
  jmethodID getDecorView = env->GetMethodID(envptr, windowClass, "getDecorView", "()Landroid/view/View;");
  jobject decorView = env->CallObjectMethod(envptr, window, getDecorView);

  //Get the flag values associated with systemuivisibility
  jclass viewClass = env->FindClass(envptr, "android/view/View");
  const int flagLayoutHideNavigation = env->GetStaticIntField(envptr, viewClass, env->GetStaticFieldID(envptr, viewClass, "SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION", "I"));
  const int flagLayoutFullscreen = env->GetStaticIntField(envptr, viewClass, env->GetStaticFieldID(envptr, viewClass, "SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN", "I"));
  const int flagLowProfile = env->GetStaticIntField(envptr, viewClass, env->GetStaticFieldID(envptr, viewClass, "SYSTEM_UI_FLAG_LOW_PROFILE", "I"));
  const int flagHideNavigation = env->GetStaticIntField(envptr, viewClass, env->GetStaticFieldID(envptr, viewClass, "SYSTEM_UI_FLAG_HIDE_NAVIGATION", "I"));
  const int flagFullscreen = env->GetStaticIntField(envptr, viewClass, env->GetStaticFieldID(envptr, viewClass, "SYSTEM_UI_FLAG_FULLSCREEN", "I"));
  const int flagImmersiveSticky = env->GetStaticIntField(envptr, viewClass, env->GetStaticFieldID(envptr, viewClass, "SYSTEM_UI_FLAG_IMMERSIVE_STICKY", "I"));

  jmethodID setSystemUiVisibility = env->GetMethodID(envptr, viewClass, "setSystemUiVisibility", "(I)V");

  //Call the decorView.setSystemUiVisibility(FLAGS)
  env->CallVoidMethod(envptr, decorView, setSystemUiVisibility,
                      (flagLayoutHideNavigation | flagLayoutFullscreen | flagLowProfile | flagHideNavigation | flagFullscreen | flagImmersiveSticky));

  //now set some more flags associated with layoutmanager -- note the $ in the class path
  //search for api-versions.xml
  //https://android.googlesource.com/platform/development/+/refs/tags/android-9.0.0_r48/sdk/api-versions.xml

  jclass layoutManagerClass = env->FindClass(envptr, "android/view/WindowManager$LayoutParams");
  const int flag_WinMan_Fullscreen = env->GetStaticIntField(envptr, layoutManagerClass, (env->GetStaticFieldID(envptr, layoutManagerClass, "FLAG_FULLSCREEN", "I")));
  const int flag_WinMan_KeepScreenOn = env->GetStaticIntField(envptr, layoutManagerClass, (env->GetStaticFieldID(envptr, layoutManagerClass, "FLAG_KEEP_SCREEN_ON", "I")));
  const int flag_WinMan_hw_acc = env->GetStaticIntField(envptr, layoutManagerClass, (env->GetStaticFieldID(envptr, layoutManagerClass, "FLAG_HARDWARE_ACCELERATED", "I")));
  //    const int flag_WinMan_flag_not_fullscreen = env->GetStaticIntField(layoutManagerClass, (env->GetStaticFieldID(layoutManagerClass, "FLAG_FORCE_NOT_FULLSCREEN", "I") ));
  //call window.addFlags(FLAGS)
  env->CallVoidMethod(envptr, window, (env->GetMethodID(envptr, windowClass, "addFlags", "(I)V")), (flag_WinMan_Fullscreen | flag_WinMan_KeepScreenOn | flag_WinMan_hw_acc));

  jnii->DetachCurrentThread(jniiptr);
}

void AndroidDisplayKeyboard(int pShow)
{
  //Based on https://stackoverflow.com/questions/5864790/how-to-show-the-soft-keyboard-on-native-activity
  jint lFlags = 0;
  const struct JNINativeInterface *env = 0;
  const struct JNINativeInterface **envptr = &env;
  const struct JNIInvokeInterface **jniiptr = gapp->activity->vm;
  const struct JNIInvokeInterface *jnii = *jniiptr;

  jnii->AttachCurrentThread(jniiptr, &envptr, NULL);
  env = (*envptr);
  jclass activityClass = env->FindClass(envptr, "android/app/NativeActivity");

  // Retrieves NativeActivity.
  jobject lNativeActivity = gapp->activity->clazz;

  // Retrieves Context.INPUT_METHOD_SERVICE.
  jclass ClassContext = env->FindClass(envptr, "android/content/Context");
  jfieldID FieldINPUT_METHOD_SERVICE = env->GetStaticFieldID(envptr, ClassContext, "INPUT_METHOD_SERVICE", "Ljava/lang/String;");
  jobject INPUT_METHOD_SERVICE = env->GetStaticObjectField(envptr, ClassContext, FieldINPUT_METHOD_SERVICE);

  // Runs getSystemService(Context.INPUT_METHOD_SERVICE).
  jclass ClassInputMethodManager = env->FindClass(envptr, "android/view/inputmethod/InputMethodManager");
  jmethodID MethodGetSystemService = env->GetMethodID(envptr, activityClass, "getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;");
  jobject lInputMethodManager = env->CallObjectMethod(envptr, lNativeActivity, MethodGetSystemService, INPUT_METHOD_SERVICE);

  // Runs getWindow().getDecorView().
  jmethodID MethodGetWindow = env->GetMethodID(envptr, activityClass, "getWindow", "()Landroid/view/Window;");
  jobject lWindow = env->CallObjectMethod(envptr, lNativeActivity, MethodGetWindow);
  jclass ClassWindow = env->FindClass(envptr, "android/view/Window");
  jmethodID MethodGetDecorView = env->GetMethodID(envptr, ClassWindow, "getDecorView", "()Landroid/view/View;");
  jobject lDecorView = env->CallObjectMethod(envptr, lWindow, MethodGetDecorView);

  if (pShow)
  {
    // Runs lInputMethodManager.showSoftInput(...).
    jmethodID MethodShowSoftInput = env->GetMethodID(envptr, ClassInputMethodManager, "showSoftInput", "(Landroid/view/View;I)Z");
    /*jboolean lResult = */ env->CallBooleanMethod(envptr, lInputMethodManager, MethodShowSoftInput, lDecorView, lFlags);
  }
  else
  {
    // Runs lWindow.getViewToken()
    jclass ClassView = env->FindClass(envptr, "android/view/View");
    jmethodID MethodGetWindowToken = env->GetMethodID(envptr, ClassView, "getWindowToken", "()Landroid/os/IBinder;");
    jobject lBinder = env->CallObjectMethod(envptr, lDecorView, MethodGetWindowToken);

    // lInputMethodManager.hideSoftInput(...).
    jmethodID MethodHideSoftInput = env->GetMethodID(envptr, ClassInputMethodManager, "hideSoftInputFromWindow", "(Landroid/os/IBinder;I)Z");
    /*jboolean lRes = */ env->CallBooleanMethod(envptr, lInputMethodManager, MethodHideSoftInput, lBinder, lFlags);
  }

  // Finished with the JVM.
  jnii->DetachCurrentThread(jniiptr);
}

int AndroidGetUnicodeChar(int keyCode, int metaState)
{
  //https://stackoverflow.com/questions/21124051/receive-complete-android-unicode-input-in-c-c/43871301

  int eventType = AKEY_EVENT_ACTION_DOWN;
  const struct JNINativeInterface *env = 0;
  const struct JNINativeInterface **envptr = &env;
  const struct JNIInvokeInterface **jniiptr = gapp->activity->vm;
  const struct JNIInvokeInterface *jnii = *jniiptr;

  jnii->AttachCurrentThread(jniiptr, &envptr, NULL);
  env = (*envptr);
  //jclass activityClass = env->FindClass( envptr, "android/app/NativeActivity");
  // Retrieves NativeActivity.
  //jobject lNativeActivity = gapp->activity->clazz;

  jclass class_key_event = env->FindClass(envptr, "android/view/KeyEvent");
  int unicodeKey;

  jmethodID method_get_unicode_char = env->GetMethodID(envptr, class_key_event, "getUnicodeChar", "(I)I");
  jmethodID eventConstructor = env->GetMethodID(envptr, class_key_event, "<init>", "(II)V");
  jobject eventObj = env->NewObject(envptr, class_key_event, eventConstructor, eventType, keyCode);

  unicodeKey = env->CallIntMethod(envptr, eventObj, method_get_unicode_char, metaState);

  // Finished with the JVM.
  jnii->DetachCurrentThread(jniiptr);

  //printf("Unicode key is: %d", unicodeKey);
  return unicodeKey;
}

//Based on: https://stackoverflow.com/questions/41820039/jstringjni-to-stdstringc-with-utf8-characters

jstring android_permission_name(const struct JNINativeInterface **envptr, const char *perm_name)
{
  // nested class permission in class android.Manifest,
  // hence android 'slash' Manifest 'dollar' permission
  const struct JNINativeInterface *env = *envptr;
  jclass ClassManifestpermission = env->FindClass(envptr, "android/Manifest$permission");
  jfieldID lid_PERM = env->GetStaticFieldID(envptr, ClassManifestpermission, perm_name, "Ljava/lang/String;");
  jstring ls_PERM = (jstring)(env->GetStaticObjectField(envptr, ClassManifestpermission, lid_PERM));
  return ls_PERM;
}

/**
 * \brief Tests whether a permission is granted.
 * \param[in] app a pointer to the android app.
 * \param[in] perm_name the name of the permission, e.g.,
 *   "READ_EXTERNAL_STORAGE", "WRITE_EXTERNAL_STORAGE".
 * \retval true if the permission is granted.
 * \retval false otherwise.
 * \note Requires Android API level 23 (Marshmallow, May 2015)
 */
int AndroidHasPermissions(const char *perm_name)
{
  struct android_app *app = gapp;
  const struct JNINativeInterface *env = 0;
  const struct JNINativeInterface **envptr = &env;
  const struct JNIInvokeInterface **jniiptr = app->activity->vm;
  const struct JNIInvokeInterface *jnii = *jniiptr;

  if (android_sdk_version < 23)
  {
    printf("Android SDK version %d does not support AndroidHasPermissions\n", android_sdk_version);
    return 1;
  }

  jnii->AttachCurrentThread(jniiptr, &envptr, NULL);
  env = (*envptr);

  int result = 0;
  jstring ls_PERM = android_permission_name(envptr, perm_name);

  jint PERMISSION_GRANTED = (-1);

  {
    jclass ClassPackageManager = env->FindClass(envptr, "android/content/pm/PackageManager");
    jfieldID lid_PERMISSION_GRANTED = env->GetStaticFieldID(envptr, ClassPackageManager, "PERMISSION_GRANTED", "I");
    PERMISSION_GRANTED = env->GetStaticIntField(envptr, ClassPackageManager, lid_PERMISSION_GRANTED);
  }
  {
    jobject activity = app->activity->clazz;
    jclass ClassContext = env->FindClass(envptr, "android/content/Context");
    jmethodID MethodcheckSelfPermission = env->GetMethodID(envptr, ClassContext, "checkSelfPermission", "(Ljava/lang/String;)I");
    jint int_result = env->CallIntMethod(envptr, activity, MethodcheckSelfPermission, ls_PERM);
    result = (int_result == PERMISSION_GRANTED);
  }

  jnii->DetachCurrentThread(jniiptr);

  return result;
}

/**
 * \brief Query file permissions.
 * \details This opens the system dialog that lets the user
 *  grant (or deny) the permission.
 * \param[in] app a pointer to the android app.
 * \note Requires Android API level 23 (Marshmallow, May 2015)
 */
void AndroidRequestAppPermissions(const char *perm)
{
  if (android_sdk_version < 23)
  {
    printf("Android SDK version %d does not support AndroidRequestAppPermissions\n", android_sdk_version);
    return;
  }

  struct android_app *app = gapp;
  const struct JNINativeInterface *env = 0;
  const struct JNINativeInterface **envptr = &env;
  const struct JNIInvokeInterface **jniiptr = app->activity->vm;
  const struct JNIInvokeInterface *jnii = *jniiptr;
  jnii->AttachCurrentThread(jniiptr, &envptr, NULL);
  env = (*envptr);
  jobject activity = app->activity->clazz;

  jobjectArray perm_array = env->NewObjectArray(envptr, 1, env->FindClass(envptr, "java/lang/String"), env->NewStringUTF(envptr, ""));
  env->SetObjectArrayElement(envptr, perm_array, 0, android_permission_name(envptr, perm));
  jclass ClassActivity = env->FindClass(envptr, "android/app/Activity");

  jmethodID MethodrequestPermissions = env->GetMethodID(envptr, ClassActivity, "requestPermissions", "([Ljava/lang/String;I)V");

  // Last arg (0) is just for the callback (that I do not use)
  env->CallVoidMethod(envptr, activity, MethodrequestPermissions, perm_array, 0);
  jnii->DetachCurrentThread(jniiptr);
}

/* Example:
	int hasperm = android_has_permission( "RECORD_AUDIO" );
	if( !hasperm )
	{
		android_request_app_permissions( "RECORD_AUDIO" );
	}
*/

void AndroidSendToBack(int param)
{
  struct android_app *app = gapp;
  const struct JNINativeInterface *env = 0;
  const struct JNINativeInterface **envptr = &env;
  const struct JNIInvokeInterface **jniiptr = app->activity->vm;
  const struct JNIInvokeInterface *jnii = *jniiptr;
  jnii->AttachCurrentThread(jniiptr, &envptr, NULL);
  env = (*envptr);
  jobject activity = app->activity->clazz;

  //_glfmCallJavaMethodWithArgs(jni, gapp->activity->clazz, "moveTaskToBack", "(Z)Z", Boolean, false);
  jclass ClassActivity = env->FindClass(envptr, "android/app/Activity");
  jmethodID MethodmoveTaskToBack = env->GetMethodID(envptr, ClassActivity, "moveTaskToBack", "(Z)Z");
  env->CallBooleanMethod(envptr, activity, MethodmoveTaskToBack, param);
  jnii->DetachCurrentThread(jniiptr);
}