//
//  demo2.m
//  ARDemo
//
//  Created by AK on 2018/5/25.
//  Copyright © 2018年 11. All rights reserved.
//

#import "demo2.h"

@interface demo2 ()

@end

@implementation demo2

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加节点时候调用（当开启平地捕捉模式之后，如果捕捉到平地，ARKit会自动添加一个平地节点）
- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    //平面检测
//    //1.获取捕捉到的平地锚点画一个平面
//    ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
//    SCNPlane * plane = [SCNPlane planeWithWidth:planeAnchor.extent.x - 0.05 height:planeAnchor.extent.z - 0.05];
//    SCNMaterial * material = [SCNMaterial new];
//    material.colorBufferWriteMask=SCNColorMaskGreen;
//    //material.isDoubleSided=YES;
//    [plane setMaterials:@[material]];
//
//
//    SCNNode *planeNode = [SCNNode new];
//    planeNode.geometry = plane;
//    // SceneKit 里的平面默认是垂直的，所以需要旋转90度来匹配 ARKit 中的平面
//    planeNode.transform = SCNMatrix4MakeRotation(-M_PI / 2.0, 1, 0, 0);
//    // 将平面plane移动到ARKit对应的位置
//    planeNode.position = SCNVector3Make(planeAnchor.center.x, -0.01, planeAnchor.center.z);
//
//    [node addChildNode:planeNode];
//    
//    return;
    if ([anchor isMemberOfClass:[ARPlaneAnchor class]])
    {
        NSLog(@"捕捉到平地");
        
        //添加一个3D平面模型，ARKit只有捕捉能力，锚点只是一个空间位置，要想更加清楚看到这个空间，我们需要给空间添加一个平地的3D模型来渲染他
        
        //1.获取捕捉到的平地锚点
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        //2.创建一个3D物体模型    （系统捕捉到的平地是一个不规则大小的长方形，这里笔者将其变成一个长方形，并且是否对平地做了一个缩放效果）
        //参数分别是长宽高和圆角
        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x*0.3 height:0 length:planeAnchor.extent.x*0.3 chamferRadius:0];
        //3.使用Material渲染3D模型（默认模型是白色的）
        plane.firstMaterial.diffuse.contents = [UIColor greenColor];
        
        //4.创建一个基于3D物体模型的节点
        SCNNode * planeNode = [SCNNode nodeWithGeometry:plane];
        //5.设置节点的位置为捕捉到的平地的锚点的中心位置  SceneKit框架中节点的位置position是一个基于3D坐标系的矢量坐标SCNVector3Make
        planeNode.position =SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        [node addChildNode:planeNode];
        
        //1.当捕捉到平地时 创建一个花瓶场景
        SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/vase/vase.scn"];
        //2.获取花瓶节点（一个场景会有多个节点，此处我们只写，花瓶节点则默认是场景子节点的第一个）
        //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点
        SCNNode *vaseNode = scene.rootNode.childNodes[0];
        
        //4.设置花瓶节点的位置为捕捉到的平地的位置，如果不设置，则默认为原点位置，也就是相机位置
        vaseNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        
        //5.将花瓶节点添加到当前屏幕中
        //!!!此处一定要注意：花瓶节点是添加到代理捕捉到的节点中，而不是AR视图的根节点。因为捕捉到的平地锚点是一个本地坐标系，而不是世界坐标系
        [node addChildNode:vaseNode];
        
    }
}



@end
