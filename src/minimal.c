
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <unistd.h>

#include <jni.h>
#include <android/native_activity.h>

#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include <android/sensor.h>

#include <EGL/egl.h>
#include <GLES3/gl3.h>

#include "android_native_app_glue.h"

struct android_app *gapp;

static int OGLESStarted;
int android_width, android_height;
int android_sdk_version;

unsigned frames = 0;
unsigned long iframeno = 0;

EGLNativeWindowType native_window;

void AndroidDisplayKeyboard(int pShow);

int lastbuttonx = 0;
int lastbuttony = 0;
int lastmotionx = 0;
int lastmotiony = 0;
int lastbid = 0;
int lastmask = 0;
int lastkey, lastkeydown;

static int keyboard_up;

void HandleKey(int keycode, int bDown)
{
	lastkey = keycode;
	lastkeydown = bDown;
	if (keycode == 10 && !bDown)
	{
		keyboard_up = 0;
		AndroidDisplayKeyboard(keyboard_up);
	}

	if (keycode == 4)
	{
		AndroidSendToBack(1);
	} //Handle Physical Back Button.
}

void HandleButton(int x, int y, int button, int bDown)
{
	lastbid = button;
	lastbuttonx = x;
	lastbuttony = y;

	if (bDown)
	{
		keyboard_up = !keyboard_up;
		AndroidDisplayKeyboard(keyboard_up);
	}
}

void HandleMotion(int x, int y, int mask)
{
	lastmask = mask;
	lastmotionx = x;
	lastmotiony = y;
}

extern struct android_app *gapp;

void setScreenViewport()
{
	android_width = ANativeWindow_getWidth(native_window);
	android_height = ANativeWindow_getHeight(native_window);
	glViewport(0, 0, android_width, android_height);
}

EGLDisplay egl_display;
EGLSurface egl_surface;

int initialize_egl()
{
	EGLint egl_major, egl_minor;
	EGLConfig config;
	EGLint num_config;
	EGLContext context;

	//This MUST be called before doing any initialization.
	int events;
	while (!OGLESStarted)
	{
		struct android_poll_source *source;
		if (ALooper_pollAll(0, 0, &events, (void **)&source) >= 0)
		{
			if (source != NULL)
				source->process(gapp, source);
		}
	}

	egl_display = eglGetDisplay(EGL_DEFAULT_DISPLAY);

	if (egl_display == EGL_NO_DISPLAY)
	{
		printf("Error: No display found!\n");
		return -1;
	}

	if (!eglInitialize(egl_display, &egl_major, &egl_minor))
	{
		printf("Error: eglInitialise failed!\n");
		return -1;
	}

	printf("EGL Version: \"%s\"\n", eglQueryString(egl_display, EGL_VERSION));
	printf("EGL Vendor: \"%s\"\n", eglQueryString(egl_display, EGL_VENDOR));
	printf("EGL Extensions: \"%s\"\n", eglQueryString(egl_display, EGL_EXTENSIONS));

	static EGLint const config_attribute_list[] = {
		EGL_RED_SIZE,
		8,
		EGL_GREEN_SIZE,
		8,
		EGL_BLUE_SIZE,
		8,
		EGL_ALPHA_SIZE,
		8,
		EGL_BUFFER_SIZE,
		32,
		EGL_STENCIL_SIZE,
		0,
		EGL_DEPTH_SIZE,
		16,
//EGL_SAMPLES, 1,
#if ANDROIDVERSION >= 28
		EGL_RENDERABLE_TYPE,
		EGL_OPENGL_ES3_BIT,
#else
		EGL_RENDERABLE_TYPE,
		EGL_OPENGL_ES2_BIT,
#endif
		EGL_NONE
	};

	eglChooseConfig(egl_display, config_attribute_list, &config, 1, &num_config);

	printf("Config: %d\n", num_config);

	printf("Creating Context\n");

	static const EGLint context_attribute_list[] = {EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE};
	context = eglCreateContext(egl_display, config, EGL_NO_CONTEXT, context_attribute_list);
	if (context == EGL_NO_CONTEXT)
	{
		printf("Error: eglCreateContext failed: 0x%08X\n", eglGetError());
		return -1;
	}
	printf("Context Created %p\n", context);

	if (native_window && !gapp->window)
	{
		printf("WARNING: App restarted without a window.  Cannot progress.\n");
		exit(0);
	}

	printf("Getting Surface %p\n", native_window = gapp->window);

	if (!native_window)
	{
		printf("FAULT: Cannot get window\n");
		return -5;
	}
	android_width = ANativeWindow_getWidth(native_window);
	android_height = ANativeWindow_getHeight(native_window);

	printf("Width/Height: %dx%d\n", android_width, android_height);

	static EGLint window_attribute_list[] = {EGL_NONE};
	egl_surface = eglCreateWindowSurface(egl_display, config, gapp->window, window_attribute_list);

	printf("Got Surface: %p\n", egl_surface);

	if (egl_surface == EGL_NO_SURFACE)
	{
		printf("Error: eglCreateWindowSurface failed: x%08X\n", eglGetError());
		return -1;
	}

	if (!eglMakeCurrent(egl_display, egl_surface, egl_surface, context))
	{
		printf("Error: eglMakeCurrent() failed: 0x%08X\n", eglGetError());
		return -1;
	}

	printf("GL Vendor: \"%s\"\n", glGetString(GL_VENDOR));
	printf("GL Renderer: \"%s\"\n", glGetString(GL_RENDERER));
	printf("GL Version: \"%s\"\n", glGetString(GL_VERSION));
	printf("GL Extensions: \"%s\"\n", glGetString(GL_EXTENSIONS));

	// egl_immediate_geo_ptr = &egl_immediate_geo_buffer[0];

	return 0;
}

