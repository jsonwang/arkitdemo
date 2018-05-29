//=============================================================================================================================
//
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

import Foundation

public class RefBase {
    fileprivate let cdata_: OpaquePointer
    fileprivate let deleter_: (OpaquePointer) -> Void

    fileprivate init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        cdata_ = cdata
        deleter_ = deleter
    }

    deinit {
        deleter_(cdata_)
    }
}

let TypeNameToConstructor: [String : (OpaquePointer) -> RefBase] = [
    "CloudRecognizer": { cdata in CloudRecognizer(cdata: cdata, deleter: easyar_CloudRecognizer__dtor) },
    "Buffer": { cdata in Buffer(cdata: cdata, deleter: easyar_Buffer__dtor) },
    "Drawable": { cdata in Drawable(cdata: cdata, deleter: easyar_Drawable__dtor) },
    "Frame": { cdata in Frame(cdata: cdata, deleter: easyar_Frame__dtor) },
    "Image": { cdata in Image(cdata: cdata, deleter: easyar_Image__dtor) },
    "CameraCalibration": { cdata in CameraCalibration(cdata: cdata, deleter: easyar_CameraCalibration__dtor) },
    "CameraDevice": { cdata in CameraDevice(cdata: cdata, deleter: easyar_CameraDevice__dtor) },
    "VideoPlayer": { cdata in VideoPlayer(cdata: cdata, deleter: easyar_VideoPlayer__dtor) },
    "Renderer": { cdata in Renderer(cdata: cdata, deleter: easyar_Renderer__dtor) },
    "FrameFilter": { cdata in FrameFilter(cdata: cdata, deleter: easyar_FrameFilter__dtor) },
    "FrameStreamer": { cdata in FrameStreamer(cdata: cdata, deleter: easyar_FrameStreamer__dtor) },
    "CameraFrameStreamer": { cdata in CameraFrameStreamer(cdata: cdata, deleter: easyar_CameraFrameStreamer__dtor) },
    "QRCodeScanner": { cdata in QRCodeScanner(cdata: cdata, deleter: easyar_QRCodeScanner__dtor) },
    "Target": { cdata in Target(cdata: cdata, deleter: easyar_Target__dtor) },
    "TargetInstance": { cdata in TargetInstance(cdata: cdata, deleter: easyar_TargetInstance__dtor) },
    "TargetTracker": { cdata in TargetTracker(cdata: cdata, deleter: easyar_TargetTracker__dtor) },
    "ImageTarget": { cdata in ImageTarget(cdata: cdata, deleter: easyar_ImageTarget__dtor) },
    "ImageTracker": { cdata in ImageTracker(cdata: cdata, deleter: easyar_ImageTracker__dtor) },
]

fileprivate class OpaquePointerContainer {
    public let ptr_: OpaquePointer
    public let deleter_: (OpaquePointer) -> Void
    public init(_ ptr: OpaquePointer, _ deleter: @escaping (OpaquePointer) -> Void) {
        ptr_ = ptr
        deleter_ = deleter
    }
    deinit {
        deleter_(ptr_)
    }
}

fileprivate func Optional_retain(_ ptr: OpaquePointer?, _ retain: @convention(c) (OpaquePointer, UnsafeMutablePointer<OpaquePointer>) -> Void) -> OpaquePointer? {
    if let p = ptr {
        let pptr = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            pptr.deinitialize()
        }
        retain(p, &pptr.pointee)
        return pptr.pointee
    } else {
        return nil
    }
}

fileprivate func String_to_c(_ s: String) -> OpaquePointerContainer {
    let pptr = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
    defer {
        pptr.deinitialize()
    }
    s.utf8CString.withUnsafeBufferPointer { p in
        easyar_String_from_utf8(p.baseAddress, p.baseAddress?.advanced(by: p.count - 1), pptr)
    }
    let ptr = pptr.pointee
    return OpaquePointerContainer(ptr, { p in easyar_String__dtor(p) })
}

fileprivate func String_from_c(_ ptr: OpaquePointerContainer) -> String {
    let begin = easyar_String_begin(ptr.ptr_)
    let count = begin == nil ? 0 : begin!.distance(to: easyar_String_end(ptr.ptr_)!)
    let arr = [UInt8](UnsafeBufferPointer<UInt8>(start: UnsafePointer<UInt8>(OpaquePointer(begin)), count: count))
    return String(bytes: arr, encoding: String.Encoding.utf8)!
}

fileprivate func Object_from_c<T>(_ ptr: OpaquePointer, _ typeNameGetter: (OpaquePointer) -> UnsafePointer<CChar>) -> T {
    let typeName = String(cString: typeNameGetter(ptr))
    if let ctor = TypeNameToConstructor[typeName] {
        if let o = ctor(ptr) as? T {
            return o
        } else {
            fatalError("ValueNotOfType")
        }
    } else {
        fatalError("ConstructorNotExistForType")
    }
}

fileprivate func Matrix34F_to_c(_ r: Matrix34F) -> easyar_Matrix34F {
    return easyar_Matrix34F(data: (r.data.0, r.data.1, r.data.2, r.data.3, r.data.4, r.data.5, r.data.6, r.data.7, r.data.8, r.data.9, r.data.10, r.data.11))
}
fileprivate func Matrix34F_from_c(_ r: easyar_Matrix34F) -> Matrix34F {
    return Matrix34F(r.data.0, r.data.1, r.data.2, r.data.3, r.data.4, r.data.5, r.data.6, r.data.7, r.data.8, r.data.9, r.data.10, r.data.11)
}

fileprivate func Matrix44F_to_c(_ r: Matrix44F) -> easyar_Matrix44F {
    return easyar_Matrix44F(data: (r.data.0, r.data.1, r.data.2, r.data.3, r.data.4, r.data.5, r.data.6, r.data.7, r.data.8, r.data.9, r.data.10, r.data.11, r.data.12, r.data.13, r.data.14, r.data.15))
}
fileprivate func Matrix44F_from_c(_ r: easyar_Matrix44F) -> Matrix44F {
    return Matrix44F(r.data.0, r.data.1, r.data.2, r.data.3, r.data.4, r.data.5, r.data.6, r.data.7, r.data.8, r.data.9, r.data.10, r.data.11, r.data.12, r.data.13, r.data.14, r.data.15)
}

