const std = @import("std");

const android = @import("android");

const JNI = android.JNI;
const c = android.egl.c;

const audio_log = std.log.scoped(.audio);

pub fn midiToFreq(note: usize) f64 {
    return std.math.pow(f64, 2, (@intToFloat(f64, note) - 49) / 12) * 440;
}

pub fn amplitudeTodB(amplitude: f64) f64 {
    return 20.0 * std.math.log10(amplitude);
}

pub fn dBToAmplitude(dB: f64) f64 {
    return std.math.pow(f64, 10.0, dB / 20.0);
}

pub const StreamLayout = struct {
    sample_rate: u32,
    channel_count: usize,
    buffer: union(enum) {
        Uint8: []u8,
        Int16: []i16,
        Float32: []f32,
    },
};

const StreamCallbackFn = *const fn (StreamLayout, *anyopaque) void;

pub const AudioManager = struct {};

pub const OutputStreamConfig = struct {
    // Leave null to use the the platforms native sampling rate
    sample_rate: ?u32 = null,
    sample_format: enum {
        Uint8,
        Int16,
        Float32,
    },
    buffer_size: ?usize = null,
    buffer_count: usize = 4,
    channel_count: usize = 1,
    callback: StreamCallbackFn,
    user_data: *anyopaque,
};

pub const OutputStream = union(enum) {
    OpenSL: OpenSL.OpenSLOutputStream,
    AAudio: AAudio.AAudioOutputStream,

    pub fn stop(output_stream: *@This()) !void {
        switch (output_stream) {
            .OpenSL => |opensl| try opensl.stop(),
            .AAudio => |aaudio| try aaudio.stop(),
        }
    }

    pub fn deinit(output_stream: *@This(), allocator: std.mem.Allocator) void {
        switch (output_stream) {
            .OpenSL => |opensl| opensl.deinit(allocator),
            .AAudio => |aaudio| aaudio.deinit(),
        }
    }

    pub fn start(output_stream: *@This()) !void {
        switch (output_stream) {
            .OpenSL => |opensl| try opensl.start(),
            .AAudio => |aaudio| try aaudio.start(),
        }
    }
};