void HandleDestroy();
void HandleResume();
void HandleSuspend();

void handle_cmd(struct android_app *app, int32_t cmd)
{
	switch (cmd)
	{
	case APP_CMD_DESTROY:
		//This gets called initially after back.
		HandleDestroy();
		ANativeActivity_finish(gapp->activity);
		break;

	case APP_CMD_INIT_WINDOW:
		//When returning from a back button suspension, this isn't called.
		if (!OGLESStarted)
		{
			OGLESStarted = 1;
			printf("Got start event\n");
		}
		else
		{
			initialize_egl();
			HandleResume();
		}
		break;

	case APP_CMD_START:
		// Starting the App here
		break;

	case APP_CMD_RESUME:
		HandleResume();
		break;

	case APP_CMD_PAUSE:
		HandleSuspend();
		break;

	//case APP_CMD_TERM_WINDOW:
	//This gets called initially when you click "back"
	//This also gets called when you are brought into standby.
	//Not sure why - callbacks here seem to break stuff.
	//	break;
	default:
		printf("event not handled: %d", cmd);
	}
}

int debuga, debugb, debugc;

int32_t handle_input(struct android_app *app, AInputEvent *event)
{
	//Potentially do other things here.

	if (AInputEvent_getType(event) == AINPUT_EVENT_TYPE_MOTION)
	{
		static uint64_t downmask;

		int action = AMotionEvent_getAction(event);
		int whichsource = action >> 8;
		action &= AMOTION_EVENT_ACTION_MASK;
		size_t pointerCount = AMotionEvent_getPointerCount(event);

		for (size_t i = 0; i < pointerCount; ++i)
		{
			int x = AMotionEvent_getX(event, i);
			int y = AMotionEvent_getY(event, i);
			int index = AMotionEvent_getPointerId(event, i);

			if (action == AMOTION_EVENT_ACTION_POINTER_DOWN || action == AMOTION_EVENT_ACTION_DOWN)
			{
				int id = index;
				if (action == AMOTION_EVENT_ACTION_POINTER_DOWN && id != whichsource)
					continue;
				HandleButton(x, y, id, 1);
				downmask |= 1 << id;
				ANativeActivity_showSoftInput(gapp->activity, ANATIVEACTIVITY_SHOW_SOFT_INPUT_FORCED);
			}
			else if (action == AMOTION_EVENT_ACTION_POINTER_UP || action == AMOTION_EVENT_ACTION_UP || action == AMOTION_EVENT_ACTION_CANCEL)
			{
				int id = index;
				if (action == AMOTION_EVENT_ACTION_POINTER_UP && id != whichsource)
					continue;
				HandleButton(x, y, id, 0);
				downmask &= ~(1 << id);
			}
			else if (action == AMOTION_EVENT_ACTION_MOVE)
			{
				HandleMotion(x, y, index);
			}
		}
		return 1;
	}
	else if (AInputEvent_getType(event) == AINPUT_EVENT_TYPE_KEY)
	{
		int code = AKeyEvent_getKeyCode(event);
#ifdef ANDROID_USE_SCANCODES
		HandleKey(code, AKeyEvent_getAction(event));
#else
		int unicode = AndroidGetUnicodeChar(code, AMotionEvent_getMetaState(event));
		if (unicode)
			HandleKey(unicode, AKeyEvent_getAction(event));
		else
		{
			HandleKey(code, !AKeyEvent_getAction(event));
			return (code == 4) ? 1 : 0; //don't override functionality.
		}
#endif

		return 1;
	}
	return 0;
}

bool IsSuspended();

void zig_main(struct android_app *app)
{
	gapp = app;
	app->onAppCmd = handle_cmd;
	app->onInputEvent = handle_input;

	// Include this if the app wants fullscreen display (no navigation buttons)
	// AndroidMakeFullscreen();

	initialize_egl();

	setScreenViewport();

	const char *assettext = "Not Found";
	AAsset *file = AAssetManager_open(gapp->activity->assetManager, "dummy.txt", AASSET_MODE_BUFFER);
	if (file)
	{
		size_t fileLength = AAsset_getLength(file);
		char *temp = malloc(fileLength + 1);
		memcpy(temp, AAsset_getBuffer(file), fileLength);
		temp[fileLength] = 0;
		assettext = temp;

		printf("assettext: %s\n", assettext);
	}

	while (1)
	{
		// Update events
		int events;
		struct android_poll_source *source;
		while (ALooper_pollAll(0, 0, &events, (void **)&source) >= 0)
		{
			if (source != NULL)
			{
				source->process(gapp, source);
			}
		}

		if (IsSuspended())
		{
			usleep(50000);
			continue;
		}

		glClearColor(1.0, 1.0, 1.0, 1.0);
		glClear(GL_COLOR_BUFFER_BIT /*| GL_DEPTH_BUFFER_BIT*/);

		// TODO: Render here

		eglSwapBuffers(egl_display, egl_surface);
		setScreenViewport();
	}

	return;
}