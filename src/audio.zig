const std = @import("std");
const build_options = @import("build_options");

const android = @import("c.zig");

const audio_log = std.log.scoped(.audio);

const AAudio = @import("aaudio.zig").AAudio;

pub fn midiToFreq(note: usize) f64 {
    return std.math.pow(f64, 2, (@as(f64, @floatFromInt(note)) - 49) / 12) * 440;
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

pub fn getOutputStream(allocator: std.mem.Allocator, config: OutputStreamConfig) !*AAudio.OutputStream {
    return try AAudio.getOutputStream(allocator, config);
}