fileprivate func Vec4F_to_c(_ r: Vec4F) -> easyar_Vec4F {
    return easyar_Vec4F(data: (r.data.0, r.data.1, r.data.2, r.data.3))
}
fileprivate func Vec4F_from_c(_ r: easyar_Vec4F) -> Vec4F {
    return Vec4F(r.data.0, r.data.1, r.data.2, r.data.3)
}

fileprivate func Vec3F_to_c(_ r: Vec3F) -> easyar_Vec3F {
    return easyar_Vec3F(data: (r.data.0, r.data.1, r.data.2))
}
fileprivate func Vec3F_from_c(_ r: easyar_Vec3F) -> Vec3F {
    return Vec3F(r.data.0, r.data.1, r.data.2)
}

fileprivate func Vec2F_to_c(_ r: Vec2F) -> easyar_Vec2F {
    return easyar_Vec2F(data: (r.data.0, r.data.1))
}
fileprivate func Vec2F_from_c(_ r: easyar_Vec2F) -> Vec2F {
    return Vec2F(r.data.0, r.data.1)
}

fileprivate func Vec4I_to_c(_ r: Vec4I) -> easyar_Vec4I {
    return easyar_Vec4I(data: (r.data.0, r.data.1, r.data.2, r.data.3))
}
fileprivate func Vec4I_from_c(_ r: easyar_Vec4I) -> Vec4I {
    return Vec4I(r.data.0, r.data.1, r.data.2, r.data.3)
}

fileprivate func Vec2I_to_c(_ r: Vec2I) -> easyar_Vec2I {
    return easyar_Vec2I(data: (r.data.0, r.data.1))
}
fileprivate func Vec2I_from_c(_ r: easyar_Vec2I) -> Vec2I {
    return Vec2I(r.data.0, r.data.1)
}

fileprivate func FunctorOfVoidFromCloudStatus_func(_ state: OpaquePointer, _ arg0: Int32) -> Void {
    let sarg0 = CloudStatus(rawValue: arg0)
    let f = UnsafeMutablePointer<(CloudStatus) -> Void>(state).pointee
    f(sarg0)
}
fileprivate func FunctorOfVoidFromCloudStatus_to_c(_ f: @escaping (CloudStatus) -> Void) -> easyar_FunctorOfVoidFromCloudStatus {
    let s = UnsafeMutablePointer<(CloudStatus) -> Void>.allocate(capacity: 1)
    s.initialize(to: f)
    return easyar_FunctorOfVoidFromCloudStatus(_state: OpaquePointer(s), _func: FunctorOfVoidFromCloudStatus_func, _destroy: { p in UnsafeMutablePointer<(CloudStatus) -> Void>(p).deinitialize() })
}

fileprivate func FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_func(_ state: OpaquePointer, _ arg0: Int32, _ arg1: OpaquePointer) -> Void {
    let sarg0 = CloudStatus(rawValue: arg0)
    var varg1 = arg1
    easyar_ListOfPointerOfTarget_copy(varg1, &varg1)
    let sarg1 = ListOfPointerOfTarget_from_c(OpaquePointerContainer(varg1, { p in easyar_ListOfPointerOfTarget__dtor(p) }))
    let f = UnsafeMutablePointer<(CloudStatus, [Target]) -> Void>(state).pointee
    f(sarg0, sarg1)
}
fileprivate func FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_to_c(_ f: @escaping (CloudStatus, [Target]) -> Void) -> easyar_FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget {
    let s = UnsafeMutablePointer<(CloudStatus, [Target]) -> Void>.allocate(capacity: 1)
    s.initialize(to: f)
    return easyar_FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget(_state: OpaquePointer(s), _func: FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_func, _destroy: { p in UnsafeMutablePointer<(CloudStatus, [Target]) -> Void>(p).deinitialize() })
}

fileprivate func ListOfPointerOfTarget_to_c(_ l: [Target]) -> OpaquePointerContainer {
    let arr = l.map({ e in e.cdata_ })
    let pptr = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
    defer {
        pptr.deinitialize()
    }
    arr.withUnsafeBufferPointer { bp in
        easyar_ListOfPointerOfTarget__ctor(UnsafePointer<OpaquePointer>(bp.baseAddress), UnsafePointer<OpaquePointer>(bp.baseAddress?.advanced(by: bp.count)), pptr)
    }
    return OpaquePointerContainer(pptr.pointee, { p in easyar_ListOfPointerOfTarget__dtor(p) })
}
fileprivate func ListOfPointerOfTarget_from_c(_ l: OpaquePointerContainer) -> [Target] {
    let size = Int(easyar_ListOfPointerOfTarget_size(l.ptr_))
    var values = [Target]()
    values.reserveCapacity(size)
    for k in 0..<size {
        var v = easyar_ListOfPointerOfTarget_at(l.ptr_, Int32(k))
        easyar_Target__retain(v, &v)
        values.append((Object_from_c(v, easyar_Target__typeName) as Target))
    }
    return values
}

fileprivate func ListOfPointerOfImage_to_c(_ l: [Image]) -> OpaquePointerContainer {
    let arr = l.map({ e in e.cdata_ })
    let pptr = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
    defer {
        pptr.deinitialize()
    }
    arr.withUnsafeBufferPointer { bp in
        easyar_ListOfPointerOfImage__ctor(UnsafePointer<OpaquePointer>(bp.baseAddress), UnsafePointer<OpaquePointer>(bp.baseAddress?.advanced(by: bp.count)), pptr)
    }
    return OpaquePointerContainer(pptr.pointee, { p in easyar_ListOfPointerOfImage__dtor(p) })
}
fileprivate func ListOfPointerOfImage_from_c(_ l: OpaquePointerContainer) -> [Image] {
    let size = Int(easyar_ListOfPointerOfImage_size(l.ptr_))
    var values = [Image]()
    values.reserveCapacity(size)
    for k in 0..<size {
        var v = easyar_ListOfPointerOfImage_at(l.ptr_, Int32(k))
        easyar_Image__retain(v, &v)
        values.append((Object_from_c(v, easyar_Image__typeName) as Image))
    }
    return values
}

