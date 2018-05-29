//
//  ViewController.swift
//  ARKit-TransfeGate
//
//  Created by xu jie on 2017/8/21.
//  Copyright © 2017年 xujie. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate,ARSessionDelegate {
// 下载完整的arkit+scenekit 学习教程 请前往appstore搜索scenekit
// 教程对应的源码请前往 群:530957835 自取
// 如需技术指导 请私聊
    @IBOutlet var sceneView: ARSCNView!
    let cameraNode = SCNNode()
     let scene2 = SCNScene()
     let sphereNode = SCNNode(geometry: SCNSphere(radius: 2))
    let textNode = SCNNode()
    let doorNode = SCNNode()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        self.sceneView.scene.rootNode.addChildNode(self.sceneView.pointOfView!)
        
        sceneView.scene = scene
        sceneView.preferredFramesPerSecond =  30
        
        // 放置一个门
        doorNode.geometry = SCNPlane(width: 1.5, height: 2)
        doorNode.position = SCNVector3Make(0, -1, -2)
        
        
        
        scene.rootNode.addChildNode(doorNode)
        sphereNode.geometry?.firstMaterial?.isDoubleSided = false
        sphereNode.geometry?.firstMaterial?.cullMode = .front
        sphereNode.geometry?.firstMaterial?.diffuse.contents = "3.jpg"
        
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 90
        cameraNode.camera?.automaticallyAdjustsZRange = true
        scene2.rootNode.addChildNode(cameraNode)
        scene2.rootNode.addChildNode(sphereNode)
        
        let scnView =  SCNView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        scnView.preferredFramesPerSecond = 30
        scnView.scene = scene2
        doorNode.geometry?.firstMaterial?.diffuse.contents = scnView
        
        
        // 添加文字
        let text = SCNText(string: "APPStore搜索SceneKit", extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 0.2)
        textNode.geometry = text
        textNode.geometry?.firstMaterial?.diffuse.contents = "4.jpg"
        textNode.position = SCNVector3Make(-1, 0, -2)
        scene.rootNode.addChildNode(textNode)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        sceneView.session.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textNode.physicsBody = SCNPhysicsBody.dynamic()
        self.doorNode.physicsBody = SCNPhysicsBody.static()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        sceneView.delegate = self
    }
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
            self.cameraNode.eulerAngles = self.sceneView.pointOfView!.eulerAngles
    }
    
}
