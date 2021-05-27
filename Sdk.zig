//! External dependencies:
//! - `keytool`, `jarsigner` from OpenJDK
//! - `adb` from the Android tools package

const std = @import("std");

const auto_detect = @import("build/auto-detect.zig");

/// This file encodes a instance of an Android SDK interface.
const Sdk = @This();

/// The builder instance associated with this object.
b: *Builder,

/// A set of tools that run on the build host that are required to complete the 
/// project build. Must be created with the `hostTools()` function that passes in
/// the correct relpath to the package.
host_tools: HostTools,

/// The configuration for all non-shipped system tools.
/// Contains the normal default config for each tool.
system_tools: SystemTools = .{},

/// Contains paths to each required input folder.
folders: UserConfig,

versions: ToolchainVersions,

android_package: std.build.Pkg,

/// Initializes the android SDK.
/// It requires some input on which versions of the tool chains should be used
pub fn init(b: *Builder, comptime package_directory: []const u8, user_config: ?UserConfig, versions: ToolchainVersions) !Sdk {
    const package_root = if (package_directory[package_directory.len - 1] != '/')
        package_directory ++ "/"
    else
        package_directory;

    const actual_user_config = user_config orelse try auto_detect.findUserConfig(b, versions);

    const system_tools = blk: {
        const exe = if (std.builtin.os.tag == .windows) ".exe" else "";

        const zipalign = std.fs.path.join(b.allocator, &[_][]const u8{ actual_user_config.android_sdk_root, "build-tools", versions.build_tools_version, "zipalign" ++ exe }) catch unreachable;
        const aapt = std.fs.path.join(b.allocator, &[_][]const u8{ actual_user_config.android_sdk_root, "build-tools", versions.build_tools_version, "aapt" ++ exe }) catch unreachable;
        const adb = std.fs.path.join(b.allocator, &[_][]const u8{ actual_user_config.android_sdk_root, "platform-tools", "adb" ++ exe }) catch unreachable;
        const jarsigner = std.fs.path.join(b.allocator, &[_][]const u8{ actual_user_config.java_home, "bin", "jarsigner" ++ exe }) catch unreachable;
        const keytool = std.fs.path.join(b.allocator, &[_][]const u8{ actual_user_config.java_home, "bin", "keytool" ++ exe }) catch unreachable;

        break :blk SystemTools{
            .zipalign = zipalign,
            .aapt = aapt,
            .adb = adb,
            .jarsigner = jarsigner,
            .keytool = keytool,
        };
    };

    // Compiles all required additional tools for toolchain.
    const host_tools = blk: {
        const zip_add = b.addExecutable("zip_add", package_root ++ "tools/zip_add.zig");
        zip_add.addCSourceFile(package_root ++ "vendor/kuba-zip/zip.c", &[_][]const u8{
            "-std=c99",
            "-fno-sanitize=undefined",
        });
        zip_add.addIncludeDir(package_root ++ "vendor/kuba-zip");
        zip_add.linkLibC();

        break :blk HostTools{
            .zip_add = zip_add,
        };
    };

    return Sdk{
        .b = b,
        .host_tools = host_tools,
        .system_tools = system_tools,
        .folders = actual_user_config,
        .versions = versions,
        .android_package = std.build.Pkg{
            .name = "android",
            .path = package_root ++ "src/android-support.zig",
        },
    };
}

pub const ToolchainVersions = struct {
    android_sdk_version: u16 = 29,
    build_tools_version: []const u8 = "28.0.3",
    ndk_version: []const u8 = "21.1.6352462",

    pub fn androidSdkString(self: ToolchainVersions, buf: *[5]u8) []u8 {
        return std.fmt.bufPrint(buf, "{d}", .{self.android_sdk_version}) catch unreachable;
    }
};

pub const UserConfig = struct {
    android_sdk_root: []const u8 = "",
    android_ndk_root: []const u8 = "",
    java_home: []const u8 = "",
};