fileprivate func ListOfPointerOfTargetInstance_to_c(_ l: [TargetInstance]) -> OpaquePointerContainer {
    let arr = l.map({ e in e.cdata_ })
    let pptr = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
    defer {
        pptr.deinitialize()
    }
    arr.withUnsafeBufferPointer { bp in
        easyar_ListOfPointerOfTargetInstance__ctor(UnsafePointer<OpaquePointer>(bp.baseAddress), UnsafePointer<OpaquePointer>(bp.baseAddress?.advanced(by: bp.count)), pptr)
    }
    return OpaquePointerContainer(pptr.pointee, { p in easyar_ListOfPointerOfTargetInstance__dtor(p) })
}
fileprivate func ListOfPointerOfTargetInstance_from_c(_ l: OpaquePointerContainer) -> [TargetInstance] {
    let size = Int(easyar_ListOfPointerOfTargetInstance_size(l.ptr_))
    var values = [TargetInstance]()
    values.reserveCapacity(size)
    for k in 0..<size {
        var v = easyar_ListOfPointerOfTargetInstance_at(l.ptr_, Int32(k))
        easyar_TargetInstance__retain(v, &v)
        values.append((Object_from_c(v, easyar_TargetInstance__typeName) as TargetInstance))
    }
    return values
}

fileprivate func FunctorOfVoidFromPermissionStatusAndString_func(_ state: OpaquePointer, _ arg0: Int32, _ arg1: OpaquePointer) -> Void {
    let sarg0 = PermissionStatus(rawValue: arg0)
    var varg1 = arg1
    easyar_String_copy(varg1, &varg1)
    let sarg1 = String_from_c(OpaquePointerContainer(varg1, { p in easyar_String__dtor(p) }))
    let f = UnsafeMutablePointer<(PermissionStatus, String) -> Void>(state).pointee
    f(sarg0, sarg1)
}
fileprivate func FunctorOfVoidFromPermissionStatusAndString_to_c(_ f: @escaping (PermissionStatus, String) -> Void) -> easyar_FunctorOfVoidFromPermissionStatusAndString {
    let s = UnsafeMutablePointer<(PermissionStatus, String) -> Void>.allocate(capacity: 1)
    s.initialize(to: f)
    return easyar_FunctorOfVoidFromPermissionStatusAndString(_state: OpaquePointer(s), _func: FunctorOfVoidFromPermissionStatusAndString_func, _destroy: { p in UnsafeMutablePointer<(PermissionStatus, String) -> Void>(p).deinitialize() })
}

fileprivate func FunctorOfVoidFromVideoStatus_func(_ state: OpaquePointer, _ arg0: Int32) -> Void {
    let sarg0 = VideoStatus(rawValue: arg0)
    let f = UnsafeMutablePointer<(VideoStatus) -> Void>(state).pointee
    f(sarg0)
}
fileprivate func FunctorOfVoidFromVideoStatus_to_c(_ f: @escaping (VideoStatus) -> Void) -> easyar_FunctorOfVoidFromVideoStatus {
    let s = UnsafeMutablePointer<(VideoStatus) -> Void>.allocate(capacity: 1)
    s.initialize(to: f)
    return easyar_FunctorOfVoidFromVideoStatus(_state: OpaquePointer(s), _func: FunctorOfVoidFromVideoStatus_func, _destroy: { p in UnsafeMutablePointer<(VideoStatus) -> Void>(p).deinitialize() })
}

fileprivate func FunctorOfVoidFromPointerOfTargetAndBool_func(_ state: OpaquePointer, _ arg0: OpaquePointer, _ arg1: Bool) -> Void {
    var varg0 = arg0
    easyar_Target__retain(varg0, &varg0)
    let sarg0 = (Object_from_c(varg0, easyar_Target__typeName) as Target)
    let sarg1 = arg1
    let f = UnsafeMutablePointer<(Target, Bool) -> Void>(state).pointee
    f(sarg0, sarg1)
}
fileprivate func FunctorOfVoidFromPointerOfTargetAndBool_to_c(_ f: @escaping (Target, Bool) -> Void) -> easyar_FunctorOfVoidFromPointerOfTargetAndBool {
    let s = UnsafeMutablePointer<(Target, Bool) -> Void>.allocate(capacity: 1)
    s.initialize(to: f)
    return easyar_FunctorOfVoidFromPointerOfTargetAndBool(_state: OpaquePointer(s), _func: FunctorOfVoidFromPointerOfTargetAndBool_func, _destroy: { p in UnsafeMutablePointer<(Target, Bool) -> Void>(p).deinitialize() })
}

fileprivate func ListOfPointerOfImageTarget_to_c(_ l: [ImageTarget]) -> OpaquePointerContainer {
    let arr = l.map({ e in e.cdata_ })
    let pptr = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
    defer {
        pptr.deinitialize()
    }
    arr.withUnsafeBufferPointer { bp in
        easyar_ListOfPointerOfImageTarget__ctor(UnsafePointer<OpaquePointer>(bp.baseAddress), UnsafePointer<OpaquePointer>(bp.baseAddress?.advanced(by: bp.count)), pptr)
    }
    return OpaquePointerContainer(pptr.pointee, { p in easyar_ListOfPointerOfImageTarget__dtor(p) })
}
fileprivate func ListOfPointerOfImageTarget_from_c(_ l: OpaquePointerContainer) -> [ImageTarget] {
    let size = Int(easyar_ListOfPointerOfImageTarget_size(l.ptr_))
    var values = [ImageTarget]()
    values.reserveCapacity(size)
    for k in 0..<size {
        var v = easyar_ListOfPointerOfImageTarget_at(l.ptr_, Int32(k))
        easyar_ImageTarget__retain(v, &v)
        values.append((Object_from_c(v, easyar_ImageTarget__typeName) as ImageTarget))
    }
    return values
}

public struct CloudStatus : OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }

    public static let Success = CloudStatus(rawValue: 0)
    public static let Reconnecting = CloudStatus(rawValue: 1)
    public static let Fail = CloudStatus(rawValue: 2)
}