pub const AAudio = struct {
    pub const AAudioOutputStream = struct {
        config: OutputStreamConfig,
        stream: ?*c.AAudioStream,
        // thread: ?std.Thread = null,

        pub fn start(output_stream: *@This()) !void {
            try checkResult(c.AAudioStream_requestStart(output_stream.stream));
            // output_stream.thread = try std.Thread.spawn(.{}, _start, .{output_stream});
            // output_stream.thread.?.detach();
        }

        // fn _start(output_stream: *@This()) !void {
        // }

        // pub fn restart(output_stream: *@This()) void {
        //     output_stream.stop() catch |e| {
        //         audio_log.err("Error stopping stream {s}", .{@errorName(e)});
        //     };
        //     output_stream.deinit();
        //     _ = output_stream.start();
        // }

        pub fn stop(output_stream: *@This()) !void {
            try checkResult(c.AAudioStream_requestStop(output_stream.stream));
        }

        pub fn deinit(output_stream: *@This()) void {
            checkResult(c.AAudioStream_close(output_stream.stream)) catch |e| {
                audio_log.err("Error deiniting stream {s}", .{@errorName(e)});
            };
            // if (output_stream.thread) |thread| {
            //     thread.join();
            // }
        }
    };

    fn dataCallback(
        stream: ?*c.AAudioStream,
        user_data: ?*anyopaque,
        audio_data: ?*anyopaque,
        num_frames: i32,
    ) callconv(.C) c.aaudio_data_callback_result_t {
        _ = stream;
        const output_stream = @ptrCast(*AAudioOutputStream, @alignCast(@alignOf(AAudioOutputStream), user_data.?));
        // TODO:
        // const audio_slice = @ptrCast([*]f32, @alignCast(@alignOf(f32), audio_data.?))[0..@intCast(usize, num_frames)];
        const audio_slice = @ptrCast([*]i16, @alignCast(@alignOf(i16), audio_data.?))[0..@intCast(usize, num_frames)];

        for (audio_slice) |*frame| {
            frame.* = 0;
        }

        var stream_layout = StreamLayout{
            .sample_rate = output_stream.config.sample_rate.?,
            .channel_count = @intCast(usize, output_stream.config.channel_count),
            .buffer = .{ .Int16 = audio_slice },
        };

        output_stream.config.callback(stream_layout, output_stream.config.user_data);

        return c.AAUDIO_CALLBACK_RESULT_CONTINUE;
    }

    fn errorCallback(
        stream: ?*c.AAudioStream,
        user_data: ?*anyopaque,
        err: c.aaudio_result_t,
    ) callconv(.C) void {
        _ = stream;
        audio_log.err("AAudio Stream error! {}", .{err});
        if (err == c.AAUDIO_ERROR_DISCONNECTED) {
            const output_stream = @ptrCast(*AAudioOutputStream, @alignCast(@alignOf(AAudioOutputStream), user_data.?));
            // if (output_stream.thread) |thread| thread.join();
            _ = std.Thread.spawn(.{}, AAudioOutputStream.deinit, .{output_stream}) catch @panic("eh");
        }
    }

    pub fn getOutputStream(allocator: std.mem.Allocator, config: OutputStreamConfig) !*AAudioOutputStream {
        errdefer audio_log.err("Encountered an error with getting output stream", .{});
        // Create a stream builder
        var stream_builder: ?*c.AAudioStreamBuilder = null;
        checkResult(c.AAudio_createStreamBuilder(&stream_builder)) catch |e| {
            audio_log.err("Couldn't create audio stream builder: {s}", .{@errorName(e)});
            return e;
        };
        defer checkResult(c.AAudioStreamBuilder_delete(stream_builder)) catch |e| {
            // TODO
            audio_log.err("Issue with deleting stream builder: {s}", .{@errorName(e)});
        };

        var output_stream = try allocator.create(AAudioOutputStream);
        output_stream.* = AAudioOutputStream{
            .config = config,
            .stream = undefined,
        };

        // Configure the stream
        c.AAudioStreamBuilder_setFormat(stream_builder, switch (config.sample_format) {
            .Uint8 => return error.Unsupported,
            .Int16 => c.AAUDIO_FORMAT_PCM_I16,
            .Float32 => c.AAUDIO_FORMAT_PCM_FLOAT,
        });
        c.AAudioStreamBuilder_setChannelCount(stream_builder, @intCast(i32, config.channel_count));
        c.AAudioStreamBuilder_setPerformanceMode(stream_builder, c.AAUDIO_PERFORMANCE_MODE_LOW_LATENCY);
        c.AAudioStreamBuilder_setDataCallback(stream_builder, dataCallback, output_stream);
        c.AAudioStreamBuilder_setErrorCallback(stream_builder, errorCallback, output_stream);

        if (config.sample_rate) |rate| c.AAudioStreamBuilder_setSampleRate(stream_builder, @intCast(i32, rate));
        if (config.buffer_size) |size| c.AAudioStreamBuilder_setFramesPerDataCallback(stream_builder, @intCast(i32, size));

        // Open the stream
        checkResult(c.AAudioStreamBuilder_openStream(stream_builder, &output_stream.stream)) catch |e| {
            audio_log.err("Issue with opening stream: {s}", .{@errorName(e)});
            return e;
        };

        // Save the details of the stream
        output_stream.config.sample_rate = @intCast(u32, c.AAudioStream_getSampleRate(output_stream.stream));
        output_stream.config.buffer_size = @intCast(usize, c.AAudioStream_getFramesPerBurst(output_stream.stream));

        var res = c.AAudioStream_setBufferSizeInFrames(output_stream.stream, @intCast(i32, output_stream.config.buffer_count * output_stream.config.buffer_size.?));
        if (res < 0) {
            checkResult(res) catch |e| {
                audio_log.err("Issue with setting buffer size in frames stream: {s}", .{@errorName(e)});
                return e;
            };
        } else {
            // TODO: store buffer size somewhere
            // output_stream.config.
        }

        audio_log.info("Got AAudio OutputStream", .{});

        return output_stream;
    }

    pub const AAudioError = error{
        Base,
        Disconnected,
        IllegalArgument,
        Internal,
        InvalidState,
        InvalidHandle,
        Unimplemented,
        Unavailable,
        NoFreeHandles,
        NoMemory,
        Null,
        Timeout,
        WouldBlock,
        InvalidFormat,
        OutOfRange,
        NoService,
        InvalidRate,
        Unknown,
    };

    pub fn checkResult(result: c.aaudio_result_t) AAudioError!void {
        return switch (result) {
            c.AAUDIO_OK => {},
            c.AAUDIO_ERROR_BASE => error.Base,
            c.AAUDIO_ERROR_DISCONNECTED => error.Disconnected,
            c.AAUDIO_ERROR_ILLEGAL_ARGUMENT => error.IllegalArgument,
            c.AAUDIO_ERROR_INTERNAL => error.Internal,
            c.AAUDIO_ERROR_INVALID_STATE => error.InvalidState,
            c.AAUDIO_ERROR_INVALID_HANDLE => error.InvalidHandle,
            c.AAUDIO_ERROR_UNIMPLEMENTED => error.Unimplemented,
            c.AAUDIO_ERROR_UNAVAILABLE => error.Unavailable,
            c.AAUDIO_ERROR_NO_FREE_HANDLES => error.NoFreeHandles,
            c.AAUDIO_ERROR_NO_MEMORY => error.NoMemory,
            c.AAUDIO_ERROR_NULL => error.Null,
            c.AAUDIO_ERROR_TIMEOUT => error.Timeout,
            c.AAUDIO_ERROR_WOULD_BLOCK => error.WouldBlock,
            c.AAUDIO_ERROR_INVALID_FORMAT => error.InvalidFormat,
            c.AAUDIO_ERROR_OUT_OF_RANGE => error.OutOfRange,
            c.AAUDIO_ERROR_NO_SERVICE => error.NoService,
            c.AAUDIO_ERROR_INVALID_RATE => error.InvalidRate,
            else => error.Unknown,
        };
    }
};