/// Configuration of the Android toolchain.
pub const Config = struct {
    /// Path to the SDK root folder.
    /// Example: `/home/ziggy/android-sdk`.
    sdk_root: []const u8,

    /// Path to the NDK root folder.
    /// Example: `/home/ziggy/android-sdk/ndk/21.1.6352462`.
    ndk_root: []const u8,

    /// Path to the build tools folder.
    /// Example: `/home/ziggy/android-sdk/build-tools/28.0.3`.
    build_tools: []const u8,

    /// A key store. This is required when an APK is created and signed.
    /// If you don't care for production code, just use the default here
    /// and it will work. This needs to be changed to a *proper* key store
    /// when you want to publish the app.
    key_store: KeyStore = KeyStore{
        .file = "zig-cache/",
        .alias = "default",
        .password = "ziguana",
    },
};

/// Configuration of an application.
pub const AppConfig = struct {
    /// The display name of the application. This is shown to the users.
    display_name: []const u8,

    /// Application name, only lower case letters and underscores are allowed.
    app_name: []const u8,

    /// Java package name, usually the reverse top level domain + app name.
    /// Only lower case letters, dots and underscores are allowed.
    package_name: []const u8,

    /// The android version which is embedded in the manifset.
    /// This is usually the same version as of the SDK that was used, but might also be 
    /// overridden for a specific app.
    target_sdk_version: ?u16 = null,

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

/// One of the legal targets android can be built for.
pub const Target = enum {
    aarch64,
    arm,
    x86,
    x86_64,
};

pub const KeyStore = struct {
    file: []const u8,
    alias: []const u8,
    password: []const u8,
};

pub const HostTools = struct {
    zip_add: *std.build.LibExeObjStep,
};

/// Configuration of the binary paths to all tools that are not included in the android SDK.
pub const SystemTools = struct {
    //keytool: []const u8 = "keytool",
    //adb: []const u8 = "adb",
    //jarsigner: []const u8 = "/usr/lib/jvm/java-11-openjdk/bin/jarsigner",
    mkdir: []const u8 = "mkdir",
    rm: []const u8 = "rm",

    zipalign: []const u8 = "zipalign",
    aapt: []const u8 = "aapt",
    adb: []const u8 = "adb",
    jarsigner: []const u8 = "jarsigner",
    keytool: []const u8 = "keytool",
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
    sdk: Sdk,
    apk_file: []const u8,
    src_file: []const u8,
    app_config: AppConfig,
    mode: std.builtin.Mode,
    targets: AppTargetConfig,
    key_store: KeyStore,
) CreateAppStep {
    const strings_xml = std.fs.path.resolve(sdk.b.allocator, &[_][]const u8{
        sdk.b.pathFromRoot(app_config.resource_directory),
        "values",
        "strings.xml",
    }) catch unreachable;
    if (std.fs.path.dirname(strings_xml)) |dir| {
        std.fs.cwd().makePath(dir) catch unreachable;
    }
    std.fs.cwd().writeFile(strings_xml, blk: {
        var buf = std.ArrayList(u8).init(sdk.b.allocator);
        errdefer buf.deinit();

        var writer = buf.writer();

        writer.writeAll(
            \\<?xml version="1.0" encoding="utf-8"?>
            \\<resources>
            \\
        ) catch unreachable;

        writer.print(
            \\    <string name="app_name">{s}</string>
            \\    <string name="lib_name">{s}</string>
            \\    <string name="package_name">{s}</string>
            \\
        , .{
            app_config.display_name,
            app_config.app_name,
            app_config.package_name,
        }) catch unreachable;

        writer.writeAll(
            \\</resources>
            \\
        ) catch unreachable;

        break :blk buf.toOwnedSlice();
    }) catch unreachable;

    const manifest_step = sdk.b.addWriteFile("AndroidManifest.xml", blk: {
        var buf = std.ArrayList(u8).init(sdk.b.allocator);
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

        if (app_config.fullscreen) {
            writer.writeAll(
                \\    <application android:debuggable="true" android:hasCode="false" android:label="@string/app_name" android:theme="@android:style/Theme.NoTitleBar.Fullscreen" tools:replace="android:icon,android:theme,android:allowBackup,label" android:icon="@mipmap/icon"  android:requestLegacyExternalStorage="true">
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
            ) catch unreachable;
        } else {
            writer.writeAll(
                \\    <application android:debuggable="true" android:hasCode="false" android:label="@string/app_name" tools:replace="android:icon,android:theme,android:allowBackup,label" android:icon="@mipmap/icon"  android:requestLegacyExternalStorage="true">
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
            ) catch unreachable;
        }

        break :blk buf.toOwnedSlice();
    });

    const sdk_version = sdk.versions.android_sdk_version;
    const target_sdk_version = app_config.target_sdk_version orelse sdk.versions.android_sdk_version;

    const root_jar = std.fs.path.resolve(sdk.b.allocator, &[_][]const u8{
        sdk.folders.android_sdk_root,
        "platforms",
        sdk.b.fmt("android-{d}", .{sdk_version}),
        "android.jar",
    }) catch unreachable;

    const make_unsigned_apk = sdk.b.addSystemCommand(&[_][]const u8{
        sdk.system_tools.aapt,
        "package",
        "-f", // force overwrite of existing files
        "-F", // specify the apk file to output
        sdk.b.pathFromRoot(apk_file),
        "-I", // add an existing package to base include set
        root_jar,
        "-M", // specify full path to AndroidManifest.xml to include in zip
    });
    make_unsigned_apk.addWriteFileArg(manifest_step, "AndroidManifest.xml");
    make_unsigned_apk.addArgs(&[_][]const u8{
        "-S", // directory in which to find resources.  Multiple directories will be scanned and the first match found (left to right) will take precedence
        sdk.b.pathFromRoot(app_config.resource_directory),
        "-v",
        "--target-sdk-version",
        sdk.b.fmt("{d}", .{target_sdk_version}),
    });
    for (app_config.asset_directories) |dir| {
        make_unsigned_apk.addArg("-A"); // additional directory in which to find raw asset files
        make_unsigned_apk.addArg(sdk.b.pathFromRoot(dir));
    }

    var libs = std.ArrayList(*std.build.LibExeObjStep).init(sdk.b.allocator);
    defer libs.deinit();

    const sign_step = sdk.signApk(apk_file, key_store);

    inline for (std.meta.fields(AppTargetConfig)) |fld| {
        const target_name = @field(Target, fld.name);
        if (@field(targets, fld.name)) {
            const step = sdk.compileAppLibrary(
                src_file,
                app_config,
                mode,
                target_name,
            );
            libs.append(step) catch unreachable;

            const so_dir = switch (target_name) {
                .aarch64 => "lib/arm64-v8a/",
                .arm => "lib/armeabi/",
                .x86_64 => "lib/x86_64/",
                .x86 => "lib/x86/",
            };

            const copy_to_zip = CopyToZipStep.create(sdk, apk_file, so_dir, step);
            copy_to_zip.step.dependOn(&make_unsigned_apk.step); // enforces creation of APK before the execution
            sign_step.dependOn(&copy_to_zip.step);
        }
    }

    // const compress_step = compressApk(b, android_config, apk_file, "zig-out/demo.packed.apk");
    // compress_step.dependOn(sign_step);

    return CreateAppStep{
        .first_step = &make_unsigned_apk.step,
        .final_step = sign_step,
        .libraries = libs.toOwnedSlice(),
    };
}

const CopyToZipStep = struct {
    step: Step,
    sdk: Sdk,
    target_dir: []const u8,
    so: *std.build.LibExeObjStep,
    apk_file: []const u8,

    fn create(sdk: Sdk, apk_file: []const u8, target_dir: []const u8, so: *std.build.LibExeObjStep) *CopyToZipStep {
        std.debug.assert(target_dir[target_dir.len - 1] == '/');
        const self = sdk.b.allocator.create(CopyToZipStep) catch unreachable;
        self.* = CopyToZipStep{
            .step = Step.init(.Custom, "CopyToZip", sdk.b.allocator, make),
            .target_dir = target_dir,
            .so = so,
            .sdk = sdk,
            .apk_file = sdk.b.pathFromRoot(apk_file),
        };
        self.step.dependOn(&sdk.host_tools.zip_add.step);
        self.step.dependOn(&so.step);
        return self;
    }

    // id: Id, name: []const u8, allocator: *Allocator, makeFn: fn (*Step) anyerror!void

    fn make(step: *Step) !void {
        const self = @fieldParentPtr(CopyToZipStep, "step", step);

        const output_path = self.so.getOutputPath();

        var zip_name = std.mem.concat(self.sdk.b.allocator, u8, &[_][]const u8{
            self.target_dir,
            std.fs.path.basename(output_path),
        }) catch unreachable;

        const args = [_][]const u8{
            self.sdk.host_tools.zip_add.getOutputPath(),
            self.apk_file,
            output_path,
            zip_name,
        };

        var child = try std.ChildProcess.init(&args, self.sdk.b.allocator);

        const term = try child.spawnAndWait();
        std.debug.assert(term.Exited == 0);
    }
};

/// Compiles a single .so file for the given platform.
/// Note that this function assumes your build script only uses a single `android_config`!
pub fn compileAppLibrary(
    sdk: Sdk,
    src_file: []const u8,
    app_config: AppConfig,
    mode: std.builtin.Mode,
    target: Target,
) *std.build.LibExeObjStep {
    const ndk_root = sdk.b.pathFromRoot(sdk.folders.android_ndk_root);

    const exe = sdk.b.addSharedLibrary(app_config.app_name, src_file, .unversioned);

    exe.addPackage(sdk.android_package);

    exe.force_pic = true;
    exe.link_function_sections = true;
    exe.bundle_compiler_rt = true;
    exe.strip = (mode == .ReleaseSmall);

    exe.defineCMacro("ANDROID");

    const include_dir = std.fs.path.resolve(sdk.b.allocator, &[_][]const u8{ ndk_root, "sysroot/usr/include" }) catch unreachable;
    exe.addIncludeDir(include_dir);

    exe.linkLibC();
    for (app_libs) |lib| {
        exe.linkSystemLibraryName(lib);
    }

    exe.addBuildOption(u16, "android_sdk_version", app_config.target_sdk_version orelse sdk.versions.android_sdk_version);
    exe.addBuildOption(bool, "fullscreen", app_config.fullscreen);
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
            .lib_dir = "arch-x86_64/usr/lib64",
            .include_dir = "x86_64-linux-android",
            .out_dir = "x86_64",
            .target = zig_targets.x86_64,
        },
    };

    const lib_dir_root = sdk.b.fmt("{s}/platforms/android-{d}", .{
        ndk_root,
        sdk.versions.android_sdk_version,
    });

    var temp_buffer: [64]u8 = undefined;
    const libc_path = std.fs.path.resolve(sdk.b.allocator, &[_][]const u8{
        sdk.b.cache_root,
        "android-libc",
        sdk.b.fmt("android-{d}-{s}.conf", .{ sdk.versions.android_sdk_version, config.out_dir }),
    }) catch unreachable;

    const lib_dir = std.fs.path.resolve(sdk.b.allocator, &[_][]const u8{ lib_dir_root, config.lib_dir }) catch unreachable;

    exe.setTarget(config.target);
    exe.addLibPath(lib_dir);
    exe.addIncludeDir(std.fs.path.resolve(sdk.b.allocator, &[_][]const u8{ include_dir, config.include_dir }) catch unreachable);

    exe.libc_file = libc_path;
    // exe.output_dir = std.fs.path.resolve(b.allocator, &[_][]const u8{
    //     b.cache_root,
    //     b.pathFromRoot(output_directory),
    //     "lib",
    //     config.out_dir,
    // }) catch unreachable;

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
    try writer.writeAll("gcc_dir=\n");
}

