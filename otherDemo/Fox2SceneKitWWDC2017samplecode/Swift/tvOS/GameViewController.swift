/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The app's main view controller.
 */

import SceneKit
import UIKit

class GameViewControllerTVOS: UIViewController {
    var gameView: SCNView! {
        // swiftlint:disable force_cast
        return view as! SCNView
        // swiftlint:enable force_cast
    }
    var gameController: GameController?

    override func viewDidLoad() {
        super.viewDidLoad()
        gameController = GameController(scnView: gameView)

        // Configure the view
        gameView!.backgroundColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
