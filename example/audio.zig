const std = @import("std");

const android = @import("android");

const JNI = android.JNI;
const c = android.egl.c;

const app_log = std.log.scoped(.audio);

const Oscillator = struct {
    isWaveOn: bool,
    phase: f64 = 0.0,
    phaseIncrement: f64 = 0,
    frequency: f64 = 440,
    amplitude: f64 = 0.1,
    fn setWaveOn(self: *@This(), isWaveOn: bool) void {
        @atomicStore(bool, &self.isWaveOn, isWaveOn, .SeqCst);
    }
    fn setSampleRate(self: *@This(), sample_rate: i32) void {
        self.phaseIncrement = (std.math.tau * self.frequency) / @intToFloat(f64, sample_rate);
    }
    fn render(self: *@This(), audio_data: []f32) void {
        if (!@atomicLoad(bool, &self.isWaveOn, .SeqCst)) self.phase = 0;

        for (audio_data) |*frame| {
            if (@atomicLoad(bool, &self.isWaveOn, .SeqCst)) {
                frame.* += @floatCast(f32, std.math.sin(self.phase) * self.amplitude);
                self.phase += self.phaseIncrement;
                if (self.phase > std.math.tau) self.phase -= std.math.tau;
            }
        }
    }
};

pub const AudioEngine = struct {
    oscillators: [10]Oscillator = undefined,
    stream: ?*c.AAudioStream = null,

    const buffer_size_in_bursts = 2;

    fn dataCallback(
        stream: ?*c.AAudioStream,
        user_data: ?*anyopaque,
        audio_data: ?*anyopaque,
        num_frames: i32,
    ) callconv(.C) c.aaudio_data_callback_result_t {
        _ = stream;
        const audio_engine = @ptrCast(*AudioEngine, @alignCast(@alignOf(AudioEngine), user_data.?));
        const audio_slice = @ptrCast([*]f32, @alignCast(@alignOf(f32), audio_data.?))[0..@intCast(usize, num_frames)];
        for (audio_slice) |*frame| {
            frame.* = 0;
        }
        for (audio_engine.oscillators) |*oscillator| {
            oscillator.render(audio_slice);
        }
        return c.AAUDIO_CALLBACK_RESULT_CONTINUE;
    }

    fn errorCallback(
        stream: ?*c.AAudioStream,
        user_data: ?*anyopaque,
        err: c.aaudio_result_t,
    ) callconv(.C) void {
        _ = stream;
        if (err == c.AAUDIO_ERROR_DISCONNECTED) {
            const self = @ptrCast(*AudioEngine, @alignCast(@alignOf(AudioEngine), user_data.?));
            _ = std.Thread.spawn(.{}, restart, .{self}) catch {
                app_log.err("Couldn't spawn thread", .{});
            };
        }
    }

    pub fn start(self: *@This()) bool {
        var stream_builder: ?*c.AAudioStreamBuilder = null;
        _ = c.AAudio_createStreamBuilder(&stream_builder);
        defer _ = c.AAudioStreamBuilder_delete(stream_builder);

        c.AAudioStreamBuilder_setFormat(stream_builder, c.AAUDIO_FORMAT_PCM_FLOAT);
        c.AAudioStreamBuilder_setChannelCount(stream_builder, 1);
        c.AAudioStreamBuilder_setPerformanceMode(stream_builder, c.AAUDIO_PERFORMANCE_MODE_LOW_LATENCY);
        c.AAudioStreamBuilder_setDataCallback(stream_builder, dataCallback, self);
        c.AAudioStreamBuilder_setErrorCallback(stream_builder, errorCallback, self);

        {
            const result = c.AAudioStreamBuilder_openStream(stream_builder, &self.stream);
            if (result != c.AAUDIO_OK) {
                app_log.err("Error opening stream {s}", .{c.AAudio_convertResultToText(result)});
                return false;
            }
        }

        const sample_rate = c.AAudioStream_getSampleRate(self.stream);
        for (self.oscillators) |*oscillator, index| {
            oscillator.* = Oscillator{
                .isWaveOn = false,
                .frequency = midiToFreq(49 + index * 3),
                .amplitude = dBToAmplitude(-@intToFloat(f64, index) - 11),
            };
            oscillator.setSampleRate(sample_rate);
        }

        _ = c.AAudioStream_setBufferSizeInFrames(self.stream, c.AAudioStream_getFramesPerBurst(self.stream) * buffer_size_in_bursts);

        {
            const result = c.AAudioStream_requestStart(self.stream);
            if (result != c.AAUDIO_OK) {
                app_log.err("Error starting stream {s}", .{c.AAudio_convertResultToText(result)});
                return false;
            }
        }

        return true;
    }

    var restartingLock = std.Thread.Mutex{};
    pub fn restart(self: *@This()) void {
        if (restartingLock.tryLock()) {
            self.stop();
            _ = self.start();
            restartingLock.unlock();
        }
    }

    pub fn stop(self: *@This()) void {
        if (self.stream) |stream| {
            _ = c.AAudioStream_requestStop(stream);
            _ = c.AAudioStream_close(stream);
        }
    }

    pub fn setToneOn(self: *@This(), which: usize, isToneOn: bool) void {
        // if (which >= self.oscillators.len) return;
        self.oscillators[which].setWaveOn(isToneOn);
    }
};

