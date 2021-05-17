//! External dependencies:
//! - `keytool`, `jarsigner` from OpenJDK
//! - `adb` from the Android tools package

const std = @import("std");

const Builder = std.build.Builder;
const Step = std.build.Step;

const android_os = .linux;
const android_abi = .android;

const zig_targets = struct {
    const aarch64 = std.zig.CrossTarget{
        .cpu_arch = .aarch64,
        .os_tag = android_os,
        .abi = android_abi,
        .cpu_model = .baseline,
        .cpu_features_add = std.Target.aarch64.featureSet(&.{.v8a}),
    };

    const arm = std.zig.CrossTarget{
        .cpu_arch = .arm,
        .os_tag = android_os,
        .abi = android_abi,
        .cpu_model = .baseline,
        .cpu_features_add = std.Target.arm.featureSet(&.{.v7a}),
    };

    const x86 = std.zig.CrossTarget{
        .cpu_arch = .i386,
        .os_tag = android_os,
        .abi = android_abi,
        .cpu_model = .baseline,
    };

    const x86_64 = std.zig.CrossTarget{
        .cpu_arch = .x86_64,
        .os_tag = android_os,
        .abi = android_abi,
        .cpu_model = .baseline,
    };
};

const app_libs = [_][]const u8{
    "GLESv2", "EGL", "android", "log",
};

/// One of the legal targets android can be built for.
pub const Target = enum {
    aarch64,
    arm,
    x86,
    x86_64,
};

/// Configuration of the Android toolchain.
pub const Config = struct {
    sdk_root: []const u8,
    ndk_root: []const u8,
    build_tools: []const u8,
    key_store: ?KeyStore = null,
    system_tools: SystemTools = .{},
};

pub const KeyStore = struct {
    file: []const u8,
    alias: []const u8,
    password: []const u8,
};

/// Configuration of the binary paths to all tools that are not included in the android SDK.
pub const SystemTools = struct {
    keytool: []const u8 = "keytool",
    adb: []const u8 = "adb",
    jarsigner: []const u8 = "/usr/lib/jvm/java-11-openjdk/bin/jarsigner",
    mkdir: []const u8 = "mkdir",
    rm: []const u8 = "rm",
};

/// Configuration of an application
pub const AppConfig = struct {
    /// The display name of the application. This is shown to the users.
    display_name: []const u8,

    /// Application name, only lower case letters and underscores are allowed.
    app_name: []const u8,

    /// Java package name, usually the reverse top level domain + app name.
    /// Only lower case letters, dots and underscores are allowed.
    package_name: []const u8,

    /// The android version to build against.
    android_version: u16 = 29,

    /// The resource directory that will contain the manifest and other app resources.
    /// This should be a distinct directory per app.
    resource_directory: []const u8,

    /// If true, the app will be started in "fullscreen" mode, this means that
    /// navigation buttons as well as the top bar are not shown.
    /// This is usually relevant for games.
    fullscreen: bool = false,

    /// One or more asset directories. Each directory will be added into the app assets.
    asset_directories: []const []const u8 = &[_][]const u8{},

    permissions: []const []const u8 = &[_][]const u8{
        //"android.permission.SET_RELEASE_APP",
        //"android.permission.RECORD_AUDIO",
    },
};

/// The configuration which targets a app should be built for.
pub const AppTargetConfig = struct {
    aarch64: bool = true,
    arm: bool = true,
    x86_64: bool = true,
    x86: bool = false,
};

const CreateAppStep = struct {
    first_step: *std.build.Step,
    final_step: *std.build.Step,

    libraries: []const *std.build.LibExeObjStep,
};

