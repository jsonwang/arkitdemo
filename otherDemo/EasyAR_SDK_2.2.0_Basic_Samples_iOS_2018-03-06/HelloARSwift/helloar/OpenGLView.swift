//=============================================================================================================================
//
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

import GLKit
import EasyARSwift

internal class OpenGLView : GLKView {
    private var helloAR: HelloAR
    private var initialized: Bool = false
    
    override init(frame: CGRect) {
        helloAR = HelloAR()
        super.init(frame: frame)
        context = EAGLContext(api: EAGLRenderingAPI.openGLES2)!
        drawableColorFormat = GLKViewDrawableColorFormat.RGBA8888
        drawableDepthFormat = GLKViewDrawableDepthFormat.format24
        drawableStencilFormat = GLKViewDrawableStencilFormat.format8
        bindDrawable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
    }

    public func start() {
        if helloAR.initialize() {
            _ = helloAR.start()
        }
    }
    
    public func stop() {
        _ = helloAR.stop()
        helloAR.dispose()
    }
    
    public func resize(_ frame: CGRect, _ orientation: UIInterfaceOrientation) {
        var scale: CGFloat
        if #available(iOS 8, *) {
            scale = UIScreen.main.nativeScale
        } else {
            scale = UIScreen.main.scale
        }
        
        helloAR.resizeGL(width: Int32(frame.size.width * scale), height: Int32(frame.size.height * scale))
    }

    override func draw(_ rect: CGRect) {
        if !initialized {
            helloAR.initGL()
            initialized = true
        }
        helloAR.render()
    }
    
    public func setOrientation(_ orientation: UIInterfaceOrientation) {
        do {
            switch orientation {
            case .portrait:
                try Engine.setRotation(270)
            case .portraitUpsideDown:
                try Engine.setRotation(90)
            case .landscapeLeft:
                try Engine.setRotation(180)
            case .landscapeRight:
                try Engine.setRotation(0)
            default:
                break
            }
        } catch let error {
            print("error: \(error)")
        }
    }
}