public class CloudRecognizer : FrameFilter {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public convenience init() {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_CloudRecognizer__ctor(_return_value_)
        self.init(cdata: _return_value_.pointee, deleter: { ptr in easyar_CloudRecognizer__dtor(ptr) })
    }
    public func `open`(_ server: String, _ appKey: String, _ appSecret: String, _ callback_open: @escaping (CloudStatus) -> Void, _ callback_recognize: @escaping (CloudStatus, [Target]) -> Void) -> Void {
        easyar_CloudRecognizer_open(cdata_, String_to_c(server).ptr_, String_to_c(appKey).ptr_, String_to_c(appSecret).ptr_, FunctorOfVoidFromCloudStatus_to_c(callback_open), FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_to_c(callback_recognize))
    }
    public func close() -> Bool {
        let _return_value_ = easyar_CloudRecognizer_close(cdata_)
        return _return_value_
    }
    public override func attachStreamer(_ obj: FrameStreamer?) -> Bool {
        let _return_value_ = easyar_CloudRecognizer_attachStreamer(cdata_, obj.map({(p) in p.cdata_}))
        return _return_value_
    }
    public override func start() -> Bool {
        let _return_value_ = easyar_CloudRecognizer_start(cdata_)
        return _return_value_
    }
    public override func stop() -> Bool {
        let _return_value_ = easyar_CloudRecognizer_stop(cdata_)
        return _return_value_
    }
}

public class Buffer : RefBase {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public func data() -> OpaquePointer {
        let _return_value_ = easyar_Buffer_data(cdata_)
        return _return_value_
    }
    public func size() -> Int32 {
        let _return_value_ = easyar_Buffer_size(cdata_)
        return _return_value_
    }
}

public class Drawable : RefBase {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
}

public class Frame : Drawable {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public convenience init() {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_Frame__ctor(_return_value_)
        self.init(cdata: _return_value_.pointee, deleter: { ptr in easyar_Frame__dtor(ptr) })
    }
    public func size() -> Vec2I {
        let _return_value_ = easyar_Frame_size(cdata_)
        return Vec2I_from_c(_return_value_)
    }
    public func timestamp() -> Double {
        let _return_value_ = easyar_Frame_timestamp(cdata_)
        return _return_value_
    }
    public func index() -> Int32 {
        let _return_value_ = easyar_Frame_index(cdata_)
        return _return_value_
    }
    public func images() -> [Image] {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_Frame_images(cdata_, _return_value_)
        return ListOfPointerOfImage_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_ListOfPointerOfImage__dtor(p) }))
    }
    public func targetInstances() -> [TargetInstance] {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_Frame_targetInstances(cdata_, _return_value_)
        return ListOfPointerOfTargetInstance_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_ListOfPointerOfTargetInstance__dtor(p) }))
    }
    public func text() -> String {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_Frame_text(cdata_, _return_value_)
        return String_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_String__dtor(p) }))
    }
}

public struct PixelFormat : OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }

    public static let Unknown = PixelFormat(rawValue: 0)
    public static let Gray = PixelFormat(rawValue: 1)
    public static let YUV_NV21 = PixelFormat(rawValue: 2)
    public static let YUV_NV12 = PixelFormat(rawValue: 3)
    public static let RGB888 = PixelFormat(rawValue: 4)
    public static let BGR888 = PixelFormat(rawValue: 5)
    public static let RGBA8888 = PixelFormat(rawValue: 6)
}

public class Image : RefBase {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public func buffer() -> Buffer {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_Image_buffer(cdata_, _return_value_)
        return (Object_from_c(_return_value_.pointee, easyar_Buffer__typeName) as Buffer)
    }
    public func format() -> PixelFormat {
        let _return_value_ = easyar_Image_format(cdata_)
        return PixelFormat(rawValue: _return_value_)
    }
    public func width() -> Int32 {
        let _return_value_ = easyar_Image_width(cdata_)
        return _return_value_
    }
    public func height() -> Int32 {
        let _return_value_ = easyar_Image_height(cdata_)
        return _return_value_
    }
    public func stride() -> Int32 {
        let _return_value_ = easyar_Image_stride(cdata_)
        return _return_value_
    }
    public func data() -> OpaquePointer {
        let _return_value_ = easyar_Image_data(cdata_)
        return _return_value_
    }
}

public struct Matrix34F {
    public var data: (Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float)

    public init(_ data_0: Float, _ data_1: Float, _ data_2: Float, _ data_3: Float, _ data_4: Float, _ data_5: Float, _ data_6: Float, _ data_7: Float, _ data_8: Float, _ data_9: Float, _ data_10: Float, _ data_11: Float) {
        self.data = (data_0, data_1, data_2, data_3, data_4, data_5, data_6, data_7, data_8, data_9, data_10, data_11);
    }
}

public struct Matrix44F {
    public var data: (Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float)

    public init(_ data_0: Float, _ data_1: Float, _ data_2: Float, _ data_3: Float, _ data_4: Float, _ data_5: Float, _ data_6: Float, _ data_7: Float, _ data_8: Float, _ data_9: Float, _ data_10: Float, _ data_11: Float, _ data_12: Float, _ data_13: Float, _ data_14: Float, _ data_15: Float) {
        self.data = (data_0, data_1, data_2, data_3, data_4, data_5, data_6, data_7, data_8, data_9, data_10, data_11, data_12, data_13, data_14, data_15);
    }
}

public struct Vec4F {
    public var data: (Float, Float, Float, Float)

    public init(_ data_0: Float, _ data_1: Float, _ data_2: Float, _ data_3: Float) {
        self.data = (data_0, data_1, data_2, data_3);
    }
}

public struct Vec3F {
    public var data: (Float, Float, Float)

    public init(_ data_0: Float, _ data_1: Float, _ data_2: Float) {
        self.data = (data_0, data_1, data_2);
    }
}

public struct Vec2F {
    public var data: (Float, Float)

    public init(_ data_0: Float, _ data_1: Float) {
        self.data = (data_0, data_1);
    }
}

public struct Vec4I {
    public var data: (Int32, Int32, Int32, Int32)

    public init(_ data_0: Int32, _ data_1: Int32, _ data_2: Int32, _ data_3: Int32) {
        self.data = (data_0, data_1, data_2, data_3);
    }
}