/// Instantiates the full build pipeline to create an APK file.
///
pub fn createApp(
    b: *Builder,
    android_config: Config,
    apk_file: []const u8,
    src_file: []const u8,
    app_config: AppConfig,
    mode: std.builtin.Mode,
    targets: AppTargetConfig,
) CreateAppStep {
    // try std.fs.cwd().writeFile("./resources/values/strings.xml", blk: {
    //     var buf = std.ArrayList(u8).init(b.allocator);
    //     errdefer buf.deinit();

    //     var writer = buf.writer();

    //     try writer.writeAll(
    //         \\<?xml version="1.0" encoding="utf-8"?>
    //         \\<resources>
    //         \\
    //     );

    //     try writer.print(
    //         \\    <string name="app_name">{s}</string>
    //         \\    <string name="lib_name">{s}</string>
    //         \\    <string name="package_name">{s}</string>
    //         \\
    //     , .{
    //         human_readable_app_name,
    //         app_name,
    //         package_name,
    //     });

    //     try writer.writeAll(
    //         \\</resources>
    //         \\
    //     );

    //     break :blk buf.toOwnedSlice();
    // });

    const manifest_step = b.addWriteFile("AndroidManifest.xml", blk: {
        var buf = std.ArrayList(u8).init(b.allocator);
        errdefer buf.deinit();

        var writer = buf.writer();

        @setEvalBranchQuota(1_000_000);
        writer.print(
            \\<?xml version="1.0" encoding="utf-8" standalone="no"?><manifest xmlns:tools="http://schemas.android.com/tools" xmlns:android="http://schemas.android.com/apk/res/android" package="{s}">
            \\
        , .{app_config.package_name}) catch unreachable;
        for (app_config.permissions) |perm| {
            writer.print(
                \\    <uses-permission android:name="{s}"/>
                \\
            , .{perm}) catch unreachable;
        }
        writer.print(
            \\    <application android:debuggable="true" android:hasCode="false" android:label="@string/app_name" {s} tools:replace="android:icon,android:theme,android:allowBackup,label" android:icon="@mipmap/icon"  android:requestLegacyExternalStorage="true">
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
        , .{
            if (app_config.fullscreen) @as([]const u8, "android:theme=\"@android:style/Theme.NoTitleBar.Fullscreen\"") else "",
        }) catch unreachable;

        break :blk buf.toOwnedSlice();
    });

    const root_jar = std.fs.path.resolve(b.allocator, &[_][]const u8{
        android_config.sdk_root,
        "platforms",
        std.fmt.allocPrint(b.allocator, "android-{d}", .{app_config.android_version}) catch unreachable,
        "android.jar",
    }) catch unreachable;

    const make_unsigned_apk = b.addSystemCommand(&[_][]const u8{
        std.fs.path.resolve(b.allocator, &[_][]const u8{
            b.pathFromRoot(android_config.build_tools),
            "aapt",
        }) catch unreachable,
        "package",
        "-f", // force overwrite of existing files
        "-F", // specify the apk file to output
        b.pathFromRoot(apk_file),
        "-I", // add an existing package to base include set
        root_jar,
        "-M", // specify full path to AndroidManifest.xml to include in zip
    });
    make_unsigned_apk.addWriteFileArg(manifest_step, "AndroidManifest.xml");
    make_unsigned_apk.addArgs(&[_][]const u8{
        "-S", // directory in which to find resources.  Multiple directories will be scanned and the first match found (left to right) will take precedence
        b.pathFromRoot(app_config.resource_directory),
        "-v",
        "--target-sdk-version",
        std.fmt.allocPrint(b.allocator, "{d}", .{app_config.android_version}) catch unreachable,
    });
    for (app_config.asset_directories) |dir| {
        make_unsigned_apk.addArg("-A"); // additional directory in which to find raw asset files
        make_unsigned_apk.addArg(b.pathFromRoot(dir));
    }

    var libs = std.ArrayList(*std.build.LibExeObjStep).init(b.allocator);
    defer libs.deinit();

    inline for (std.meta.fields(AppTargetConfig)) |fld| {
        if (@field(targets, fld.name)) {
            const step = compileAppLibrary(
                b,
                android_config,
                "apk",
                src_file,
                app_config,
                mode,
                @field(Target, fld.name),
            );
            libs.append(step) catch unreachable;
            make_unsigned_apk.step.dependOn(&step.step);
        }
    }

    return CreateAppStep{
        .first_step = &make_unsigned_apk.step,
        .final_step = &make_unsigned_apk.step,
        .libraries = libs.toOwnedSlice(),
    };
}

