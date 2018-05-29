//
//  ViewController.m
//  ARPhoto
//
//  Created by anyongxue on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <ARSCNViewDelegate>

@property (nonatomic,strong) IBOutlet ARSCNView *sceneView;

@property (nonatomic,assign)CGFloat currentK;

@end

    
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sceneView.delegate = self;
    self.sceneView.showsStatistics = YES;
//    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
//    self.sceneView.scene = scene;
    
    //创建点击手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhotoCollect)];
    [self.view addGestureRecognizer:tapGes];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.worldAlignment = ARWorldAlignmentGravity;
    configuration.planeDetection = ARPlaneDetectionNone;
    //3.自适应灯光（相机从暗到强光快速过渡效果会平缓一些）
    configuration.lightEstimationEnabled = YES;
    [self.sceneView.session runWithConfiguration:configuration];
    
}

// 多张照片集合
- (void)takePhotoCollect{
    
    ARFrame *currentFrame = self.sceneView.session.currentFrame;
    //创建照片
    //SCNPlane创建的对象是一个有指定宽高的平面矩形
    SCNPlane *imagePlane = [SCNPlane planeWithWidth:self.sceneView.bounds.size.width/6000 height:self.sceneView.bounds.size.height/6000];
    imagePlane.firstMaterial.diffuse.contents = self.sceneView.snapshot;
    imagePlane.firstMaterial.lightingModelName = SCNLightingModelConstant;
    
    for (int i =0;i<20;i++) {
        NSLog(@"创建%d",i);
        SCNNode *planeNode = [SCNNode nodeWithGeometry:imagePlane];
        if (i<10) {
            planeNode.position=SCNVector3Make(0+i*0.05,0, -0.1+i*0.05);
            NSLog(@"x %f;z %f",(0+i*0.05),(-0.1+i*0.05));
        }else{
            planeNode.position=SCNVector3Make((-9*0.05)-((i-9)*0.05),0,-0.1+i*0.05);
            NSLog(@"大于10 x %f;z %f",(-9*0.05)+((i-9)*0.05),(-0.1+i*0.05));
        }
        [self.sceneView.scene.rootNode addChildNode:planeNode];
    }
    
}

//单张照片
- (void)takePhoto{
    /*
     实现: 对飞机模型的AR场景 进行截图 在增强现实的场景中创建多个节点(模型) 在虚拟世界中万物皆模型
     1.判断能不能获取到当前的Frame
     2.创建一张截图
     3.对创建的图片进行截图
     4.通过截图创建一个节点并加到AR场景的根节点上
     4.追踪相机的位置
     */
    
    if (self.sceneView.session.currentFrame) {
        NSLog(@"创建");
        ARFrame *currentFrame = self.sceneView.session.currentFrame;
        
        //创建照片
        //SCNPlane创建的对象是一个有指定宽高的平面矩形
        SCNPlane *imagePlane = [SCNPlane planeWithWidth:self.sceneView.bounds.size.width/6000 height:self.sceneView.bounds.size.height/6000];
        
        /*
         SCNMaterial 渲染
         */
        imagePlane.firstMaterial.diffuse.contents = self.sceneView.snapshot;
        imagePlane.firstMaterial.lightingModelName = SCNLightingModelConstant;

        //在图片的几何平面上创建一个节点
        SCNNode *planeNode = [SCNNode nodeWithGeometry:imagePlane];
        //planeNode.transform = SCNMatrix4MakeRotation(M_PI, 0, 1, 0);
        //planeNode.position=SCNVector3Make(0,0, -1);
        [self.sceneView.scene.rootNode addChildNode:planeNode];
        
         //追踪相机位置
        /*
         4X4的矩阵
         matrix_identity_float4x4
         columns.3.z  3代表3轴 xyz
         */
        simd_float4x4 translate = matrix_identity_float4x4;
        translate.columns[3].z = -0.1;
        planeNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translate);
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    [self.sceneView.session pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - ARSCNViewDelegate

/*
// Override to create and configure nodes for anchors added to the view's session.
- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor {
    SCNNode *node = [SCNNode new];
 
    // Add geometry to the node...
 
    return node;
}
*/

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    // Present an error message to the user
    
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
}

@end