public struct Vec2I {
    public var data: (Int32, Int32)

    public init(_ data_0: Int32, _ data_1: Int32) {
        self.data = (data_0, data_1);
    }
}

public struct CameraDeviceFocusMode : OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }

    public static let Normal = CameraDeviceFocusMode(rawValue: 0)
    public static let Triggerauto = CameraDeviceFocusMode(rawValue: 1)
    public static let Continousauto = CameraDeviceFocusMode(rawValue: 2)
    public static let Infinity = CameraDeviceFocusMode(rawValue: 3)
    public static let Macro = CameraDeviceFocusMode(rawValue: 4)
}

public struct CameraDeviceType : OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }

    public static let Default = CameraDeviceType(rawValue: 0)
    public static let Back = CameraDeviceType(rawValue: 1)
    public static let Front = CameraDeviceType(rawValue: 2)
}

public class CameraCalibration : RefBase {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public convenience init() {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_CameraCalibration__ctor(_return_value_)
        self.init(cdata: _return_value_.pointee, deleter: { ptr in easyar_CameraCalibration__dtor(ptr) })
    }
    public func size() -> Vec2I {
        let _return_value_ = easyar_CameraCalibration_size(cdata_)
        return Vec2I_from_c(_return_value_)
    }
    public func focalLength() -> Vec2F {
        let _return_value_ = easyar_CameraCalibration_focalLength(cdata_)
        return Vec2F_from_c(_return_value_)
    }
    public func principalPoint() -> Vec2F {
        let _return_value_ = easyar_CameraCalibration_principalPoint(cdata_)
        return Vec2F_from_c(_return_value_)
    }
    public func distortionParameters() -> Vec4F {
        let _return_value_ = easyar_CameraCalibration_distortionParameters(cdata_)
        return Vec4F_from_c(_return_value_)
    }
    public func rotation() -> Int32 {
        let _return_value_ = easyar_CameraCalibration_rotation(cdata_)
        return _return_value_
    }
    public func projectionGL(_ nearPlane: Float, _ farPlane: Float) -> Matrix44F {
        let _return_value_ = easyar_CameraCalibration_projectionGL(cdata_, nearPlane, farPlane)
        return Matrix44F_from_c(_return_value_)
    }
}

public class CameraDevice : RefBase {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public convenience init() {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_CameraDevice__ctor(_return_value_)
        self.init(cdata: _return_value_.pointee, deleter: { ptr in easyar_CameraDevice__dtor(ptr) })
    }
    public func start() -> Bool {
        let _return_value_ = easyar_CameraDevice_start(cdata_)
        return _return_value_
    }
    public func stop() -> Bool {
        let _return_value_ = easyar_CameraDevice_stop(cdata_)
        return _return_value_
    }
    public func requestPermissions(_ permissionCallback: @escaping (PermissionStatus, String) -> Void) -> Void {
        easyar_CameraDevice_requestPermissions(cdata_, FunctorOfVoidFromPermissionStatusAndString_to_c(permissionCallback))
    }
    public func `open`(_ camera: Int32) -> Bool {
        let _return_value_ = easyar_CameraDevice_open(cdata_, camera)
        return _return_value_
    }
    public func close() -> Bool {
        let _return_value_ = easyar_CameraDevice_close(cdata_)
        return _return_value_
    }
    public func isOpened() -> Bool {
        let _return_value_ = easyar_CameraDevice_isOpened(cdata_)
        return _return_value_
    }
    public func setHorizontalFlip(_ flip: Bool) -> Void {
        easyar_CameraDevice_setHorizontalFlip(cdata_, flip)
    }
    public func frameRate() -> Float {
        let _return_value_ = easyar_CameraDevice_frameRate(cdata_)
        return _return_value_
    }
    public func supportedFrameRateCount() -> Int32 {
        let _return_value_ = easyar_CameraDevice_supportedFrameRateCount(cdata_)
        return _return_value_
    }
    public func supportedFrameRate(_ idx: Int32) -> Float {
        let _return_value_ = easyar_CameraDevice_supportedFrameRate(cdata_, idx)
        return _return_value_
    }
    public func setFrameRate(_ fps: Float) -> Bool {
        let _return_value_ = easyar_CameraDevice_setFrameRate(cdata_, fps)
        return _return_value_
    }
    public func size() -> Vec2I {
        let _return_value_ = easyar_CameraDevice_size(cdata_)
        return Vec2I_from_c(_return_value_)
    }
    public func supportedSizeCount() -> Int32 {
        let _return_value_ = easyar_CameraDevice_supportedSizeCount(cdata_)
        return _return_value_
    }
    public func supportedSize(_ idx: Int32) -> Vec2I {
        let _return_value_ = easyar_CameraDevice_supportedSize(cdata_, idx)
        return Vec2I_from_c(_return_value_)
    }
    public func setSize(_ size: Vec2I) -> Bool {
        let _return_value_ = easyar_CameraDevice_setSize(cdata_, Vec2I_to_c(size))
        return _return_value_
    }
    public func zoomScale() -> Float {
        let _return_value_ = easyar_CameraDevice_zoomScale(cdata_)
        return _return_value_
    }
    public func setZoomScale(_ scale: Float) -> Void {
        easyar_CameraDevice_setZoomScale(cdata_, scale)
    }
    public func minZoomScale() -> Float {
        let _return_value_ = easyar_CameraDevice_minZoomScale(cdata_)
        return _return_value_
    }
    public func maxZoomScale() -> Float {
        let _return_value_ = easyar_CameraDevice_maxZoomScale(cdata_)
        return _return_value_
    }
    public func cameraCalibration() -> CameraCalibration? {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_CameraDevice_cameraCalibration(cdata_, _return_value_)
        return _return_value_.pointee.map({(p) in (Object_from_c(p, easyar_CameraCalibration__typeName) as CameraCalibration)})
    }
    public func setFlashTorchMode(_ on: Bool) -> Bool {
        let _return_value_ = easyar_CameraDevice_setFlashTorchMode(cdata_, on)
        return _return_value_
    }
    public func setFocusMode(_ focusMode: CameraDeviceFocusMode) -> Bool {
        let _return_value_ = easyar_CameraDevice_setFocusMode(cdata_, focusMode.rawValue)
        return _return_value_
    }
    public func projectionGL(_ nearPlane: Float, _ farPlane: Float) -> Matrix44F {
        let _return_value_ = easyar_CameraDevice_projectionGL(cdata_, nearPlane, farPlane)
        return Matrix44F_from_c(_return_value_)
    }
}

