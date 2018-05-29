//
//  plane.swift
//  myARKitDemo
//
//  Created by ksyun on 2017/6/13.
//  Copyright © 2017年 ksyun. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class plane: SCNNode {
    var anchor:ARPlaneAnchor
    var planeGeometry:SCNPlane
    
    init(anchor:ARPlaneAnchor) {
        
        self.anchor = anchor
        self.planeGeometry = SCNPlane.init(width: CGFloat(self.anchor.extent.x), height: CGFloat(self.anchor.extent.z))
        super.init()
        // Instead of just visualizing the grid as a gray plane, we will render
        // it in some Tron style colours.
        let material:SCNMaterial = SCNMaterial()
        let image:UIImage = UIImage(named: "tron_grid.png")!
        material.diffuse.contents = image
        self.planeGeometry.materials = [material]
        
        //insert planeNode
        let planeNode:SCNNode = SCNNode.init(geometry: self.planeGeometry)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-.pi/2, 1.0, 0, 0)
        self.setTextureScale()
        self.addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(anchor :ARPlaneAnchor){
        // As the user moves around the extend and location of the plane
        // may be updated. We need to update our 3D geometry to match the
        // new parameters of the plane.
        self.planeGeometry.width = CGFloat(anchor.extent.x);
        self.planeGeometry.height = CGFloat(anchor.extent.z);
        
        // When the plane is first created it's center is 0,0,0 and the nodes
        // transform contains the translation parameters. As the plane is updated
        // the planes translation remains the same but it's center is updated so
        // we need to update the 3D geometry position
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        self.setTextureScale();
    }
    
    func setTextureScale(){
        let material = self.planeGeometry.materials.first;
        material?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(self.planeGeometry.width), Float(self.planeGeometry.height), 1)
        material?.diffuse.wrapS = SCNWrapMode.repeat
        material?.diffuse.wrapT = SCNWrapMode.repeat
        
    }
}