fn midiToFreq(note: usize) f64 {
    return std.math.pow(f64, 2, (@intToFloat(f64, note) - 49) / 12) * 440;
}

fn amplitudeTodB(amplitude: f64) f64 {
    return 20.0 * std.math.log10(amplitude);
}

fn dBToAmplitude(dB: f64) f64 {
    return std.math.pow(f64, 10.0, dB / 20.0);
}

// OpenSLES support
pub const OpenSL = struct {
    var init_sl_counter: usize = 0;
    var engine_object: c.SLObjectItf = undefined;
    var engine: c.SLEngineItf = undefined;

    var output_mix: c.SLObjectItf = undefined;

    var player: c.SLObjectItf = undefined;
    var play_itf: c.SLPlayItf = undefined;
    var buffer_queue_itf: c.SLAndroidSimpleBufferQueueItf = undefined;
    var state: c.SLAndroidSimpleBufferQueueState = undefined;

    var audio_sink: c.SLDataSink = undefined;
    var locator_outputmix: c.SLDataLocator_OutputMix = undefined;

    var audio_source: c.SLDataSource = undefined;
    var buffer_queue: c.SLDataLocator_BufferQueue = undefined;
    var pcm: c.SLDataFormat_PCM = undefined;

    // Local storage for audio data in 16 bit words
    const audio_data_storage_size = 4096;
    // Audio data buffer size in 16 bit words. 8 data segments are used in this simple example.
    const audio_data_buffer_size = audio_data_storage_size / 8;

    // Local storage for audio data
    var pcm_data: [audio_data_storage_size]c.SLint16 = undefined;

    const CallbackContext = struct {
        play_itf: c.SLPlayItf,
        /// Base buffer of local audio data storage
        data_base: []c.SLint16,
        /// Current location in local audio data storage
        data_index: usize,
        last_played_buffer: usize = 0,
        phase: f64 = 0.0,
        phaseIncrement: f64 = 0,
        frequency: f64 = 440,
        amplitude: f64 = 0.1,
        mutex: std.Thread.Mutex,

        fn setSampleRate(self: *@This(), sample_rate: i32) void {
            self.phaseIncrement = (std.math.tau * self.frequency) / @intToFloat(f64, sample_rate);
        }
    };

    pub fn bufferQueueCallback(queue_itf: c.SLAndroidSimpleBufferQueueItf, user_data: ?*anyopaque) callconv(.C) void {
        var context = @ptrCast(*CallbackContext, @alignCast(@alignOf(CallbackContext), user_data));
        context.mutex.lock();
        defer context.mutex.unlock();
        if (context.data_index < context.data_base.len) {
            var buffer = context.data_base[context.data_index..context.data_index + audio_data_buffer_size];
            var i: usize = 0;
            while (i < buffer.len) {
                buffer[i] = 0;
                buffer[i] +|= @floatToInt(i16, (std.math.sin(context.phase) * context.amplitude * (std.math.maxInt(i16))));
                i += 1;
                context.phase += context.phaseIncrement;
                if (context.phase > std.math.tau) context.phase -= std.math.tau;
            }
            checkResult(queue_itf.*.*.Enqueue.?(queue_itf, @ptrCast(*anyopaque, buffer.ptr), @intCast(c.SLuint32, 2 * buffer.len))) catch |e| {
                app_log.err("Error enqueueing buffer! {s}", .{@errorName(e)});
            };
            context.data_index = (context.data_index + audio_data_buffer_size) % context.data_base.len;
        }
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
        }
    }

    pub fn deinit() void {
        std.debug.assert(init_sl_counter > 0);

        if (thread) |t| {
            t.join();
            thread = null;
        }

        // spinlock lock
        {
            init_sl_counter -= 1;
            if (init_sl_counter == 0) {
                engine_object.*.*.Destroy.?(engine_object);
            }
        }
        // spinlock unlock
    }

    var thread: ?std.Thread = null;

    pub fn play_test() !void {
        if (thread == null) {
            thread = try std.Thread.spawn(.{}, play_thread_handler, .{});
        }
    }

    pub fn play_thread_handler() !void {
        play_thread() catch |e| {
            app_log.info("play_test error: {s}", .{@errorName(e)});
        };
    }

    pub fn play_thread() !void {
        app_log.info("Start play test", .{});
        const max_interfaces = 3;
        var required: [max_interfaces]c.SLboolean = .{c.SL_BOOLEAN_FALSE} ** max_interfaces;
        var iid_array: [max_interfaces]c.SLInterfaceID = .{c.SL_IID_NULL} ** max_interfaces;

        // Get OutputMix object
        try checkResult(engine.*.*.CreateOutputMix.?(engine, &output_mix, 1, &iid_array, &required));
        app_log.info("Created output mix", .{});
        try checkResult(output_mix.*.*.Realize.?(output_mix, c.SL_BOOLEAN_FALSE));
        app_log.info("Realized output mix", .{});
        defer output_mix.*.*.Destroy.?(output_mix);

        var output_mix_itf: c.SLOutputMixItf = undefined;
        try checkResult(output_mix.*.*.GetInterface.?(output_mix, c.SL_IID_OUTPUTMIX, @ptrCast(*anyopaque, &output_mix_itf)));
        // defer output_mix_itf.*.*.Destroy.?();
        var output_device_ids: [10]c.SLuint32 = undefined;
        var output_device_num: c.SLint32 = 10;
        try checkResult(output_mix_itf.*.*.GetDestinationOutputDeviceIDs.?(output_mix_itf, &output_device_num, &output_device_ids));
        for (output_device_ids[0..@intCast(usize, output_device_num)]) |id| {
            // var descriptor: c.SLAudioOutputDescriptor = undefined;
            // try checkResult(output_mix_itf.*.*.QueryAudioOutputCapabilities.?(output_mix_itf, id, &descriptor));
            app_log.info("Output mix device id: {}", .{id});
        }

        buffer_queue.locatorType = c.SL_DATALOCATOR_BUFFERQUEUE;
        buffer_queue.numBuffers = 4;

        // Setup the format of the content in the buffer queue
        pcm.formatType = c.SL_DATAFORMAT_PCM;
        pcm.numChannels = 1;
        pcm.samplesPerSec = c.SL_SAMPLINGRATE_44_1;
        pcm.bitsPerSample = c.SL_PCMSAMPLEFORMAT_FIXED_16;
        pcm.containerSize = 16;
        pcm.channelMask = c.SL_SPEAKER_FRONT_CENTER;
        pcm.endianness = c.SL_BYTEORDER_LITTLEENDIAN;

        audio_source.pFormat = @ptrCast(*anyopaque, &pcm);
        audio_source.pLocator = @ptrCast(*anyopaque, &buffer_queue);

        // Setup the data sink structure
        locator_outputmix.locatorType = c.SL_DATALOCATOR_OUTPUTMIX;
        locator_outputmix.outputMix = output_mix;

        audio_sink.pLocator = @ptrCast(*anyopaque, &locator_outputmix);
        audio_sink.pFormat = null;

        // Initialize the context for Buffer queue callbacks
        var context = CallbackContext{
            .play_itf = undefined,
            .data_base = pcm_data[0..],
            .data_index = 0,
            .mutex = std.Thread.Mutex{},
        };
        context.setSampleRate(44100);

        // Set arrays required and iid_array for SEEK interface (PlayItf is implicit)
        required[0] = c.SL_BOOLEAN_TRUE;
        iid_array[0] = c.SL_IID_BUFFERQUEUE;

        // Create the music player
        try checkResult(engine.*.*.CreateAudioPlayer.?(engine, &player, &audio_source, &audio_sink, 1, &iid_array, &required));
        try checkResult(player.*.*.Realize.?(player, c.SL_BOOLEAN_FALSE));
        defer player.*.*.Destroy.?(player);
        try checkResult(player.*.*.GetInterface.?(player, c.SL_IID_PLAY, @ptrCast(*anyopaque, &play_itf)));
        try checkResult(player.*.*.GetInterface.?(player, c.SL_IID_ANDROIDSIMPLEBUFFERQUEUE, @ptrCast(*anyopaque, &buffer_queue_itf)));
        try checkResult(buffer_queue_itf.*.*.RegisterCallback.?(buffer_queue_itf, bufferQueueCallback, @ptrCast(*anyopaque, &context))); // Register callback

        // Enqueue a few buffers to get the ball rollng
        try checkResult(buffer_queue_itf.*.*.Enqueue.?(buffer_queue_itf, &context.data_base[context.data_index], 2 * audio_data_buffer_size));
        context.last_played_buffer = context.data_index / audio_data_buffer_size;
        context.data_index += audio_data_buffer_size;
        try checkResult(buffer_queue_itf.*.*.Enqueue.?(buffer_queue_itf, &context.data_base[context.data_index], 2 * audio_data_buffer_size));
        context.last_played_buffer = context.data_index / audio_data_buffer_size;
        context.data_index += audio_data_buffer_size;
        try checkResult(buffer_queue_itf.*.*.Enqueue.?(buffer_queue_itf, &context.data_base[context.data_index], 2 * audio_data_buffer_size));
        context.last_played_buffer = context.data_index / audio_data_buffer_size;
        context.data_index += audio_data_buffer_size;
        try checkResult(buffer_queue_itf.*.*.Enqueue.?(buffer_queue_itf, &context.data_base[context.data_index], 2 * audio_data_buffer_size));
        context.last_played_buffer = context.data_index / audio_data_buffer_size;
        context.data_index += audio_data_buffer_size;

        try checkResult(play_itf.*.*.SetPlayState.?(play_itf, c.SL_PLAYSTATE_PLAYING));

        // Wait until the PCM data is done playing, the buffer queue callback
        // will continue to queue buffers until the entire PCM data has been
        // played. This is indicated by waiting for the count member of the
        // SLBufferQueueState to go to zero.
        try checkResult(buffer_queue_itf.*.*.GetState.?(buffer_queue_itf, &state));

        while (state.count > 0) {
            try checkResult(buffer_queue_itf.*.*.GetState.?(buffer_queue_itf, &state));
            // app_log.info("state count {}", .{state.count});
        }
        app_log.info("end get buffer queue state loop", .{});

        try checkResult(play_itf.*.*.SetPlayState.?(play_itf, c.SL_PLAYSTATE_STOPPED));
        app_log.info("set play state stopped", .{});
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
                    app_log.info("OpenSL engine interface id: {s}", .{@tagName(tag)});
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
                app_log.info("OpenSL engine extension {}: {s}", .{ i, extension_name });
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
                    app_log.info("OpenSL engine interface id: {s}", .{@tagName(tag)});
                } else {
                    app_log.info("Unknown engine interface id: {}", .{interface_id.*});
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