/// Compiles a single .so file for the given platform.
/// Note that this function assumes your build script only uses a single `android_config`!
pub fn compileAppLibrary(
    b: *Builder,
    android_config: Config,
    output_directory: []const u8,
    src_file: []const u8,
    app_config: AppConfig,
    mode: std.builtin.Mode,
    target: Target,
) *std.build.LibExeObjStep {
    const ndk_root = b.pathFromRoot(android_config.ndk_root);

    const exe = b.addSharedLibrary(app_config.app_name, src_file, .{
        .versioned = .{
            .major = 1,
            .minor = 0,
            .patch = 0,
        },
    });

    exe.force_pic = true;
    exe.link_function_sections = true;
    exe.bundle_compiler_rt = true;
    exe.strip = (mode == .ReleaseSmall);
    exe.single_threaded = true;

    exe.defineCMacro("ANDROID");

    const include_dir = std.fs.path.resolve(b.allocator, &[_][]const u8{ ndk_root, "sysroot/usr/include" }) catch unreachable;
    exe.addIncludeDir(include_dir);

    for (app_libs) |lib| {
        exe.linkSystemLibraryName(lib);
    }

    exe.addBuildOption(u16, "android_sdk_version", app_config.android_version);
    exe.addBuildOption(bool, "fullscreen", app_config.fullscreen);
    exe.linkLibC();
    exe.setBuildMode(mode);

    const TargetConfig = struct {
        lib_dir: []const u8,
        include_dir: []const u8,
        out_dir: []const u8,
        target: std.zig.CrossTarget,
    };

    const config: TargetConfig = switch (target) {
        .aarch64 => TargetConfig{
            .lib_dir = "arch-arm64/usr/lib",
            .include_dir = "aarch64-linux-android",
            .out_dir = "arm64-v8a",
            .target = zig_targets.aarch64,
        },
        .arm => TargetConfig{
            .lib_dir = "arch-arm/usr/lib",
            .include_dir = "arm-linux-androideabi",
            .out_dir = "armeabi",
            .target = zig_targets.arm,
        },
        .x86 => TargetConfig{
            .lib_dir = "arch-x86/usr/lib",
            .include_dir = "i686-linux-android",
            .out_dir = "x86",
            .target = zig_targets.x86,
        },
        .x86_64 => TargetConfig{
            .lib_dir = "x86_64/usr/lib64",
            .include_dir = "x86_64-linux-android",
            .out_dir = "x86_64",
            .target = zig_targets.x86_64,
        },
    };

    const lib_dir_root = std.fmt.allocPrint(b.allocator, "{s}/platforms/android-{d}", .{
        ndk_root,
        app_config.android_version,
    }) catch unreachable;

    var temp_buffer: [64]u8 = undefined;
    const libc_path = std.fs.path.resolve(b.allocator, &[_][]const u8{
        b.cache_root,
        "android-libc",
        std.fmt.bufPrint(&temp_buffer, "android-{d}-{s}.conf", .{
            app_config.android_version,
            config.out_dir,
        }) catch unreachable,
    }) catch unreachable;

    const lib_dir = std.fs.path.resolve(b.allocator, &[_][]const u8{ lib_dir_root, config.lib_dir }) catch unreachable;

    exe.setTarget(config.target);
    exe.addLibPath(lib_dir);
    exe.addIncludeDir(std.fs.path.resolve(b.allocator, &[_][]const u8{ include_dir, config.include_dir }) catch unreachable);

    exe.libc_file = libc_path;
    exe.output_dir = std.fs.path.resolve(b.allocator, &[_][]const u8{
        b.cache_root,
        b.pathFromRoot(output_directory),
        "lib",
        config.out_dir,
    }) catch unreachable;

    // write libc file:
    createLibCFile(exe.libc_file.?, include_dir, include_dir, lib_dir) catch unreachable;

    return exe;
}

fn createLibCFile(path: []const u8, include_dir: []const u8, sys_include_dir: []const u8, crt_dir: []const u8) !void {
    if (std.fs.path.dirname(path)) |dir| {
        try std.fs.cwd().makePath(dir);
    }

    var f = try std.fs.cwd().createFile(path, .{});
    defer f.close();

    var writer = f.writer();

    try writer.print("include_dir={s}\n", .{include_dir});
    try writer.print("sys_include_dir={s}\n", .{sys_include_dir});
    try writer.print("crt_dir={s}\n", .{crt_dir});
    try writer.writeAll("msvc_lib_dir=\n");
    try writer.writeAll("kernel32_lib_dir=\n");
}

