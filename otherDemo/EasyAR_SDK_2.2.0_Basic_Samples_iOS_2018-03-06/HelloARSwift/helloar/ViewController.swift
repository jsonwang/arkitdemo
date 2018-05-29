//=============================================================================================================================
//
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

import GLKit

internal class ViewController: GLKViewController {
    private var glView: OpenGLView? = nil

    override func loadView() {
        glView = OpenGLView(frame: CGRect.zero)
        view = glView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glView?.setOrientation(self.interfaceOrientation)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        glView?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        glView?.stop()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        glView?.resize(self.view.bounds, self.interfaceOrientation)
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        super.willRotate(to: toInterfaceOrientation, duration: duration)
        glView?.setOrientation(toInterfaceOrientation)
    }
}
