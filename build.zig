const std = @import("std");

// Configure these (required):
const human_readable_app_name = "Ziggy";
const app_name = "ziggy";
const package_name = "net.random_projects." ++ app_name;

const android_fullscreen = false;

// Adjust these to your system:
const android_sdk_root = "/home/felix/projects/android-hass/android-sdk";
const android_ndk_root = android_sdk_root ++ "/ndk/21.1.6352462";
const android_build_tools = android_sdk_root ++ "/build-tools/28.0.3";

// These are tweakable, but are not required to be touched

const apk_file = app_name ++ ".apk";

const android_version = 29;
const android_target = android_version;

const android_version_str = blk: {
    comptime var buf: [std.math.log10(android_version) + 3]u8 = undefined;
    break :blk std.fmt.bufPrint(&buf, "{d}", .{android_version}) catch unreachable;
};

const android_target_str = blk: {
    comptime var buf: [std.math.log10(android_target) + 3]u8 = undefined;
    break :blk std.fmt.bufPrint(&buf, "{d}", .{android_target}) catch unreachable;
};

const aapt = android_build_tools ++ "/aapt";
const zipalign = android_build_tools ++ "/zipalign";

const keystore_file = "debug.keystore";
const keystore_alias = "standkey";
const keystore_storepass = "passwd123";
const keystore_keypass = "passwd456";

const common_cflags = [_][]const u8{
    // generic
    "-ffunction-sections",
    "-fdata-sections",
    "-Wall",
    "-fno-sanitize=undefined",
    "-fvisibility=hidden",
};

const common_lflags = [_][]const u8{
    "-Wl,--gc-sections",
    "-s",
    "-shared",
    "-uANativeActivity_onCreate",
};

fn initAppCommon(b: *std.build.Builder, output_name: []const u8, target: std.zig.CrossTarget, mode: std.builtin.Mode) *std.build.LibExeObjStep {
    const exe = b.addSharedLibrary(output_name, "./src/main.zig", .{
        .major = 1,
        .minor = 0,
        .patch = 0,
    });

    exe.force_pic = true;
    exe.link_function_sections = true;
    exe.bundle_compiler_rt = true;

    exe.defineCMacro("ANDROID");
    // exe.defineCMacro("APPNAME=\"" ++ app_name ++ "\"");
    // if (android_fullscreen) {
    //     exe.defineCMacro("DANDROID_FULLSCREEN");
    // }
    // exe.defineCMacro("DANDROIDVERSION=" ++ android_version_str);

    exe.addIncludeDir("./src");
    exe.addIncludeDir(android_ndk_root ++ "/sysroot/usr/include");
    // exe.addIncludeDir(android_ndk_root ++ "/sysroot/usr/include/android");

    // for (app_sources) |src| {
    //     exe.addCSourceFile(src, &common_cflags);
    // }

    for (app_libs) |lib| {
        exe.linkSystemLibrary(lib);
    }

    exe.addBuildOption(comptime_int, "android_sdk_version", android_version);
    exe.linkLibC();
    exe.setBuildMode(mode);
    exe.setTarget(target);

    return exe;
}