pub fn compressApk(sdk: Sdk, input_apk_file: []const u8, output_apk_file: []const u8) *Step {
    const temp_folder = sdk.b.pathFromRoot("zig-cache/apk-compress-folder");

    const mkdir_cmd = sdk.b.addSystemCommand(&[_][]const u8{
        sdk.system_tools.mkdir,
        temp_folder,
    });

    const unpack_apk = sdk.b.addSystemCommand(&[_][]const u8{
        "unzip",
        "-o",
        b.pathFromRoot(input_apk_file),
        "-d",
        temp_folder,
    });
    unpack_apk.step.dependOn(&mkdir_cmd.step);

    const repack_apk = sdk.b.addSystemCommand(&[_][]const u8{
        "zip",
        "-D9r",
        b.pathFromRoot(output_apk_file),
        ".",
    });
    repack_apk.cwd = temp_folder;
    repack_apk.step.dependOn(&unpack_apk.step);

    const rmdir_cmd = sdk.b.addSystemCommand(&[_][]const u8{
        sdk.system_tools.rm,
        "-rf",
        temp_folder,
    });
    rmdir_cmd.step.dependOn(&repack_apk.step);
    return &rmdir_cmd.step;
}

pub fn signApk(sdk: Sdk, apk_file: []const u8, key_store: KeyStore) *Step {
    const sign_apk = sdk.b.addSystemCommand(&[_][]const u8{
        sdk.system_tools.jarsigner,
        "-sigalg",
        "SHA1withRSA",
        "-digestalg",
        "SHA1",
        "-verbose",
        "-keystore",
        key_store.file,
        "-storepass",
        key_store.password,
        sdk.b.pathFromRoot(apk_file),
        key_store.alias,
    });
    return &sign_apk.step;
}