public struct PermissionStatus : OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }

    public static let Granted = PermissionStatus(rawValue: 0x00000000)
    public static let Denied = PermissionStatus(rawValue: 0x00000001)
    public static let Error = PermissionStatus(rawValue: 0x00000002)
}

public struct VideoStatus : OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }

    public static let Error = VideoStatus(rawValue: -1)
    public static let Ready = VideoStatus(rawValue: 0)
    public static let Completed = VideoStatus(rawValue: 1)
}

public struct VideoType : OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }

    public static let Normal = VideoType(rawValue: 0)
    public static let TransparentSideBySide = VideoType(rawValue: 1)
    public static let TransparentTopAndBottom = VideoType(rawValue: 2)
}

public class VideoPlayer : RefBase {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public convenience init() {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_VideoPlayer__ctor(_return_value_)
        self.init(cdata: _return_value_.pointee, deleter: { ptr in easyar_VideoPlayer__dtor(ptr) })
    }
    public func setVideoType(_ videoType: VideoType) -> Void {
        easyar_VideoPlayer_setVideoType(cdata_, videoType.rawValue)
    }
    public func setRenderTexture(_ texture: OpaquePointer) -> Void {
        easyar_VideoPlayer_setRenderTexture(cdata_, texture)
    }
    public func `open`(_ path: String, _ storageType: StorageType, _ callback: @escaping (VideoStatus) -> Void) -> Void {
        easyar_VideoPlayer_open(cdata_, String_to_c(path).ptr_, storageType.rawValue, FunctorOfVoidFromVideoStatus_to_c(callback))
    }
    public func close() -> Void {
        easyar_VideoPlayer_close(cdata_)
    }
    public func play() -> Bool {
        let _return_value_ = easyar_VideoPlayer_play(cdata_)
        return _return_value_
    }
    public func stop() -> Bool {
        let _return_value_ = easyar_VideoPlayer_stop(cdata_)
        return _return_value_
    }
    public func pause() -> Bool {
        let _return_value_ = easyar_VideoPlayer_pause(cdata_)
        return _return_value_
    }
    public func isRenderTextureAvailable() -> Bool {
        let _return_value_ = easyar_VideoPlayer_isRenderTextureAvailable(cdata_)
        return _return_value_
    }
    public func updateFrame() -> Void {
        easyar_VideoPlayer_updateFrame(cdata_)
    }
    public func duration() -> Int32 {
        let _return_value_ = easyar_VideoPlayer_duration(cdata_)
        return _return_value_
    }
    public func currentPosition() -> Int32 {
        let _return_value_ = easyar_VideoPlayer_currentPosition(cdata_)
        return _return_value_
    }
    public func seek(_ position: Int32) -> Bool {
        let _return_value_ = easyar_VideoPlayer_seek(cdata_, position)
        return _return_value_
    }
    public func size() -> Vec2I {
        let _return_value_ = easyar_VideoPlayer_size(cdata_)
        return Vec2I_from_c(_return_value_)
    }
    public func volume() -> Float {
        let _return_value_ = easyar_VideoPlayer_volume(cdata_)
        return _return_value_
    }
    public func setVolume(_ volume: Float) -> Bool {
        let _return_value_ = easyar_VideoPlayer_setVolume(cdata_, volume)
        return _return_value_
    }
}

public struct RendererAPI : OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }

    public static let Auto = RendererAPI(rawValue: 0)
    public static let None = RendererAPI(rawValue: 1)
    public static let GLES2 = RendererAPI(rawValue: 2)
    public static let GLES3 = RendererAPI(rawValue: 3)
    public static let GL = RendererAPI(rawValue: 4)
    public static let D3D9 = RendererAPI(rawValue: 5)
    public static let D3D11 = RendererAPI(rawValue: 6)
    public static let D3D12 = RendererAPI(rawValue: 7)
}

public class Renderer : RefBase {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public convenience init() {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_Renderer__ctor(_return_value_)
        self.init(cdata: _return_value_.pointee, deleter: { ptr in easyar_Renderer__dtor(ptr) })
    }
    public func chooseAPI(_ api: RendererAPI) -> Void {
        easyar_Renderer_chooseAPI(cdata_, api.rawValue)
    }
    public func setDevice(_ device: OpaquePointer) -> Void {
        easyar_Renderer_setDevice(cdata_, device)
    }
    public func render(_ frame: Drawable?, _ viewport: Vec4I) -> Bool {
        let _return_value_ = easyar_Renderer_render(cdata_, frame.map({(p) in p.cdata_}), Vec4I_to_c(viewport))
        return _return_value_
    }
    public func renderToTexture(_ frame: Drawable?, _ texture: OpaquePointer) -> Bool {
        let _return_value_ = easyar_Renderer_renderToTexture(cdata_, frame.map({(p) in p.cdata_}), texture)
        return _return_value_
    }
    public func renderErrorMessage(_ viewport: Vec4I) -> Bool {
        let _return_value_ = easyar_Renderer_renderErrorMessage(cdata_, Vec4I_to_c(viewport))
        return _return_value_
    }
    public func renderErrorMessageToTexture(_ texture: OpaquePointer) -> Bool {
        let _return_value_ = easyar_Renderer_renderErrorMessageToTexture(cdata_, texture)
        return _return_value_
    }
}

public class Engine {
    public static func initialize(_ key: String) -> Bool {
        let _return_value_ = easyar_Engine_initialize(String_to_c(key).ptr_)
        return _return_value_
    }
    public static func onPause() -> Void {
        easyar_Engine_onPause()
    }
    public static func onResume() -> Void {
        easyar_Engine_onResume()
    }
    public static func setRotation(_ rotation: Int32) -> Void {
        easyar_Engine_setRotation(rotation)
    }
    public static func versionString() -> String {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_Engine_versionString(_return_value_)
        return String_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_String__dtor(p) }))
    }
    public static func name() -> String {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_Engine_name(_return_value_)
        return String_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_String__dtor(p) }))
    }
}