pub fn build(b: *std.build.Builder) !void {
    const aarch64_target = std.zig.CrossTarget.parse(.{
        .arch_os_abi = "aarch64-linux",
        .cpu_features = "baseline+v8a",
    }) catch unreachable;

    const arm_target = std.zig.CrossTarget.parse(.{
        .arch_os_abi = "arm-linux",
        .cpu_features = "baseline+v7a",
    }) catch unreachable;

    const x86_target = std.zig.CrossTarget.parse(.{
        .arch_os_abi = "i386-linux",
        .cpu_features = "baseline",
    }) catch unreachable;

    const x86_64_target = std.zig.CrossTarget.parse(.{
        .arch_os_abi = "x86_64-linux",
        .cpu_features = "baseline",
    }) catch unreachable;

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const aarch64_exe = initAppCommon(b, app_name, aarch64_target, mode);
    const arm_exe = initAppCommon(b, app_name, arm_target, mode);
    const x86_exe = initAppCommon(b, app_name, x86_target, mode);
    const x86_64_exe = initAppCommon(b, app_name, x86_64_target, mode);

    aarch64_exe.addLibPath(android_ndk_root ++ "/platforms/android-" ++ android_version_str ++ "/arch-arm64/usr/lib");
    arm_exe.addLibPath(android_ndk_root ++ "/platforms/android-" ++ android_version_str ++ "/arch-arm/usr/lib");
    x86_exe.addLibPath(android_ndk_root ++ "/platforms/android-" ++ android_version_str ++ "/arch-x86/usr/lib");
    x86_64_exe.addLibPath(android_ndk_root ++ "/platforms/android-" ++ android_version_str ++ "/arch-x86_64/usr/lib64");

    aarch64_exe.addIncludeDir(android_ndk_root ++ "/sysroot/usr/include/aarch64-linux-android");
    aarch64_exe.libc_file = "./libc/arm64.conf";
    aarch64_exe.output_dir = "./apk/lib/arm64-v8a";

    arm_exe.addIncludeDir(android_ndk_root ++ "/sysroot/usr/include/arm-linux-androideabi");
    arm_exe.libc_file = "./libc/arm.conf";
    arm_exe.output_dir = "./apk/lib/armeabi";

    x86_exe.addIncludeDir(android_ndk_root ++ "/sysroot/usr/include/i686-linux-android");
    x86_exe.libc_file = "./libc/x86.conf";
    x86_exe.output_dir = "./apk/lib/x86";

    x86_64_exe.addIncludeDir(android_ndk_root ++ "/sysroot/usr/include/x86_64-linux-android");
    x86_64_exe.libc_file = "./libc/x86_64.conf";
    x86_64_exe.output_dir = "./apk/lib/x86_64";

    try std.fs.cwd().writeFile("./resources/values/strings.xml", blk: {
        var buf = std.ArrayList(u8).init(b.allocator);
        errdefer buf.deinit();

        var writer = buf.writer();

        try writer.writeAll(
            \\<?xml version="1.0" encoding="utf-8"?>
            \\<resources>
            \\
        );

        try writer.print(
            \\    <string name="app_name">{}</string>
            \\    <string name="lib_name">{}</string>
            \\    <string name="package_name">{}</string>
            \\
        , .{
            human_readable_app_name,
            app_name,
            package_name,
        });

        try writer.writeAll(
            \\</resources>
            \\
        );

        break :blk buf.toOwnedSlice();
    });

    const manifest_step = b.addWriteFile("AndroidManifest.xml", blk: {
        var buf = std.ArrayList(u8).init(b.allocator);
        errdefer buf.deinit();

        var writer = buf.writer();

        // attribute to <application>
        // android:theme="@android:style/Theme.NoTitleBar.Fullscreen"
        @setEvalBranchQuota(1_000_000);
        try writer.print(
            \\<?xml version="1.0" encoding="utf-8" standalone="no"?><manifest xmlns:tools="http://schemas.android.com/tools" xmlns:android="http://schemas.android.com/apk/res/android" package="{}">
            \\    <uses-permission android:name="android.permission.SET_RELEASE_APP"/>
            \\    <application android:debuggable="true" android:hasCode="false" android:label="@string/app_name"   tools:replace="android:icon,android:theme,android:allowBackup,label" android:icon="@mipmap/icon"  android:requestLegacyExternalStorage="true">
            \\        <activity android:configChanges="keyboardHidden|orientation" android:name="android.app.NativeActivity">
            \\            <meta-data android:name="android.app.lib_name" android:value="@string/lib_name"/>
            \\            <intent-filter>
            \\                <action android:name="android.intent.action.MAIN"/>
            \\                <category android:name="android.intent.category.LAUNCHER"/>
            \\            </intent-filter>
            \\        </activity>
            \\    </application>
            \\</manifest>
            \\
        , .{package_name});

        break :blk buf.toOwnedSlice();
    });

    std.fs.cwd().deleteFile("ziggy.apk") catch {};

    const make_unsigned_apk = b.addSystemCommand(&[_][]const u8{
        aapt,
        "package",
        "-f", // force overwrite of existing files
        "-F", // specify the apk file to output
        "incomplete.apk",
        "-I", // add an existing package to base include set
        android_sdk_root ++ "/platforms/android-" ++ android_version_str ++ "/android.jar",
        "-M", // specify full path to AndroidManifest.xml to include in zip
    });
    make_unsigned_apk.addWriteFileArg(manifest_step, "AndroidManifest.xml");
    make_unsigned_apk.addArgs(&[_][]const u8{
        "-S", // directory in which to find resources.  Multiple directories will be scanned and the first match found (left to right) will take precedence
        "./resources",
        "-A", // additional directory in which to find raw asset files
        "./assets",
        "-v",
        "--target-sdk-version",
        android_target_str,
    });

    make_unsigned_apk.step.dependOn(&aarch64_exe.step);
    // make_unsigned_apk.step.dependOn(&arm_exe.step);
    // make_unsigned_apk.step.dependOn(&x86_exe.step);
    // make_unsigned_apk.step.dependOn(&x86_64_exe.step);

    const unpack_apk = b.addSystemCommand(&[_][]const u8{
        "unzip",
        "-o",
        "incomplete.apk",
        "-d",
        "./apk",
    });
    unpack_apk.step.dependOn(&make_unsigned_apk.step);

    const repack_apk = b.addSystemCommand(&[_][]const u8{
        "zip",
        "-D9r",
        "../unsigned.apk",
        ".",
    });
    repack_apk.cwd = "./apk";
    repack_apk.step.dependOn(&unpack_apk.step);

    const sign_apk = b.addSystemCommand(&[_][]const u8{
        "/usr/lib/jvm/java-11-openjdk/bin/jarsigner",
        "-sigalg",
        "SHA1withRSA",
        "-digestalg",
        "SHA1",
        "-verbose",
        "-keystore",
        keystore_file,
        "-storepass",
        keystore_storepass,
        "unsigned.apk",
        keystore_alias,
    });
    sign_apk.step.dependOn(&repack_apk.step);

    const align_apk = b.addSystemCommand(&[_][]const u8{
        zipalign,
        "-v",
        "4",
        "unsigned.apk",
        apk_file,
    });
    align_apk.step.dependOn(&sign_apk.step);

    b.getInstallStep().dependOn(&align_apk.step);

    const push_apk = b.addSystemCommand(&[_][]const u8{
        "adb",
        "install",
        apk_file,
    });
    push_apk.step.dependOn(&align_apk.step);

    const push_step = b.step("push", "Installs the APK on the connected android system.");
    push_step.dependOn(&push_apk.step);

    const run_apk = b.addSystemCommand(&[_][]const u8{
        "adb",
        "shell",
        "am",
        "start",
        "-n",
        package_name ++ "/android.app.NativeActivity",
    });
    run_apk.step.dependOn(&push_apk.step);

    const run_step = b.step("run", "Runs the APK on the connected android system.");
    run_step.dependOn(&run_apk.step);

    const make_keystore = b.addSystemCommand(&[_][]const u8{
        "keytool",
        "-genkey",
        "-v",
        "-keystore",
        keystore_file,
        "-alias",
        keystore_alias,
        "-keyalg",
        "RSA",
        "-keysize",
        "2048",
        "-validity",
        "10000",
        "-storepass",
        keystore_storepass,
        "-keypass",
        keystore_keypass,
        "-dname",
        "CN=example.com, OU=ID, O=Example, L=Doe, S=John, C=GB",
    });

    const keystore_step = b.step("keystore", "Creates a new dummy keystore for testing");
    keystore_step.dependOn(&make_keystore.step);
}

const app_sources = [_][]const u8{
    "./src/minimal.c",
    "./src/android_native_app_glue.c",
};

const app_libs = [_][]const u8{
    "GLESv3", "EGL", "android", "log",
};
