//=============================================================================================================================
//
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

import Foundation
import OpenGLES
import EasyARSwift

internal class HelloAR {
    private var camera: CameraDevice? = nil
    private var streamer: CameraFrameStreamer? = nil
    private var trackers: [ImageTracker] = []
    private var videobg_renderer: Renderer? = nil
    private var box_renderer: BoxRenderer? = nil
    private var viewport_changed: Bool = false
    private var view_size: (Int32, Int32) = (0, 0)
    private var view_rotation: Int32 = 0
    private var viewport: (Int32, Int32, Int32, Int32) = (0, 0, 1280, 720)
    
    private func loadFromImage(_ tracker: ImageTracker, _ path: String) -> Void {
        let target = ImageTarget()
        var name:String
        if let index = path.range(of: ".") {
            name = path.substring(to: index.lowerBound)
        } else {
            name = path
        }
        let jstr = "{\n"
            + "  \"images\" :\n"
            + "  [\n"
            + "    {\n"
            + "      \"image\" : \"\(path)\",\n"
            + "      \"name\" : \"\(name)\"\n"
            + "    }\n"
            + "  ]\n"
            + "}"
        _ = target.setup(jstr, StorageType([StorageType.Assets, StorageType.Json]).rawValue, "")
        tracker.loadTarget(target, { (target, status) in
            print("load target (\(status)): \(target.name()) (\(target.runtimeID()))")
        })
    }
    
    private func loadFromJsonFile(_ tracker: ImageTracker, _ path: String, _ targetName: String) {
        let target = ImageTarget()
        _ = target.setup(path, StorageType.Assets.rawValue, targetName)
        tracker.loadTarget(target, { (target, status) in
            print("load target (\(status)): \(target.name()) (\(target.runtimeID()))")
        })
    }
    
    private func loadAllFromJsonFile(_ tracker: ImageTracker, _ path: String) {
        for target in ImageTarget.setupAll(path, StorageType.Assets.rawValue) {
            tracker.loadTarget(target, { (target, status) in
                print("load target (\(status)): \(target.name()) (\(target.runtimeID()))")
            })
        }
    }
    
    public func initialize() -> Bool {
        camera = CameraDevice()
        streamer = CameraFrameStreamer()
        _ = streamer!.attachCamera(camera!)
        
        var status = true
        var temp_status = true
        temp_status = camera!.open(CameraDeviceType.Default.rawValue)
        status = status && temp_status
        _ = camera!.setSize(Vec2I(1280, 720))
        
        if !status { return status }
        let tracker = ImageTracker()
        _ = tracker.attachStreamer(streamer!)
        loadFromJsonFile(tracker, "targets.json", "argame")
        loadFromJsonFile(tracker, "targets.json", "idback")
        loadAllFromJsonFile(tracker, "targets2.json")
        loadFromImage(tracker, "namecard.jpg")
        trackers.append(tracker)
    
        return status
    }
    
    public func dispose() -> Void {
        trackers.removeAll()
        box_renderer = nil
        videobg_renderer = nil
        streamer = nil
        camera = nil
    }
    
    public func start() -> Bool {
        var status = true
        var temp_status = true
        temp_status = (camera != nil) && camera!.start()
        status = status && temp_status
        temp_status = (streamer != nil) && streamer!.start()
        status = status && temp_status
        _ = camera!.setFocusMode(CameraDeviceFocusMode.Continousauto)
        for tracker in trackers {
            temp_status = tracker.start()
            status = status && temp_status
        }
        return status
    }
    
    public func stop() -> Bool {
        var status = true
        var temp_status = true
        for tracker in trackers {
            temp_status = tracker.stop()
            status = status && temp_status
        }
        temp_status = (streamer != nil) && streamer!.stop()
        status = status && temp_status
        temp_status = (camera != nil) && camera!.stop()
        status = status && temp_status
        return status
    }
    
    public func initGL() -> Void {
        videobg_renderer = Renderer()
        box_renderer = BoxRenderer()
    }
    
    public func resizeGL(width: Int32, height: Int32) {
        view_size = (width, height)
        viewport_changed = true
    }
    
    public func updateViewport() -> Void {
        let calib = camera?.cameraCalibration() ?? nil
        let rotation = calib?.rotation() ?? 0
        if rotation != view_rotation {
            view_rotation = rotation
            viewport_changed = true
        }
        if (viewport_changed) {
            var size: (Int32, Int32) = (1, 1)
            if camera?.isOpened() ?? false {
                size = camera!.size().data
            }
            if rotation == 90 || rotation == 270 {
                size = (size.1, size.0)
            }
            let scaleRatio = max(Float(view_size.0) / Float(size.0), Float(view_size.1) / Float(size.1))
            let viewport_size = (Int32(roundf(Float(size.0) * scaleRatio)), Int32(roundf(Float(size.1) * scaleRatio)))
            let viewport_new = (Int32((view_size.0 - viewport_size.0)) / 2, Int32((view_size.1 - viewport_size.1)) / 2, viewport_size.0, viewport_size.1)
            viewport = viewport_new
            
            if camera?.isOpened() ?? false {
                viewport_changed = false
            }
        }
    }
    
    public func render() -> Void {
        glClearColor(1.0, 1.0, 1.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        if videobg_renderer != nil {
            let default_viewport: (Int32, Int32, Int32, Int32) = (0, 0, view_size.0, view_size.1)
            glViewport(default_viewport.0, default_viewport.1, default_viewport.2, default_viewport.3)
            if videobg_renderer!.renderErrorMessage(Vec4I(default_viewport.0, default_viewport.1, default_viewport.2, default_viewport.3)) {
                return
            }
        }
        
        if (streamer == nil) { return; }
        let frame = streamer!.peek()
        updateViewport()
        glViewport(viewport.0, viewport.1, viewport.2, viewport.3)
        
        if videobg_renderer != nil {
            _ = videobg_renderer!.render(frame, Vec4I(viewport.0, viewport.1, viewport.2, viewport.3))
        }
        
        for targetInstance in frame.targetInstances() {
            let status = targetInstance.status()
            if status == TargetStatus.Tracked {
                let target = targetInstance.target()
                if let imagetarget = target as? ImageTarget {
                    box_renderer!.render(camera!.projectionGL(0.2, 500), targetInstance.poseGL(), imagetarget.size())
                }
            }
        }
    }
}