pub fn compressApk(b: *Builder, android_config: Config, input_apk_file: []const u8, output_apk_file: []const u8) *Step {
    const temp_folder = b.pathFromRoot("zig-cache/apk-compress-folder");

    const mkdir_cmd = b.addSystemCommand(&[_][]const u8{
        android_config.system_tools.mkdir,
        temp_folder,
    });

    const unpack_apk = b.addSystemCommand(&[_][]const u8{
        "unzip",
        "-o",
        b.pathFromRoot(input_apk_file),
        "-d",
        temp_folder,
    });
    unpack_apk.step.dependOn(&mkdir_cmd.step);

    const repack_apk = b.addSystemCommand(&[_][]const u8{
        "zip",
        "-D9r",
        b.pathFromRoot(output_apk_file),
        ".",
    });
    repack_apk.cwd = temp_folder;
    repack_apk.step.dependOn(&unpack_apk.step);

    const rmdir_cmd = b.addSystemCommand(&[_][]const u8{
        android_config.system_tools.rm,
        "-rf",
        temp_folder,
    });
    rmdir_cmd.step.dependOn(&repack_apk.step);
    return &rmdir_cmd.step;
}

pub fn signApk(b: *Builder, android_config: Config, apk_file: []const u8) *Step {
    const sign_apk = b.addSystemCommand(&[_][]const u8{
        android_config.system_tools.jarsigner,
        "-sigalg",
        "SHA1withRSA",
        "-digestalg",
        "SHA1",
        "-verbose",
        "-keystore",
        android_config.key_store.?.file,
        "-storepass",
        android_config.key_store.?.storepass,
        b.pathFromRoot(apk_file),
        android_config.key_store.?.alias,
    });
    return &sign_apk.step;
}

pub fn alignApk(b: *Builder, android_config: Config, input_apk_file: []const u8, output_apk_file: []const u8) *Step {
    const step = b.addSystemCommand(&[_][]const u8{
        std.fs.path.resolve(b.allocator, &[_][]const u8{
            b.pathFromRoot(android_config.build_tools),
            "zipalign",
        }) catch unreachable,
        "-v",
        "4",
        b.pathFromRoot(input_apk_file),
        b.pathFromRoot(output_apk_file),
    });
    return &step.step;
}

pub fn installApp(b: *Builder, android_config: Config, apk_file: []const u8) *Step {
    const step = b.addSystemCommand(&[_][]const u8{
        android_config.system_tools.adb,
        "install",
        b.pathFromRoot(apk_file),
    });
    return &step.step;
}

pub fn startApp(b: *Builder, android_config: Config, app_config: AppConfig) *Step {
    const step = b.addSystemCommand(&[_][]const u8{
        android_config.system_tools.adb,
        "shell",
        "am",
        "start",
        "-n",
        std.mem.join(b.allocator, "/", &[_][]const u8{
            app_config.package_name,
            "android.app.NativeActivity",
        }) catch unreachable,
    });
    return &step.step;
}

/// Configuration for a signing key.
pub const KeyConfig = struct {
    pub const Algorithm = enum { RSA };
    key_algorithm: Algorithm = .RSA,
    key_size: u32 = 2048, // bits
    validity: u32 = 10_000, // days
    distinguished_name: []const u8 = "CN=example.com, OU=ID, O=Example, L=Doe, S=John, C=GB",
};
/// A build step that initializes a new key store from the given configuration.
/// `android_config.key_store` must be non-`null` as it is used to initialize the key store.
pub fn initKeystore(b: *Builder, android_config: Config, key_config: KeyConfig) *Step {
    var temp_buffer: [1024]u8 = undefined;

    const step = b.addSystemCommand(&[_][]const u8{
        android_config.system_tools.keytool,
        "-genkey",
        "-v",
        "-keystore",
        android_config.key_store.?.file,
        "-alias",
        android_config.key_store.?.alias,
        "-keyalg",
        @tagName(key_config.key_algorithm),
        "-keysize",
        b.dupe(std.fmt.bufPrint(&temp_buffer, "{d}", .{key_config.key_size}) catch unreachable),
        "-validity",
        b.dupe(std.fmt.bufPrint(&temp_buffer, "{d}", .{key_config.validity}) catch unreachable),
        "-storepass",
        android_config.key_store.?.password,
        "-keypass",
        android_config.key_store.?.password,
        "-dname",
        key_config.distinguished_name,
    });
    return &step.step;
}