// OpenSLES support
pub const OpenSL = struct {
    // Global variables
    var init_sl_counter: usize = 0;
    var engine_object: c.SLObjectItf = undefined;
    var engine: c.SLEngineItf = undefined;

    var output_mix: c.SLObjectItf = undefined;
    var output_mix_itf: c.SLOutputMixItf = undefined;

    pub const OpenSLOutputStream = struct {
        config: OutputStreamConfig,
        player: c.SLObjectItf,
        play_itf: c.SLPlayItf,
        buffer_queue_itf: c.SLAndroidSimpleBufferQueueItf,
        state: c.SLAndroidSimpleBufferQueueState,

        audio_sink: c.SLDataSink,
        locator_outputmix: c.SLDataLocator_OutputMix,

        audio_source: c.SLDataSource,
        buffer_queue: c.SLDataLocator_BufferQueue,
        pcm: c.SLDataFormat_PCM,

        buffer: []i16,
        buffer_index: usize,
        mutex: std.Thread.Mutex,

        // Must be initialized using OpenSL.getOutputStream

        pub fn stop(output_stream: *OpenSLOutputStream) !void {
            try checkResult(output_stream.play_itf.*.*.SetPlayState.?(output_stream.play_itf, c.SL_PLAYSTATE_STOPPED));
        }

        pub fn deinit(output_stream: *OpenSLOutputStream, alloc: std.mem.Allocator) void {
            output_stream.player.*.*.Destroy.?(output_stream.player);
            alloc.free(output_stream.buffer);
        }

        pub fn start(output_stream: *OpenSLOutputStream) !void {
            // Get player interface
            try checkResult(output_stream.player.*.*.GetInterface.?(
                output_stream.player,
                c.SL_IID_PLAY,
                @ptrCast(*anyopaque, &output_stream.play_itf),
            ));

            // Get buffer queue interface
            try checkResult(output_stream.player.*.*.GetInterface.?(
                output_stream.player,
                c.SL_IID_ANDROIDSIMPLEBUFFERQUEUE,
                @ptrCast(*anyopaque, &output_stream.buffer_queue_itf),
            ));

            // Register callback
            try checkResult(output_stream.buffer_queue_itf.*.*.RegisterCallback.?(
                output_stream.buffer_queue_itf,
                bufferQueueCallback,
                @ptrCast(*anyopaque, output_stream),
            ));

            // Enqueue a few buffers to get the ball rollng
            var i: usize = 0;
            while (i < output_stream.config.buffer_count) : (i += 1) {
                try checkResult(output_stream.buffer_queue_itf.*.*.Enqueue.?(
                    output_stream.buffer_queue_itf,
                    &output_stream.buffer[output_stream.buffer_index],
                    @intCast(u32, output_stream.config.buffer_size.? * (output_stream.pcm.containerSize / 8)),
                ));
                output_stream.buffer_index += output_stream.config.buffer_size.?;
            }

            output_stream.buffer_index = (output_stream.buffer_index + output_stream.config.buffer_size.?) % output_stream.buffer.len;

            // Start playing queued audio buffers
            try checkResult(output_stream.play_itf.*.*.SetPlayState.?(output_stream.play_itf, c.SL_PLAYSTATE_PLAYING));

            audio_log.info("started opensl output stream", .{});
        }
    };

    pub fn bufferQueueCallback(queue_itf: c.SLAndroidSimpleBufferQueueItf, user_data: ?*anyopaque) callconv(.C) void {
        var output_stream = @ptrCast(*OpenSLOutputStream, @alignCast(@alignOf(OpenSLOutputStream), user_data));

        // Lock the mutex to prevent race conditions
        output_stream.mutex.lock();
        defer output_stream.mutex.unlock();

        var buffer = output_stream.buffer[output_stream.buffer_index .. output_stream.buffer_index + output_stream.config.buffer_size.?];

        for (buffer) |*frame| {
            frame.* = 0;
        }

        var stream_layout = StreamLayout{
            .sample_rate = output_stream.pcm.samplesPerSec / 1000,
            .channel_count = output_stream.pcm.numChannels,
            .buffer = .{ .Int16 = buffer },
        };

        output_stream.config.callback(stream_layout, output_stream.config.user_data);

        checkResult(queue_itf.*.*.Enqueue.?(
            queue_itf,
            @ptrCast(*anyopaque, buffer.ptr),
            @intCast(c.SLuint32, (output_stream.pcm.containerSize / 8) * buffer.len),
        )) catch |e| {
            audio_log.err("Error enqueueing buffer! {s}", .{@errorName(e)});
        };

        output_stream.buffer_index = (output_stream.buffer_index + output_stream.config.buffer_size.?) % output_stream.buffer.len;
    }

    pub fn init() SLError!void {
        init_sl_counter += 1;
        if (init_sl_counter == 1) {
            try printInterfaces();
            errdefer init_sl_counter -= 1; // decrement counter on failure

            // Get engine object
            try checkResult(c.slCreateEngine(&engine_object, 0, null, 0, null, null));

            // Initialize engine object
            try checkResult(engine_object.*.*.Realize.?(engine_object, c.SL_BOOLEAN_FALSE));
            errdefer engine_object.*.*.Destroy.?(engine_object);

            // Get engine interface
            try checkResult(engine_object.*.*.GetInterface.?(engine_object, c.SL_IID_ENGINE, @ptrCast(*anyopaque, &engine)));
            try printEngineInterfaces();
            try printEngineExtensions();

            // Get OutputMix object
            try checkResult(engine.*.*.CreateOutputMix.?(engine, &output_mix, 0, null, null));
            try checkResult(output_mix.*.*.Realize.?(output_mix, c.SL_BOOLEAN_FALSE));
            errdefer output_mix.*.*.Destroy.?(output_mix);

            // Get OutputMix interface
            try checkResult(output_mix.*.*.GetInterface.?(output_mix, c.SL_IID_OUTPUTMIX, @ptrCast(*anyopaque, &output_mix_itf)));
        }
    }

    pub fn deinit() void {
        std.debug.assert(init_sl_counter > 0);

        // spinlock lock
        {
            init_sl_counter -= 1;
            if (init_sl_counter == 0) {
                output_mix.*.*.Destroy.?(output_mix);
                engine_object.*.*.Destroy.?(engine_object);
            }
        }
        // spinlock unlock
    }

    pub fn getOutputStream(allocator: std.mem.Allocator, conf: OutputStreamConfig) !*OpenSLOutputStream {
        // TODO: support multiple formats
        std.debug.assert(conf.sample_format == .Int16);

        var config = conf;
        config.buffer_size = config.buffer_size orelse 256;
        config.sample_rate = config.sample_rate orelse 44100;

        // Allocate memory for audio buffer
        // TODO: support other formats
        var buffers = try allocator.alloc(i16, config.buffer_size.? * config.buffer_count);
        errdefer allocator.free(buffers);

        for (buffers) |*sample| {
            sample.* = 0;
        }

        // Initialize the context for Buffer queue callbacks
        var output_stream = try allocator.create(OpenSLOutputStream);
        output_stream.* = OpenSLOutputStream{
            // We don't have these values yet
            .player = undefined,
            .play_itf = undefined,
            .state = undefined,
            .buffer_queue_itf = undefined,

            // Store user defined callback information
            .config = config,

            // Store pointer to audio buffer
            .buffer = buffers,
            .buffer_index = 0,

            // Setup the format of the content in the buffer queue
            .buffer_queue = .{
                .locatorType = c.SL_DATALOCATOR_BUFFERQUEUE,
                .numBuffers = @intCast(u32, config.buffer_count),
            },
            .pcm = .{
                .formatType = c.SL_DATAFORMAT_PCM,
                .numChannels = @intCast(u32, config.channel_count),
                .samplesPerSec = config.sample_rate.? * 1000, // OpenSL ES uses milliHz instead of Hz, for some reason
                .bitsPerSample = switch (config.sample_format) {
                    .Uint8 => c.SL_PCMSAMPLEFORMAT_FIXED_8,
                    .Int16 => c.SL_PCMSAMPLEFORMAT_FIXED_16,
                    .Float32 => c.SL_PCMSAMPLEFORMAT_FIXED_32,
                },
                .containerSize = switch (config.sample_format) {
                    .Uint8 => 8,
                    .Int16 => 16,
                    .Float32 => 32,
                },
                .channelMask = c.SL_SPEAKER_FRONT_CENTER, // TODO
                .endianness = c.SL_BYTEORDER_LITTLEENDIAN, // TODO

            },

            // Configure audio source
            .audio_source = .{
                .pFormat = @ptrCast(*anyopaque, &output_stream.pcm),
                .pLocator = @ptrCast(*anyopaque, &output_stream.buffer_queue),
            },
            .locator_outputmix = .{
                .locatorType = c.SL_DATALOCATOR_OUTPUTMIX,
                .outputMix = output_mix,
            },
            // Configure audio output
            .audio_sink = .{
                .pLocator = @ptrCast(*anyopaque, &output_stream.locator_outputmix),
                .pFormat = null,
            },

            // Thread safety
            .mutex = std.Thread.Mutex{},
        };

        // Create the music player
        try checkResult(engine.*.*.CreateAudioPlayer.?(
            engine,
            &output_stream.player,
            &output_stream.audio_source,
            &output_stream.audio_sink,
            1,
            &[_]c.SLInterfaceID{c.SL_IID_BUFFERQUEUE},
            &[_]c.SLboolean{c.SL_BOOLEAN_TRUE},
        ));

        // Realize the player interface
        try checkResult(output_stream.player.*.*.Realize.?(output_stream.player, c.SL_BOOLEAN_FALSE));

        // Return to user for them to start
        return output_stream;
    }

    const Result = enum(u32) {
        Success = c.SL_RESULT_SUCCESS,
        PreconditionsViolated = c.SL_RESULT_PRECONDITIONS_VIOLATED,
        ParameterInvalid = c.SL_RESULT_PARAMETER_INVALID,
        MemoryFailure = c.SL_RESULT_MEMORY_FAILURE,
        ResourceError = c.SL_RESULT_RESOURCE_ERROR,
        ResourceLost = c.SL_RESULT_RESOURCE_LOST,
        IoError = c.SL_RESULT_IO_ERROR,
        BufferInsufficient = c.SL_RESULT_BUFFER_INSUFFICIENT,
        ContentCorrupted = c.SL_RESULT_CONTENT_CORRUPTED,
        ContentUnsupported = c.SL_RESULT_CONTENT_UNSUPPORTED,
        ContentNotFound = c.SL_RESULT_CONTENT_NOT_FOUND,
        PermissionDenied = c.SL_RESULT_PERMISSION_DENIED,
        FeatureUnsupported = c.SL_RESULT_FEATURE_UNSUPPORTED,
        InternalError = c.SL_RESULT_INTERNAL_ERROR,
        UnknownError = c.SL_RESULT_UNKNOWN_ERROR,
        OperationAborted = c.SL_RESULT_OPERATION_ABORTED,
        ControlLost = c.SL_RESULT_CONTROL_LOST,
        _,
    };

    const SLError = error{
        PreconditionsViolated,
        ParameterInvalid,
        MemoryFailure,
        ResourceError,
        ResourceLost,
        IoError,
        BufferInsufficient,
        ContentCorrupted,
        ContentUnsupported,
        ContentNotFound,
        PermissionDenied,
        FeatureUnsupported,
        InternalError,
        UnknownError,
        OperationAborted,
        ControlLost,
    };

    pub fn checkResult(result: u32) SLError!void {
        const tag = std.meta.intToEnum(Result, result) catch return error.UnknownError;
        return switch (tag) {
            .Success => {},
            .PreconditionsViolated => error.PreconditionsViolated,
            .ParameterInvalid => error.ParameterInvalid,
            .MemoryFailure => error.MemoryFailure,
            .ResourceError => error.ResourceError,
            .ResourceLost => error.ResourceLost,
            .IoError => error.IoError,
            .BufferInsufficient => error.BufferInsufficient,
            .ContentCorrupted => error.ContentCorrupted,
            .ContentUnsupported => error.ContentUnsupported,
            .ContentNotFound => error.ContentNotFound,
            .PermissionDenied => error.PermissionDenied,
            .FeatureUnsupported => error.FeatureUnsupported,
            .InternalError => error.InternalError,
            .UnknownError => error.UnknownError,
            .OperationAborted => error.OperationAborted,
            .ControlLost => error.ControlLost,
            else => error.UnknownError,
        };
    }

    fn printInterfaces() !void {
        var interface_count: c.SLuint32 = undefined;
        try checkResult(c.slQueryNumSupportedEngineInterfaces(&interface_count));
        {
            var i: c.SLuint32 = 0;
            while (i < interface_count) : (i += 1) {
                var interface_id: c.SLInterfaceID = undefined;
                try checkResult(c.slQuerySupportedEngineInterfaces(i, &interface_id));
                const interface_tag = InterfaceID.fromIid(interface_id);
                if (interface_tag) |tag| {
                    audio_log.info("OpenSL engine interface id: {s}", .{@tagName(tag)});
                }
            }
        }
    }

    fn printEngineExtensions() !void {
        var extension_count: c.SLuint32 = undefined;
        try checkResult(engine.*.*.QueryNumSupportedExtensions.?(engine, &extension_count));
        {
            var i: c.SLuint32 = 0;
            while (i < extension_count) : (i += 1) {
                var extension_ptr: [4096]u8 = undefined;
                var extension_size: c.SLint16 = 4096;
                try checkResult(engine.*.*.QuerySupportedExtension.?(engine, i, &extension_ptr, &extension_size));
                var extension_name = extension_ptr[0..@intCast(usize, extension_size)];
                audio_log.info("OpenSL engine extension {}: {s}", .{ i, extension_name });
            }
        }
    }

    fn printEngineInterfaces() !void {
        var interface_count: c.SLuint32 = undefined;
        try checkResult(engine.*.*.QueryNumSupportedInterfaces.?(engine, c.SL_OBJECTID_ENGINE, &interface_count));
        {
            var i: c.SLuint32 = 0;
            while (i < interface_count) : (i += 1) {
                var interface_id: c.SLInterfaceID = undefined;
                try checkResult(engine.*.*.QuerySupportedInterfaces.?(engine, c.SL_OBJECTID_ENGINE, i, &interface_id));
                const interface_tag = InterfaceID.fromIid(interface_id);
                if (interface_tag) |tag| {
                    audio_log.info("OpenSL engine interface id: {s}", .{@tagName(tag)});
                } else {
                    audio_log.info("Unknown engine interface id: {}", .{interface_id.*});
                }
            }
        }
    }

    fn iidEq(iid1: c.SLInterfaceID, iid2: c.SLInterfaceID) bool {
        return iid1.*.time_low == iid2.*.time_low and
            iid1.*.time_mid == iid2.*.time_mid and
            iid1.*.time_hi_and_version == iid2.*.time_hi_and_version and
            iid1.*.clock_seq == iid2.*.clock_seq and
            iid1.*.time_mid == iid2.*.time_mid and
            std.mem.eql(u8, &iid1.*.node, &iid2.*.node);
    }

    const InterfaceID = enum {
        AudioIODeviceCapabilities,
        Led,
        Vibra,
        MetadataExtraction,
        MetadataTraversal,
        DynamicSource,
        OutputMix,
        Play,
        PrefetchStatus,
        PlaybackRate,
        Seek,
        Record,
        Equalizer,
        Volume,
        DeviceVolume,
        Object,
        BufferQueue,
        PresetReverb,
        EnvironmentalReverb,
        EffectSend,
        _3DGrouping,
        _3DCommit,
        _3DLocation,
        _3DDoppler,
        _3DSource,
        _3DMacroscopic,
        MuteSolo,
        DynamicInterfaceManagement,
        MidiMessage,
        MidiTempo,
        MidiMuteSolo,
        MidiTime,
        AudioDecoderCapabilities,
        AudioEncoder,
        AudioEncoderCapabilities,
        BassBoost,
        Pitch,
        RatePitch,
        Virtualizer,
        Visualization,
        Engine,
        EngineCapabilities,
        ThreadSync,
        AndroidEffect,
        AndroidEffectSend,
        AndroidEffectCapabilities,
        AndroidConfiguration,
        AndroidSimpleBufferQueue,
        AndroidBufferQueueSource,
        AndroidAcousticEchoCancellation,
        AndroidAutomaticGainControl,
        AndroidNoiseSuppresssion,
        fn fromIid(iid: c.SLInterfaceID) ?InterfaceID {
            if (iidEq(iid, c.SL_IID_NULL)) return null;
            if (iidEq(iid, c.SL_IID_AUDIOIODEVICECAPABILITIES)) return .AudioIODeviceCapabilities;
            if (iidEq(iid, c.SL_IID_LED)) return .Led;
            if (iidEq(iid, c.SL_IID_VIBRA)) return .Vibra;
            if (iidEq(iid, c.SL_IID_METADATAEXTRACTION)) return .MetadataExtraction;
            if (iidEq(iid, c.SL_IID_METADATATRAVERSAL)) return .MetadataTraversal;
            if (iidEq(iid, c.SL_IID_DYNAMICSOURCE)) return .DynamicSource;
            if (iidEq(iid, c.SL_IID_OUTPUTMIX)) return .OutputMix;
            if (iidEq(iid, c.SL_IID_PLAY)) return .Play;
            if (iidEq(iid, c.SL_IID_PREFETCHSTATUS)) return .PrefetchStatus;
            if (iidEq(iid, c.SL_IID_PLAYBACKRATE)) return .PlaybackRate;
            if (iidEq(iid, c.SL_IID_SEEK)) return .Seek;
            if (iidEq(iid, c.SL_IID_RECORD)) return .Record;
            if (iidEq(iid, c.SL_IID_EQUALIZER)) return .Equalizer;
            if (iidEq(iid, c.SL_IID_VOLUME)) return .Volume;
            if (iidEq(iid, c.SL_IID_DEVICEVOLUME)) return .DeviceVolume;
            if (iidEq(iid, c.SL_IID_OBJECT)) return .Object;
            if (iidEq(iid, c.SL_IID_BUFFERQUEUE)) return .BufferQueue;
            if (iidEq(iid, c.SL_IID_PRESETREVERB)) return .PresetReverb;
            if (iidEq(iid, c.SL_IID_ENVIRONMENTALREVERB)) return .EnvironmentalReverb;
            if (iidEq(iid, c.SL_IID_EFFECTSEND)) return .EffectSend;
            if (iidEq(iid, c.SL_IID_3DGROUPING)) return ._3DGrouping;
            if (iidEq(iid, c.SL_IID_3DCOMMIT)) return ._3DCommit;
            if (iidEq(iid, c.SL_IID_3DLOCATION)) return ._3DLocation;
            if (iidEq(iid, c.SL_IID_3DDOPPLER)) return ._3DDoppler;
            if (iidEq(iid, c.SL_IID_3DSOURCE)) return ._3DSource;
            if (iidEq(iid, c.SL_IID_3DMACROSCOPIC)) return ._3DMacroscopic;
            if (iidEq(iid, c.SL_IID_MUTESOLO)) return .MuteSolo;
            if (iidEq(iid, c.SL_IID_DYNAMICINTERFACEMANAGEMENT)) return .DynamicInterfaceManagement;
            if (iidEq(iid, c.SL_IID_MIDIMESSAGE)) return .MidiMessage;
            if (iidEq(iid, c.SL_IID_MIDITEMPO)) return .MidiTempo;
            if (iidEq(iid, c.SL_IID_MIDIMUTESOLO)) return .MidiMuteSolo;
            if (iidEq(iid, c.SL_IID_MIDITIME)) return .MidiTime;
            if (iidEq(iid, c.SL_IID_AUDIODECODERCAPABILITIES)) return .AudioDecoderCapabilities;
            if (iidEq(iid, c.SL_IID_AUDIOENCODER)) return .AudioEncoder;
            if (iidEq(iid, c.SL_IID_AUDIOENCODERCAPABILITIES)) return .AudioEncoderCapabilities;
            if (iidEq(iid, c.SL_IID_BASSBOOST)) return .BassBoost;
            if (iidEq(iid, c.SL_IID_PITCH)) return .Pitch;
            if (iidEq(iid, c.SL_IID_RATEPITCH)) return .RatePitch;
            if (iidEq(iid, c.SL_IID_VIRTUALIZER)) return .Virtualizer;
            if (iidEq(iid, c.SL_IID_VISUALIZATION)) return .Visualization;
            if (iidEq(iid, c.SL_IID_ENGINE)) return .Engine;
            if (iidEq(iid, c.SL_IID_ENGINECAPABILITIES)) return .EngineCapabilities;
            if (iidEq(iid, c.SL_IID_THREADSYNC)) return .ThreadSync;
            if (iidEq(iid, c.SL_IID_ANDROIDEFFECT)) return .AndroidEffect;
            if (iidEq(iid, c.SL_IID_ANDROIDEFFECTSEND)) return .AndroidEffectSend;
            if (iidEq(iid, c.SL_IID_ANDROIDEFFECTCAPABILITIES)) return .AndroidEffectCapabilities;
            if (iidEq(iid, c.SL_IID_ANDROIDCONFIGURATION)) return .AndroidConfiguration;
            if (iidEq(iid, c.SL_IID_ANDROIDSIMPLEBUFFERQUEUE)) return .AndroidSimpleBufferQueue;
            if (iidEq(iid, c.SL_IID_ANDROIDBUFFERQUEUESOURCE)) return .AndroidBufferQueueSource;
            if (iidEq(iid, c.SL_IID_ANDROIDACOUSTICECHOCANCELLATION)) return .AndroidAcousticEchoCancellation;
            if (iidEq(iid, c.SL_IID_ANDROIDAUTOMATICGAINCONTROL)) return .AndroidAutomaticGainControl;
            if (iidEq(iid, c.SL_IID_ANDROIDNOISESUPPRESSION)) return .AndroidNoiseSuppresssion;
            return null;
        }
    };
};
