const std = @import("std");

pub const __builtin_object_size = std.zig.c_builtins.__builtin_object_size;
pub const __builtin_expect = std.zig.c_builtins.__builtin_expect;
pub const __builtin_constant_p = std.zig.c_builtins.__builtin_constant_p;

pub const sl_uint8_t = u8;
pub const sl_int8_t = i8;
pub const sl_uint16_t = c_ushort;
pub const sl_int16_t = c_short;
pub const sl_uint32_t = c_uint;
pub const sl_int32_t = c_int;
pub const sl_int64_t = c_longlong;
pub const sl_uint64_t = c_ulonglong;
pub const SLint8 = sl_int8_t;
pub const SLuint8 = sl_uint8_t;
pub const SLint16 = sl_int16_t;
pub const SLuint16 = sl_uint16_t;
pub const SLint32 = sl_int32_t;
pub const SLuint32 = sl_uint32_t;
pub const SLboolean = SLuint32;
pub const SLchar = SLuint8;
pub const SLmillibel = SLint16;
pub const SLmillisecond = SLuint32;
pub const SLmilliHertz = SLuint32;
pub const SLmillimeter = SLint32;
pub const SLmillidegree = SLint32;
pub const SLpermille = SLint16;
pub const SLmicrosecond = SLuint32;
pub const SLresult = SLuint32;
pub const struct_SLInterfaceID_ = extern struct {
    time_low: SLuint32 = std.mem.zeroes(SLuint32),
    time_mid: SLuint16 = std.mem.zeroes(SLuint16),
    time_hi_and_version: SLuint16 = std.mem.zeroes(SLuint16),
    clock_seq: SLuint16 = std.mem.zeroes(SLuint16),
    node: [6]SLuint8 = std.mem.zeroes([6]SLuint8),
};
pub const SLInterfaceID = [*c]const struct_SLInterfaceID_;
pub const SLObjectItf = [*c]const [*c]const struct_SLObjectItf_;
pub const slObjectCallback = ?*const fn ([*c]const [*c]const struct_SLObjectItf_, ?*const anyopaque, SLuint32, SLresult, SLuint32, ?*anyopaque) callconv(.C) void;
pub const struct_SLObjectItf_ = extern struct {
    Realize: ?*const fn ([*c]const [*c]const struct_SLObjectItf_, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLObjectItf_, SLboolean) callconv(.C) SLresult),
    Resume: ?*const fn ([*c]const [*c]const struct_SLObjectItf_, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLObjectItf_, SLboolean) callconv(.C) SLresult),
    GetState: ?*const fn ([*c]const [*c]const struct_SLObjectItf_, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLObjectItf_, [*c]SLuint32) callconv(.C) SLresult),
    GetInterface: ?*const fn ([*c]const [*c]const struct_SLObjectItf_, SLInterfaceID, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLObjectItf_, SLInterfaceID, ?*anyopaque) callconv(.C) SLresult),
    RegisterCallback: ?*const fn ([*c]const [*c]const struct_SLObjectItf_, slObjectCallback, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLObjectItf_, slObjectCallback, ?*anyopaque) callconv(.C) SLresult),
    AbortAsyncOperation: ?*const fn ([*c]const [*c]const struct_SLObjectItf_) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLObjectItf_) callconv(.C) void),
    Destroy: ?*const fn ([*c]const [*c]const struct_SLObjectItf_) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLObjectItf_) callconv(.C) void),
    SetPriority: ?*const fn ([*c]const [*c]const struct_SLObjectItf_, SLint32, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLObjectItf_, SLint32, SLboolean) callconv(.C) SLresult),
    GetPriority: ?*const fn ([*c]const [*c]const struct_SLObjectItf_, [*c]SLint32, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLObjectItf_, [*c]SLint32, [*c]SLboolean) callconv(.C) SLresult),
    SetLossOfControlInterfaces: ?*const fn ([*c]const [*c]const struct_SLObjectItf_, SLint16, [*c]SLInterfaceID, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLObjectItf_, SLint16, [*c]SLInterfaceID, SLboolean) callconv(.C) SLresult),
};
pub extern const SL_IID_NULL: SLInterfaceID;
pub const struct_SLDataLocator_URI_ = extern struct {
    locatorType: SLuint32 = std.mem.zeroes(SLuint32),
    URI: [*c]SLchar = std.mem.zeroes([*c]SLchar),
};
pub const SLDataLocator_URI = struct_SLDataLocator_URI_;
pub const struct_SLDataLocator_Address_ = extern struct {
    locatorType: SLuint32 = std.mem.zeroes(SLuint32),
    pAddress: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    length: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLDataLocator_Address = struct_SLDataLocator_Address_;
pub const struct_SLDataLocator_IODevice_ = extern struct {
    locatorType: SLuint32 = std.mem.zeroes(SLuint32),
    deviceType: SLuint32 = std.mem.zeroes(SLuint32),
    deviceID: SLuint32 = std.mem.zeroes(SLuint32),
    device: [*c]const [*c]const struct_SLObjectItf_ = std.mem.zeroes([*c]const [*c]const struct_SLObjectItf_),
};
pub const SLDataLocator_IODevice = struct_SLDataLocator_IODevice_;
pub const struct_SLDataLocator_OutputMix = extern struct {
    locatorType: SLuint32 = std.mem.zeroes(SLuint32),
    outputMix: [*c]const [*c]const struct_SLObjectItf_ = std.mem.zeroes([*c]const [*c]const struct_SLObjectItf_),
};
pub const SLDataLocator_OutputMix = struct_SLDataLocator_OutputMix;
pub const struct_SLDataLocator_BufferQueue = extern struct {
    locatorType: SLuint32 = std.mem.zeroes(SLuint32),
    numBuffers: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLDataLocator_BufferQueue = struct_SLDataLocator_BufferQueue;
pub const struct_SLDataLocator_MIDIBufferQueue = extern struct {
    locatorType: SLuint32 = std.mem.zeroes(SLuint32),
    tpqn: SLuint32 = std.mem.zeroes(SLuint32),
    numBuffers: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLDataLocator_MIDIBufferQueue = struct_SLDataLocator_MIDIBufferQueue;
pub const struct_SLDataFormat_MIME_ = extern struct {
    formatType: SLuint32 = std.mem.zeroes(SLuint32),
    mimeType: [*c]SLchar = std.mem.zeroes([*c]SLchar),
    containerType: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLDataFormat_MIME = struct_SLDataFormat_MIME_;
pub const struct_SLDataFormat_PCM_ = extern struct {
    formatType: SLuint32 = std.mem.zeroes(SLuint32),
    numChannels: SLuint32 = std.mem.zeroes(SLuint32),
    samplesPerSec: SLuint32 = std.mem.zeroes(SLuint32),
    bitsPerSample: SLuint32 = std.mem.zeroes(SLuint32),
    containerSize: SLuint32 = std.mem.zeroes(SLuint32),
    channelMask: SLuint32 = std.mem.zeroes(SLuint32),
    endianness: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLDataFormat_PCM = struct_SLDataFormat_PCM_;
pub const struct_SLDataSource_ = extern struct {
    pLocator: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    pFormat: ?*anyopaque = std.mem.zeroes(?*anyopaque),
};
pub const SLDataSource = struct_SLDataSource_;
pub const struct_SLDataSink_ = extern struct {
    pLocator: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    pFormat: ?*anyopaque = std.mem.zeroes(?*anyopaque),
};
pub const SLDataSink = struct_SLDataSink_;
pub extern const SL_IID_OBJECT: SLInterfaceID;
pub const struct_SLAudioInputDescriptor_ = extern struct {
    deviceName: [*c]SLchar = std.mem.zeroes([*c]SLchar),
    deviceConnection: SLint16 = std.mem.zeroes(SLint16),
    deviceScope: SLint16 = std.mem.zeroes(SLint16),
    deviceLocation: SLint16 = std.mem.zeroes(SLint16),
    isForTelephony: SLboolean = std.mem.zeroes(SLboolean),
    minSampleRate: SLmilliHertz = std.mem.zeroes(SLmilliHertz),
    maxSampleRate: SLmilliHertz = std.mem.zeroes(SLmilliHertz),
    isFreqRangeContinuous: SLboolean = std.mem.zeroes(SLboolean),
    samplingRatesSupported: [*c]SLmilliHertz = std.mem.zeroes([*c]SLmilliHertz),
    numOfSamplingRatesSupported: SLint16 = std.mem.zeroes(SLint16),
    maxChannels: SLint16 = std.mem.zeroes(SLint16),
};
pub const SLAudioInputDescriptor = struct_SLAudioInputDescriptor_;
pub const struct_SLAudioOutputDescriptor_ = extern struct {
    pDeviceName: [*c]SLchar = std.mem.zeroes([*c]SLchar),
    deviceConnection: SLint16 = std.mem.zeroes(SLint16),
    deviceScope: SLint16 = std.mem.zeroes(SLint16),
    deviceLocation: SLint16 = std.mem.zeroes(SLint16),
    isForTelephony: SLboolean = std.mem.zeroes(SLboolean),
    minSampleRate: SLmilliHertz = std.mem.zeroes(SLmilliHertz),
    maxSampleRate: SLmilliHertz = std.mem.zeroes(SLmilliHertz),
    isFreqRangeContinuous: SLboolean = std.mem.zeroes(SLboolean),
    samplingRatesSupported: [*c]SLmilliHertz = std.mem.zeroes([*c]SLmilliHertz),
    numOfSamplingRatesSupported: SLint16 = std.mem.zeroes(SLint16),
    maxChannels: SLint16 = std.mem.zeroes(SLint16),
};
pub const SLAudioOutputDescriptor = struct_SLAudioOutputDescriptor_;
pub extern const SL_IID_AUDIOIODEVICECAPABILITIES: SLInterfaceID;
pub const SLAudioIODeviceCapabilitiesItf = [*c]const [*c]const struct_SLAudioIODeviceCapabilitiesItf_;
pub const slAvailableAudioInputsChangedCallback = ?*const fn (SLAudioIODeviceCapabilitiesItf, ?*anyopaque, SLuint32, SLint32, SLboolean) callconv(.C) void;
pub const slAvailableAudioOutputsChangedCallback = ?*const fn (SLAudioIODeviceCapabilitiesItf, ?*anyopaque, SLuint32, SLint32, SLboolean) callconv(.C) void;
pub const slDefaultDeviceIDMapChangedCallback = ?*const fn (SLAudioIODeviceCapabilitiesItf, ?*anyopaque, SLboolean, SLint32) callconv(.C) void;
pub const struct_SLAudioIODeviceCapabilitiesItf_ = extern struct {
    GetAvailableAudioInputs: ?*const fn (SLAudioIODeviceCapabilitiesItf, [*c]SLint32, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioIODeviceCapabilitiesItf, [*c]SLint32, [*c]SLuint32) callconv(.C) SLresult),
    QueryAudioInputCapabilities: ?*const fn (SLAudioIODeviceCapabilitiesItf, SLuint32, [*c]SLAudioInputDescriptor) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioIODeviceCapabilitiesItf, SLuint32, [*c]SLAudioInputDescriptor) callconv(.C) SLresult),
    RegisterAvailableAudioInputsChangedCallback: ?*const fn (SLAudioIODeviceCapabilitiesItf, slAvailableAudioInputsChangedCallback, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioIODeviceCapabilitiesItf, slAvailableAudioInputsChangedCallback, ?*anyopaque) callconv(.C) SLresult),
    GetAvailableAudioOutputs: ?*const fn (SLAudioIODeviceCapabilitiesItf, [*c]SLint32, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioIODeviceCapabilitiesItf, [*c]SLint32, [*c]SLuint32) callconv(.C) SLresult),
    QueryAudioOutputCapabilities: ?*const fn (SLAudioIODeviceCapabilitiesItf, SLuint32, [*c]SLAudioOutputDescriptor) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioIODeviceCapabilitiesItf, SLuint32, [*c]SLAudioOutputDescriptor) callconv(.C) SLresult),
    RegisterAvailableAudioOutputsChangedCallback: ?*const fn (SLAudioIODeviceCapabilitiesItf, slAvailableAudioOutputsChangedCallback, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioIODeviceCapabilitiesItf, slAvailableAudioOutputsChangedCallback, ?*anyopaque) callconv(.C) SLresult),
    RegisterDefaultDeviceIDMapChangedCallback: ?*const fn (SLAudioIODeviceCapabilitiesItf, slDefaultDeviceIDMapChangedCallback, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioIODeviceCapabilitiesItf, slDefaultDeviceIDMapChangedCallback, ?*anyopaque) callconv(.C) SLresult),
    GetAssociatedAudioInputs: ?*const fn (SLAudioIODeviceCapabilitiesItf, SLuint32, [*c]SLint32, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioIODeviceCapabilitiesItf, SLuint32, [*c]SLint32, [*c]SLuint32) callconv(.C) SLresult),
    GetAssociatedAudioOutputs: ?*const fn (SLAudioIODeviceCapabilitiesItf, SLuint32, [*c]SLint32, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioIODeviceCapabilitiesItf, SLuint32, [*c]SLint32, [*c]SLuint32) callconv(.C) SLresult),
    GetDefaultAudioDevices: ?*const fn (SLAudioIODeviceCapabilitiesItf, SLuint32, [*c]SLint32, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioIODeviceCapabilitiesItf, SLuint32, [*c]SLint32, [*c]SLuint32) callconv(.C) SLresult),
    QuerySampleFormatsSupported: ?*const fn (SLAudioIODeviceCapabilitiesItf, SLuint32, SLmilliHertz, [*c]SLint32, [*c]SLint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioIODeviceCapabilitiesItf, SLuint32, SLmilliHertz, [*c]SLint32, [*c]SLint32) callconv(.C) SLresult),
};
pub const struct_SLLEDDescriptor_ = extern struct {
    ledCount: SLuint8 = std.mem.zeroes(SLuint8),
    primaryLED: SLuint8 = std.mem.zeroes(SLuint8),
    colorMask: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLLEDDescriptor = struct_SLLEDDescriptor_;
pub const struct_SLHSL_ = extern struct {
    hue: SLmillidegree = std.mem.zeroes(SLmillidegree),
    saturation: SLpermille = std.mem.zeroes(SLpermille),
    lightness: SLpermille = std.mem.zeroes(SLpermille),
};
pub const SLHSL = struct_SLHSL_;
pub extern const SL_IID_LED: SLInterfaceID;
pub const SLLEDArrayItf = [*c]const [*c]const struct_SLLEDArrayItf_;
pub const struct_SLLEDArrayItf_ = extern struct {
    ActivateLEDArray: ?*const fn (SLLEDArrayItf, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLLEDArrayItf, SLuint32) callconv(.C) SLresult),
    IsLEDArrayActivated: ?*const fn (SLLEDArrayItf, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLLEDArrayItf, [*c]SLuint32) callconv(.C) SLresult),
    SetColor: ?*const fn (SLLEDArrayItf, SLuint8, [*c]const SLHSL) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLLEDArrayItf, SLuint8, [*c]const SLHSL) callconv(.C) SLresult),
    GetColor: ?*const fn (SLLEDArrayItf, SLuint8, [*c]SLHSL) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLLEDArrayItf, SLuint8, [*c]SLHSL) callconv(.C) SLresult),
};
pub const struct_SLVibraDescriptor_ = extern struct {
    supportsFrequency: SLboolean = std.mem.zeroes(SLboolean),
    supportsIntensity: SLboolean = std.mem.zeroes(SLboolean),
    minFrequency: SLmilliHertz = std.mem.zeroes(SLmilliHertz),
    maxFrequency: SLmilliHertz = std.mem.zeroes(SLmilliHertz),
};
pub const SLVibraDescriptor = struct_SLVibraDescriptor_;
pub extern const SL_IID_VIBRA: SLInterfaceID;
pub const SLVibraItf = [*c]const [*c]const struct_SLVibraItf_;
pub const struct_SLVibraItf_ = extern struct {
    Vibrate: ?*const fn (SLVibraItf, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVibraItf, SLboolean) callconv(.C) SLresult),
    IsVibrating: ?*const fn (SLVibraItf, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVibraItf, [*c]SLboolean) callconv(.C) SLresult),
    SetFrequency: ?*const fn (SLVibraItf, SLmilliHertz) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVibraItf, SLmilliHertz) callconv(.C) SLresult),
    GetFrequency: ?*const fn (SLVibraItf, [*c]SLmilliHertz) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVibraItf, [*c]SLmilliHertz) callconv(.C) SLresult),
    SetIntensity: ?*const fn (SLVibraItf, SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVibraItf, SLpermille) callconv(.C) SLresult),
    GetIntensity: ?*const fn (SLVibraItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVibraItf, [*c]SLpermille) callconv(.C) SLresult),
};
pub const struct_SLMetadataInfo_ = extern struct {
    size: SLuint32 = std.mem.zeroes(SLuint32),
    encoding: SLuint32 = std.mem.zeroes(SLuint32),
    langCountry: [16]SLchar = std.mem.zeroes([16]SLchar),
    data: [1]SLuint8 = std.mem.zeroes([1]SLuint8),
};
pub const SLMetadataInfo = struct_SLMetadataInfo_;
pub extern const SL_IID_METADATAEXTRACTION: SLInterfaceID;
pub const SLMetadataExtractionItf = [*c]const [*c]const struct_SLMetadataExtractionItf_;
pub const struct_SLMetadataExtractionItf_ = extern struct {
    GetItemCount: ?*const fn (SLMetadataExtractionItf, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMetadataExtractionItf, [*c]SLuint32) callconv(.C) SLresult),
    GetKeySize: ?*const fn (SLMetadataExtractionItf, SLuint32, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMetadataExtractionItf, SLuint32, [*c]SLuint32) callconv(.C) SLresult),
    GetKey: ?*const fn (SLMetadataExtractionItf, SLuint32, SLuint32, [*c]SLMetadataInfo) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMetadataExtractionItf, SLuint32, SLuint32, [*c]SLMetadataInfo) callconv(.C) SLresult),
    GetValueSize: ?*const fn (SLMetadataExtractionItf, SLuint32, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMetadataExtractionItf, SLuint32, [*c]SLuint32) callconv(.C) SLresult),
    GetValue: ?*const fn (SLMetadataExtractionItf, SLuint32, SLuint32, [*c]SLMetadataInfo) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMetadataExtractionItf, SLuint32, SLuint32, [*c]SLMetadataInfo) callconv(.C) SLresult),
    AddKeyFilter: ?*const fn (SLMetadataExtractionItf, SLuint32, ?*const anyopaque, SLuint32, [*c]const SLchar, SLuint32, SLuint8) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMetadataExtractionItf, SLuint32, ?*const anyopaque, SLuint32, [*c]const SLchar, SLuint32, SLuint8) callconv(.C) SLresult),
    ClearKeyFilter: ?*const fn (SLMetadataExtractionItf) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMetadataExtractionItf) callconv(.C) SLresult),
};
pub extern const SL_IID_METADATATRAVERSAL: SLInterfaceID;
pub const SLMetadataTraversalItf = [*c]const [*c]const struct_SLMetadataTraversalItf_;
pub const struct_SLMetadataTraversalItf_ = extern struct {
    SetMode: ?*const fn (SLMetadataTraversalItf, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMetadataTraversalItf, SLuint32) callconv(.C) SLresult),
    GetChildCount: ?*const fn (SLMetadataTraversalItf, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMetadataTraversalItf, [*c]SLuint32) callconv(.C) SLresult),
    GetChildMIMETypeSize: ?*const fn (SLMetadataTraversalItf, SLuint32, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMetadataTraversalItf, SLuint32, [*c]SLuint32) callconv(.C) SLresult),
    GetChildInfo: ?*const fn (SLMetadataTraversalItf, SLuint32, [*c]SLint32, [*c]SLuint32, SLuint32, [*c]SLchar) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMetadataTraversalItf, SLuint32, [*c]SLint32, [*c]SLuint32, SLuint32, [*c]SLchar) callconv(.C) SLresult),
    SetActiveNode: ?*const fn (SLMetadataTraversalItf, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMetadataTraversalItf, SLuint32) callconv(.C) SLresult),
};
pub extern const SL_IID_DYNAMICSOURCE: SLInterfaceID;
pub const SLDynamicSourceItf = [*c]const [*c]const struct_SLDynamicSourceItf_;
pub const struct_SLDynamicSourceItf_ = extern struct {
    SetSource: ?*const fn (SLDynamicSourceItf, [*c]SLDataSource) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLDynamicSourceItf, [*c]SLDataSource) callconv(.C) SLresult),
};
pub extern const SL_IID_OUTPUTMIX: SLInterfaceID;
pub const SLOutputMixItf = [*c]const [*c]const struct_SLOutputMixItf_;
pub const slMixDeviceChangeCallback = ?*const fn ([*c]const [*c]const struct_SLOutputMixItf_, ?*anyopaque) callconv(.C) void;
pub const struct_SLOutputMixItf_ = extern struct {
    GetDestinationOutputDeviceIDs: ?*const fn ([*c]const [*c]const struct_SLOutputMixItf_, [*c]SLint32, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLOutputMixItf_, [*c]SLint32, [*c]SLuint32) callconv(.C) SLresult),
    RegisterDeviceChangeCallback: ?*const fn ([*c]const [*c]const struct_SLOutputMixItf_, slMixDeviceChangeCallback, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLOutputMixItf_, slMixDeviceChangeCallback, ?*anyopaque) callconv(.C) SLresult),
    ReRoute: ?*const fn ([*c]const [*c]const struct_SLOutputMixItf_, SLint32, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLOutputMixItf_, SLint32, [*c]SLuint32) callconv(.C) SLresult),
};
pub extern const SL_IID_PLAY: SLInterfaceID;
pub const SLPlayItf = [*c]const [*c]const struct_SLPlayItf_;
pub const slPlayCallback = ?*const fn ([*c]const [*c]const struct_SLPlayItf_, ?*anyopaque, SLuint32) callconv(.C) void;
pub const struct_SLPlayItf_ = extern struct {
    SetPlayState: ?*const fn ([*c]const [*c]const struct_SLPlayItf_, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLPlayItf_, SLuint32) callconv(.C) SLresult),
    GetPlayState: ?*const fn ([*c]const [*c]const struct_SLPlayItf_, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLPlayItf_, [*c]SLuint32) callconv(.C) SLresult),
    GetDuration: ?*const fn ([*c]const [*c]const struct_SLPlayItf_, [*c]SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLPlayItf_, [*c]SLmillisecond) callconv(.C) SLresult),
    GetPosition: ?*const fn ([*c]const [*c]const struct_SLPlayItf_, [*c]SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLPlayItf_, [*c]SLmillisecond) callconv(.C) SLresult),
    RegisterCallback: ?*const fn ([*c]const [*c]const struct_SLPlayItf_, slPlayCallback, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLPlayItf_, slPlayCallback, ?*anyopaque) callconv(.C) SLresult),
    SetCallbackEventsMask: ?*const fn ([*c]const [*c]const struct_SLPlayItf_, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLPlayItf_, SLuint32) callconv(.C) SLresult),
    GetCallbackEventsMask: ?*const fn ([*c]const [*c]const struct_SLPlayItf_, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLPlayItf_, [*c]SLuint32) callconv(.C) SLresult),
    SetMarkerPosition: ?*const fn ([*c]const [*c]const struct_SLPlayItf_, SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLPlayItf_, SLmillisecond) callconv(.C) SLresult),
    ClearMarkerPosition: ?*const fn ([*c]const [*c]const struct_SLPlayItf_) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLPlayItf_) callconv(.C) SLresult),
    GetMarkerPosition: ?*const fn ([*c]const [*c]const struct_SLPlayItf_, [*c]SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLPlayItf_, [*c]SLmillisecond) callconv(.C) SLresult),
    SetPositionUpdatePeriod: ?*const fn ([*c]const [*c]const struct_SLPlayItf_, SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLPlayItf_, SLmillisecond) callconv(.C) SLresult),
    GetPositionUpdatePeriod: ?*const fn ([*c]const [*c]const struct_SLPlayItf_, [*c]SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLPlayItf_, [*c]SLmillisecond) callconv(.C) SLresult),
};
pub extern const SL_IID_PREFETCHSTATUS: SLInterfaceID;
pub const SLPrefetchStatusItf = [*c]const [*c]const struct_SLPrefetchStatusItf_;
pub const slPrefetchCallback = ?*const fn (SLPrefetchStatusItf, ?*anyopaque, SLuint32) callconv(.C) void;
pub const struct_SLPrefetchStatusItf_ = extern struct {
    GetPrefetchStatus: ?*const fn (SLPrefetchStatusItf, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPrefetchStatusItf, [*c]SLuint32) callconv(.C) SLresult),
    GetFillLevel: ?*const fn (SLPrefetchStatusItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPrefetchStatusItf, [*c]SLpermille) callconv(.C) SLresult),
    RegisterCallback: ?*const fn (SLPrefetchStatusItf, slPrefetchCallback, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPrefetchStatusItf, slPrefetchCallback, ?*anyopaque) callconv(.C) SLresult),
    SetCallbackEventsMask: ?*const fn (SLPrefetchStatusItf, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPrefetchStatusItf, SLuint32) callconv(.C) SLresult),
    GetCallbackEventsMask: ?*const fn (SLPrefetchStatusItf, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPrefetchStatusItf, [*c]SLuint32) callconv(.C) SLresult),
    SetFillUpdatePeriod: ?*const fn (SLPrefetchStatusItf, SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPrefetchStatusItf, SLpermille) callconv(.C) SLresult),
    GetFillUpdatePeriod: ?*const fn (SLPrefetchStatusItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPrefetchStatusItf, [*c]SLpermille) callconv(.C) SLresult),
};
pub extern const SL_IID_PLAYBACKRATE: SLInterfaceID;
pub const SLPlaybackRateItf = [*c]const [*c]const struct_SLPlaybackRateItf_;
pub const struct_SLPlaybackRateItf_ = extern struct {
    SetRate: ?*const fn (SLPlaybackRateItf, SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPlaybackRateItf, SLpermille) callconv(.C) SLresult),
    GetRate: ?*const fn (SLPlaybackRateItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPlaybackRateItf, [*c]SLpermille) callconv(.C) SLresult),
    SetPropertyConstraints: ?*const fn (SLPlaybackRateItf, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPlaybackRateItf, SLuint32) callconv(.C) SLresult),
    GetProperties: ?*const fn (SLPlaybackRateItf, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPlaybackRateItf, [*c]SLuint32) callconv(.C) SLresult),
    GetCapabilitiesOfRate: ?*const fn (SLPlaybackRateItf, SLpermille, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPlaybackRateItf, SLpermille, [*c]SLuint32) callconv(.C) SLresult),
    GetRateRange: ?*const fn (SLPlaybackRateItf, SLuint8, [*c]SLpermille, [*c]SLpermille, [*c]SLpermille, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPlaybackRateItf, SLuint8, [*c]SLpermille, [*c]SLpermille, [*c]SLpermille, [*c]SLuint32) callconv(.C) SLresult),
};
pub extern const SL_IID_SEEK: SLInterfaceID;
pub const SLSeekItf = [*c]const [*c]const struct_SLSeekItf_;
pub const struct_SLSeekItf_ = extern struct {
    SetPosition: ?*const fn (SLSeekItf, SLmillisecond, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLSeekItf, SLmillisecond, SLuint32) callconv(.C) SLresult),
    SetLoop: ?*const fn (SLSeekItf, SLboolean, SLmillisecond, SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLSeekItf, SLboolean, SLmillisecond, SLmillisecond) callconv(.C) SLresult),
    GetLoop: ?*const fn (SLSeekItf, [*c]SLboolean, [*c]SLmillisecond, [*c]SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLSeekItf, [*c]SLboolean, [*c]SLmillisecond, [*c]SLmillisecond) callconv(.C) SLresult),
};
pub extern const SL_IID_RECORD: SLInterfaceID;
pub const SLRecordItf = [*c]const [*c]const struct_SLRecordItf_;
pub const slRecordCallback = ?*const fn (SLRecordItf, ?*anyopaque, SLuint32) callconv(.C) void;
pub const struct_SLRecordItf_ = extern struct {
    SetRecordState: ?*const fn (SLRecordItf, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRecordItf, SLuint32) callconv(.C) SLresult),
    GetRecordState: ?*const fn (SLRecordItf, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRecordItf, [*c]SLuint32) callconv(.C) SLresult),
    SetDurationLimit: ?*const fn (SLRecordItf, SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRecordItf, SLmillisecond) callconv(.C) SLresult),
    GetPosition: ?*const fn (SLRecordItf, [*c]SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRecordItf, [*c]SLmillisecond) callconv(.C) SLresult),
    RegisterCallback: ?*const fn (SLRecordItf, slRecordCallback, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRecordItf, slRecordCallback, ?*anyopaque) callconv(.C) SLresult),
    SetCallbackEventsMask: ?*const fn (SLRecordItf, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRecordItf, SLuint32) callconv(.C) SLresult),
    GetCallbackEventsMask: ?*const fn (SLRecordItf, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRecordItf, [*c]SLuint32) callconv(.C) SLresult),
    SetMarkerPosition: ?*const fn (SLRecordItf, SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRecordItf, SLmillisecond) callconv(.C) SLresult),
    ClearMarkerPosition: ?*const fn (SLRecordItf) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRecordItf) callconv(.C) SLresult),
    GetMarkerPosition: ?*const fn (SLRecordItf, [*c]SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRecordItf, [*c]SLmillisecond) callconv(.C) SLresult),
    SetPositionUpdatePeriod: ?*const fn (SLRecordItf, SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRecordItf, SLmillisecond) callconv(.C) SLresult),
    GetPositionUpdatePeriod: ?*const fn (SLRecordItf, [*c]SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRecordItf, [*c]SLmillisecond) callconv(.C) SLresult),
};
pub extern const SL_IID_EQUALIZER: SLInterfaceID;
pub const SLEqualizerItf = [*c]const [*c]const struct_SLEqualizerItf_;
pub const struct_SLEqualizerItf_ = extern struct {
    SetEnabled: ?*const fn (SLEqualizerItf, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEqualizerItf, SLboolean) callconv(.C) SLresult),
    IsEnabled: ?*const fn (SLEqualizerItf, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEqualizerItf, [*c]SLboolean) callconv(.C) SLresult),
    GetNumberOfBands: ?*const fn (SLEqualizerItf, [*c]SLuint16) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEqualizerItf, [*c]SLuint16) callconv(.C) SLresult),
    GetBandLevelRange: ?*const fn (SLEqualizerItf, [*c]SLmillibel, [*c]SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEqualizerItf, [*c]SLmillibel, [*c]SLmillibel) callconv(.C) SLresult),
    SetBandLevel: ?*const fn (SLEqualizerItf, SLuint16, SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEqualizerItf, SLuint16, SLmillibel) callconv(.C) SLresult),
    GetBandLevel: ?*const fn (SLEqualizerItf, SLuint16, [*c]SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEqualizerItf, SLuint16, [*c]SLmillibel) callconv(.C) SLresult),
    GetCenterFreq: ?*const fn (SLEqualizerItf, SLuint16, [*c]SLmilliHertz) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEqualizerItf, SLuint16, [*c]SLmilliHertz) callconv(.C) SLresult),
    GetBandFreqRange: ?*const fn (SLEqualizerItf, SLuint16, [*c]SLmilliHertz, [*c]SLmilliHertz) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEqualizerItf, SLuint16, [*c]SLmilliHertz, [*c]SLmilliHertz) callconv(.C) SLresult),
    GetBand: ?*const fn (SLEqualizerItf, SLmilliHertz, [*c]SLuint16) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEqualizerItf, SLmilliHertz, [*c]SLuint16) callconv(.C) SLresult),
    GetCurrentPreset: ?*const fn (SLEqualizerItf, [*c]SLuint16) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEqualizerItf, [*c]SLuint16) callconv(.C) SLresult),
    UsePreset: ?*const fn (SLEqualizerItf, SLuint16) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEqualizerItf, SLuint16) callconv(.C) SLresult),
    GetNumberOfPresets: ?*const fn (SLEqualizerItf, [*c]SLuint16) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEqualizerItf, [*c]SLuint16) callconv(.C) SLresult),
    GetPresetName: ?*const fn (SLEqualizerItf, SLuint16, [*c][*c]const SLchar) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEqualizerItf, SLuint16, [*c][*c]const SLchar) callconv(.C) SLresult),
};
pub extern const SL_IID_VOLUME: SLInterfaceID;
pub const SLVolumeItf = [*c]const [*c]const struct_SLVolumeItf_;
pub const struct_SLVolumeItf_ = extern struct {
    SetVolumeLevel: ?*const fn (SLVolumeItf, SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVolumeItf, SLmillibel) callconv(.C) SLresult),
    GetVolumeLevel: ?*const fn (SLVolumeItf, [*c]SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVolumeItf, [*c]SLmillibel) callconv(.C) SLresult),
    GetMaxVolumeLevel: ?*const fn (SLVolumeItf, [*c]SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVolumeItf, [*c]SLmillibel) callconv(.C) SLresult),
    SetMute: ?*const fn (SLVolumeItf, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVolumeItf, SLboolean) callconv(.C) SLresult),
    GetMute: ?*const fn (SLVolumeItf, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVolumeItf, [*c]SLboolean) callconv(.C) SLresult),
    EnableStereoPosition: ?*const fn (SLVolumeItf, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVolumeItf, SLboolean) callconv(.C) SLresult),
    IsEnabledStereoPosition: ?*const fn (SLVolumeItf, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVolumeItf, [*c]SLboolean) callconv(.C) SLresult),
    SetStereoPosition: ?*const fn (SLVolumeItf, SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVolumeItf, SLpermille) callconv(.C) SLresult),
    GetStereoPosition: ?*const fn (SLVolumeItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVolumeItf, [*c]SLpermille) callconv(.C) SLresult),
};
pub extern const SL_IID_DEVICEVOLUME: SLInterfaceID;
pub const SLDeviceVolumeItf = [*c]const [*c]const struct_SLDeviceVolumeItf_;
pub const struct_SLDeviceVolumeItf_ = extern struct {
    GetVolumeScale: ?*const fn (SLDeviceVolumeItf, SLuint32, [*c]SLint32, [*c]SLint32, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLDeviceVolumeItf, SLuint32, [*c]SLint32, [*c]SLint32, [*c]SLboolean) callconv(.C) SLresult),
    SetVolume: ?*const fn (SLDeviceVolumeItf, SLuint32, SLint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLDeviceVolumeItf, SLuint32, SLint32) callconv(.C) SLresult),
    GetVolume: ?*const fn (SLDeviceVolumeItf, SLuint32, [*c]SLint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLDeviceVolumeItf, SLuint32, [*c]SLint32) callconv(.C) SLresult),
};
pub extern const SL_IID_BUFFERQUEUE: SLInterfaceID;
pub const SLBufferQueueItf = [*c]const [*c]const struct_SLBufferQueueItf_;
pub const struct_SLBufferQueueState_ = extern struct {
    count: SLuint32 = std.mem.zeroes(SLuint32),
    playIndex: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLBufferQueueState = struct_SLBufferQueueState_;
pub const slBufferQueueCallback = ?*const fn (SLBufferQueueItf, ?*anyopaque) callconv(.C) void;
pub const struct_SLBufferQueueItf_ = extern struct {
    Enqueue: ?*const fn (SLBufferQueueItf, ?*const anyopaque, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLBufferQueueItf, ?*const anyopaque, SLuint32) callconv(.C) SLresult),
    Clear: ?*const fn (SLBufferQueueItf) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLBufferQueueItf) callconv(.C) SLresult),
    GetState: ?*const fn (SLBufferQueueItf, [*c]SLBufferQueueState) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLBufferQueueItf, [*c]SLBufferQueueState) callconv(.C) SLresult),
    RegisterCallback: ?*const fn (SLBufferQueueItf, slBufferQueueCallback, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLBufferQueueItf, slBufferQueueCallback, ?*anyopaque) callconv(.C) SLresult),
};
pub extern const SL_IID_PRESETREVERB: SLInterfaceID;
pub const SLPresetReverbItf = [*c]const [*c]const struct_SLPresetReverbItf_;
pub const struct_SLPresetReverbItf_ = extern struct {
    SetPreset: ?*const fn (SLPresetReverbItf, SLuint16) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPresetReverbItf, SLuint16) callconv(.C) SLresult),
    GetPreset: ?*const fn (SLPresetReverbItf, [*c]SLuint16) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPresetReverbItf, [*c]SLuint16) callconv(.C) SLresult),
};
pub const struct_SLEnvironmentalReverbSettings_ = extern struct {
    roomLevel: SLmillibel = std.mem.zeroes(SLmillibel),
    roomHFLevel: SLmillibel = std.mem.zeroes(SLmillibel),
    decayTime: SLmillisecond = std.mem.zeroes(SLmillisecond),
    decayHFRatio: SLpermille = std.mem.zeroes(SLpermille),
    reflectionsLevel: SLmillibel = std.mem.zeroes(SLmillibel),
    reflectionsDelay: SLmillisecond = std.mem.zeroes(SLmillisecond),
    reverbLevel: SLmillibel = std.mem.zeroes(SLmillibel),
    reverbDelay: SLmillisecond = std.mem.zeroes(SLmillisecond),
    diffusion: SLpermille = std.mem.zeroes(SLpermille),
    density: SLpermille = std.mem.zeroes(SLpermille),
};
pub const SLEnvironmentalReverbSettings = struct_SLEnvironmentalReverbSettings_;
pub extern const SL_IID_ENVIRONMENTALREVERB: SLInterfaceID;
pub const SLEnvironmentalReverbItf = [*c]const [*c]const struct_SLEnvironmentalReverbItf_;
pub const struct_SLEnvironmentalReverbItf_ = extern struct {
    SetRoomLevel: ?*const fn (SLEnvironmentalReverbItf, SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, SLmillibel) callconv(.C) SLresult),
    GetRoomLevel: ?*const fn (SLEnvironmentalReverbItf, [*c]SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, [*c]SLmillibel) callconv(.C) SLresult),
    SetRoomHFLevel: ?*const fn (SLEnvironmentalReverbItf, SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, SLmillibel) callconv(.C) SLresult),
    GetRoomHFLevel: ?*const fn (SLEnvironmentalReverbItf, [*c]SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, [*c]SLmillibel) callconv(.C) SLresult),
    SetDecayTime: ?*const fn (SLEnvironmentalReverbItf, SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, SLmillisecond) callconv(.C) SLresult),
    GetDecayTime: ?*const fn (SLEnvironmentalReverbItf, [*c]SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, [*c]SLmillisecond) callconv(.C) SLresult),
    SetDecayHFRatio: ?*const fn (SLEnvironmentalReverbItf, SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, SLpermille) callconv(.C) SLresult),
    GetDecayHFRatio: ?*const fn (SLEnvironmentalReverbItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, [*c]SLpermille) callconv(.C) SLresult),
    SetReflectionsLevel: ?*const fn (SLEnvironmentalReverbItf, SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, SLmillibel) callconv(.C) SLresult),
    GetReflectionsLevel: ?*const fn (SLEnvironmentalReverbItf, [*c]SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, [*c]SLmillibel) callconv(.C) SLresult),
    SetReflectionsDelay: ?*const fn (SLEnvironmentalReverbItf, SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, SLmillisecond) callconv(.C) SLresult),
    GetReflectionsDelay: ?*const fn (SLEnvironmentalReverbItf, [*c]SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, [*c]SLmillisecond) callconv(.C) SLresult),
    SetReverbLevel: ?*const fn (SLEnvironmentalReverbItf, SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, SLmillibel) callconv(.C) SLresult),
    GetReverbLevel: ?*const fn (SLEnvironmentalReverbItf, [*c]SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, [*c]SLmillibel) callconv(.C) SLresult),
    SetReverbDelay: ?*const fn (SLEnvironmentalReverbItf, SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, SLmillisecond) callconv(.C) SLresult),
    GetReverbDelay: ?*const fn (SLEnvironmentalReverbItf, [*c]SLmillisecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, [*c]SLmillisecond) callconv(.C) SLresult),
    SetDiffusion: ?*const fn (SLEnvironmentalReverbItf, SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, SLpermille) callconv(.C) SLresult),
    GetDiffusion: ?*const fn (SLEnvironmentalReverbItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, [*c]SLpermille) callconv(.C) SLresult),
    SetDensity: ?*const fn (SLEnvironmentalReverbItf, SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, SLpermille) callconv(.C) SLresult),
    GetDensity: ?*const fn (SLEnvironmentalReverbItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, [*c]SLpermille) callconv(.C) SLresult),
    SetEnvironmentalReverbProperties: ?*const fn (SLEnvironmentalReverbItf, [*c]const SLEnvironmentalReverbSettings) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, [*c]const SLEnvironmentalReverbSettings) callconv(.C) SLresult),
    GetEnvironmentalReverbProperties: ?*const fn (SLEnvironmentalReverbItf, [*c]SLEnvironmentalReverbSettings) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEnvironmentalReverbItf, [*c]SLEnvironmentalReverbSettings) callconv(.C) SLresult),
};
pub extern const SL_IID_EFFECTSEND: SLInterfaceID;
pub const SLEffectSendItf = [*c]const [*c]const struct_SLEffectSendItf_;
pub const struct_SLEffectSendItf_ = extern struct {
    EnableEffectSend: ?*const fn (SLEffectSendItf, ?*const anyopaque, SLboolean, SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEffectSendItf, ?*const anyopaque, SLboolean, SLmillibel) callconv(.C) SLresult),
    IsEnabled: ?*const fn (SLEffectSendItf, ?*const anyopaque, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEffectSendItf, ?*const anyopaque, [*c]SLboolean) callconv(.C) SLresult),
    SetDirectLevel: ?*const fn (SLEffectSendItf, SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEffectSendItf, SLmillibel) callconv(.C) SLresult),
    GetDirectLevel: ?*const fn (SLEffectSendItf, [*c]SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEffectSendItf, [*c]SLmillibel) callconv(.C) SLresult),
    SetSendLevel: ?*const fn (SLEffectSendItf, ?*const anyopaque, SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEffectSendItf, ?*const anyopaque, SLmillibel) callconv(.C) SLresult),
    GetSendLevel: ?*const fn (SLEffectSendItf, ?*const anyopaque, [*c]SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEffectSendItf, ?*const anyopaque, [*c]SLmillibel) callconv(.C) SLresult),
};
pub extern const SL_IID_3DGROUPING: SLInterfaceID;
pub const SL3DGroupingItf = [*c]const [*c]const struct_SL3DGroupingItf_;
pub const struct_SL3DGroupingItf_ = extern struct {
    Set3DGroup: ?*const fn (SL3DGroupingItf, [*c]const [*c]const struct_SLObjectItf_) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DGroupingItf, [*c]const [*c]const struct_SLObjectItf_) callconv(.C) SLresult),
    Get3DGroup: ?*const fn (SL3DGroupingItf, [*c][*c]const [*c]const struct_SLObjectItf_) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DGroupingItf, [*c][*c]const [*c]const struct_SLObjectItf_) callconv(.C) SLresult),
};
pub extern const SL_IID_3DCOMMIT: SLInterfaceID;
pub const SL3DCommitItf = [*c]const [*c]const struct_SL3DCommitItf_;
pub const struct_SL3DCommitItf_ = extern struct {
    Commit: ?*const fn (SL3DCommitItf) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DCommitItf) callconv(.C) SLresult),
    SetDeferred: ?*const fn (SL3DCommitItf, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DCommitItf, SLboolean) callconv(.C) SLresult),
};
pub const struct_SLVec3D_ = extern struct {
    x: SLint32 = std.mem.zeroes(SLint32),
    y: SLint32 = std.mem.zeroes(SLint32),
    z: SLint32 = std.mem.zeroes(SLint32),
};
pub const SLVec3D = struct_SLVec3D_;
pub extern const SL_IID_3DLOCATION: SLInterfaceID;
pub const SL3DLocationItf = [*c]const [*c]const struct_SL3DLocationItf_;
pub const struct_SL3DLocationItf_ = extern struct {
    SetLocationCartesian: ?*const fn (SL3DLocationItf, [*c]const SLVec3D) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DLocationItf, [*c]const SLVec3D) callconv(.C) SLresult),
    SetLocationSpherical: ?*const fn (SL3DLocationItf, SLmillidegree, SLmillidegree, SLmillimeter) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DLocationItf, SLmillidegree, SLmillidegree, SLmillimeter) callconv(.C) SLresult),
    Move: ?*const fn (SL3DLocationItf, [*c]const SLVec3D) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DLocationItf, [*c]const SLVec3D) callconv(.C) SLresult),
    GetLocationCartesian: ?*const fn (SL3DLocationItf, [*c]SLVec3D) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DLocationItf, [*c]SLVec3D) callconv(.C) SLresult),
    SetOrientationVectors: ?*const fn (SL3DLocationItf, [*c]const SLVec3D, [*c]const SLVec3D) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DLocationItf, [*c]const SLVec3D, [*c]const SLVec3D) callconv(.C) SLresult),
    SetOrientationAngles: ?*const fn (SL3DLocationItf, SLmillidegree, SLmillidegree, SLmillidegree) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DLocationItf, SLmillidegree, SLmillidegree, SLmillidegree) callconv(.C) SLresult),
    Rotate: ?*const fn (SL3DLocationItf, SLmillidegree, [*c]const SLVec3D) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DLocationItf, SLmillidegree, [*c]const SLVec3D) callconv(.C) SLresult),
    GetOrientationVectors: ?*const fn (SL3DLocationItf, [*c]SLVec3D, [*c]SLVec3D) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DLocationItf, [*c]SLVec3D, [*c]SLVec3D) callconv(.C) SLresult),
};
pub extern const SL_IID_3DDOPPLER: SLInterfaceID;
pub const SL3DDopplerItf = [*c]const [*c]const struct_SL3DDopplerItf_;
pub const struct_SL3DDopplerItf_ = extern struct {
    SetVelocityCartesian: ?*const fn (SL3DDopplerItf, [*c]const SLVec3D) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DDopplerItf, [*c]const SLVec3D) callconv(.C) SLresult),
    SetVelocitySpherical: ?*const fn (SL3DDopplerItf, SLmillidegree, SLmillidegree, SLmillimeter) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DDopplerItf, SLmillidegree, SLmillidegree, SLmillimeter) callconv(.C) SLresult),
    GetVelocityCartesian: ?*const fn (SL3DDopplerItf, [*c]SLVec3D) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DDopplerItf, [*c]SLVec3D) callconv(.C) SLresult),
    SetDopplerFactor: ?*const fn (SL3DDopplerItf, SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DDopplerItf, SLpermille) callconv(.C) SLresult),
    GetDopplerFactor: ?*const fn (SL3DDopplerItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DDopplerItf, [*c]SLpermille) callconv(.C) SLresult),
};
pub extern const SL_IID_3DSOURCE: SLInterfaceID;
pub const SL3DSourceItf = [*c]const [*c]const struct_SL3DSourceItf_;
pub const struct_SL3DSourceItf_ = extern struct {
    SetHeadRelative: ?*const fn (SL3DSourceItf, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DSourceItf, SLboolean) callconv(.C) SLresult),
    GetHeadRelative: ?*const fn (SL3DSourceItf, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DSourceItf, [*c]SLboolean) callconv(.C) SLresult),
    SetRolloffDistances: ?*const fn (SL3DSourceItf, SLmillimeter, SLmillimeter) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DSourceItf, SLmillimeter, SLmillimeter) callconv(.C) SLresult),
    GetRolloffDistances: ?*const fn (SL3DSourceItf, [*c]SLmillimeter, [*c]SLmillimeter) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DSourceItf, [*c]SLmillimeter, [*c]SLmillimeter) callconv(.C) SLresult),
    SetRolloffMaxDistanceMute: ?*const fn (SL3DSourceItf, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DSourceItf, SLboolean) callconv(.C) SLresult),
    GetRolloffMaxDistanceMute: ?*const fn (SL3DSourceItf, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DSourceItf, [*c]SLboolean) callconv(.C) SLresult),
    SetRolloffFactor: ?*const fn (SL3DSourceItf, SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DSourceItf, SLpermille) callconv(.C) SLresult),
    GetRolloffFactor: ?*const fn (SL3DSourceItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DSourceItf, [*c]SLpermille) callconv(.C) SLresult),
    SetRoomRolloffFactor: ?*const fn (SL3DSourceItf, SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DSourceItf, SLpermille) callconv(.C) SLresult),
    GetRoomRolloffFactor: ?*const fn (SL3DSourceItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DSourceItf, [*c]SLpermille) callconv(.C) SLresult),
    SetRolloffModel: ?*const fn (SL3DSourceItf, SLuint8) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DSourceItf, SLuint8) callconv(.C) SLresult),
    GetRolloffModel: ?*const fn (SL3DSourceItf, [*c]SLuint8) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DSourceItf, [*c]SLuint8) callconv(.C) SLresult),
    SetCone: ?*const fn (SL3DSourceItf, SLmillidegree, SLmillidegree, SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DSourceItf, SLmillidegree, SLmillidegree, SLmillibel) callconv(.C) SLresult),
    GetCone: ?*const fn (SL3DSourceItf, [*c]SLmillidegree, [*c]SLmillidegree, [*c]SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DSourceItf, [*c]SLmillidegree, [*c]SLmillidegree, [*c]SLmillibel) callconv(.C) SLresult),
};
pub extern const SL_IID_3DMACROSCOPIC: SLInterfaceID;
pub const SL3DMacroscopicItf = [*c]const [*c]const struct_SL3DMacroscopicItf_;
pub const struct_SL3DMacroscopicItf_ = extern struct {
    SetSize: ?*const fn (SL3DMacroscopicItf, SLmillimeter, SLmillimeter, SLmillimeter) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DMacroscopicItf, SLmillimeter, SLmillimeter, SLmillimeter) callconv(.C) SLresult),
    GetSize: ?*const fn (SL3DMacroscopicItf, [*c]SLmillimeter, [*c]SLmillimeter, [*c]SLmillimeter) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DMacroscopicItf, [*c]SLmillimeter, [*c]SLmillimeter, [*c]SLmillimeter) callconv(.C) SLresult),
    SetOrientationAngles: ?*const fn (SL3DMacroscopicItf, SLmillidegree, SLmillidegree, SLmillidegree) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DMacroscopicItf, SLmillidegree, SLmillidegree, SLmillidegree) callconv(.C) SLresult),
    SetOrientationVectors: ?*const fn (SL3DMacroscopicItf, [*c]const SLVec3D, [*c]const SLVec3D) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DMacroscopicItf, [*c]const SLVec3D, [*c]const SLVec3D) callconv(.C) SLresult),
    Rotate: ?*const fn (SL3DMacroscopicItf, SLmillidegree, [*c]const SLVec3D) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DMacroscopicItf, SLmillidegree, [*c]const SLVec3D) callconv(.C) SLresult),
    GetOrientationVectors: ?*const fn (SL3DMacroscopicItf, [*c]SLVec3D, [*c]SLVec3D) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SL3DMacroscopicItf, [*c]SLVec3D, [*c]SLVec3D) callconv(.C) SLresult),
};
pub extern const SL_IID_MUTESOLO: SLInterfaceID;
pub const SLMuteSoloItf = [*c]const [*c]const struct_SLMuteSoloItf_;
pub const struct_SLMuteSoloItf_ = extern struct {
    SetChannelMute: ?*const fn (SLMuteSoloItf, SLuint8, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMuteSoloItf, SLuint8, SLboolean) callconv(.C) SLresult),
    GetChannelMute: ?*const fn (SLMuteSoloItf, SLuint8, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMuteSoloItf, SLuint8, [*c]SLboolean) callconv(.C) SLresult),
    SetChannelSolo: ?*const fn (SLMuteSoloItf, SLuint8, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMuteSoloItf, SLuint8, SLboolean) callconv(.C) SLresult),
    GetChannelSolo: ?*const fn (SLMuteSoloItf, SLuint8, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMuteSoloItf, SLuint8, [*c]SLboolean) callconv(.C) SLresult),
    GetNumChannels: ?*const fn (SLMuteSoloItf, [*c]SLuint8) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMuteSoloItf, [*c]SLuint8) callconv(.C) SLresult),
};
pub extern const SL_IID_DYNAMICINTERFACEMANAGEMENT: SLInterfaceID;
pub const SLDynamicInterfaceManagementItf = [*c]const [*c]const struct_SLDynamicInterfaceManagementItf_;
pub const slDynamicInterfaceManagementCallback = ?*const fn (SLDynamicInterfaceManagementItf, ?*anyopaque, SLuint32, SLresult, SLInterfaceID) callconv(.C) void;
pub const struct_SLDynamicInterfaceManagementItf_ = extern struct {
    AddInterface: ?*const fn (SLDynamicInterfaceManagementItf, SLInterfaceID, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLDynamicInterfaceManagementItf, SLInterfaceID, SLboolean) callconv(.C) SLresult),
    RemoveInterface: ?*const fn (SLDynamicInterfaceManagementItf, SLInterfaceID) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLDynamicInterfaceManagementItf, SLInterfaceID) callconv(.C) SLresult),
    ResumeInterface: ?*const fn (SLDynamicInterfaceManagementItf, SLInterfaceID, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLDynamicInterfaceManagementItf, SLInterfaceID, SLboolean) callconv(.C) SLresult),
    RegisterCallback: ?*const fn (SLDynamicInterfaceManagementItf, slDynamicInterfaceManagementCallback, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLDynamicInterfaceManagementItf, slDynamicInterfaceManagementCallback, ?*anyopaque) callconv(.C) SLresult),
};
pub extern const SL_IID_MIDIMESSAGE: SLInterfaceID;
pub const SLMIDIMessageItf = [*c]const [*c]const struct_SLMIDIMessageItf_;
pub const slMetaEventCallback = ?*const fn (SLMIDIMessageItf, ?*anyopaque, SLuint8, SLuint32, [*c]const SLuint8, SLuint32, SLuint16) callconv(.C) void;
pub const slMIDIMessageCallback = ?*const fn (SLMIDIMessageItf, ?*anyopaque, SLuint8, SLuint32, [*c]const SLuint8, SLuint32, SLuint16) callconv(.C) void;
pub const struct_SLMIDIMessageItf_ = extern struct {
    SendMessage: ?*const fn (SLMIDIMessageItf, [*c]const SLuint8, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDIMessageItf, [*c]const SLuint8, SLuint32) callconv(.C) SLresult),
    RegisterMetaEventCallback: ?*const fn (SLMIDIMessageItf, slMetaEventCallback, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDIMessageItf, slMetaEventCallback, ?*anyopaque) callconv(.C) SLresult),
    RegisterMIDIMessageCallback: ?*const fn (SLMIDIMessageItf, slMIDIMessageCallback, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDIMessageItf, slMIDIMessageCallback, ?*anyopaque) callconv(.C) SLresult),
    AddMIDIMessageCallbackFilter: ?*const fn (SLMIDIMessageItf, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDIMessageItf, SLuint32) callconv(.C) SLresult),
    ClearMIDIMessageCallbackFilter: ?*const fn (SLMIDIMessageItf) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDIMessageItf) callconv(.C) SLresult),
};
pub extern const SL_IID_MIDIMUTESOLO: SLInterfaceID;
pub const SLMIDIMuteSoloItf = [*c]const [*c]const struct_SLMIDIMuteSoloItf_;
pub const struct_SLMIDIMuteSoloItf_ = extern struct {
    SetChannelMute: ?*const fn (SLMIDIMuteSoloItf, SLuint8, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDIMuteSoloItf, SLuint8, SLboolean) callconv(.C) SLresult),
    GetChannelMute: ?*const fn (SLMIDIMuteSoloItf, SLuint8, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDIMuteSoloItf, SLuint8, [*c]SLboolean) callconv(.C) SLresult),
    SetChannelSolo: ?*const fn (SLMIDIMuteSoloItf, SLuint8, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDIMuteSoloItf, SLuint8, SLboolean) callconv(.C) SLresult),
    GetChannelSolo: ?*const fn (SLMIDIMuteSoloItf, SLuint8, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDIMuteSoloItf, SLuint8, [*c]SLboolean) callconv(.C) SLresult),
    GetTrackCount: ?*const fn (SLMIDIMuteSoloItf, [*c]SLuint16) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDIMuteSoloItf, [*c]SLuint16) callconv(.C) SLresult),
    SetTrackMute: ?*const fn (SLMIDIMuteSoloItf, SLuint16, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDIMuteSoloItf, SLuint16, SLboolean) callconv(.C) SLresult),
    GetTrackMute: ?*const fn (SLMIDIMuteSoloItf, SLuint16, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDIMuteSoloItf, SLuint16, [*c]SLboolean) callconv(.C) SLresult),
    SetTrackSolo: ?*const fn (SLMIDIMuteSoloItf, SLuint16, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDIMuteSoloItf, SLuint16, SLboolean) callconv(.C) SLresult),
    GetTrackSolo: ?*const fn (SLMIDIMuteSoloItf, SLuint16, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDIMuteSoloItf, SLuint16, [*c]SLboolean) callconv(.C) SLresult),
};
pub extern const SL_IID_MIDITEMPO: SLInterfaceID;
pub const SLMIDITempoItf = [*c]const [*c]const struct_SLMIDITempoItf_;
pub const struct_SLMIDITempoItf_ = extern struct {
    SetTicksPerQuarterNote: ?*const fn (SLMIDITempoItf, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDITempoItf, SLuint32) callconv(.C) SLresult),
    GetTicksPerQuarterNote: ?*const fn (SLMIDITempoItf, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDITempoItf, [*c]SLuint32) callconv(.C) SLresult),
    SetMicrosecondsPerQuarterNote: ?*const fn (SLMIDITempoItf, SLmicrosecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDITempoItf, SLmicrosecond) callconv(.C) SLresult),
    GetMicrosecondsPerQuarterNote: ?*const fn (SLMIDITempoItf, [*c]SLmicrosecond) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDITempoItf, [*c]SLmicrosecond) callconv(.C) SLresult),
};
pub extern const SL_IID_MIDITIME: SLInterfaceID;
pub const SLMIDITimeItf = [*c]const [*c]const struct_SLMIDITimeItf_;
pub const struct_SLMIDITimeItf_ = extern struct {
    GetDuration: ?*const fn (SLMIDITimeItf, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDITimeItf, [*c]SLuint32) callconv(.C) SLresult),
    SetPosition: ?*const fn (SLMIDITimeItf, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDITimeItf, SLuint32) callconv(.C) SLresult),
    GetPosition: ?*const fn (SLMIDITimeItf, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDITimeItf, [*c]SLuint32) callconv(.C) SLresult),
    SetLoopPoints: ?*const fn (SLMIDITimeItf, SLuint32, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDITimeItf, SLuint32, SLuint32) callconv(.C) SLresult),
    GetLoopPoints: ?*const fn (SLMIDITimeItf, [*c]SLuint32, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLMIDITimeItf, [*c]SLuint32, [*c]SLuint32) callconv(.C) SLresult),
};
pub const struct_SLAudioCodecDescriptor_ = extern struct {
    maxChannels: SLuint32 = std.mem.zeroes(SLuint32),
    minBitsPerSample: SLuint32 = std.mem.zeroes(SLuint32),
    maxBitsPerSample: SLuint32 = std.mem.zeroes(SLuint32),
    minSampleRate: SLmilliHertz = std.mem.zeroes(SLmilliHertz),
    maxSampleRate: SLmilliHertz = std.mem.zeroes(SLmilliHertz),
    isFreqRangeContinuous: SLboolean = std.mem.zeroes(SLboolean),
    pSampleRatesSupported: [*c]SLmilliHertz = std.mem.zeroes([*c]SLmilliHertz),
    numSampleRatesSupported: SLuint32 = std.mem.zeroes(SLuint32),
    minBitRate: SLuint32 = std.mem.zeroes(SLuint32),
    maxBitRate: SLuint32 = std.mem.zeroes(SLuint32),
    isBitrateRangeContinuous: SLboolean = std.mem.zeroes(SLboolean),
    pBitratesSupported: [*c]SLuint32 = std.mem.zeroes([*c]SLuint32),
    numBitratesSupported: SLuint32 = std.mem.zeroes(SLuint32),
    profileSetting: SLuint32 = std.mem.zeroes(SLuint32),
    modeSetting: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLAudioCodecDescriptor = struct_SLAudioCodecDescriptor_;
pub const struct_SLAudioCodecProfileMode_ = extern struct {
    profileSetting: SLuint32 = std.mem.zeroes(SLuint32),
    modeSetting: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLAudioCodecProfileMode = struct_SLAudioCodecProfileMode_;
pub extern const SL_IID_AUDIODECODERCAPABILITIES: SLInterfaceID;
pub const SLAudioDecoderCapabilitiesItf = [*c]const [*c]const struct_SLAudioDecoderCapabilitiesItf_;
pub const struct_SLAudioDecoderCapabilitiesItf_ = extern struct {
    GetAudioDecoders: ?*const fn (SLAudioDecoderCapabilitiesItf, [*c]SLuint32, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioDecoderCapabilitiesItf, [*c]SLuint32, [*c]SLuint32) callconv(.C) SLresult),
    GetAudioDecoderCapabilities: ?*const fn (SLAudioDecoderCapabilitiesItf, SLuint32, [*c]SLuint32, [*c]SLAudioCodecDescriptor) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioDecoderCapabilitiesItf, SLuint32, [*c]SLuint32, [*c]SLAudioCodecDescriptor) callconv(.C) SLresult),
};
pub const struct_SLAudioEncoderSettings_ = extern struct {
    encoderId: SLuint32 = std.mem.zeroes(SLuint32),
    channelsIn: SLuint32 = std.mem.zeroes(SLuint32),
    channelsOut: SLuint32 = std.mem.zeroes(SLuint32),
    sampleRate: SLmilliHertz = std.mem.zeroes(SLmilliHertz),
    bitRate: SLuint32 = std.mem.zeroes(SLuint32),
    bitsPerSample: SLuint32 = std.mem.zeroes(SLuint32),
    rateControl: SLuint32 = std.mem.zeroes(SLuint32),
    profileSetting: SLuint32 = std.mem.zeroes(SLuint32),
    levelSetting: SLuint32 = std.mem.zeroes(SLuint32),
    channelMode: SLuint32 = std.mem.zeroes(SLuint32),
    streamFormat: SLuint32 = std.mem.zeroes(SLuint32),
    encodeOptions: SLuint32 = std.mem.zeroes(SLuint32),
    blockAlignment: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLAudioEncoderSettings = struct_SLAudioEncoderSettings_;
pub extern const SL_IID_AUDIOENCODERCAPABILITIES: SLInterfaceID;
pub const SLAudioEncoderCapabilitiesItf = [*c]const [*c]const struct_SLAudioEncoderCapabilitiesItf_;
pub const struct_SLAudioEncoderCapabilitiesItf_ = extern struct {
    GetAudioEncoders: ?*const fn (SLAudioEncoderCapabilitiesItf, [*c]SLuint32, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioEncoderCapabilitiesItf, [*c]SLuint32, [*c]SLuint32) callconv(.C) SLresult),
    GetAudioEncoderCapabilities: ?*const fn (SLAudioEncoderCapabilitiesItf, SLuint32, [*c]SLuint32, [*c]SLAudioCodecDescriptor) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioEncoderCapabilitiesItf, SLuint32, [*c]SLuint32, [*c]SLAudioCodecDescriptor) callconv(.C) SLresult),
};
pub extern const SL_IID_AUDIOENCODER: SLInterfaceID;
pub const SLAudioEncoderItf = [*c]const [*c]const struct_SLAudioEncoderItf_;
pub const struct_SLAudioEncoderItf_ = extern struct {
    SetEncoderSettings: ?*const fn (SLAudioEncoderItf, [*c]SLAudioEncoderSettings) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioEncoderItf, [*c]SLAudioEncoderSettings) callconv(.C) SLresult),
    GetEncoderSettings: ?*const fn (SLAudioEncoderItf, [*c]SLAudioEncoderSettings) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAudioEncoderItf, [*c]SLAudioEncoderSettings) callconv(.C) SLresult),
};
pub extern const SL_IID_BASSBOOST: SLInterfaceID;
pub const SLBassBoostItf = [*c]const [*c]const struct_SLBassBoostItf_;
pub const struct_SLBassBoostItf_ = extern struct {
    SetEnabled: ?*const fn (SLBassBoostItf, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLBassBoostItf, SLboolean) callconv(.C) SLresult),
    IsEnabled: ?*const fn (SLBassBoostItf, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLBassBoostItf, [*c]SLboolean) callconv(.C) SLresult),
    SetStrength: ?*const fn (SLBassBoostItf, SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLBassBoostItf, SLpermille) callconv(.C) SLresult),
    GetRoundedStrength: ?*const fn (SLBassBoostItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLBassBoostItf, [*c]SLpermille) callconv(.C) SLresult),
    IsStrengthSupported: ?*const fn (SLBassBoostItf, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLBassBoostItf, [*c]SLboolean) callconv(.C) SLresult),
};
pub extern const SL_IID_PITCH: SLInterfaceID;
pub const SLPitchItf = [*c]const [*c]const struct_SLPitchItf_;
pub const struct_SLPitchItf_ = extern struct {
    SetPitch: ?*const fn (SLPitchItf, SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPitchItf, SLpermille) callconv(.C) SLresult),
    GetPitch: ?*const fn (SLPitchItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPitchItf, [*c]SLpermille) callconv(.C) SLresult),
    GetPitchCapabilities: ?*const fn (SLPitchItf, [*c]SLpermille, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLPitchItf, [*c]SLpermille, [*c]SLpermille) callconv(.C) SLresult),
};
pub extern const SL_IID_RATEPITCH: SLInterfaceID;
pub const SLRatePitchItf = [*c]const [*c]const struct_SLRatePitchItf_;
pub const struct_SLRatePitchItf_ = extern struct {
    SetRate: ?*const fn (SLRatePitchItf, SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRatePitchItf, SLpermille) callconv(.C) SLresult),
    GetRate: ?*const fn (SLRatePitchItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRatePitchItf, [*c]SLpermille) callconv(.C) SLresult),
    GetRatePitchCapabilities: ?*const fn (SLRatePitchItf, [*c]SLpermille, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLRatePitchItf, [*c]SLpermille, [*c]SLpermille) callconv(.C) SLresult),
};
pub extern const SL_IID_VIRTUALIZER: SLInterfaceID;
pub const SLVirtualizerItf = [*c]const [*c]const struct_SLVirtualizerItf_;
pub const struct_SLVirtualizerItf_ = extern struct {
    SetEnabled: ?*const fn (SLVirtualizerItf, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVirtualizerItf, SLboolean) callconv(.C) SLresult),
    IsEnabled: ?*const fn (SLVirtualizerItf, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVirtualizerItf, [*c]SLboolean) callconv(.C) SLresult),
    SetStrength: ?*const fn (SLVirtualizerItf, SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVirtualizerItf, SLpermille) callconv(.C) SLresult),
    GetRoundedStrength: ?*const fn (SLVirtualizerItf, [*c]SLpermille) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVirtualizerItf, [*c]SLpermille) callconv(.C) SLresult),
    IsStrengthSupported: ?*const fn (SLVirtualizerItf, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVirtualizerItf, [*c]SLboolean) callconv(.C) SLresult),
};
pub extern const SL_IID_VISUALIZATION: SLInterfaceID;
pub const SLVisualizationItf = [*c]const [*c]const struct_SLVisualizationItf_;
pub const slVisualizationCallback = ?*const fn (?*anyopaque, [*c]const SLuint8, [*c]const SLuint8, SLmilliHertz) callconv(.C) void;
pub const struct_SLVisualizationItf_ = extern struct {
    RegisterVisualizationCallback: ?*const fn (SLVisualizationItf, slVisualizationCallback, ?*anyopaque, SLmilliHertz) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVisualizationItf, slVisualizationCallback, ?*anyopaque, SLmilliHertz) callconv(.C) SLresult),
    GetMaxRate: ?*const fn (SLVisualizationItf, [*c]SLmilliHertz) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLVisualizationItf, [*c]SLmilliHertz) callconv(.C) SLresult),
};
pub extern const SL_IID_ENGINE: SLInterfaceID;
pub const SLEngineItf = [*c]const [*c]const struct_SLEngineItf_;
pub const struct_SLEngineItf_ = extern struct {
    CreateLEDDevice: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, SLuint32, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, SLuint32, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult),
    CreateVibraDevice: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, SLuint32, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, SLuint32, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult),
    CreateAudioPlayer: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, [*c]SLDataSource, [*c]SLDataSink, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, [*c]SLDataSource, [*c]SLDataSink, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult),
    CreateAudioRecorder: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, [*c]SLDataSource, [*c]SLDataSink, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, [*c]SLDataSource, [*c]SLDataSink, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult),
    CreateMidiPlayer: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, [*c]SLDataSource, [*c]SLDataSource, [*c]SLDataSink, [*c]SLDataSink, [*c]SLDataSink, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, [*c]SLDataSource, [*c]SLDataSource, [*c]SLDataSink, [*c]SLDataSink, [*c]SLDataSink, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult),
    CreateListener: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult),
    Create3DGroup: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult),
    CreateOutputMix: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult),
    CreateMetadataExtractor: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, [*c]SLDataSource, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, [*c]SLDataSource, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult),
    CreateExtensionObject: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, ?*anyopaque, SLuint32, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c][*c]const [*c]const struct_SLObjectItf_, ?*anyopaque, SLuint32, SLuint32, [*c]const SLInterfaceID, [*c]const SLboolean) callconv(.C) SLresult),
    QueryNumSupportedInterfaces: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, SLuint32, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, SLuint32, [*c]SLuint32) callconv(.C) SLresult),
    QuerySupportedInterfaces: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, SLuint32, SLuint32, [*c]SLInterfaceID) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, SLuint32, SLuint32, [*c]SLInterfaceID) callconv(.C) SLresult),
    QueryNumSupportedExtensions: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c]SLuint32) callconv(.C) SLresult),
    QuerySupportedExtension: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, SLuint32, [*c]SLchar, [*c]SLint16) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, SLuint32, [*c]SLchar, [*c]SLint16) callconv(.C) SLresult),
    IsExtensionSupported: ?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c]const SLchar, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLEngineItf_, [*c]const SLchar, [*c]SLboolean) callconv(.C) SLresult),
};
pub extern const SL_IID_ENGINECAPABILITIES: SLInterfaceID;
pub const SLEngineCapabilitiesItf = [*c]const [*c]const struct_SLEngineCapabilitiesItf_;
pub const struct_SLEngineCapabilitiesItf_ = extern struct {
    QuerySupportedProfiles: ?*const fn (SLEngineCapabilitiesItf, [*c]SLuint16) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEngineCapabilitiesItf, [*c]SLuint16) callconv(.C) SLresult),
    QueryAvailableVoices: ?*const fn (SLEngineCapabilitiesItf, SLuint16, [*c]SLint16, [*c]SLboolean, [*c]SLint16) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEngineCapabilitiesItf, SLuint16, [*c]SLint16, [*c]SLboolean, [*c]SLint16) callconv(.C) SLresult),
    QueryNumberOfMIDISynthesizers: ?*const fn (SLEngineCapabilitiesItf, [*c]SLint16) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEngineCapabilitiesItf, [*c]SLint16) callconv(.C) SLresult),
    QueryAPIVersion: ?*const fn (SLEngineCapabilitiesItf, [*c]SLint16, [*c]SLint16, [*c]SLint16) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEngineCapabilitiesItf, [*c]SLint16, [*c]SLint16, [*c]SLint16) callconv(.C) SLresult),
    QueryLEDCapabilities: ?*const fn (SLEngineCapabilitiesItf, [*c]SLuint32, [*c]SLuint32, [*c]SLLEDDescriptor) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEngineCapabilitiesItf, [*c]SLuint32, [*c]SLuint32, [*c]SLLEDDescriptor) callconv(.C) SLresult),
    QueryVibraCapabilities: ?*const fn (SLEngineCapabilitiesItf, [*c]SLuint32, [*c]SLuint32, [*c]SLVibraDescriptor) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEngineCapabilitiesItf, [*c]SLuint32, [*c]SLuint32, [*c]SLVibraDescriptor) callconv(.C) SLresult),
    IsThreadSafe: ?*const fn (SLEngineCapabilitiesItf, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLEngineCapabilitiesItf, [*c]SLboolean) callconv(.C) SLresult),
};
pub extern const SL_IID_THREADSYNC: SLInterfaceID;
pub const SLThreadSyncItf = [*c]const [*c]const struct_SLThreadSyncItf_;
pub const struct_SLThreadSyncItf_ = extern struct {
    EnterCriticalSection: ?*const fn (SLThreadSyncItf) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLThreadSyncItf) callconv(.C) SLresult),
    ExitCriticalSection: ?*const fn (SLThreadSyncItf) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLThreadSyncItf) callconv(.C) SLresult),
};
pub const struct_SLEngineOption_ = extern struct {
    feature: SLuint32 = std.mem.zeroes(SLuint32),
    data: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLEngineOption = struct_SLEngineOption_;
pub extern fn slCreateEngine(pEngine: [*c][*c]const [*c]const struct_SLObjectItf_, numOptions: SLuint32, pEngineOptions: [*c]const SLEngineOption, numInterfaces: SLuint32, pInterfaceIds: [*c]const SLInterfaceID, pInterfaceRequired: [*c]const SLboolean) SLresult;
pub extern fn slQueryNumSupportedEngineInterfaces(pNumSupportedInterfaces: [*c]SLuint32) SLresult;
pub extern fn slQuerySupportedEngineInterfaces(index: SLuint32, pInterfaceId: [*c]SLInterfaceID) SLresult;
pub const __builtin_va_list = [*c]u8;
pub const __gnuc_va_list = __builtin_va_list;
pub const va_list = __builtin_va_list;
pub extern fn android_get_application_target_sdk_version(...) c_int;
pub extern fn android_get_device_api_level(...) c_int;
pub const ptrdiff_t = c_longlong;
pub const wchar_t = c_ushort;
pub const max_align_t = extern struct {
    __clang_max_align_nonce1: c_longlong align(8) = std.mem.zeroes(c_longlong),
    __clang_max_align_nonce2: c_longdouble align(16) = std.mem.zeroes(c_longdouble),
};
pub const __int8_t = i8;
pub const __uint8_t = u8;
pub const __int16_t = c_short;
pub const __uint16_t = c_ushort;
pub const __int32_t = c_int;
pub const __uint32_t = c_uint;
pub const __int64_t = c_longlong;
pub const __uint64_t = c_ulonglong;
pub const __intptr_t = c_int;
pub const __uintptr_t = c_uint;
pub const int_least8_t = i8;
pub const uint_least8_t = u8;
pub const int_least16_t = i16;
pub const uint_least16_t = u16;
pub const int_least32_t = i32;
pub const uint_least32_t = u32;
pub const int_least64_t = i64;
pub const uint_least64_t = u64;
pub const int_fast8_t = i8;
pub const uint_fast8_t = u8;
pub const int_fast64_t = i64;
pub const uint_fast64_t = u64;
pub const int_fast16_t = i32;
pub const uint_fast16_t = u32;
pub const int_fast32_t = i32;
pub const uint_fast32_t = u32;
pub const uintmax_t = u64;
pub const intmax_t = i64;
pub const jboolean = u8;
pub const jbyte = i8;
pub const jchar = u16;
pub const jshort = i16;
pub const jint = i32;
pub const jlong = i64;
pub const jfloat = f32;
pub const jdouble = f64;
pub const jsize = jint;
pub const jobject = ?*anyopaque;
pub const jclass = jobject;
pub const jstring = jobject;
pub const jarray = jobject;
pub const jobjectArray = jarray;
pub const jbooleanArray = jarray;
pub const jbyteArray = jarray;
pub const jcharArray = jarray;
pub const jshortArray = jarray;
pub const jintArray = jarray;
pub const jlongArray = jarray;
pub const jfloatArray = jarray;
pub const jdoubleArray = jarray;
pub const jthrowable = jobject;
pub const jweak = jobject;
pub const struct__jfieldID = opaque {};
pub const jfieldID = ?*struct__jfieldID;
pub const struct__jmethodID = opaque {};
pub const jmethodID = ?*struct__jmethodID;
pub const JavaVM = [*c]const struct_JNIInvokeInterface;
pub const union_jvalue = extern union {
    z: jboolean,
    b: jbyte,
    c: jchar,
    s: jshort,
    i: jint,
    j: jlong,
    f: jfloat,
    d: jdouble,
    l: jobject,
};
pub const jvalue = union_jvalue;
pub const JNIInvalidRefType: c_int = 0;
pub const JNILocalRefType: c_int = 1;
pub const JNIGlobalRefType: c_int = 2;
pub const JNIWeakGlobalRefType: c_int = 3;
pub const enum_jobjectRefType = c_uint;
pub const jobjectRefType = enum_jobjectRefType;
pub const struct_JNINativeInterface = extern struct {
    reserved0: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    reserved1: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    reserved2: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    reserved3: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    GetVersion: ?*const fn ([*c]JNIEnv) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) jint),
    DefineClass: ?*const fn ([*c]JNIEnv, [*c]const u8, jobject, [*c]const jbyte, jsize) callconv(.C) jclass = std.mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const u8, jobject, [*c]const jbyte, jsize) callconv(.C) jclass),
    FindClass: ?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) jclass = std.mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) jclass),
    FromReflectedMethod: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jmethodID = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jmethodID),
    FromReflectedField: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jfieldID = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jfieldID),
    ToReflectedMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, jboolean) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, jboolean) callconv(.C) jobject),
    GetSuperclass: ?*const fn ([*c]JNIEnv, jclass) callconv(.C) jclass = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass) callconv(.C) jclass),
    IsAssignableFrom: ?*const fn ([*c]JNIEnv, jclass, jclass) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jclass) callconv(.C) jboolean),
    ToReflectedField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jboolean) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jboolean) callconv(.C) jobject),
    Throw: ?*const fn ([*c]JNIEnv, jthrowable) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jthrowable) callconv(.C) jint),
    ThrowNew: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8) callconv(.C) jint),
    ExceptionOccurred: ?*const fn ([*c]JNIEnv) callconv(.C) jthrowable = std.mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) jthrowable),
    ExceptionDescribe: ?*const fn ([*c]JNIEnv) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) void),
    ExceptionClear: ?*const fn ([*c]JNIEnv) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) void),
    FatalError: ?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) void),
    PushLocalFrame: ?*const fn ([*c]JNIEnv, jint) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jint) callconv(.C) jint),
    PopLocalFrame: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject),
    NewGlobalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject),
    DeleteGlobalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) void),
    DeleteLocalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) void),
    IsSameObject: ?*const fn ([*c]JNIEnv, jobject, jobject) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jobject) callconv(.C) jboolean),
    NewLocalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject),
    EnsureLocalCapacity: ?*const fn ([*c]JNIEnv, jint) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jint) callconv(.C) jint),
    AllocObject: ?*const fn ([*c]JNIEnv, jclass) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass) callconv(.C) jobject),
    NewObject: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jobject),
    NewObjectV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jobject),
    NewObjectA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject),
    GetObjectClass: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jclass = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jclass),
    IsInstanceOf: ?*const fn ([*c]JNIEnv, jobject, jclass) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass) callconv(.C) jboolean),
    GetMethodID: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jmethodID = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jmethodID),
    CallObjectMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jobject),
    CallObjectMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jobject),
    CallObjectMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jobject),
    CallBooleanMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jboolean),
    CallBooleanMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jboolean),
    CallBooleanMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jboolean),
    CallByteMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jbyte = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jbyte),
    CallByteMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jbyte = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jbyte),
    CallByteMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jbyte = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jbyte),
    CallCharMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jchar = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jchar),
    CallCharMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jchar = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jchar),
    CallCharMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jchar = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jchar),
    CallShortMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jshort = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jshort),
    CallShortMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jshort = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jshort),
    CallShortMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jshort = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jshort),
    CallIntMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jint),
    CallIntMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jint),
    CallIntMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jint),
    CallLongMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jlong = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jlong),
    CallLongMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jlong = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jlong),
    CallLongMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jlong = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jlong),
    CallFloatMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jfloat = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jfloat),
    CallFloatMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jfloat = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jfloat),
    CallFloatMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jfloat = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jfloat),
    CallDoubleMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jdouble = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jdouble),
    CallDoubleMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jdouble = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jdouble),
    CallDoubleMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jdouble = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jdouble),
    CallVoidMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) void),
    CallVoidMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) void),
    CallVoidMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) void),
    CallNonvirtualObjectMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jobject),
    CallNonvirtualObjectMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jobject),
    CallNonvirtualObjectMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject),
    CallNonvirtualBooleanMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jboolean),
    CallNonvirtualBooleanMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jboolean),
    CallNonvirtualBooleanMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jboolean),
    CallNonvirtualByteMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jbyte = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jbyte),
    CallNonvirtualByteMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jbyte = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jbyte),
    CallNonvirtualByteMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jbyte = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jbyte),
    CallNonvirtualCharMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jchar = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jchar),
    CallNonvirtualCharMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jchar = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jchar),
    CallNonvirtualCharMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jchar = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jchar),
    CallNonvirtualShortMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jshort = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jshort),
    CallNonvirtualShortMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jshort = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jshort),
    CallNonvirtualShortMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jshort = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jshort),
    CallNonvirtualIntMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jint),
    CallNonvirtualIntMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jint),
    CallNonvirtualIntMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jint),
    CallNonvirtualLongMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jlong = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jlong),
    CallNonvirtualLongMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jlong = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jlong),
    CallNonvirtualLongMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jlong = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jlong),
    CallNonvirtualFloatMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jfloat = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jfloat),
    CallNonvirtualFloatMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jfloat = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jfloat),
    CallNonvirtualFloatMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jfloat = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jfloat),
    CallNonvirtualDoubleMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jdouble = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jdouble),
    CallNonvirtualDoubleMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jdouble = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jdouble),
    CallNonvirtualDoubleMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jdouble = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jdouble),
    CallNonvirtualVoidMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) void),
    CallNonvirtualVoidMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) void),
    CallNonvirtualVoidMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) void),
    GetFieldID: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jfieldID = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jfieldID),
    GetObjectField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jobject),
    GetBooleanField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jboolean),
    GetByteField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jbyte = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jbyte),
    GetCharField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jchar = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jchar),
    GetShortField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jshort = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jshort),
    GetIntField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jint),
    GetLongField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jlong = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jlong),
    GetFloatField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jfloat = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jfloat),
    GetDoubleField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jdouble = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jdouble),
    SetObjectField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jobject) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jobject) callconv(.C) void),
    SetBooleanField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jboolean) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jboolean) callconv(.C) void),
    SetByteField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jbyte) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jbyte) callconv(.C) void),
    SetCharField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jchar) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jchar) callconv(.C) void),
    SetShortField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jshort) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jshort) callconv(.C) void),
    SetIntField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jint) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jint) callconv(.C) void),
    SetLongField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jlong) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jlong) callconv(.C) void),
    SetFloatField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jfloat) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jfloat) callconv(.C) void),
    SetDoubleField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jdouble) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jdouble) callconv(.C) void),
    GetStaticMethodID: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jmethodID = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jmethodID),
    CallStaticObjectMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jobject),
    CallStaticObjectMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jobject),
    CallStaticObjectMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject),
    CallStaticBooleanMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jboolean),
    CallStaticBooleanMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jboolean),
    CallStaticBooleanMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jboolean),
    CallStaticByteMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jbyte = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jbyte),
    CallStaticByteMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jbyte = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jbyte),
    CallStaticByteMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jbyte = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jbyte),
    CallStaticCharMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jchar = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jchar),
    CallStaticCharMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jchar = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jchar),
    CallStaticCharMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jchar = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jchar),
    CallStaticShortMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jshort = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jshort),
    CallStaticShortMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jshort = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jshort),
    CallStaticShortMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jshort = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jshort),
    CallStaticIntMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jint),
    CallStaticIntMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jint),
    CallStaticIntMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jint),
    CallStaticLongMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jlong = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jlong),
    CallStaticLongMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jlong = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jlong),
    CallStaticLongMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jlong = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jlong),
    CallStaticFloatMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jfloat = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jfloat),
    CallStaticFloatMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jfloat = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jfloat),
    CallStaticFloatMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jfloat = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jfloat),
    CallStaticDoubleMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jdouble = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jdouble),
    CallStaticDoubleMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jdouble = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jdouble),
    CallStaticDoubleMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jdouble = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jdouble),
    CallStaticVoidMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) void),
    CallStaticVoidMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) void),
    CallStaticVoidMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) void),
    GetStaticFieldID: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jfieldID = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jfieldID),
    GetStaticObjectField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jobject),
    GetStaticBooleanField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jboolean),
    GetStaticByteField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jbyte = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jbyte),
    GetStaticCharField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jchar = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jchar),
    GetStaticShortField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jshort = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jshort),
    GetStaticIntField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jint),
    GetStaticLongField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jlong = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jlong),
    GetStaticFloatField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jfloat = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jfloat),
    GetStaticDoubleField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jdouble = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jdouble),
    SetStaticObjectField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jobject) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jobject) callconv(.C) void),
    SetStaticBooleanField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jboolean) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jboolean) callconv(.C) void),
    SetStaticByteField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jbyte) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jbyte) callconv(.C) void),
    SetStaticCharField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jchar) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jchar) callconv(.C) void),
    SetStaticShortField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jshort) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jshort) callconv(.C) void),
    SetStaticIntField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jint) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jint) callconv(.C) void),
    SetStaticLongField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jlong) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jlong) callconv(.C) void),
    SetStaticFloatField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jfloat) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jfloat) callconv(.C) void),
    SetStaticDoubleField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jdouble) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jdouble) callconv(.C) void),
    NewString: ?*const fn ([*c]JNIEnv, [*c]const jchar, jsize) callconv(.C) jstring = std.mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const jchar, jsize) callconv(.C) jstring),
    GetStringLength: ?*const fn ([*c]JNIEnv, jstring) callconv(.C) jsize = std.mem.zeroes(?*const fn ([*c]JNIEnv, jstring) callconv(.C) jsize),
    GetStringChars: ?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const jchar = std.mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const jchar),
    ReleaseStringChars: ?*const fn ([*c]JNIEnv, jstring, [*c]const jchar) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]const jchar) callconv(.C) void),
    NewStringUTF: ?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) jstring = std.mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) jstring),
    GetStringUTFLength: ?*const fn ([*c]JNIEnv, jstring) callconv(.C) jsize = std.mem.zeroes(?*const fn ([*c]JNIEnv, jstring) callconv(.C) jsize),
    GetStringUTFChars: ?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const u8 = std.mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const u8),
    ReleaseStringUTFChars: ?*const fn ([*c]JNIEnv, jstring, [*c]const u8) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]const u8) callconv(.C) void),
    GetArrayLength: ?*const fn ([*c]JNIEnv, jarray) callconv(.C) jsize = std.mem.zeroes(?*const fn ([*c]JNIEnv, jarray) callconv(.C) jsize),
    NewObjectArray: ?*const fn ([*c]JNIEnv, jsize, jclass, jobject) callconv(.C) jobjectArray = std.mem.zeroes(?*const fn ([*c]JNIEnv, jsize, jclass, jobject) callconv(.C) jobjectArray),
    GetObjectArrayElement: ?*const fn ([*c]JNIEnv, jobjectArray, jsize) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobjectArray, jsize) callconv(.C) jobject),
    SetObjectArrayElement: ?*const fn ([*c]JNIEnv, jobjectArray, jsize, jobject) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobjectArray, jsize, jobject) callconv(.C) void),
    NewBooleanArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jbooleanArray = std.mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jbooleanArray),
    NewByteArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jbyteArray = std.mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jbyteArray),
    NewCharArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jcharArray = std.mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jcharArray),
    NewShortArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jshortArray = std.mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jshortArray),
    NewIntArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jintArray = std.mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jintArray),
    NewLongArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jlongArray = std.mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jlongArray),
    NewFloatArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jfloatArray = std.mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jfloatArray),
    NewDoubleArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jdoubleArray = std.mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jdoubleArray),
    GetBooleanArrayElements: ?*const fn ([*c]JNIEnv, jbooleanArray, [*c]jboolean) callconv(.C) [*c]jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv, jbooleanArray, [*c]jboolean) callconv(.C) [*c]jboolean),
    GetByteArrayElements: ?*const fn ([*c]JNIEnv, jbyteArray, [*c]jboolean) callconv(.C) [*c]jbyte = std.mem.zeroes(?*const fn ([*c]JNIEnv, jbyteArray, [*c]jboolean) callconv(.C) [*c]jbyte),
    GetCharArrayElements: ?*const fn ([*c]JNIEnv, jcharArray, [*c]jboolean) callconv(.C) [*c]jchar = std.mem.zeroes(?*const fn ([*c]JNIEnv, jcharArray, [*c]jboolean) callconv(.C) [*c]jchar),
    GetShortArrayElements: ?*const fn ([*c]JNIEnv, jshortArray, [*c]jboolean) callconv(.C) [*c]jshort = std.mem.zeroes(?*const fn ([*c]JNIEnv, jshortArray, [*c]jboolean) callconv(.C) [*c]jshort),
    GetIntArrayElements: ?*const fn ([*c]JNIEnv, jintArray, [*c]jboolean) callconv(.C) [*c]jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jintArray, [*c]jboolean) callconv(.C) [*c]jint),
    GetLongArrayElements: ?*const fn ([*c]JNIEnv, jlongArray, [*c]jboolean) callconv(.C) [*c]jlong = std.mem.zeroes(?*const fn ([*c]JNIEnv, jlongArray, [*c]jboolean) callconv(.C) [*c]jlong),
    GetFloatArrayElements: ?*const fn ([*c]JNIEnv, jfloatArray, [*c]jboolean) callconv(.C) [*c]jfloat = std.mem.zeroes(?*const fn ([*c]JNIEnv, jfloatArray, [*c]jboolean) callconv(.C) [*c]jfloat),
    GetDoubleArrayElements: ?*const fn ([*c]JNIEnv, jdoubleArray, [*c]jboolean) callconv(.C) [*c]jdouble = std.mem.zeroes(?*const fn ([*c]JNIEnv, jdoubleArray, [*c]jboolean) callconv(.C) [*c]jdouble),
    ReleaseBooleanArrayElements: ?*const fn ([*c]JNIEnv, jbooleanArray, [*c]jboolean, jint) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jbooleanArray, [*c]jboolean, jint) callconv(.C) void),
    ReleaseByteArrayElements: ?*const fn ([*c]JNIEnv, jbyteArray, [*c]jbyte, jint) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jbyteArray, [*c]jbyte, jint) callconv(.C) void),
    ReleaseCharArrayElements: ?*const fn ([*c]JNIEnv, jcharArray, [*c]jchar, jint) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jcharArray, [*c]jchar, jint) callconv(.C) void),
    ReleaseShortArrayElements: ?*const fn ([*c]JNIEnv, jshortArray, [*c]jshort, jint) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jshortArray, [*c]jshort, jint) callconv(.C) void),
    ReleaseIntArrayElements: ?*const fn ([*c]JNIEnv, jintArray, [*c]jint, jint) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jintArray, [*c]jint, jint) callconv(.C) void),
    ReleaseLongArrayElements: ?*const fn ([*c]JNIEnv, jlongArray, [*c]jlong, jint) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jlongArray, [*c]jlong, jint) callconv(.C) void),
    ReleaseFloatArrayElements: ?*const fn ([*c]JNIEnv, jfloatArray, [*c]jfloat, jint) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jfloatArray, [*c]jfloat, jint) callconv(.C) void),
    ReleaseDoubleArrayElements: ?*const fn ([*c]JNIEnv, jdoubleArray, [*c]jdouble, jint) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jdoubleArray, [*c]jdouble, jint) callconv(.C) void),
    GetBooleanArrayRegion: ?*const fn ([*c]JNIEnv, jbooleanArray, jsize, jsize, [*c]jboolean) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jbooleanArray, jsize, jsize, [*c]jboolean) callconv(.C) void),
    GetByteArrayRegion: ?*const fn ([*c]JNIEnv, jbyteArray, jsize, jsize, [*c]jbyte) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jbyteArray, jsize, jsize, [*c]jbyte) callconv(.C) void),
    GetCharArrayRegion: ?*const fn ([*c]JNIEnv, jcharArray, jsize, jsize, [*c]jchar) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jcharArray, jsize, jsize, [*c]jchar) callconv(.C) void),
    GetShortArrayRegion: ?*const fn ([*c]JNIEnv, jshortArray, jsize, jsize, [*c]jshort) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jshortArray, jsize, jsize, [*c]jshort) callconv(.C) void),
    GetIntArrayRegion: ?*const fn ([*c]JNIEnv, jintArray, jsize, jsize, [*c]jint) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jintArray, jsize, jsize, [*c]jint) callconv(.C) void),
    GetLongArrayRegion: ?*const fn ([*c]JNIEnv, jlongArray, jsize, jsize, [*c]jlong) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jlongArray, jsize, jsize, [*c]jlong) callconv(.C) void),
    GetFloatArrayRegion: ?*const fn ([*c]JNIEnv, jfloatArray, jsize, jsize, [*c]jfloat) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jfloatArray, jsize, jsize, [*c]jfloat) callconv(.C) void),
    GetDoubleArrayRegion: ?*const fn ([*c]JNIEnv, jdoubleArray, jsize, jsize, [*c]jdouble) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jdoubleArray, jsize, jsize, [*c]jdouble) callconv(.C) void),
    SetBooleanArrayRegion: ?*const fn ([*c]JNIEnv, jbooleanArray, jsize, jsize, [*c]const jboolean) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jbooleanArray, jsize, jsize, [*c]const jboolean) callconv(.C) void),
    SetByteArrayRegion: ?*const fn ([*c]JNIEnv, jbyteArray, jsize, jsize, [*c]const jbyte) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jbyteArray, jsize, jsize, [*c]const jbyte) callconv(.C) void),
    SetCharArrayRegion: ?*const fn ([*c]JNIEnv, jcharArray, jsize, jsize, [*c]const jchar) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jcharArray, jsize, jsize, [*c]const jchar) callconv(.C) void),
    SetShortArrayRegion: ?*const fn ([*c]JNIEnv, jshortArray, jsize, jsize, [*c]const jshort) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jshortArray, jsize, jsize, [*c]const jshort) callconv(.C) void),
    SetIntArrayRegion: ?*const fn ([*c]JNIEnv, jintArray, jsize, jsize, [*c]const jint) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jintArray, jsize, jsize, [*c]const jint) callconv(.C) void),
    SetLongArrayRegion: ?*const fn ([*c]JNIEnv, jlongArray, jsize, jsize, [*c]const jlong) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jlongArray, jsize, jsize, [*c]const jlong) callconv(.C) void),
    SetFloatArrayRegion: ?*const fn ([*c]JNIEnv, jfloatArray, jsize, jsize, [*c]const jfloat) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jfloatArray, jsize, jsize, [*c]const jfloat) callconv(.C) void),
    SetDoubleArrayRegion: ?*const fn ([*c]JNIEnv, jdoubleArray, jsize, jsize, [*c]const jdouble) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jdoubleArray, jsize, jsize, [*c]const jdouble) callconv(.C) void),
    RegisterNatives: ?*const fn ([*c]JNIEnv, jclass, [*c]const JNINativeMethod, jint) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const JNINativeMethod, jint) callconv(.C) jint),
    UnregisterNatives: ?*const fn ([*c]JNIEnv, jclass) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jclass) callconv(.C) jint),
    MonitorEnter: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jint),
    MonitorExit: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jint),
    GetJavaVM: ?*const fn ([*c]JNIEnv, [*c][*c]JavaVM) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JNIEnv, [*c][*c]JavaVM) callconv(.C) jint),
    GetStringRegion: ?*const fn ([*c]JNIEnv, jstring, jsize, jsize, [*c]jchar) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jstring, jsize, jsize, [*c]jchar) callconv(.C) void),
    GetStringUTFRegion: ?*const fn ([*c]JNIEnv, jstring, jsize, jsize, [*c]u8) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jstring, jsize, jsize, [*c]u8) callconv(.C) void),
    GetPrimitiveArrayCritical: ?*const fn ([*c]JNIEnv, jarray, [*c]jboolean) callconv(.C) ?*anyopaque = std.mem.zeroes(?*const fn ([*c]JNIEnv, jarray, [*c]jboolean) callconv(.C) ?*anyopaque),
    ReleasePrimitiveArrayCritical: ?*const fn ([*c]JNIEnv, jarray, ?*anyopaque, jint) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jarray, ?*anyopaque, jint) callconv(.C) void),
    GetStringCritical: ?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const jchar = std.mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const jchar),
    ReleaseStringCritical: ?*const fn ([*c]JNIEnv, jstring, [*c]const jchar) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]const jchar) callconv(.C) void),
    NewWeakGlobalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jweak = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jweak),
    DeleteWeakGlobalRef: ?*const fn ([*c]JNIEnv, jweak) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]JNIEnv, jweak) callconv(.C) void),
    ExceptionCheck: ?*const fn ([*c]JNIEnv) callconv(.C) jboolean = std.mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) jboolean),
    NewDirectByteBuffer: ?*const fn ([*c]JNIEnv, ?*anyopaque, jlong) callconv(.C) jobject = std.mem.zeroes(?*const fn ([*c]JNIEnv, ?*anyopaque, jlong) callconv(.C) jobject),
    GetDirectBufferAddress: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) ?*anyopaque = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) ?*anyopaque),
    GetDirectBufferCapacity: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jlong = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jlong),
    GetObjectRefType: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobjectRefType = std.mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobjectRefType),
};
pub const JNIEnv = [*c]const struct_JNINativeInterface;
pub const struct_JNIInvokeInterface = extern struct {
    reserved0: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    reserved1: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    reserved2: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    DestroyJavaVM: ?*const fn ([*c]JavaVM) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JavaVM) callconv(.C) jint),
    AttachCurrentThread: ?*const fn ([*c]JavaVM, [*c][*c]JNIEnv, ?*anyopaque) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JavaVM, [*c][*c]JNIEnv, ?*anyopaque) callconv(.C) jint),
    DetachCurrentThread: ?*const fn ([*c]JavaVM) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JavaVM) callconv(.C) jint),
    GetEnv: ?*const fn ([*c]JavaVM, [*c]?*anyopaque, jint) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JavaVM, [*c]?*anyopaque, jint) callconv(.C) jint),
    AttachCurrentThreadAsDaemon: ?*const fn ([*c]JavaVM, [*c][*c]JNIEnv, ?*anyopaque) callconv(.C) jint = std.mem.zeroes(?*const fn ([*c]JavaVM, [*c][*c]JNIEnv, ?*anyopaque) callconv(.C) jint),
};
pub const JNINativeMethod = extern struct {
    name: [*c]const u8 = std.mem.zeroes([*c]const u8),
    signature: [*c]const u8 = std.mem.zeroes([*c]const u8),
    fnPtr: ?*anyopaque = std.mem.zeroes(?*anyopaque),
};
pub const struct__JNIEnv = extern struct {
    functions: [*c]const struct_JNINativeInterface = std.mem.zeroes([*c]const struct_JNINativeInterface),
};
pub const struct__JavaVM = extern struct {
    functions: [*c]const struct_JNIInvokeInterface = std.mem.zeroes([*c]const struct_JNIInvokeInterface),
};
pub const C_JNIEnv = [*c]const struct_JNINativeInterface;
pub const struct_JavaVMAttachArgs = extern struct {
    version: jint = std.mem.zeroes(jint),
    name: [*c]const u8 = std.mem.zeroes([*c]const u8),
    group: jobject = std.mem.zeroes(jobject),
};
pub const JavaVMAttachArgs = struct_JavaVMAttachArgs;
pub const struct_JavaVMOption = extern struct {
    optionString: [*c]const u8 = std.mem.zeroes([*c]const u8),
    extraInfo: ?*anyopaque = std.mem.zeroes(?*anyopaque),
};
pub const JavaVMOption = struct_JavaVMOption;
pub const struct_JavaVMInitArgs = extern struct {
    version: jint = std.mem.zeroes(jint),
    nOptions: jint = std.mem.zeroes(jint),
    options: [*c]JavaVMOption = std.mem.zeroes([*c]JavaVMOption),
    ignoreUnrecognized: jboolean = std.mem.zeroes(jboolean),
};
pub const JavaVMInitArgs = struct_JavaVMInitArgs;
pub extern fn JNI_GetDefaultJavaVMInitArgs(?*anyopaque) jint;
pub extern fn JNI_CreateJavaVM([*c][*c]JavaVM, [*c][*c]JNIEnv, ?*anyopaque) jint;
pub extern fn JNI_GetCreatedJavaVMs([*c][*c]JavaVM, jsize, [*c]jsize) jint;
pub extern fn JNI_OnLoad(vm: [*c]JavaVM, reserved: ?*anyopaque) jint;
pub extern fn JNI_OnUnload(vm: [*c]JavaVM, reserved: ?*anyopaque) void;
pub const SLAint64 = sl_int64_t;
pub const SLAuint64 = sl_uint64_t;
pub const struct_SLAndroidDataFormat_PCM_EX_ = extern struct {
    formatType: SLuint32 = std.mem.zeroes(SLuint32),
    numChannels: SLuint32 = std.mem.zeroes(SLuint32),
    sampleRate: SLuint32 = std.mem.zeroes(SLuint32),
    bitsPerSample: SLuint32 = std.mem.zeroes(SLuint32),
    containerSize: SLuint32 = std.mem.zeroes(SLuint32),
    channelMask: SLuint32 = std.mem.zeroes(SLuint32),
    endianness: SLuint32 = std.mem.zeroes(SLuint32),
    representation: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLAndroidDataFormat_PCM_EX = struct_SLAndroidDataFormat_PCM_EX_;
pub extern const SL_IID_ANDROIDEFFECT: SLInterfaceID;
pub const SLAndroidEffectItf = [*c]const [*c]const struct_SLAndroidEffectItf_;
pub const struct_SLAndroidEffectItf_ = extern struct {
    CreateEffect: ?*const fn (SLAndroidEffectItf, SLInterfaceID) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidEffectItf, SLInterfaceID) callconv(.C) SLresult),
    ReleaseEffect: ?*const fn (SLAndroidEffectItf, SLInterfaceID) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidEffectItf, SLInterfaceID) callconv(.C) SLresult),
    SetEnabled: ?*const fn (SLAndroidEffectItf, SLInterfaceID, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidEffectItf, SLInterfaceID, SLboolean) callconv(.C) SLresult),
    IsEnabled: ?*const fn (SLAndroidEffectItf, SLInterfaceID, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidEffectItf, SLInterfaceID, [*c]SLboolean) callconv(.C) SLresult),
    SendCommand: ?*const fn (SLAndroidEffectItf, SLInterfaceID, SLuint32, SLuint32, ?*anyopaque, [*c]SLuint32, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidEffectItf, SLInterfaceID, SLuint32, SLuint32, ?*anyopaque, [*c]SLuint32, ?*anyopaque) callconv(.C) SLresult),
};
pub extern const SL_IID_ANDROIDEFFECTSEND: SLInterfaceID;
pub const SLAndroidEffectSendItf = [*c]const [*c]const struct_SLAndroidEffectSendItf_;
pub const struct_SLAndroidEffectSendItf_ = extern struct {
    EnableEffectSend: ?*const fn (SLAndroidEffectSendItf, SLInterfaceID, SLboolean, SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidEffectSendItf, SLInterfaceID, SLboolean, SLmillibel) callconv(.C) SLresult),
    IsEnabled: ?*const fn (SLAndroidEffectSendItf, SLInterfaceID, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidEffectSendItf, SLInterfaceID, [*c]SLboolean) callconv(.C) SLresult),
    SetDirectLevel: ?*const fn (SLAndroidEffectSendItf, SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidEffectSendItf, SLmillibel) callconv(.C) SLresult),
    GetDirectLevel: ?*const fn (SLAndroidEffectSendItf, [*c]SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidEffectSendItf, [*c]SLmillibel) callconv(.C) SLresult),
    SetSendLevel: ?*const fn (SLAndroidEffectSendItf, SLInterfaceID, SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidEffectSendItf, SLInterfaceID, SLmillibel) callconv(.C) SLresult),
    GetSendLevel: ?*const fn (SLAndroidEffectSendItf, SLInterfaceID, [*c]SLmillibel) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidEffectSendItf, SLInterfaceID, [*c]SLmillibel) callconv(.C) SLresult),
};
pub extern const SL_IID_ANDROIDEFFECTCAPABILITIES: SLInterfaceID;
pub const SLAndroidEffectCapabilitiesItf = [*c]const [*c]const struct_SLAndroidEffectCapabilitiesItf_;
pub const struct_SLAndroidEffectCapabilitiesItf_ = extern struct {
    QueryNumEffects: ?*const fn (SLAndroidEffectCapabilitiesItf, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidEffectCapabilitiesItf, [*c]SLuint32) callconv(.C) SLresult),
    QueryEffect: ?*const fn (SLAndroidEffectCapabilitiesItf, SLuint32, [*c]SLInterfaceID, [*c]SLInterfaceID, [*c]SLchar, [*c]SLuint16) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidEffectCapabilitiesItf, SLuint32, [*c]SLInterfaceID, [*c]SLInterfaceID, [*c]SLchar, [*c]SLuint16) callconv(.C) SLresult),
};
pub extern const SL_IID_ANDROIDCONFIGURATION: SLInterfaceID;
pub const SLAndroidConfigurationItf = [*c]const [*c]const struct_SLAndroidConfigurationItf_;
pub const struct_SLAndroidConfigurationItf_ = extern struct {
    SetConfiguration: ?*const fn (SLAndroidConfigurationItf, [*c]const SLchar, ?*const anyopaque, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidConfigurationItf, [*c]const SLchar, ?*const anyopaque, SLuint32) callconv(.C) SLresult),
    GetConfiguration: ?*const fn (SLAndroidConfigurationItf, [*c]const SLchar, [*c]SLuint32, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidConfigurationItf, [*c]const SLchar, [*c]SLuint32, ?*anyopaque) callconv(.C) SLresult),
    AcquireJavaProxy: ?*const fn (SLAndroidConfigurationItf, SLuint32, [*c]jobject) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidConfigurationItf, SLuint32, [*c]jobject) callconv(.C) SLresult),
    ReleaseJavaProxy: ?*const fn (SLAndroidConfigurationItf, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidConfigurationItf, SLuint32) callconv(.C) SLresult),
};
pub extern const SL_IID_ANDROIDSIMPLEBUFFERQUEUE: SLInterfaceID;
pub const SLAndroidSimpleBufferQueueItf = [*c]const [*c]const struct_SLAndroidSimpleBufferQueueItf_;
pub const struct_SLAndroidSimpleBufferQueueState_ = extern struct {
    count: SLuint32 = std.mem.zeroes(SLuint32),
    index: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLAndroidSimpleBufferQueueState = struct_SLAndroidSimpleBufferQueueState_;
pub const slAndroidSimpleBufferQueueCallback = ?*const fn ([*c]const [*c]const struct_SLAndroidSimpleBufferQueueItf_, ?*anyopaque) callconv(.C) void;
pub const struct_SLAndroidSimpleBufferQueueItf_ = extern struct {
    Enqueue: ?*const fn ([*c]const [*c]const struct_SLAndroidSimpleBufferQueueItf_, ?*const anyopaque, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLAndroidSimpleBufferQueueItf_, ?*const anyopaque, SLuint32) callconv(.C) SLresult),
    Clear: ?*const fn ([*c]const [*c]const struct_SLAndroidSimpleBufferQueueItf_) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLAndroidSimpleBufferQueueItf_) callconv(.C) SLresult),
    GetState: ?*const fn ([*c]const [*c]const struct_SLAndroidSimpleBufferQueueItf_, [*c]SLAndroidSimpleBufferQueueState) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLAndroidSimpleBufferQueueItf_, [*c]SLAndroidSimpleBufferQueueState) callconv(.C) SLresult),
    RegisterCallback: ?*const fn ([*c]const [*c]const struct_SLAndroidSimpleBufferQueueItf_, slAndroidSimpleBufferQueueCallback, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn ([*c]const [*c]const struct_SLAndroidSimpleBufferQueueItf_, slAndroidSimpleBufferQueueCallback, ?*anyopaque) callconv(.C) SLresult),
};
pub extern const SL_IID_ANDROIDBUFFERQUEUESOURCE: SLInterfaceID;
pub const SLAndroidBufferQueueItf = [*c]const [*c]const struct_SLAndroidBufferQueueItf_;
pub const struct_SLAndroidBufferItem_ = extern struct {
    itemKey: SLuint32 align(4) = std.mem.zeroes(SLuint32),
    itemSize: SLuint32 = std.mem.zeroes(SLuint32),
    pub fn itemData(self: anytype) std.zig.c_translation.FlexibleArrayType(@TypeOf(self), u8) {
        const Intermediate = std.zig.c_translation.FlexibleArrayType(@TypeOf(self), u8);
        const ReturnType = std.zig.c_translation.FlexibleArrayType(@TypeOf(self), u8);
        return @as(ReturnType, @ptrCast(@alignCast(@as(Intermediate, @ptrCast(self)) + 8)));
    }
};
pub const SLAndroidBufferItem = struct_SLAndroidBufferItem_;
pub const slAndroidBufferQueueCallback = ?*const fn (SLAndroidBufferQueueItf, ?*anyopaque, ?*anyopaque, ?*anyopaque, SLuint32, SLuint32, [*c]const SLAndroidBufferItem, SLuint32) callconv(.C) SLresult;
pub const struct_SLAndroidBufferQueueState_ = extern struct {
    count: SLuint32 = std.mem.zeroes(SLuint32),
    index: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLAndroidBufferQueueState = struct_SLAndroidBufferQueueState_;
pub const struct_SLAndroidBufferQueueItf_ = extern struct {
    RegisterCallback: ?*const fn (SLAndroidBufferQueueItf, slAndroidBufferQueueCallback, ?*anyopaque) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidBufferQueueItf, slAndroidBufferQueueCallback, ?*anyopaque) callconv(.C) SLresult),
    Clear: ?*const fn (SLAndroidBufferQueueItf) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidBufferQueueItf) callconv(.C) SLresult),
    Enqueue: ?*const fn (SLAndroidBufferQueueItf, ?*anyopaque, ?*anyopaque, SLuint32, [*c]const SLAndroidBufferItem, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidBufferQueueItf, ?*anyopaque, ?*anyopaque, SLuint32, [*c]const SLAndroidBufferItem, SLuint32) callconv(.C) SLresult),
    GetState: ?*const fn (SLAndroidBufferQueueItf, [*c]SLAndroidBufferQueueState) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidBufferQueueItf, [*c]SLAndroidBufferQueueState) callconv(.C) SLresult),
    SetCallbackEventsMask: ?*const fn (SLAndroidBufferQueueItf, SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidBufferQueueItf, SLuint32) callconv(.C) SLresult),
    GetCallbackEventsMask: ?*const fn (SLAndroidBufferQueueItf, [*c]SLuint32) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidBufferQueueItf, [*c]SLuint32) callconv(.C) SLresult),
};
pub const struct_SLDataLocator_AndroidFD_ = extern struct {
    locatorType: SLuint32 = std.mem.zeroes(SLuint32),
    fd: SLint32 = std.mem.zeroes(SLint32),
    offset: SLAint64 = std.mem.zeroes(SLAint64),
    length: SLAint64 = std.mem.zeroes(SLAint64),
};
pub const SLDataLocator_AndroidFD = struct_SLDataLocator_AndroidFD_;
pub const struct_SLDataLocator_AndroidSimpleBufferQueue = extern struct {
    locatorType: SLuint32 = std.mem.zeroes(SLuint32),
    numBuffers: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLDataLocator_AndroidSimpleBufferQueue = struct_SLDataLocator_AndroidSimpleBufferQueue;
pub const struct_SLDataLocator_AndroidBufferQueue_ = extern struct {
    locatorType: SLuint32 = std.mem.zeroes(SLuint32),
    numBuffers: SLuint32 = std.mem.zeroes(SLuint32),
};
pub const SLDataLocator_AndroidBufferQueue = struct_SLDataLocator_AndroidBufferQueue_;
pub extern const SL_IID_ANDROIDACOUSTICECHOCANCELLATION: SLInterfaceID;
pub const SLAndroidAcousticEchoCancellationItf = [*c]const [*c]const struct_SLAndroidAcousticEchoCancellationItf_;
pub const struct_SLAndroidAcousticEchoCancellationItf_ = extern struct {
    SetEnabled: ?*const fn (SLAndroidAcousticEchoCancellationItf, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidAcousticEchoCancellationItf, SLboolean) callconv(.C) SLresult),
    IsEnabled: ?*const fn (SLAndroidAcousticEchoCancellationItf, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidAcousticEchoCancellationItf, [*c]SLboolean) callconv(.C) SLresult),
};
pub extern const SL_IID_ANDROIDAUTOMATICGAINCONTROL: SLInterfaceID;
pub const SLAndroidAutomaticGainControlItf = [*c]const [*c]const struct_SLAndroidAutomaticGainControlItf_;
pub const struct_SLAndroidAutomaticGainControlItf_ = extern struct {
    SetEnabled: ?*const fn (SLAndroidAutomaticGainControlItf, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidAutomaticGainControlItf, SLboolean) callconv(.C) SLresult),
    IsEnabled: ?*const fn (SLAndroidAutomaticGainControlItf, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidAutomaticGainControlItf, [*c]SLboolean) callconv(.C) SLresult),
};
pub extern const SL_IID_ANDROIDNOISESUPPRESSION: SLInterfaceID;
pub const SLAndroidNoiseSuppressionItf = [*c]const [*c]const struct_SLAndroidNoiseSuppressionItf_;
pub const struct_SLAndroidNoiseSuppressionItf_ = extern struct {
    SetEnabled: ?*const fn (SLAndroidNoiseSuppressionItf, SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidNoiseSuppressionItf, SLboolean) callconv(.C) SLresult),
    IsEnabled: ?*const fn (SLAndroidNoiseSuppressionItf, [*c]SLboolean) callconv(.C) SLresult = std.mem.zeroes(?*const fn (SLAndroidNoiseSuppressionItf, [*c]SLboolean) callconv(.C) SLresult),
};
pub const __INTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `LL`"); // (no file):89:9
pub const __UINTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `ULL`"); // (no file):95:9
pub const __INT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `LL`"); // (no file):193:9
pub const __UINT32_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `U`"); // (no file):215:9
pub const __UINT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `ULL`"); // (no file):223:9
pub const __seg_gs = @compileError("unable to translate macro: undefined identifier `address_space`"); // (no file):351:9
pub const __seg_fs = @compileError("unable to translate macro: undefined identifier `address_space`"); // (no file):352:9
pub const __declspec = @compileError("unable to translate C expr: unexpected token '__attribute__'"); // (no file):412:9
pub const _cdecl = @compileError("unable to translate macro: undefined identifier `__cdecl__`"); // (no file):413:9
pub const __cdecl = @compileError("unable to translate macro: undefined identifier `__cdecl__`"); // (no file):414:9
pub const _stdcall = @compileError("unable to translate macro: undefined identifier `__stdcall__`"); // (no file):415:9
pub const __stdcall = @compileError("unable to translate macro: undefined identifier `__stdcall__`"); // (no file):416:9
pub const _fastcall = @compileError("unable to translate macro: undefined identifier `__fastcall__`"); // (no file):417:9
pub const __fastcall = @compileError("unable to translate macro: undefined identifier `__fastcall__`"); // (no file):418:9
pub const _thiscall = @compileError("unable to translate macro: undefined identifier `__thiscall__`"); // (no file):419:9
pub const __thiscall = @compileError("unable to translate macro: undefined identifier `__thiscall__`"); // (no file):420:9
pub const _pascal = @compileError("unable to translate macro: undefined identifier `__pascal__`"); // (no file):421:9
pub const __pascal = @compileError("unable to translate macro: undefined identifier `__pascal__`"); // (no file):422:9
pub const SL_API_DEPRECATED = @compileError("unable to translate macro: undefined identifier `availability`"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES_Platform.h:58:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_DEFAULT = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1441:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_GENERIC = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1443:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_PADDEDCELL = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1445:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_ROOM = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1447:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_BATHROOM = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1449:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_LIVINGROOM = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1451:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_STONEROOM = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1453:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_AUDITORIUM = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1455:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_CONCERTHALL = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1457:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_CAVE = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1459:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_ARENA = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1461:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_HANGAR = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1463:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_CARPETEDHALLWAY = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1465:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_HALLWAY = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1467:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_STONECORRIDOR = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1469:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_ALLEY = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1471:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_FOREST = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1473:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_CITY = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1475:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_MOUNTAINS = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1477:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_QUARRY = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1479:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_PLAIN = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1481:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_PARKINGLOT = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1483:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_SEWERPIPE = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1485:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_UNDERWATER = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1487:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_SMALLROOM = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1489:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_MEDIUMROOM = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1491:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_LARGEROOM = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1493:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_MEDIUMHALL = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1495:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_LARGEHALL = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1497:9
pub const SL_I3DL2_ENVIRONMENT_PRESET_PLATE = @compileError("unable to translate C expr: unexpected token '{'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES.h:1499:9
pub const SL_ANDROID_KEY_RECORDING_PRESET = @compileError("unable to translate C expr: unexpected token 'const'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES_AndroidConfiguration.h:30:9
pub const SL_ANDROID_KEY_STREAM_TYPE = @compileError("unable to translate C expr: unexpected token 'const'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES_AndroidConfiguration.h:54:9
pub const SL_ANDROID_KEY_PERFORMANCE_MODE = @compileError("unable to translate C expr: unexpected token 'const'"); // d:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include\SLES/OpenSLES_AndroidConfiguration.h:86:9
pub const va_start = @compileError("unable to translate macro: undefined identifier `__builtin_va_start`"); // C:\ProgramTools\zig-windows-x86_64-0.12.0-dev.1746+19af8aac8\lib\include/stdarg.h:33:9
pub const va_end = @compileError("unable to translate macro: undefined identifier `__builtin_va_end`"); // C:\ProgramTools\zig-windows-x86_64-0.12.0-dev.1746+19af8aac8\lib\include/stdarg.h:35:9
pub const va_arg = @compileError("unable to translate C expr: unexpected token 'an identifier'"); // C:\ProgramTools\zig-windows-x86_64-0.12.0-dev.1746+19af8aac8\lib\include/stdarg.h:36:9
pub const __va_copy = @compileError("unable to translate macro: undefined identifier `__builtin_va_copy`"); // C:\ProgramTools\zig-windows-x86_64-0.12.0-dev.1746+19af8aac8\lib\include/stdarg.h:41:9
pub const va_copy = @compileError("unable to translate macro: undefined identifier `__builtin_va_copy`"); // C:\ProgramTools\zig-windows-x86_64-0.12.0-dev.1746+19af8aac8\lib\include/stdarg.h:46:9
pub const __strong_alias = @compileError("unable to translate C expr: unexpected token '__asm__'"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:53:9
pub const __CONCAT1 = @compileError("unable to translate C expr: unexpected token '##'"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:75:9
pub const __STRING = @compileError("unable to translate C expr: unexpected token '#'"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:79:9
pub const __always_inline = @compileError("unable to translate macro: undefined identifier `__always_inline__`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:86:9
pub const __attribute_const__ = @compileError("unable to translate C expr: unexpected token '__attribute__'"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:87:9
pub const __attribute_pure__ = @compileError("unable to translate macro: undefined identifier `__pure__`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:88:9
pub const __dead = @compileError("unable to translate macro: undefined identifier `__noreturn__`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:89:9
pub const __noreturn = @compileError("unable to translate macro: undefined identifier `__noreturn__`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:90:9
pub const __mallocfunc = @compileError("unable to translate macro: undefined identifier `__malloc__`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:91:9
pub const __packed = @compileError("unable to translate macro: undefined identifier `__packed__`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:92:9
pub const __returns_twice = @compileError("unable to translate macro: undefined identifier `__returns_twice__`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:93:9
pub const __unused = @compileError("unable to translate macro: undefined identifier `__unused__`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:94:9
pub const __used = @compileError("unable to translate macro: undefined identifier `__used__`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:95:9
pub const __printflike = @compileError("unable to translate macro: undefined identifier `__format__`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:97:9
pub const __scanflike = @compileError("unable to translate macro: undefined identifier `__format__`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:98:9
pub const __strftimelike = @compileError("unable to translate macro: undefined identifier `__format__`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:99:9
pub const __wur = @compileError("unable to translate macro: undefined identifier `__warn_unused_result__`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:132:9
pub const __errorattr = @compileError("unable to translate macro: undefined identifier `unavailable`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:134:9
pub const __warnattr = @compileError("unable to translate macro: undefined identifier `deprecated`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:135:9
pub const __warnattr_real = @compileError("unable to translate macro: undefined identifier `deprecated`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:136:9
pub const __enable_if = @compileError("unable to translate macro: undefined identifier `enable_if`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:137:9
pub const __clang_error_if = @compileError("unable to translate macro: undefined identifier `diagnose_if`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:138:9
pub const __clang_warning_if = @compileError("unable to translate macro: undefined identifier `diagnose_if`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:139:9
pub const __warnattr_strict = @compileError("unable to translate C expr: unexpected token ''"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:148:11
pub const __IDSTRING = @compileError("unable to translate C expr: unexpected token ''"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:156:9
pub const __COPYRIGHT = @compileError("unable to translate C expr: unexpected token ''"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:157:9
pub const __FBSDID = @compileError("unable to translate C expr: unexpected token ''"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:158:9
pub const __RCSID = @compileError("unable to translate C expr: unexpected token ''"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:159:9
pub const __SCCSID = @compileError("unable to translate C expr: unexpected token ''"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:160:9
pub const __RENAME_IF_FILE_OFFSET64 = @compileError("unable to translate C expr: unexpected token ''"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:193:11
pub const __RENAME_LDBL = @compileError("unable to translate C expr: unexpected token 'an identifier'"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:215:9
pub const __RENAME_LDBL_NO_GUARD_FOR_NDK = @compileError("unable to translate C expr: unexpected token 'an identifier'"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:216:9
pub const __RENAME_STAT64 = @compileError("unable to translate C expr: unexpected token 'an identifier'"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:226:9
pub const __pass_object_size_n = @compileError("unable to translate C expr: unexpected token ''"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:301:11
pub const __bos_trivially_ge = @compileError("unable to translate C expr: unexpected token '>='"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:321:9
pub const __bos_trivially_gt = @compileError("unable to translate C expr: unexpected token '>'"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:322:9
pub const __overloadable = @compileError("unable to translate macro: undefined identifier `overloadable`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:328:9
pub const __diagnose_as_builtin = @compileError("unable to translate C expr: expected ')' instead got '...'"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:330:9
pub const __LIBC_HIDDEN__ = @compileError("unable to translate macro: undefined identifier `visibility`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:333:9
pub const __LIBC32_LEGACY_PUBLIC__ = @compileError("unable to translate macro: undefined identifier `visibility`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:342:9
pub const __RENAME = @compileError("unable to translate C expr: unexpected token '__asm__'"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:346:9
pub const __size_mul_overflow = @compileError("unable to translate macro: undefined identifier `__builtin_umul_overflow`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/sys/cdefs.h:352:9
pub const __BIONIC_AVAILABILITY = @compileError("unable to translate macro: undefined identifier `__availability__`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/android/versioning.h:57:9
pub const __INTRODUCED_IN_NO_GUARD_FOR_NDK = @compileError("unable to translate C expr: unexpected token ''"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/android/versioning.h:58:9
pub const __INTRODUCED_IN_X86_NO_GUARD_FOR_NDK = @compileError("unable to translate C expr: unexpected token ''"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/android/versioning.h:59:9
pub const __INTRODUCED_IN = @compileError("unable to translate macro: undefined identifier `introduced`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/android/versioning.h:62:9
pub const __DEPRECATED_IN = @compileError("unable to translate macro: undefined identifier `deprecated`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/android/versioning.h:63:9
pub const __REMOVED_IN = @compileError("unable to translate macro: undefined identifier `obsoleted`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/android/versioning.h:64:9
pub const __INTRODUCED_IN_32 = @compileError("unable to translate macro: undefined identifier `introduced`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/android/versioning.h:79:9
pub const __INTRODUCED_IN_64 = @compileError("unable to translate C expr: unexpected token ''"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/android/versioning.h:80:9
pub const __INTRODUCED_IN_ARM = @compileError("unable to translate C expr: unexpected token ''"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/android/versioning.h:90:9
pub const __INTRODUCED_IN_X86 = @compileError("unable to translate macro: undefined identifier `introduced`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/android/versioning.h:91:9
pub const offsetof = @compileError("unable to translate C expr: unexpected token 'an identifier'"); // C:\ProgramTools\zig-windows-x86_64-0.12.0-dev.1746+19af8aac8\lib\include/stddef.h:116:9
pub const JNIEXPORT = @compileError("unable to translate macro: undefined identifier `visibility`"); // D:\Android\sdk\ndk\25.1.8937393\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\include/jni.h:1105:9
pub const __llvm__ = @as(c_int, 1);
pub const __clang__ = @as(c_int, 1);
pub const __clang_major__ = @as(c_int, 17);
pub const __clang_minor__ = @as(c_int, 0);
pub const __clang_patchlevel__ = @as(c_int, 3);
pub const __clang_version__ = "17.0.3 (https://github.com/ziglang/zig-bootstrap 1dc1fa6a122996fcd030cc956385e055289e09d9)";
pub const __GNUC__ = @as(c_int, 4);
pub const __GNUC_MINOR__ = @as(c_int, 2);
pub const __GNUC_PATCHLEVEL__ = @as(c_int, 1);
pub const __GXX_ABI_VERSION = @as(c_int, 1002);
pub const __ATOMIC_RELAXED = @as(c_int, 0);
pub const __ATOMIC_CONSUME = @as(c_int, 1);
pub const __ATOMIC_ACQUIRE = @as(c_int, 2);
pub const __ATOMIC_RELEASE = @as(c_int, 3);
pub const __ATOMIC_ACQ_REL = @as(c_int, 4);
pub const __ATOMIC_SEQ_CST = @as(c_int, 5);
pub const __OPENCL_MEMORY_SCOPE_WORK_ITEM = @as(c_int, 0);
pub const __OPENCL_MEMORY_SCOPE_WORK_GROUP = @as(c_int, 1);
pub const __OPENCL_MEMORY_SCOPE_DEVICE = @as(c_int, 2);
pub const __OPENCL_MEMORY_SCOPE_ALL_SVM_DEVICES = @as(c_int, 3);
pub const __OPENCL_MEMORY_SCOPE_SUB_GROUP = @as(c_int, 4);
pub const __FPCLASS_SNAN = @as(c_int, 0x0001);
pub const __FPCLASS_QNAN = @as(c_int, 0x0002);
pub const __FPCLASS_NEGINF = @as(c_int, 0x0004);
pub const __FPCLASS_NEGNORMAL = @as(c_int, 0x0008);
pub const __FPCLASS_NEGSUBNORMAL = @as(c_int, 0x0010);
pub const __FPCLASS_NEGZERO = @as(c_int, 0x0020);
pub const __FPCLASS_POSZERO = @as(c_int, 0x0040);
pub const __FPCLASS_POSSUBNORMAL = @as(c_int, 0x0080);
pub const __FPCLASS_POSNORMAL = @as(c_int, 0x0100);
pub const __FPCLASS_POSINF = @as(c_int, 0x0200);
pub const __PRAGMA_REDEFINE_EXTNAME = @as(c_int, 1);
pub const __VERSION__ = "Clang 17.0.3 (https://github.com/ziglang/zig-bootstrap 1dc1fa6a122996fcd030cc956385e055289e09d9)";
pub const __OBJC_BOOL_IS_BOOL = @as(c_int, 0);
pub const __CONSTANT_CFSTRINGS__ = @as(c_int, 1);
pub const __SEH__ = @as(c_int, 1);
pub const __clang_literal_encoding__ = "UTF-8";
pub const __clang_wide_literal_encoding__ = "UTF-16";
pub const __ORDER_LITTLE_ENDIAN__ = @as(c_int, 1234);
pub const __ORDER_BIG_ENDIAN__ = @as(c_int, 4321);
pub const __ORDER_PDP_ENDIAN__ = @as(c_int, 3412);
pub const __BYTE_ORDER__ = __ORDER_LITTLE_ENDIAN__;
pub const __LITTLE_ENDIAN__ = @as(c_int, 1);
pub const __CHAR_BIT__ = @as(c_int, 8);
pub const __BOOL_WIDTH__ = @as(c_int, 8);
pub const __SHRT_WIDTH__ = @as(c_int, 16);
pub const __INT_WIDTH__ = @as(c_int, 32);
pub const __LONG_WIDTH__ = @as(c_int, 32);
pub const __LLONG_WIDTH__ = @as(c_int, 64);
pub const __BITINT_MAXWIDTH__ = std.zig.c_translation.promoteIntLiteral(c_int, 8388608, .decimal);
pub const __SCHAR_MAX__ = @as(c_int, 127);
pub const __SHRT_MAX__ = @as(c_int, 32767);
pub const __INT_MAX__ = std.zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __LONG_MAX__ = @as(c_long, 2147483647);
pub const __LONG_LONG_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __WCHAR_MAX__ = std.zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __WCHAR_WIDTH__ = @as(c_int, 16);
pub const __WINT_MAX__ = std.zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __WINT_WIDTH__ = @as(c_int, 16);
pub const __INTMAX_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INTMAX_WIDTH__ = @as(c_int, 64);
pub const __SIZE_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __SIZE_WIDTH__ = @as(c_int, 64);
pub const __UINTMAX_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __UINTMAX_WIDTH__ = @as(c_int, 64);
pub const __PTRDIFF_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __PTRDIFF_WIDTH__ = @as(c_int, 64);
pub const __INTPTR_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INTPTR_WIDTH__ = @as(c_int, 64);
pub const __UINTPTR_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __UINTPTR_WIDTH__ = @as(c_int, 64);
pub const __SIZEOF_DOUBLE__ = @as(c_int, 8);
pub const __SIZEOF_FLOAT__ = @as(c_int, 4);
pub const __SIZEOF_INT__ = @as(c_int, 4);
pub const __SIZEOF_LONG__ = @as(c_int, 4);
pub const __SIZEOF_LONG_DOUBLE__ = @as(c_int, 16);
pub const __SIZEOF_LONG_LONG__ = @as(c_int, 8);
pub const __SIZEOF_POINTER__ = @as(c_int, 8);
pub const __SIZEOF_SHORT__ = @as(c_int, 2);
pub const __SIZEOF_PTRDIFF_T__ = @as(c_int, 8);
pub const __SIZEOF_SIZE_T__ = @as(c_int, 8);
pub const __SIZEOF_WCHAR_T__ = @as(c_int, 2);
pub const __SIZEOF_WINT_T__ = @as(c_int, 2);
pub const __SIZEOF_INT128__ = @as(c_int, 16);
pub const __INTMAX_TYPE__ = c_longlong;
pub const __INTMAX_FMTd__ = "lld";
pub const __INTMAX_FMTi__ = "lli";
pub const __UINTMAX_TYPE__ = c_ulonglong;
pub const __UINTMAX_FMTo__ = "llo";
pub const __UINTMAX_FMTu__ = "llu";
pub const __UINTMAX_FMTx__ = "llx";
pub const __UINTMAX_FMTX__ = "llX";
pub const __PTRDIFF_TYPE__ = c_longlong;
pub const __PTRDIFF_FMTd__ = "lld";
pub const __PTRDIFF_FMTi__ = "lli";
pub const __INTPTR_TYPE__ = c_longlong;
pub const __INTPTR_FMTd__ = "lld";
pub const __INTPTR_FMTi__ = "lli";
pub const __SIZE_TYPE__ = c_ulonglong;
pub const __SIZE_FMTo__ = "llo";
pub const __SIZE_FMTu__ = "llu";
pub const __SIZE_FMTx__ = "llx";
pub const __SIZE_FMTX__ = "llX";
pub const __WCHAR_TYPE__ = c_ushort;
pub const __WINT_TYPE__ = c_ushort;
pub const __SIG_ATOMIC_MAX__ = std.zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __SIG_ATOMIC_WIDTH__ = @as(c_int, 32);
pub const __CHAR16_TYPE__ = c_ushort;
pub const __CHAR32_TYPE__ = c_uint;
pub const __UINTPTR_TYPE__ = c_ulonglong;
pub const __UINTPTR_FMTo__ = "llo";
pub const __UINTPTR_FMTu__ = "llu";
pub const __UINTPTR_FMTx__ = "llx";
pub const __UINTPTR_FMTX__ = "llX";
pub const __FLT16_DENORM_MIN__ = @as(f16, 5.9604644775390625e-8);
pub const __FLT16_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT16_DIG__ = @as(c_int, 3);
pub const __FLT16_DECIMAL_DIG__ = @as(c_int, 5);
pub const __FLT16_EPSILON__ = @as(f16, 9.765625e-4);
pub const __FLT16_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT16_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT16_MANT_DIG__ = @as(c_int, 11);
pub const __FLT16_MAX_10_EXP__ = @as(c_int, 4);
pub const __FLT16_MAX_EXP__ = @as(c_int, 16);
pub const __FLT16_MAX__ = @as(f16, 6.5504e+4);
pub const __FLT16_MIN_10_EXP__ = -@as(c_int, 4);
pub const __FLT16_MIN_EXP__ = -@as(c_int, 13);
pub const __FLT16_MIN__ = @as(f16, 6.103515625e-5);
pub const __FLT_DENORM_MIN__ = @as(f32, 1.40129846e-45);
pub const __FLT_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT_DIG__ = @as(c_int, 6);
pub const __FLT_DECIMAL_DIG__ = @as(c_int, 9);
pub const __FLT_EPSILON__ = @as(f32, 1.19209290e-7);
pub const __FLT_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT_MANT_DIG__ = @as(c_int, 24);
pub const __FLT_MAX_10_EXP__ = @as(c_int, 38);
pub const __FLT_MAX_EXP__ = @as(c_int, 128);
pub const __FLT_MAX__ = @as(f32, 3.40282347e+38);
pub const __FLT_MIN_10_EXP__ = -@as(c_int, 37);
pub const __FLT_MIN_EXP__ = -@as(c_int, 125);
pub const __FLT_MIN__ = @as(f32, 1.17549435e-38);
pub const __DBL_DENORM_MIN__ = @as(f64, 4.9406564584124654e-324);
pub const __DBL_HAS_DENORM__ = @as(c_int, 1);
pub const __DBL_DIG__ = @as(c_int, 15);
pub const __DBL_DECIMAL_DIG__ = @as(c_int, 17);
pub const __DBL_EPSILON__ = @as(f64, 2.2204460492503131e-16);
pub const __DBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __DBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __DBL_MANT_DIG__ = @as(c_int, 53);
pub const __DBL_MAX_10_EXP__ = @as(c_int, 308);
pub const __DBL_MAX_EXP__ = @as(c_int, 1024);
pub const __DBL_MAX__ = @as(f64, 1.7976931348623157e+308);
pub const __DBL_MIN_10_EXP__ = -@as(c_int, 307);
pub const __DBL_MIN_EXP__ = -@as(c_int, 1021);
pub const __DBL_MIN__ = @as(f64, 2.2250738585072014e-308);
pub const __LDBL_DENORM_MIN__ = @as(c_longdouble, 3.64519953188247460253e-4951);
pub const __LDBL_HAS_DENORM__ = @as(c_int, 1);
pub const __LDBL_DIG__ = @as(c_int, 18);
pub const __LDBL_DECIMAL_DIG__ = @as(c_int, 21);
pub const __LDBL_EPSILON__ = @as(c_longdouble, 1.08420217248550443401e-19);
pub const __LDBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __LDBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __LDBL_MANT_DIG__ = @as(c_int, 64);
pub const __LDBL_MAX_10_EXP__ = @as(c_int, 4932);
pub const __LDBL_MAX_EXP__ = @as(c_int, 16384);
pub const __LDBL_MAX__ = @as(c_longdouble, 1.18973149535723176502e+4932);
pub const __LDBL_MIN_10_EXP__ = -@as(c_int, 4931);
pub const __LDBL_MIN_EXP__ = -@as(c_int, 16381);
pub const __LDBL_MIN__ = @as(c_longdouble, 3.36210314311209350626e-4932);
pub const __POINTER_WIDTH__ = @as(c_int, 64);
pub const __BIGGEST_ALIGNMENT__ = @as(c_int, 16);
pub const __WCHAR_UNSIGNED__ = @as(c_int, 1);
pub const __WINT_UNSIGNED__ = @as(c_int, 1);
pub const __INT8_TYPE__ = i8;
pub const __INT8_FMTd__ = "hhd";
pub const __INT8_FMTi__ = "hhi";
pub const __INT8_C_SUFFIX__ = "";
pub const __INT16_TYPE__ = c_short;
pub const __INT16_FMTd__ = "hd";
pub const __INT16_FMTi__ = "hi";
pub const __INT16_C_SUFFIX__ = "";
pub const __INT32_TYPE__ = c_int;
pub const __INT32_FMTd__ = "d";
pub const __INT32_FMTi__ = "i";
pub const __INT32_C_SUFFIX__ = "";
pub const __INT64_TYPE__ = c_longlong;
pub const __INT64_FMTd__ = "lld";
pub const __INT64_FMTi__ = "lli";
pub const __UINT8_TYPE__ = u8;
pub const __UINT8_FMTo__ = "hho";
pub const __UINT8_FMTu__ = "hhu";
pub const __UINT8_FMTx__ = "hhx";
pub const __UINT8_FMTX__ = "hhX";
pub const __UINT8_C_SUFFIX__ = "";
pub const __UINT8_MAX__ = @as(c_int, 255);
pub const __INT8_MAX__ = @as(c_int, 127);
pub const __UINT16_TYPE__ = c_ushort;
pub const __UINT16_FMTo__ = "ho";
pub const __UINT16_FMTu__ = "hu";
pub const __UINT16_FMTx__ = "hx";
pub const __UINT16_FMTX__ = "hX";
pub const __UINT16_C_SUFFIX__ = "";
pub const __UINT16_MAX__ = std.zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __INT16_MAX__ = @as(c_int, 32767);
pub const __UINT32_TYPE__ = c_uint;
pub const __UINT32_FMTo__ = "o";
pub const __UINT32_FMTu__ = "u";
pub const __UINT32_FMTx__ = "x";
pub const __UINT32_FMTX__ = "X";
pub const __UINT32_MAX__ = std.zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __INT32_MAX__ = std.zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __UINT64_TYPE__ = c_ulonglong;
pub const __UINT64_FMTo__ = "llo";
pub const __UINT64_FMTu__ = "llu";
pub const __UINT64_FMTx__ = "llx";
pub const __UINT64_FMTX__ = "llX";
pub const __UINT64_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __INT64_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INT_LEAST8_TYPE__ = i8;
pub const __INT_LEAST8_MAX__ = @as(c_int, 127);
pub const __INT_LEAST8_WIDTH__ = @as(c_int, 8);
pub const __INT_LEAST8_FMTd__ = "hhd";
pub const __INT_LEAST8_FMTi__ = "hhi";
pub const __UINT_LEAST8_TYPE__ = u8;
pub const __UINT_LEAST8_MAX__ = @as(c_int, 255);
pub const __UINT_LEAST8_FMTo__ = "hho";
pub const __UINT_LEAST8_FMTu__ = "hhu";
pub const __UINT_LEAST8_FMTx__ = "hhx";
pub const __UINT_LEAST8_FMTX__ = "hhX";
pub const __INT_LEAST16_TYPE__ = c_short;
pub const __INT_LEAST16_MAX__ = @as(c_int, 32767);
pub const __INT_LEAST16_WIDTH__ = @as(c_int, 16);
pub const __INT_LEAST16_FMTd__ = "hd";
pub const __INT_LEAST16_FMTi__ = "hi";
pub const __UINT_LEAST16_TYPE__ = c_ushort;
pub const __UINT_LEAST16_MAX__ = std.zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_LEAST16_FMTo__ = "ho";
pub const __UINT_LEAST16_FMTu__ = "hu";
pub const __UINT_LEAST16_FMTx__ = "hx";
pub const __UINT_LEAST16_FMTX__ = "hX";
pub const __INT_LEAST32_TYPE__ = c_int;
pub const __INT_LEAST32_MAX__ = std.zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_LEAST32_WIDTH__ = @as(c_int, 32);
pub const __INT_LEAST32_FMTd__ = "d";
pub const __INT_LEAST32_FMTi__ = "i";
pub const __UINT_LEAST32_TYPE__ = c_uint;
pub const __UINT_LEAST32_MAX__ = std.zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_LEAST32_FMTo__ = "o";
pub const __UINT_LEAST32_FMTu__ = "u";
pub const __UINT_LEAST32_FMTx__ = "x";
pub const __UINT_LEAST32_FMTX__ = "X";
pub const __INT_LEAST64_TYPE__ = c_longlong;
pub const __INT_LEAST64_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INT_LEAST64_WIDTH__ = @as(c_int, 64);
pub const __INT_LEAST64_FMTd__ = "lld";
pub const __INT_LEAST64_FMTi__ = "lli";
pub const __UINT_LEAST64_TYPE__ = c_ulonglong;
pub const __UINT_LEAST64_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __UINT_LEAST64_FMTo__ = "llo";
pub const __UINT_LEAST64_FMTu__ = "llu";
pub const __UINT_LEAST64_FMTx__ = "llx";
pub const __UINT_LEAST64_FMTX__ = "llX";
pub const __INT_FAST8_TYPE__ = i8;
pub const __INT_FAST8_MAX__ = @as(c_int, 127);
pub const __INT_FAST8_WIDTH__ = @as(c_int, 8);
pub const __INT_FAST8_FMTd__ = "hhd";
pub const __INT_FAST8_FMTi__ = "hhi";
pub const __UINT_FAST8_TYPE__ = u8;
pub const __UINT_FAST8_MAX__ = @as(c_int, 255);
pub const __UINT_FAST8_FMTo__ = "hho";
pub const __UINT_FAST8_FMTu__ = "hhu";
pub const __UINT_FAST8_FMTx__ = "hhx";
pub const __UINT_FAST8_FMTX__ = "hhX";
pub const __INT_FAST16_TYPE__ = c_short;
pub const __INT_FAST16_MAX__ = @as(c_int, 32767);
pub const __INT_FAST16_WIDTH__ = @as(c_int, 16);
pub const __INT_FAST16_FMTd__ = "hd";
pub const __INT_FAST16_FMTi__ = "hi";
pub const __UINT_FAST16_TYPE__ = c_ushort;
pub const __UINT_FAST16_MAX__ = std.zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_FAST16_FMTo__ = "ho";
pub const __UINT_FAST16_FMTu__ = "hu";
pub const __UINT_FAST16_FMTx__ = "hx";
pub const __UINT_FAST16_FMTX__ = "hX";
pub const __INT_FAST32_TYPE__ = c_int;
pub const __INT_FAST32_MAX__ = std.zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_FAST32_WIDTH__ = @as(c_int, 32);
pub const __INT_FAST32_FMTd__ = "d";
pub const __INT_FAST32_FMTi__ = "i";
pub const __UINT_FAST32_TYPE__ = c_uint;
pub const __UINT_FAST32_MAX__ = std.zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_FAST32_FMTo__ = "o";
pub const __UINT_FAST32_FMTu__ = "u";
pub const __UINT_FAST32_FMTx__ = "x";
pub const __UINT_FAST32_FMTX__ = "X";
pub const __INT_FAST64_TYPE__ = c_longlong;
pub const __INT_FAST64_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INT_FAST64_WIDTH__ = @as(c_int, 64);
pub const __INT_FAST64_FMTd__ = "lld";
pub const __INT_FAST64_FMTi__ = "lli";
pub const __UINT_FAST64_TYPE__ = c_ulonglong;
pub const __UINT_FAST64_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __UINT_FAST64_FMTo__ = "llo";
pub const __UINT_FAST64_FMTu__ = "llu";
pub const __UINT_FAST64_FMTx__ = "llx";
pub const __UINT_FAST64_FMTX__ = "llX";
pub const __USER_LABEL_PREFIX__ = "";
pub const __FINITE_MATH_ONLY__ = @as(c_int, 0);
pub const __GNUC_STDC_INLINE__ = @as(c_int, 1);
pub const __GCC_ATOMIC_TEST_AND_SET_TRUEVAL = @as(c_int, 1);
pub const __CLANG_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __NO_INLINE__ = @as(c_int, 1);
pub const __PIC__ = @as(c_int, 2);
pub const __pic__ = @as(c_int, 2);
pub const __FLT_RADIX__ = @as(c_int, 2);
pub const __DECIMAL_DIG__ = __LDBL_DECIMAL_DIG__;
pub const __GCC_ASM_FLAG_OUTPUTS__ = @as(c_int, 1);
pub const __code_model_small__ = @as(c_int, 1);
pub const __amd64__ = @as(c_int, 1);
pub const __amd64 = @as(c_int, 1);
pub const __x86_64 = @as(c_int, 1);
pub const __x86_64__ = @as(c_int, 1);
pub const __SEG_GS = @as(c_int, 1);
pub const __SEG_FS = @as(c_int, 1);
pub const __k8 = @as(c_int, 1);
pub const __k8__ = @as(c_int, 1);
pub const __tune_k8__ = @as(c_int, 1);
pub const __REGISTER_PREFIX__ = "";
pub const __NO_MATH_INLINES = @as(c_int, 1);
pub const __AES__ = @as(c_int, 1);
pub const __PCLMUL__ = @as(c_int, 1);
pub const __LAHF_SAHF__ = @as(c_int, 1);
pub const __LZCNT__ = @as(c_int, 1);
pub const __RDRND__ = @as(c_int, 1);
pub const __FSGSBASE__ = @as(c_int, 1);
pub const __BMI__ = @as(c_int, 1);
pub const __BMI2__ = @as(c_int, 1);
pub const __POPCNT__ = @as(c_int, 1);
pub const __PRFCHW__ = @as(c_int, 1);
pub const __RDSEED__ = @as(c_int, 1);
pub const __ADX__ = @as(c_int, 1);
pub const __MOVBE__ = @as(c_int, 1);
pub const __FMA__ = @as(c_int, 1);
pub const __F16C__ = @as(c_int, 1);
pub const __FXSR__ = @as(c_int, 1);
pub const __XSAVE__ = @as(c_int, 1);
pub const __XSAVEOPT__ = @as(c_int, 1);
pub const __XSAVEC__ = @as(c_int, 1);
pub const __XSAVES__ = @as(c_int, 1);
pub const __CLFLUSHOPT__ = @as(c_int, 1);
pub const __SGX__ = @as(c_int, 1);
pub const __INVPCID__ = @as(c_int, 1);
pub const __AVX2__ = @as(c_int, 1);
pub const __AVX__ = @as(c_int, 1);
pub const __SSE4_2__ = @as(c_int, 1);
pub const __SSE4_1__ = @as(c_int, 1);
pub const __SSSE3__ = @as(c_int, 1);
pub const __SSE3__ = @as(c_int, 1);
pub const __SSE2__ = @as(c_int, 1);
pub const __SSE2_MATH__ = @as(c_int, 1);
pub const __SSE__ = @as(c_int, 1);
pub const __SSE_MATH__ = @as(c_int, 1);
pub const __MMX__ = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_16 = @as(c_int, 1);
pub const __SIZEOF_FLOAT128__ = @as(c_int, 16);
pub const _WIN32 = @as(c_int, 1);
pub const _WIN64 = @as(c_int, 1);
pub const WIN32 = @as(c_int, 1);
pub const __WIN32 = @as(c_int, 1);
pub const __WIN32__ = @as(c_int, 1);
pub const WINNT = @as(c_int, 1);
pub const __WINNT = @as(c_int, 1);
pub const __WINNT__ = @as(c_int, 1);
pub const WIN64 = @as(c_int, 1);
pub const __WIN64 = @as(c_int, 1);
pub const __WIN64__ = @as(c_int, 1);
pub const __MINGW64__ = @as(c_int, 1);
pub const __MSVCRT__ = @as(c_int, 1);
pub const __MINGW32__ = @as(c_int, 1);
pub const __STDC__ = @as(c_int, 1);
pub const __STDC_HOSTED__ = @as(c_int, 1);
pub const __STDC_VERSION__ = @as(c_long, 201710);
pub const __STDC_UTF_16__ = @as(c_int, 1);
pub const __STDC_UTF_32__ = @as(c_int, 1);
pub const _WIN32_WINNT = @as(c_int, 0x0a00);
pub const _DEBUG = @as(c_int, 1);
pub const OPENSL_ES_ANDROID_H_ = "";
pub const OPENSL_ES_H_ = "";
pub const _OPENSLES_PLATFORM_H_ = "";
pub const SL_API = "";
pub const SLAPIENTRY = "";
pub const _KHRONOS_KEYS_ = "";
pub const KHRONOS_TITLE = "KhronosTitle";
pub const KHRONOS_ALBUM = "KhronosAlbum";
pub const KHRONOS_TRACK_NUMBER = "KhronosTrackNumber";
pub const KHRONOS_ARTIST = "KhronosArtist";
pub const KHRONOS_GENRE = "KhronosGenre";
pub const KHRONOS_YEAR = "KhronosYear";
pub const KHRONOS_COMMENT = "KhronosComment";
pub const KHRONOS_ARTIST_URL = "KhronosArtistURL";
pub const KHRONOS_CONTENT_URL = "KhronosContentURL";
pub const KHRONOS_RATING = "KhronosRating";
pub const KHRONOS_ALBUM_ART = "KhronosAlbumArt";
pub const KHRONOS_COPYRIGHT = "KhronosCopyright";
pub const SL_BOOLEAN_FALSE = std.zig.c_translation.cast(SLboolean, @as(c_int, 0x00000000));
pub const SL_BOOLEAN_TRUE = std.zig.c_translation.cast(SLboolean, @as(c_int, 0x00000001));
pub const SL_MILLIBEL_MAX = std.zig.c_translation.cast(SLmillibel, @as(c_int, 0x7FFF));
pub const SL_MILLIBEL_MIN = std.zig.c_translation.cast(SLmillibel, -SL_MILLIBEL_MAX - @as(c_int, 1));
pub const SL_MILLIHERTZ_MAX = std.zig.c_translation.cast(SLmilliHertz, std.zig.c_translation.promoteIntLiteral(c_int, 0xFFFFFFFF, .hex));
pub const SL_MILLIMETER_MAX = std.zig.c_translation.cast(SLmillimeter, std.zig.c_translation.promoteIntLiteral(c_int, 0x7FFFFFFF, .hex));
pub const SL_OBJECTID_ENGINE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00001001));
pub const SL_OBJECTID_LEDDEVICE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00001002));
pub const SL_OBJECTID_VIBRADEVICE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00001003));
pub const SL_OBJECTID_AUDIOPLAYER = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00001004));
pub const SL_OBJECTID_AUDIORECORDER = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00001005));
pub const SL_OBJECTID_MIDIPLAYER = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00001006));
pub const SL_OBJECTID_LISTENER = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00001007));
pub const SL_OBJECTID_3DGROUP = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00001008));
pub const SL_OBJECTID_OUTPUTMIX = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00001009));
pub const SL_OBJECTID_METADATAEXTRACTOR = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000100A));
pub const SL_PROFILES_PHONE = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0001));
pub const SL_PROFILES_MUSIC = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0002));
pub const SL_PROFILES_GAME = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0004));
pub const SL_VOICETYPE_2D_AUDIO = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0001));
pub const SL_VOICETYPE_MIDI = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0002));
pub const SL_VOICETYPE_3D_AUDIO = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0004));
pub const SL_VOICETYPE_3D_MIDIOUTPUT = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0008));
pub const SL_PRIORITY_LOWEST = std.zig.c_translation.cast(SLint32, -std.zig.c_translation.promoteIntLiteral(c_int, 0x7FFFFFFF, .hex) - @as(c_int, 1));
pub const SL_PRIORITY_VERYLOW = std.zig.c_translation.cast(SLint32, -std.zig.c_translation.promoteIntLiteral(c_int, 0x60000000, .hex));
pub const SL_PRIORITY_LOW = std.zig.c_translation.cast(SLint32, -std.zig.c_translation.promoteIntLiteral(c_int, 0x40000000, .hex));
pub const SL_PRIORITY_BELOWNORMAL = std.zig.c_translation.cast(SLint32, -std.zig.c_translation.promoteIntLiteral(c_int, 0x20000000, .hex));
pub const SL_PRIORITY_NORMAL = std.zig.c_translation.cast(SLint32, @as(c_int, 0x00000000));
pub const SL_PRIORITY_ABOVENORMAL = std.zig.c_translation.cast(SLint32, std.zig.c_translation.promoteIntLiteral(c_int, 0x20000000, .hex));
pub const SL_PRIORITY_HIGH = std.zig.c_translation.cast(SLint32, std.zig.c_translation.promoteIntLiteral(c_int, 0x40000000, .hex));
pub const SL_PRIORITY_VERYHIGH = std.zig.c_translation.cast(SLint32, std.zig.c_translation.promoteIntLiteral(c_int, 0x60000000, .hex));
pub const SL_PRIORITY_HIGHEST = std.zig.c_translation.cast(SLint32, std.zig.c_translation.promoteIntLiteral(c_int, 0x7FFFFFFF, .hex));
pub const SL_PCMSAMPLEFORMAT_FIXED_8 = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0008));
pub const SL_PCMSAMPLEFORMAT_FIXED_16 = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0010));
pub const SL_PCMSAMPLEFORMAT_FIXED_20 = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0014));
pub const SL_PCMSAMPLEFORMAT_FIXED_24 = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0018));
pub const SL_PCMSAMPLEFORMAT_FIXED_28 = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x001C));
pub const SL_PCMSAMPLEFORMAT_FIXED_32 = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0020));
pub const SL_SAMPLINGRATE_8 = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 8000000, .decimal));
pub const SL_SAMPLINGRATE_11_025 = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 11025000, .decimal));
pub const SL_SAMPLINGRATE_12 = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 12000000, .decimal));
pub const SL_SAMPLINGRATE_16 = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 16000000, .decimal));
pub const SL_SAMPLINGRATE_22_05 = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 22050000, .decimal));
pub const SL_SAMPLINGRATE_24 = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 24000000, .decimal));
pub const SL_SAMPLINGRATE_32 = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 32000000, .decimal));
pub const SL_SAMPLINGRATE_44_1 = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 44100000, .decimal));
pub const SL_SAMPLINGRATE_48 = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 48000000, .decimal));
pub const SL_SAMPLINGRATE_64 = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 64000000, .decimal));
pub const SL_SAMPLINGRATE_88_2 = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 88200000, .decimal));
pub const SL_SAMPLINGRATE_96 = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 96000000, .decimal));
pub const SL_SAMPLINGRATE_192 = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 192000000, .decimal));
pub const SL_SPEAKER_FRONT_LEFT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_SPEAKER_FRONT_RIGHT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_SPEAKER_FRONT_CENTER = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_SPEAKER_LOW_FREQUENCY = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000008));
pub const SL_SPEAKER_BACK_LEFT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000010));
pub const SL_SPEAKER_BACK_RIGHT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000020));
pub const SL_SPEAKER_FRONT_LEFT_OF_CENTER = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000040));
pub const SL_SPEAKER_FRONT_RIGHT_OF_CENTER = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000080));
pub const SL_SPEAKER_BACK_CENTER = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000100));
pub const SL_SPEAKER_SIDE_LEFT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000200));
pub const SL_SPEAKER_SIDE_RIGHT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000400));
pub const SL_SPEAKER_TOP_CENTER = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000800));
pub const SL_SPEAKER_TOP_FRONT_LEFT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00001000));
pub const SL_SPEAKER_TOP_FRONT_CENTER = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00002000));
pub const SL_SPEAKER_TOP_FRONT_RIGHT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00004000));
pub const SL_SPEAKER_TOP_BACK_LEFT = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 0x00008000, .hex));
pub const SL_SPEAKER_TOP_BACK_CENTER = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 0x00010000, .hex));
pub const SL_SPEAKER_TOP_BACK_RIGHT = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 0x00020000, .hex));
pub const SL_RESULT_SUCCESS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000000));
pub const SL_RESULT_PRECONDITIONS_VIOLATED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_RESULT_PARAMETER_INVALID = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_RESULT_MEMORY_FAILURE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_RESULT_RESOURCE_ERROR = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_RESULT_RESOURCE_LOST = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000005));
pub const SL_RESULT_IO_ERROR = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000006));
pub const SL_RESULT_BUFFER_INSUFFICIENT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000007));
pub const SL_RESULT_CONTENT_CORRUPTED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000008));
pub const SL_RESULT_CONTENT_UNSUPPORTED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000009));
pub const SL_RESULT_CONTENT_NOT_FOUND = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000A));
pub const SL_RESULT_PERMISSION_DENIED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000B));
pub const SL_RESULT_FEATURE_UNSUPPORTED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000C));
pub const SL_RESULT_INTERNAL_ERROR = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000D));
pub const SL_RESULT_UNKNOWN_ERROR = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000E));
pub const SL_RESULT_OPERATION_ABORTED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000F));
pub const SL_RESULT_CONTROL_LOST = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000010));
pub const SL_OBJECT_STATE_UNREALIZED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_OBJECT_STATE_REALIZED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_OBJECT_STATE_SUSPENDED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_OBJECT_EVENT_RUNTIME_ERROR = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_OBJECT_EVENT_ASYNC_TERMINATION = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_OBJECT_EVENT_RESOURCES_LOST = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_OBJECT_EVENT_RESOURCES_AVAILABLE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_OBJECT_EVENT_ITF_CONTROL_TAKEN = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000005));
pub const SL_OBJECT_EVENT_ITF_CONTROL_RETURNED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000006));
pub const SL_OBJECT_EVENT_ITF_PARAMETERS_CHANGED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000007));
pub const SL_DATALOCATOR_URI = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_DATALOCATOR_ADDRESS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_DATALOCATOR_IODEVICE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_DATALOCATOR_OUTPUTMIX = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_DATALOCATOR_RESERVED5 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000005));
pub const SL_DATALOCATOR_BUFFERQUEUE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000006));
pub const SL_DATALOCATOR_MIDIBUFFERQUEUE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000007));
pub const SL_DATALOCATOR_RESERVED8 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000008));
pub const SL_IODEVICE_AUDIOINPUT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_IODEVICE_LEDARRAY = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_IODEVICE_VIBRA = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_IODEVICE_RESERVED4 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_IODEVICE_RESERVED5 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000005));
pub const SL_DATAFORMAT_MIME = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_DATAFORMAT_PCM = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_DATAFORMAT_RESERVED3 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_BYTEORDER_BIGENDIAN = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_BYTEORDER_LITTLEENDIAN = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_CONTAINERTYPE_UNSPECIFIED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_CONTAINERTYPE_RAW = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_CONTAINERTYPE_ASF = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_CONTAINERTYPE_AVI = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_CONTAINERTYPE_BMP = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000005));
pub const SL_CONTAINERTYPE_JPG = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000006));
pub const SL_CONTAINERTYPE_JPG2000 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000007));
pub const SL_CONTAINERTYPE_M4A = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000008));
pub const SL_CONTAINERTYPE_MP3 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000009));
pub const SL_CONTAINERTYPE_MP4 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000A));
pub const SL_CONTAINERTYPE_MPEG_ES = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000B));
pub const SL_CONTAINERTYPE_MPEG_PS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000C));
pub const SL_CONTAINERTYPE_MPEG_TS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000D));
pub const SL_CONTAINERTYPE_QT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000E));
pub const SL_CONTAINERTYPE_WAV = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000F));
pub const SL_CONTAINERTYPE_XMF_0 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000010));
pub const SL_CONTAINERTYPE_XMF_1 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000011));
pub const SL_CONTAINERTYPE_XMF_2 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000012));
pub const SL_CONTAINERTYPE_XMF_3 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000013));
pub const SL_CONTAINERTYPE_XMF_GENERIC = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000014));
pub const SL_CONTAINERTYPE_AMR = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000015));
pub const SL_CONTAINERTYPE_AAC = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000016));
pub const SL_CONTAINERTYPE_3GPP = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000017));
pub const SL_CONTAINERTYPE_3GA = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000018));
pub const SL_CONTAINERTYPE_RM = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000019));
pub const SL_CONTAINERTYPE_DMF = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000001A));
pub const SL_CONTAINERTYPE_SMF = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000001B));
pub const SL_CONTAINERTYPE_MOBILE_DLS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000001C));
pub const SL_CONTAINERTYPE_OGG = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000001D));
pub const SL_DEFAULTDEVICEID_AUDIOINPUT = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 0xFFFFFFFF, .hex));
pub const SL_DEFAULTDEVICEID_AUDIOOUTPUT = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 0xFFFFFFFE, .hex));
pub const SL_DEFAULTDEVICEID_LED = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 0xFFFFFFFD, .hex));
pub const SL_DEFAULTDEVICEID_VIBRA = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 0xFFFFFFFC, .hex));
pub const SL_DEFAULTDEVICEID_RESERVED1 = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 0xFFFFFFFB, .hex));
pub const SL_DEVCONNECTION_INTEGRATED = std.zig.c_translation.cast(SLint16, @as(c_int, 0x0001));
pub const SL_DEVCONNECTION_ATTACHED_WIRED = std.zig.c_translation.cast(SLint16, @as(c_int, 0x0100));
pub const SL_DEVCONNECTION_ATTACHED_WIRELESS = std.zig.c_translation.cast(SLint16, @as(c_int, 0x0200));
pub const SL_DEVCONNECTION_NETWORK = std.zig.c_translation.cast(SLint16, @as(c_int, 0x0400));
pub const SL_DEVLOCATION_HANDSET = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0001));
pub const SL_DEVLOCATION_HEADSET = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0002));
pub const SL_DEVLOCATION_CARKIT = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0003));
pub const SL_DEVLOCATION_DOCK = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0004));
pub const SL_DEVLOCATION_REMOTE = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0005));
pub const SL_DEVLOCATION_RESLTE = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0005));
pub const SL_DEVSCOPE_UNKNOWN = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0001));
pub const SL_DEVSCOPE_ENVIRONMENT = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0002));
pub const SL_DEVSCOPE_USER = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0003));
pub const SL_CHARACTERENCODING_UNKNOWN = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000000));
pub const SL_CHARACTERENCODING_BINARY = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_CHARACTERENCODING_ASCII = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_CHARACTERENCODING_BIG5 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_CHARACTERENCODING_CODEPAGE1252 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_CHARACTERENCODING_GB2312 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000005));
pub const SL_CHARACTERENCODING_HZGB2312 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000006));
pub const SL_CHARACTERENCODING_GB12345 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000007));
pub const SL_CHARACTERENCODING_GB18030 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000008));
pub const SL_CHARACTERENCODING_GBK = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000009));
pub const SL_CHARACTERENCODING_IMAPUTF7 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000A));
pub const SL_CHARACTERENCODING_ISO2022JP = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000B));
pub const SL_CHARACTERENCODING_ISO2022JP1 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000B));
pub const SL_CHARACTERENCODING_ISO88591 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000C));
pub const SL_CHARACTERENCODING_ISO885910 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000D));
pub const SL_CHARACTERENCODING_ISO885913 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000E));
pub const SL_CHARACTERENCODING_ISO885914 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000F));
pub const SL_CHARACTERENCODING_ISO885915 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000010));
pub const SL_CHARACTERENCODING_ISO88592 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000011));
pub const SL_CHARACTERENCODING_ISO88593 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000012));
pub const SL_CHARACTERENCODING_ISO88594 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000013));
pub const SL_CHARACTERENCODING_ISO88595 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000014));
pub const SL_CHARACTERENCODING_ISO88596 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000015));
pub const SL_CHARACTERENCODING_ISO88597 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000016));
pub const SL_CHARACTERENCODING_ISO88598 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000017));
pub const SL_CHARACTERENCODING_ISO88599 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000018));
pub const SL_CHARACTERENCODING_ISOEUCJP = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000019));
pub const SL_CHARACTERENCODING_SHIFTJIS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000001A));
pub const SL_CHARACTERENCODING_SMS7BIT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000001B));
pub const SL_CHARACTERENCODING_UTF7 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000001C));
pub const SL_CHARACTERENCODING_UTF8 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000001D));
pub const SL_CHARACTERENCODING_JAVACONFORMANTUTF8 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000001E));
pub const SL_CHARACTERENCODING_UTF16BE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000001F));
pub const SL_CHARACTERENCODING_UTF16LE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000020));
pub const SL_METADATA_FILTER_KEY = std.zig.c_translation.cast(SLuint8, @as(c_int, 0x01));
pub const SL_METADATA_FILTER_LANG = std.zig.c_translation.cast(SLuint8, @as(c_int, 0x02));
pub const SL_METADATA_FILTER_ENCODING = std.zig.c_translation.cast(SLuint8, @as(c_int, 0x04));
pub const SL_METADATATRAVERSALMODE_ALL = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_METADATATRAVERSALMODE_NODE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_NODETYPE_UNSPECIFIED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_NODETYPE_AUDIO = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_NODETYPE_VIDEO = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_NODETYPE_IMAGE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_NODE_PARENT = std.zig.c_translation.promoteIntLiteral(c_int, 0xFFFFFFFF, .hex);
pub const SL_PLAYSTATE_STOPPED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_PLAYSTATE_PAUSED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_PLAYSTATE_PLAYING = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_PLAYEVENT_HEADATEND = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_PLAYEVENT_HEADATMARKER = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_PLAYEVENT_HEADATNEWPOS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_PLAYEVENT_HEADMOVING = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000008));
pub const SL_PLAYEVENT_HEADSTALLED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000010));
pub const SL_TIME_UNKNOWN = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 0xFFFFFFFF, .hex));
pub const SL_PREFETCHEVENT_STATUSCHANGE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_PREFETCHEVENT_FILLLEVELCHANGE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_PREFETCHSTATUS_UNDERFLOW = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_PREFETCHSTATUS_SUFFICIENTDATA = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_PREFETCHSTATUS_OVERFLOW = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_RATEPROP_RESERVED1 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_RATEPROP_RESERVED2 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_RATEPROP_SILENTAUDIO = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000100));
pub const SL_RATEPROP_STAGGEREDAUDIO = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000200));
pub const SL_RATEPROP_NOPITCHCORAUDIO = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000400));
pub const SL_RATEPROP_PITCHCORAUDIO = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000800));
pub const SL_SEEKMODE_FAST = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0001));
pub const SL_SEEKMODE_ACCURATE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0002));
pub const SL_RECORDSTATE_STOPPED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_RECORDSTATE_PAUSED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_RECORDSTATE_RECORDING = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_RECORDEVENT_HEADATLIMIT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_RECORDEVENT_HEADATMARKER = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_RECORDEVENT_HEADATNEWPOS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_RECORDEVENT_HEADMOVING = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000008));
pub const SL_RECORDEVENT_HEADSTALLED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000010));
pub const SL_RECORDEVENT_BUFFER_INSUFFICIENT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000020));
pub const SL_RECORDEVENT_BUFFER_FULL = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000020));
pub const SL_EQUALIZER_UNDEFINED = std.zig.c_translation.cast(SLuint16, std.zig.c_translation.promoteIntLiteral(c_int, 0xFFFF, .hex));
pub const SL_REVERBPRESET_NONE = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0000));
pub const SL_REVERBPRESET_SMALLROOM = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0001));
pub const SL_REVERBPRESET_MEDIUMROOM = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0002));
pub const SL_REVERBPRESET_LARGEROOM = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0003));
pub const SL_REVERBPRESET_MEDIUMHALL = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0004));
pub const SL_REVERBPRESET_LARGEHALL = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0005));
pub const SL_REVERBPRESET_PLATE = std.zig.c_translation.cast(SLuint16, @as(c_int, 0x0006));
pub const SL_ROLLOFFMODEL_EXPONENTIAL = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000000));
pub const SL_ROLLOFFMODEL_LINEAR = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_DYNAMIC_ITF_EVENT_RUNTIME_ERROR = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_DYNAMIC_ITF_EVENT_ASYNC_TERMINATION = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_DYNAMIC_ITF_EVENT_RESOURCES_LOST = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_DYNAMIC_ITF_EVENT_RESOURCES_LOST_PERMANENTLY = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_DYNAMIC_ITF_EVENT_RESOURCES_AVAILABLE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000005));
pub const SL_MIDIMESSAGETYPE_NOTE_ON_OFF = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_MIDIMESSAGETYPE_POLY_PRESSURE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_MIDIMESSAGETYPE_CONTROL_CHANGE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_MIDIMESSAGETYPE_PROGRAM_CHANGE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_MIDIMESSAGETYPE_CHANNEL_PRESSURE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000005));
pub const SL_MIDIMESSAGETYPE_PITCH_BEND = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000006));
pub const SL_MIDIMESSAGETYPE_SYSTEM_MESSAGE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000007));
pub const SL_RATECONTROLMODE_CONSTANTBITRATE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_RATECONTROLMODE_VARIABLEBITRATE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_AUDIOCODEC_PCM = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOCODEC_MP3 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_AUDIOCODEC_AMR = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_AUDIOCODEC_AMRWB = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_AUDIOCODEC_AMRWBPLUS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000005));
pub const SL_AUDIOCODEC_AAC = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000006));
pub const SL_AUDIOCODEC_WMA = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000007));
pub const SL_AUDIOCODEC_REAL = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000008));
pub const SL_AUDIOPROFILE_PCM = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOPROFILE_MPEG1_L3 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOPROFILE_MPEG2_L3 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_AUDIOPROFILE_MPEG25_L3 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_AUDIOCHANMODE_MP3_MONO = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOCHANMODE_MP3_STEREO = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_AUDIOCHANMODE_MP3_JOINTSTEREO = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_AUDIOCHANMODE_MP3_DUAL = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_AUDIOPROFILE_AMR = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOSTREAMFORMAT_CONFORMANCE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOSTREAMFORMAT_IF1 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_AUDIOSTREAMFORMAT_IF2 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_AUDIOSTREAMFORMAT_FSF = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_AUDIOSTREAMFORMAT_RTPPAYLOAD = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000005));
pub const SL_AUDIOSTREAMFORMAT_ITU = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000006));
pub const SL_AUDIOPROFILE_AMRWB = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOPROFILE_AMRWBPLUS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOPROFILE_AAC_AAC = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOMODE_AAC_MAIN = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOMODE_AAC_LC = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_AUDIOMODE_AAC_SSR = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_AUDIOMODE_AAC_LTP = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_AUDIOMODE_AAC_HE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000005));
pub const SL_AUDIOMODE_AAC_SCALABLE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000006));
pub const SL_AUDIOMODE_AAC_ERLC = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000007));
pub const SL_AUDIOMODE_AAC_LD = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000008));
pub const SL_AUDIOMODE_AAC_HE_PS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000009));
pub const SL_AUDIOMODE_AAC_HE_MPS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x0000000A));
pub const SL_AUDIOSTREAMFORMAT_MP2ADTS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOSTREAMFORMAT_MP4ADTS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_AUDIOSTREAMFORMAT_MP4LOAS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_AUDIOSTREAMFORMAT_MP4LATM = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_AUDIOSTREAMFORMAT_ADIF = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000005));
pub const SL_AUDIOSTREAMFORMAT_MP4FF = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000006));
pub const SL_AUDIOSTREAMFORMAT_RAW = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000007));
pub const SL_AUDIOPROFILE_WMA7 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOPROFILE_WMA8 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_AUDIOPROFILE_WMA9 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_AUDIOPROFILE_WMA10 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_AUDIOMODE_WMA_LEVEL1 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOMODE_WMA_LEVEL2 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_AUDIOMODE_WMA_LEVEL3 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_AUDIOMODE_WMA_LEVEL4 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_AUDIOMODE_WMAPRO_LEVELM0 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000005));
pub const SL_AUDIOMODE_WMAPRO_LEVELM1 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000006));
pub const SL_AUDIOMODE_WMAPRO_LEVELM2 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000007));
pub const SL_AUDIOMODE_WMAPRO_LEVELM3 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000008));
pub const SL_AUDIOPROFILE_REALAUDIO = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOMODE_REALAUDIO_G2 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_AUDIOMODE_REALAUDIO_8 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_AUDIOMODE_REALAUDIO_10 = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_AUDIOMODE_REALAUDIO_SURROUND = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_ENGINEOPTION_THREADSAFE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_ENGINEOPTION_LOSSOFCONTROL = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const OPENSL_ES_ANDROIDCONFIGURATION_H_ = "";
pub const SL_ANDROID_RECORDING_PRESET_NONE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000000));
pub const SL_ANDROID_RECORDING_PRESET_GENERIC = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_ANDROID_RECORDING_PRESET_CAMCORDER = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_ANDROID_RECORDING_PRESET_VOICE_RECOGNITION = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_ANDROID_RECORDING_PRESET_VOICE_COMMUNICATION = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_ANDROID_RECORDING_PRESET_UNPROCESSED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000005));
pub const SL_ANDROID_STREAM_VOICE = std.zig.c_translation.cast(SLint32, @as(c_int, 0x00000000));
pub const SL_ANDROID_STREAM_SYSTEM = std.zig.c_translation.cast(SLint32, @as(c_int, 0x00000001));
pub const SL_ANDROID_STREAM_RING = std.zig.c_translation.cast(SLint32, @as(c_int, 0x00000002));
pub const SL_ANDROID_STREAM_MEDIA = std.zig.c_translation.cast(SLint32, @as(c_int, 0x00000003));
pub const SL_ANDROID_STREAM_ALARM = std.zig.c_translation.cast(SLint32, @as(c_int, 0x00000004));
pub const SL_ANDROID_STREAM_NOTIFICATION = std.zig.c_translation.cast(SLint32, @as(c_int, 0x00000005));
pub const SL_ANDROID_PERFORMANCE_NONE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000000));
pub const SL_ANDROID_PERFORMANCE_LATENCY = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_ANDROID_PERFORMANCE_LATENCY_EFFECTS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_ANDROID_PERFORMANCE_POWER_SAVING = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const OPENSL_ES_ANDROIDMETADATA_H_ = "";
pub const ANDROID_KEY_PCMFORMAT_NUMCHANNELS = "AndroidPcmFormatNumChannels";
pub const ANDROID_KEY_PCMFORMAT_SAMPLERATE = "AndroidPcmFormatSampleRate";
pub const ANDROID_KEY_PCMFORMAT_BITSPERSAMPLE = "AndroidPcmFormatBitsPerSample";
pub const ANDROID_KEY_PCMFORMAT_CONTAINERSIZE = "AndroidPcmFormatContainerSize";
pub const ANDROID_KEY_PCMFORMAT_CHANNELMASK = "AndroidPcmFormatChannelMask";
pub const ANDROID_KEY_PCMFORMAT_ENDIANNESS = "AndroidPcmFormatEndianness";
pub const __GNUC_VA_LIST = "";
pub const __STDARG_H = "";
pub const _VA_LIST = "";
pub const _STDINT_H = "";
pub const __BIONIC__ = @as(c_int, 1);
pub const __BEGIN_DECLS = "";
pub const __END_DECLS = "";
pub inline fn __BIONIC_CAST(_k: anytype, _t: anytype, _v: anytype) @TypeOf(_t(_v)) {
    _ = &_k;
    _ = &_t;
    _ = &_v;
    return _t(_v);
}
pub inline fn __BIONIC_ALIGN(__value: anytype, __alignment: anytype) @TypeOf(((__value + __alignment) - @as(c_int, 1)) & ~(__alignment - @as(c_int, 1))) {
    _ = &__value;
    _ = &__alignment;
    return ((__value + __alignment) - @as(c_int, 1)) & ~(__alignment - @as(c_int, 1));
}
pub inline fn __P(protos: anytype) @TypeOf(protos) {
    _ = &protos;
    return protos;
}
pub inline fn __CONCAT(x: anytype, y: anytype) @TypeOf(__CONCAT1(x, y)) {
    _ = &x;
    _ = &y;
    return __CONCAT1(x, y);
}
pub inline fn ___CONCAT(x: anytype, y: anytype) @TypeOf(__CONCAT(x, y)) {
    _ = &x;
    _ = &y;
    return __CONCAT(x, y);
}
pub inline fn ___STRING(x: anytype) @TypeOf(__STRING(x)) {
    _ = &x;
    return __STRING(x);
}
pub inline fn __predict_true(exp: anytype) @TypeOf(__builtin_expect(exp != @as(c_int, 0), @as(c_int, 1))) {
    _ = &exp;
    return __builtin_expect(exp != @as(c_int, 0), @as(c_int, 1));
}
pub inline fn __predict_false(exp: anytype) @TypeOf(__builtin_expect(exp != @as(c_int, 0), @as(c_int, 0))) {
    _ = &exp;
    return __builtin_expect(exp != @as(c_int, 0), @as(c_int, 0));
}
pub const __WORDSIZE = @as(c_int, 32);
pub const __BIONIC_FORTIFY_UNKNOWN_SIZE = std.zig.c_translation.cast(usize, -@as(c_int, 1));
pub const __bos_level = @as(c_int, 0);
pub inline fn __bosn(s: anytype, n: anytype) @TypeOf(__builtin_object_size(s, n)) {
    _ = &s;
    _ = &n;
    return __builtin_object_size(s, n);
}
pub inline fn __bos(s: anytype) @TypeOf(__bosn(s, __bos_level)) {
    _ = &s;
    return __bosn(s, __bos_level);
}
pub const __pass_object_size = __pass_object_size_n(__bos_level);
pub const __pass_object_size0 = __pass_object_size_n(@as(c_int, 0));
pub inline fn __bos_unevaluated_lt(bos_val: anytype, val: anytype) @TypeOf((bos_val != __BIONIC_FORTIFY_UNKNOWN_SIZE) and (bos_val < val)) {
    _ = &bos_val;
    _ = &val;
    return (bos_val != __BIONIC_FORTIFY_UNKNOWN_SIZE) and (bos_val < val);
}
pub inline fn __bos_unevaluated_le(bos_val: anytype, val: anytype) @TypeOf((bos_val != __BIONIC_FORTIFY_UNKNOWN_SIZE) and (bos_val <= val)) {
    _ = &bos_val;
    _ = &val;
    return (bos_val != __BIONIC_FORTIFY_UNKNOWN_SIZE) and (bos_val <= val);
}
pub inline fn __bos_dynamic_check_impl_and(bos_val: anytype, op: anytype, index: anytype, cond: anytype) @TypeOf((bos_val == __BIONIC_FORTIFY_UNKNOWN_SIZE) or (((__builtin_constant_p(index) != 0) and ((bos_val ++ op ++ index) != 0)) and (cond != 0))) {
    _ = &bos_val;
    _ = &op;
    _ = &index;
    _ = &cond;
    return (bos_val == __BIONIC_FORTIFY_UNKNOWN_SIZE) or (((__builtin_constant_p(index) != 0) and ((bos_val ++ op ++ index) != 0)) and (cond != 0));
}
pub inline fn __bos_dynamic_check_impl(bos_val: anytype, op: anytype, index: anytype) @TypeOf(__bos_dynamic_check_impl_and(bos_val, op, index, @as(c_int, 1))) {
    _ = &bos_val;
    _ = &op;
    _ = &index;
    return __bos_dynamic_check_impl_and(bos_val, op, index, @as(c_int, 1));
}
pub inline fn __unsafe_check_mul_overflow(x: anytype, y: anytype) @TypeOf((__SIZE_TYPE__ - std.zig.c_translation.MacroArithmetic.div(@as(c_int, 1), x)) < y) {
    _ = &x;
    _ = &y;
    return (__SIZE_TYPE__ - std.zig.c_translation.MacroArithmetic.div(@as(c_int, 1), x)) < y;
}
pub const __VERSIONER_NO_GUARD = "";
pub const __VERSIONER_FORTIFY_INLINE = "";
pub const __ANDROID_API_FUTURE__ = @as(c_int, 10000);
pub const __ANDROID_API__ = __ANDROID_API_FUTURE__;
pub const __ANDROID_API_G__ = @as(c_int, 9);
pub const __ANDROID_API_I__ = @as(c_int, 14);
pub const __ANDROID_API_J__ = @as(c_int, 16);
pub const __ANDROID_API_J_MR1__ = @as(c_int, 17);
pub const __ANDROID_API_J_MR2__ = @as(c_int, 18);
pub const __ANDROID_API_K__ = @as(c_int, 19);
pub const __ANDROID_API_L__ = @as(c_int, 21);
pub const __ANDROID_API_L_MR1__ = @as(c_int, 22);
pub const __ANDROID_API_M__ = @as(c_int, 23);
pub const __ANDROID_API_N__ = @as(c_int, 24);
pub const __ANDROID_API_N_MR1__ = @as(c_int, 25);
pub const __ANDROID_API_O__ = @as(c_int, 26);
pub const __ANDROID_API_O_MR1__ = @as(c_int, 27);
pub const __ANDROID_API_P__ = @as(c_int, 28);
pub const __ANDROID_API_Q__ = @as(c_int, 29);
pub const __ANDROID_API_R__ = @as(c_int, 30);
pub const __ANDROID_API_S__ = @as(c_int, 31);
pub const __ANDROID_API_T__ = @as(c_int, 33);
pub const __ANDROID_API_U__ = @as(c_int, 34);
pub const __ANDROID_NDK__ = @as(c_int, 1);
pub const __NDK_MAJOR__ = @as(c_int, 25);
pub const __NDK_MINOR__ = @as(c_int, 1);
pub const __NDK_BETA__ = @as(c_int, 0);
pub const __NDK_BUILD__ = std.zig.c_translation.promoteIntLiteral(c_int, 8937393, .decimal);
pub const __NDK_CANARY__ = @as(c_int, 0);
pub const WCHAR_MAX = __WCHAR_MAX__;
pub const WCHAR_MIN = '\x00';
pub const __STDDEF_H = "";
pub const __need_ptrdiff_t = "";
pub const __need_size_t = "";
pub const __need_wchar_t = "";
pub const __need_NULL = "";
pub const __need_STDDEF_H_misc = "";
pub const _PTRDIFF_T = "";
pub const _SIZE_T = "";
pub const _WCHAR_T = "";
pub const NULL = std.zig.c_translation.cast(?*anyopaque, @as(c_int, 0));
pub const __CLANG_MAX_ALIGN_T_DEFINED = "";
pub const __BIT_TYPES_DEFINED__ = "";
pub inline fn INT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn INT_LEAST8_C(c: anytype) @TypeOf(INT8_C(c)) {
    _ = &c;
    return INT8_C(c);
}
pub inline fn INT_FAST8_C(c: anytype) @TypeOf(INT8_C(c)) {
    _ = &c;
    return INT8_C(c);
}
pub inline fn UINT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn UINT_LEAST8_C(c: anytype) @TypeOf(UINT8_C(c)) {
    _ = &c;
    return UINT8_C(c);
}
pub inline fn UINT_FAST8_C(c: anytype) @TypeOf(UINT8_C(c)) {
    _ = &c;
    return UINT8_C(c);
}
pub inline fn INT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn INT_LEAST16_C(c: anytype) @TypeOf(INT16_C(c)) {
    _ = &c;
    return INT16_C(c);
}
pub inline fn INT_FAST16_C(c: anytype) @TypeOf(INT32_C(c)) {
    _ = &c;
    return INT32_C(c);
}
pub inline fn UINT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn UINT_LEAST16_C(c: anytype) @TypeOf(UINT16_C(c)) {
    _ = &c;
    return UINT16_C(c);
}
pub inline fn UINT_FAST16_C(c: anytype) @TypeOf(UINT32_C(c)) {
    _ = &c;
    return UINT32_C(c);
}
pub inline fn INT32_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn INT_LEAST32_C(c: anytype) @TypeOf(INT32_C(c)) {
    _ = &c;
    return INT32_C(c);
}
pub inline fn INT_FAST32_C(c: anytype) @TypeOf(INT32_C(c)) {
    _ = &c;
    return INT32_C(c);
}
pub const UINT32_C = std.zig.c_translation.Macros.U_SUFFIX;
pub inline fn UINT_LEAST32_C(c: anytype) @TypeOf(UINT32_C(c)) {
    _ = &c;
    return UINT32_C(c);
}
pub inline fn UINT_FAST32_C(c: anytype) @TypeOf(UINT32_C(c)) {
    _ = &c;
    return UINT32_C(c);
}
pub inline fn INT_LEAST64_C(c: anytype) @TypeOf(INT64_C(c)) {
    _ = &c;
    return INT64_C(c);
}
pub inline fn INT_FAST64_C(c: anytype) @TypeOf(INT64_C(c)) {
    _ = &c;
    return INT64_C(c);
}
pub inline fn UINT_LEAST64_C(c: anytype) @TypeOf(UINT64_C(c)) {
    _ = &c;
    return UINT64_C(c);
}
pub inline fn UINT_FAST64_C(c: anytype) @TypeOf(UINT64_C(c)) {
    _ = &c;
    return UINT64_C(c);
}
pub inline fn INTMAX_C(c: anytype) @TypeOf(INT64_C(c)) {
    _ = &c;
    return INT64_C(c);
}
pub inline fn UINTMAX_C(c: anytype) @TypeOf(UINT64_C(c)) {
    _ = &c;
    return UINT64_C(c);
}
pub const INT64_C = std.zig.c_translation.Macros.LL_SUFFIX;
pub const UINT64_C = std.zig.c_translation.Macros.ULL_SUFFIX;
pub inline fn INTPTR_C(c: anytype) @TypeOf(INT32_C(c)) {
    _ = &c;
    return INT32_C(c);
}
pub inline fn UINTPTR_C(c: anytype) @TypeOf(UINT32_C(c)) {
    _ = &c;
    return UINT32_C(c);
}
pub inline fn PTRDIFF_C(c: anytype) @TypeOf(INT32_C(c)) {
    _ = &c;
    return INT32_C(c);
}
pub const INT8_MIN = -@as(c_int, 128);
pub const INT8_MAX = @as(c_int, 127);
pub const INT_LEAST8_MIN = INT8_MIN;
pub const INT_LEAST8_MAX = INT8_MAX;
pub const INT_FAST8_MIN = INT8_MIN;
pub const INT_FAST8_MAX = INT8_MAX;
pub const UINT8_MAX = @as(c_int, 255);
pub const UINT_LEAST8_MAX = UINT8_MAX;
pub const UINT_FAST8_MAX = UINT8_MAX;
pub const INT16_MIN = -std.zig.c_translation.promoteIntLiteral(c_int, 32768, .decimal);
pub const INT16_MAX = @as(c_int, 32767);
pub const INT_LEAST16_MIN = INT16_MIN;
pub const INT_LEAST16_MAX = INT16_MAX;
pub const INT_FAST16_MIN = INT32_MIN;
pub const INT_FAST16_MAX = INT32_MAX;
pub const UINT16_MAX = std.zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT_LEAST16_MAX = UINT16_MAX;
pub const UINT_FAST16_MAX = UINT32_MAX;
pub const INT32_MIN = -std.zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const INT32_MAX = std.zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const INT_LEAST32_MIN = INT32_MIN;
pub const INT_LEAST32_MAX = INT32_MAX;
pub const INT_FAST32_MIN = INT32_MIN;
pub const INT_FAST32_MAX = INT32_MAX;
pub const UINT32_MAX = std.zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT_LEAST32_MAX = UINT32_MAX;
pub const UINT_FAST32_MAX = UINT32_MAX;
pub const INT64_MIN = INT64_C(-std.zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT64_MAX = INT64_C(std.zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const INT_LEAST64_MIN = INT64_MIN;
pub const INT_LEAST64_MAX = INT64_MAX;
pub const INT_FAST64_MIN = INT64_MIN;
pub const INT_FAST64_MAX = INT64_MAX;
pub const UINT64_MAX = UINT64_C(std.zig.c_translation.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const UINT_LEAST64_MAX = UINT64_MAX;
pub const UINT_FAST64_MAX = UINT64_MAX;
pub const INTMAX_MIN = INT64_MIN;
pub const INTMAX_MAX = INT64_MAX;
pub const UINTMAX_MAX = UINT64_MAX;
pub const SIG_ATOMIC_MAX = INT32_MAX;
pub const SIG_ATOMIC_MIN = INT32_MIN;
pub const WINT_MAX = UINT32_MAX;
pub const WINT_MIN = @as(c_int, 0);
pub const INTPTR_MIN = INT32_MIN;
pub const INTPTR_MAX = INT32_MAX;
pub const UINTPTR_MAX = UINT32_MAX;
pub const PTRDIFF_MIN = INT32_MIN;
pub const PTRDIFF_MAX = INT32_MAX;
pub const SIZE_MAX = UINT32_MAX;
pub const JNIIMPORT = "";
pub const JNICALL = "";
pub const JNI_FALSE = @as(c_int, 0);
pub const JNI_TRUE = @as(c_int, 1);
pub const JNI_VERSION_1_1 = std.zig.c_translation.promoteIntLiteral(c_int, 0x00010001, .hex);
pub const JNI_VERSION_1_2 = std.zig.c_translation.promoteIntLiteral(c_int, 0x00010002, .hex);
pub const JNI_VERSION_1_4 = std.zig.c_translation.promoteIntLiteral(c_int, 0x00010004, .hex);
pub const JNI_VERSION_1_6 = std.zig.c_translation.promoteIntLiteral(c_int, 0x00010006, .hex);
pub const JNI_OK = @as(c_int, 0);
pub const JNI_ERR = -@as(c_int, 1);
pub const JNI_EDETACHED = -@as(c_int, 2);
pub const JNI_EVERSION = -@as(c_int, 3);
pub const JNI_ENOMEM = -@as(c_int, 4);
pub const JNI_EEXIST = -@as(c_int, 5);
pub const JNI_EINVAL = -@as(c_int, 6);
pub const JNI_COMMIT = @as(c_int, 1);
pub const JNI_ABORT = @as(c_int, 2);
pub const SL_ANDROID_PCM_REPRESENTATION_SIGNED_INT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_ANDROID_PCM_REPRESENTATION_UNSIGNED_INT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_ANDROID_PCM_REPRESENTATION_FLOAT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_ANDROID_DATAFORMAT_PCM_EX = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_ANDROID_SPEAKER_NON_POSITIONAL = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 0x80000000, .hex));
pub inline fn SL_ANDROID_MAKE_INDEXED_CHANNEL_MASK(bitfield: anytype) @TypeOf(bitfield | SL_ANDROID_SPEAKER_NON_POSITIONAL) {
    _ = &bitfield;
    return bitfield | SL_ANDROID_SPEAKER_NON_POSITIONAL;
}
pub const SL_ANDROID_SPEAKER_USE_DEFAULT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0));
pub const SL_ANDROID_JAVA_PROXY_ROUTING = @as(c_int, 0x0001);
pub const SL_ANDROID_ITEMKEY_NONE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000000));
pub const SL_ANDROID_ITEMKEY_EOS = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_ANDROID_ITEMKEY_DISCONTINUITY = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000002));
pub const SL_ANDROID_ITEMKEY_BUFFERQUEUEEVENT = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000003));
pub const SL_ANDROID_ITEMKEY_FORMAT_CHANGE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000004));
pub const SL_ANDROIDBUFFERQUEUEEVENT_NONE = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000000));
pub const SL_ANDROIDBUFFERQUEUEEVENT_PROCESSED = std.zig.c_translation.cast(SLuint32, @as(c_int, 0x00000001));
pub const SL_DATALOCATOR_ANDROIDFD = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 0x800007BC, .hex));
pub const SL_DATALOCATOR_ANDROIDFD_USE_FILE_SIZE = std.zig.c_translation.cast(SLAint64, std.zig.c_translation.promoteIntLiteral(c_longlong, 0xFFFFFFFFFFFFFFFF, .hex));
pub const SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 0x800007BD, .hex));
pub const SL_DATALOCATOR_ANDROIDBUFFERQUEUE = std.zig.c_translation.cast(SLuint32, std.zig.c_translation.promoteIntLiteral(c_int, 0x800007BE, .hex));
pub const SL_ANDROID_MIME_AACADTS = std.zig.c_translation.cast([*c]SLchar, "audio/vnd.android.aac-adts");
pub const SLInterfaceID_ = struct_SLInterfaceID_;
pub const SLObjectItf_ = struct_SLObjectItf_;
pub const SLDataLocator_URI_ = struct_SLDataLocator_URI_;
pub const SLDataLocator_Address_ = struct_SLDataLocator_Address_;
pub const SLDataLocator_IODevice_ = struct_SLDataLocator_IODevice_;
pub const SLDataFormat_MIME_ = struct_SLDataFormat_MIME_;
pub const SLDataFormat_PCM_ = struct_SLDataFormat_PCM_;
pub const SLDataSource_ = struct_SLDataSource_;
pub const SLDataSink_ = struct_SLDataSink_;
pub const SLAudioInputDescriptor_ = struct_SLAudioInputDescriptor_;
pub const SLAudioOutputDescriptor_ = struct_SLAudioOutputDescriptor_;
pub const SLAudioIODeviceCapabilitiesItf_ = struct_SLAudioIODeviceCapabilitiesItf_;
pub const SLLEDDescriptor_ = struct_SLLEDDescriptor_;
pub const SLHSL_ = struct_SLHSL_;
pub const SLLEDArrayItf_ = struct_SLLEDArrayItf_;
pub const SLVibraDescriptor_ = struct_SLVibraDescriptor_;
pub const SLVibraItf_ = struct_SLVibraItf_;
pub const SLMetadataInfo_ = struct_SLMetadataInfo_;
pub const SLMetadataExtractionItf_ = struct_SLMetadataExtractionItf_;
pub const SLMetadataTraversalItf_ = struct_SLMetadataTraversalItf_;
pub const SLDynamicSourceItf_ = struct_SLDynamicSourceItf_;
pub const SLOutputMixItf_ = struct_SLOutputMixItf_;
pub const SLPlayItf_ = struct_SLPlayItf_;
pub const SLPrefetchStatusItf_ = struct_SLPrefetchStatusItf_;
pub const SLPlaybackRateItf_ = struct_SLPlaybackRateItf_;
pub const SLSeekItf_ = struct_SLSeekItf_;
pub const SLRecordItf_ = struct_SLRecordItf_;
pub const SLEqualizerItf_ = struct_SLEqualizerItf_;
pub const SLVolumeItf_ = struct_SLVolumeItf_;
pub const SLDeviceVolumeItf_ = struct_SLDeviceVolumeItf_;
pub const SLBufferQueueState_ = struct_SLBufferQueueState_;
pub const SLBufferQueueItf_ = struct_SLBufferQueueItf_;
pub const SLPresetReverbItf_ = struct_SLPresetReverbItf_;
pub const SLEnvironmentalReverbSettings_ = struct_SLEnvironmentalReverbSettings_;
pub const SLEnvironmentalReverbItf_ = struct_SLEnvironmentalReverbItf_;
pub const SLEffectSendItf_ = struct_SLEffectSendItf_;
pub const SL3DGroupingItf_ = struct_SL3DGroupingItf_;
pub const SL3DCommitItf_ = struct_SL3DCommitItf_;
pub const SLVec3D_ = struct_SLVec3D_;
pub const SL3DLocationItf_ = struct_SL3DLocationItf_;
pub const SL3DDopplerItf_ = struct_SL3DDopplerItf_;
pub const SL3DSourceItf_ = struct_SL3DSourceItf_;
pub const SL3DMacroscopicItf_ = struct_SL3DMacroscopicItf_;
pub const SLMuteSoloItf_ = struct_SLMuteSoloItf_;
pub const SLDynamicInterfaceManagementItf_ = struct_SLDynamicInterfaceManagementItf_;
pub const SLMIDIMessageItf_ = struct_SLMIDIMessageItf_;
pub const SLMIDIMuteSoloItf_ = struct_SLMIDIMuteSoloItf_;
pub const SLMIDITempoItf_ = struct_SLMIDITempoItf_;
pub const SLMIDITimeItf_ = struct_SLMIDITimeItf_;
pub const SLAudioCodecDescriptor_ = struct_SLAudioCodecDescriptor_;
pub const SLAudioCodecProfileMode_ = struct_SLAudioCodecProfileMode_;
pub const SLAudioDecoderCapabilitiesItf_ = struct_SLAudioDecoderCapabilitiesItf_;
pub const SLAudioEncoderSettings_ = struct_SLAudioEncoderSettings_;
pub const SLAudioEncoderCapabilitiesItf_ = struct_SLAudioEncoderCapabilitiesItf_;
pub const SLAudioEncoderItf_ = struct_SLAudioEncoderItf_;
pub const SLBassBoostItf_ = struct_SLBassBoostItf_;
pub const SLPitchItf_ = struct_SLPitchItf_;
pub const SLRatePitchItf_ = struct_SLRatePitchItf_;
pub const SLVirtualizerItf_ = struct_SLVirtualizerItf_;
pub const SLVisualizationItf_ = struct_SLVisualizationItf_;
pub const SLEngineItf_ = struct_SLEngineItf_;
pub const SLEngineCapabilitiesItf_ = struct_SLEngineCapabilitiesItf_;
pub const SLThreadSyncItf_ = struct_SLThreadSyncItf_;
pub const SLEngineOption_ = struct_SLEngineOption_;
pub const _jfieldID = struct__jfieldID;
pub const _jmethodID = struct__jmethodID;
pub const JNINativeInterface = struct_JNINativeInterface;
pub const JNIInvokeInterface = struct_JNIInvokeInterface;
pub const _JNIEnv = struct__JNIEnv;
pub const _JavaVM = struct__JavaVM;
pub const SLAndroidDataFormat_PCM_EX_ = struct_SLAndroidDataFormat_PCM_EX_;
pub const SLAndroidEffectItf_ = struct_SLAndroidEffectItf_;
pub const SLAndroidEffectSendItf_ = struct_SLAndroidEffectSendItf_;
pub const SLAndroidEffectCapabilitiesItf_ = struct_SLAndroidEffectCapabilitiesItf_;
pub const SLAndroidConfigurationItf_ = struct_SLAndroidConfigurationItf_;
pub const SLAndroidSimpleBufferQueueState_ = struct_SLAndroidSimpleBufferQueueState_;
pub const SLAndroidSimpleBufferQueueItf_ = struct_SLAndroidSimpleBufferQueueItf_;
pub const SLAndroidBufferItem_ = struct_SLAndroidBufferItem_;
pub const SLAndroidBufferQueueState_ = struct_SLAndroidBufferQueueState_;
pub const SLAndroidBufferQueueItf_ = struct_SLAndroidBufferQueueItf_;
pub const SLDataLocator_AndroidFD_ = struct_SLDataLocator_AndroidFD_;
pub const SLDataLocator_AndroidBufferQueue_ = struct_SLDataLocator_AndroidBufferQueue_;
pub const SLAndroidAcousticEchoCancellationItf_ = struct_SLAndroidAcousticEchoCancellationItf_;
pub const SLAndroidAutomaticGainControlItf_ = struct_SLAndroidAutomaticGainControlItf_;
pub const SLAndroidNoiseSuppressionItf_ = struct_SLAndroidNoiseSuppressionItf_;