pub fn alignApk(sdk: Sdk, input_apk_file: []const u8, output_apk_file: []const u8) *Step {
    const step = sdk.b.addSystemCommand(&[_][]const u8{
        sdk.system_tools.zipalign,
        "-v",
        "4",
        b.pathFromRoot(input_apk_file),
        b.pathFromRoot(output_apk_file),
    });
    return &step.step;
}

pub fn installApp(sdk: Sdk, apk_file: []const u8) *Step {
    const step = sdk.b.addSystemCommand(&[_][]const u8{
        sdk.system_tools.adb,
        "install",
        sdk.b.pathFromRoot(apk_file),
    });
    return &step.step;
}

pub fn startApp(sdk: Sdk, app_config: AppConfig) *Step {
    const step = sdk.b.addSystemCommand(&[_][]const u8{
        sdk.system_tools.adb,
        "shell",
        "am",
        "start",
        "-n",
        sdk.b.fmt("{s}/android.app.NativeActivity", .{app_config.package_name}),
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
pub fn initKeystore(sdk: Sdk, key_store: KeyStore, key_config: KeyConfig) *Step {
    const step = sdk.b.addSystemCommand(&[_][]const u8{
        sdk.system_tools.keytool,
        "-genkey",
        "-v",
        "-keystore",
        key_store.file,
        "-alias",
        key_store.alias,
        "-keyalg",
        @tagName(key_config.key_algorithm),
        "-keysize",
        sdk.b.fmt("{d}", .{key_config.key_size}),
        "-validity",
        sdk.b.fmt("{d}", .{key_config.validity}),
        "-storepass",
        key_store.password,
        "-keypass",
        key_store.password,
        "-dname",
        key_config.distinguished_name,
    });
    return &step.step;
}

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