public class FrameFilter : RefBase {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public func attachStreamer(_ obj: FrameStreamer?) -> Bool {
        let _return_value_ = easyar_FrameFilter_attachStreamer(cdata_, obj.map({(p) in p.cdata_}))
        return _return_value_
    }
    public func start() -> Bool {
        let _return_value_ = easyar_FrameFilter_start(cdata_)
        return _return_value_
    }
    public func stop() -> Bool {
        let _return_value_ = easyar_FrameFilter_stop(cdata_)
        return _return_value_
    }
}

public class FrameStreamer : RefBase {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public func peek() -> Frame {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_FrameStreamer_peek(cdata_, _return_value_)
        return (Object_from_c(_return_value_.pointee, easyar_Frame__typeName) as Frame)
    }
    public func start() -> Bool {
        let _return_value_ = easyar_FrameStreamer_start(cdata_)
        return _return_value_
    }
    public func stop() -> Bool {
        let _return_value_ = easyar_FrameStreamer_stop(cdata_)
        return _return_value_
    }
}

public class CameraFrameStreamer : FrameStreamer {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public convenience init() {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_CameraFrameStreamer__ctor(_return_value_)
        self.init(cdata: _return_value_.pointee, deleter: { ptr in easyar_CameraFrameStreamer__dtor(ptr) })
    }
    public func attachCamera(_ obj: CameraDevice?) -> Bool {
        let _return_value_ = easyar_CameraFrameStreamer_attachCamera(cdata_, obj.map({(p) in p.cdata_}))
        return _return_value_
    }
    public override func peek() -> Frame {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_CameraFrameStreamer_peek(cdata_, _return_value_)
        return (Object_from_c(_return_value_.pointee, easyar_Frame__typeName) as Frame)
    }
    public override func start() -> Bool {
        let _return_value_ = easyar_CameraFrameStreamer_start(cdata_)
        return _return_value_
    }
    public override func stop() -> Bool {
        let _return_value_ = easyar_CameraFrameStreamer_stop(cdata_)
        return _return_value_
    }
}

public class QRCodeScanner : FrameFilter {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public convenience init() {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_QRCodeScanner__ctor(_return_value_)
        self.init(cdata: _return_value_.pointee, deleter: { ptr in easyar_QRCodeScanner__dtor(ptr) })
    }
    public override func attachStreamer(_ obj: FrameStreamer?) -> Bool {
        let _return_value_ = easyar_QRCodeScanner_attachStreamer(cdata_, obj.map({(p) in p.cdata_}))
        return _return_value_
    }
    public override func start() -> Bool {
        let _return_value_ = easyar_QRCodeScanner_start(cdata_)
        return _return_value_
    }
    public override func stop() -> Bool {
        let _return_value_ = easyar_QRCodeScanner_stop(cdata_)
        return _return_value_
    }
}

public struct StorageType : OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }

    public static let App = StorageType(rawValue: 0)
    public static let Assets = StorageType(rawValue: 1)
    public static let Absolute = StorageType(rawValue: 2)
    public static let Json = StorageType(rawValue: 0x00000100)
}

public class Target : RefBase {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public func runtimeID() -> Int32 {
        let _return_value_ = easyar_Target_runtimeID(cdata_)
        return _return_value_
    }
    public func uid() -> String {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_Target_uid(cdata_, _return_value_)
        return String_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_String__dtor(p) }))
    }
    public func name() -> String {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_Target_name(cdata_, _return_value_)
        return String_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_String__dtor(p) }))
    }
    public func meta() -> String {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_Target_meta(cdata_, _return_value_)
        return String_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_String__dtor(p) }))
    }
    public func setMeta(_ data: String) -> Void {
        easyar_Target_setMeta(cdata_, String_to_c(data).ptr_)
    }
}

public struct TargetStatus : OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }

    public static let Unknown = TargetStatus(rawValue: 0)
    public static let Undefined = TargetStatus(rawValue: 1)
    public static let Detected = TargetStatus(rawValue: 2)
    public static let Tracked = TargetStatus(rawValue: 3)
}

public class TargetInstance : RefBase {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public convenience init() {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_TargetInstance__ctor(_return_value_)
        self.init(cdata: _return_value_.pointee, deleter: { ptr in easyar_TargetInstance__dtor(ptr) })
    }
    public func status() -> TargetStatus {
        let _return_value_ = easyar_TargetInstance_status(cdata_)
        return TargetStatus(rawValue: _return_value_)
    }
    public func target() -> Target? {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_TargetInstance_target(cdata_, _return_value_)
        return _return_value_.pointee.map({(p) in (Object_from_c(p, easyar_Target__typeName) as Target)})
    }
    public func pose() -> Matrix34F {
        let _return_value_ = easyar_TargetInstance_pose(cdata_)
        return Matrix34F_from_c(_return_value_)
    }
    public func poseGL() -> Matrix44F {
        let _return_value_ = easyar_TargetInstance_poseGL(cdata_)
        return Matrix44F_from_c(_return_value_)
    }
}

public class TargetTracker : FrameFilter {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public func loadTarget(_ target: Target, _ callback: @escaping (Target, Bool) -> Void) -> Void {
        easyar_TargetTracker_loadTarget(cdata_, target.cdata_, FunctorOfVoidFromPointerOfTargetAndBool_to_c(callback))
    }
    public func unloadTarget(_ target: Target, _ callback: @escaping (Target, Bool) -> Void) -> Void {
        easyar_TargetTracker_unloadTarget(cdata_, target.cdata_, FunctorOfVoidFromPointerOfTargetAndBool_to_c(callback))
    }
    public func loadTargetBlocked(_ target: Target) -> Bool {
        let _return_value_ = easyar_TargetTracker_loadTargetBlocked(cdata_, target.cdata_)
        return _return_value_
    }
    public func unloadTargetBlocked(_ target: Target) -> Bool {
        let _return_value_ = easyar_TargetTracker_unloadTargetBlocked(cdata_, target.cdata_)
        return _return_value_
    }
    public func targets() -> [Target] {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_TargetTracker_targets(cdata_, _return_value_)
        return ListOfPointerOfTarget_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_ListOfPointerOfTarget__dtor(p) }))
    }
    public func setSimultaneousNum(_ num: Int32) -> Bool {
        let _return_value_ = easyar_TargetTracker_setSimultaneousNum(cdata_, num)
        return _return_value_
    }
    public func simultaneousNum() -> Int32 {
        let _return_value_ = easyar_TargetTracker_simultaneousNum(cdata_)
        return _return_value_
    }
    public override func attachStreamer(_ obj: FrameStreamer?) -> Bool {
        let _return_value_ = easyar_TargetTracker_attachStreamer(cdata_, obj.map({(p) in p.cdata_}))
        return _return_value_
    }
    public override func start() -> Bool {
        let _return_value_ = easyar_TargetTracker_start(cdata_)
        return _return_value_
    }
    public override func stop() -> Bool {
        let _return_value_ = easyar_TargetTracker_stop(cdata_)
        return _return_value_
    }
}

