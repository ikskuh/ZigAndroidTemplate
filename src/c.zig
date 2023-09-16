const build_options = @import("build_options");
pub usingnamespace @cImport({
    @cInclude("EGL/egl.h");
    // @cInclude("EGL/eglext.h");
    @cInclude("GLES2/gl2.h");
    @cInclude("GLES2/gl2ext.h");
    // @cInclude("unwind.h");
    // @cInclude("dlfcn.h");
    @cInclude("aaudio/AAudio.h");
});