public class ImageTarget : Target {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public convenience init() {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_ImageTarget__ctor(_return_value_)
        self.init(cdata: _return_value_.pointee, deleter: { ptr in easyar_ImageTarget__dtor(ptr) })
    }
    public func setup(_ path: String, _ storageType: Int32, _ name: String) -> Bool {
        let _return_value_ = easyar_ImageTarget_setup(cdata_, String_to_c(path).ptr_, storageType, String_to_c(name).ptr_)
        return _return_value_
    }
    public static func setupAll(_ path: String, _ storageType: Int32) -> [ImageTarget] {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_ImageTarget_setupAll(String_to_c(path).ptr_, storageType, _return_value_)
        return ListOfPointerOfImageTarget_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_ListOfPointerOfImageTarget__dtor(p) }))
    }
    public func size() -> Vec2F {
        let _return_value_ = easyar_ImageTarget_size(cdata_)
        return Vec2F_from_c(_return_value_)
    }
    public func setSize(_ size: Vec2F) -> Bool {
        let _return_value_ = easyar_ImageTarget_setSize(cdata_, Vec2F_to_c(size))
        return _return_value_
    }
    public func images() -> [Image] {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_ImageTarget_images(cdata_, _return_value_)
        return ListOfPointerOfImage_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_ListOfPointerOfImage__dtor(p) }))
    }
    public override func runtimeID() -> Int32 {
        let _return_value_ = easyar_ImageTarget_runtimeID(cdata_)
        return _return_value_
    }
    public override func uid() -> String {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_ImageTarget_uid(cdata_, _return_value_)
        return String_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_String__dtor(p) }))
    }
    public override func name() -> String {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_ImageTarget_name(cdata_, _return_value_)
        return String_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_String__dtor(p) }))
    }
    public override func meta() -> String {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_ImageTarget_meta(cdata_, _return_value_)
        return String_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_String__dtor(p) }))
    }
    public override func setMeta(_ data: String) -> Void {
        easyar_ImageTarget_setMeta(cdata_, String_to_c(data).ptr_)
    }
}

public struct ImageTrackerMode : OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }

    public static let PreferQuality = ImageTrackerMode(rawValue: 0)
    public static let PreferPerformance = ImageTrackerMode(rawValue: 1)
}

public class ImageTracker : TargetTracker {
    fileprivate override init(cdata: OpaquePointer, deleter: @escaping (OpaquePointer) -> Void) {
        super.init(cdata: cdata, deleter: deleter)
    }
    public convenience init() {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_ImageTracker__ctor(_return_value_)
        self.init(cdata: _return_value_.pointee, deleter: { ptr in easyar_ImageTracker__dtor(ptr) })
    }
    public static func createWithMode(_ mode: ImageTrackerMode) -> ImageTracker {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_ImageTracker_createWithMode(mode.rawValue, _return_value_)
        return (Object_from_c(_return_value_.pointee, easyar_ImageTracker__typeName) as ImageTracker)
    }
    public override func loadTarget(_ target: Target, _ callback: @escaping (Target, Bool) -> Void) -> Void {
        easyar_ImageTracker_loadTarget(cdata_, target.cdata_, FunctorOfVoidFromPointerOfTargetAndBool_to_c(callback))
    }
    public override func unloadTarget(_ target: Target, _ callback: @escaping (Target, Bool) -> Void) -> Void {
        easyar_ImageTracker_unloadTarget(cdata_, target.cdata_, FunctorOfVoidFromPointerOfTargetAndBool_to_c(callback))
    }
    public override func loadTargetBlocked(_ target: Target) -> Bool {
        let _return_value_ = easyar_ImageTracker_loadTargetBlocked(cdata_, target.cdata_)
        return _return_value_
    }
    public override func unloadTargetBlocked(_ target: Target) -> Bool {
        let _return_value_ = easyar_ImageTracker_unloadTargetBlocked(cdata_, target.cdata_)
        return _return_value_
    }
    public override func targets() -> [Target] {
        let _return_value_ = UnsafeMutablePointer<OpaquePointer>.allocate(capacity: 1)
        defer {
            _return_value_.deinitialize()
        }
        easyar_ImageTracker_targets(cdata_, _return_value_)
        return ListOfPointerOfTarget_from_c(OpaquePointerContainer(_return_value_.pointee, { p in easyar_ListOfPointerOfTarget__dtor(p) }))
    }
    public override func setSimultaneousNum(_ num: Int32) -> Bool {
        let _return_value_ = easyar_ImageTracker_setSimultaneousNum(cdata_, num)
        return _return_value_
    }
    public override func simultaneousNum() -> Int32 {
        let _return_value_ = easyar_ImageTracker_simultaneousNum(cdata_)
        return _return_value_
    }
    public override func attachStreamer(_ obj: FrameStreamer?) -> Bool {
        let _return_value_ = easyar_ImageTracker_attachStreamer(cdata_, obj.map({(p) in p.cdata_}))
        return _return_value_
    }
    public override func start() -> Bool {
        let _return_value_ = easyar_ImageTracker_start(cdata_)
        return _return_value_
    }
    public override func stop() -> Bool {
        let _return_value_ = easyar_ImageTracker_stop(cdata_)
        return _return_value_
    }
}
