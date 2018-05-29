//
//  ViewController.m
//  ARDemo
//
//  Created by AK on 2018/2/9.
//  Copyright © 2018年 11. All rights reserved.
//


#import "demo1.h"
#import "JPARRecord.h"

@interface demo1 ()<JPARRecordDelegate>
{
    SCNNode *chairNode;
    SCNNode *_personNode;//人物层
    SCNScene * idleScene;
    
  
}

@property (nonatomic, strong) SCNRenderer *renderer;
@property (nonatomic, strong) JPARRecord * arRecord;
@end

    
@implementation demo1

//插入光源
- (void)insertSpotLight:(SCNVector3)position
{
    SCNLight *spotLight = [SCNLight light];
    spotLight.type = SCNLightTypeOmni ;
    spotLight.castsShadow = YES;
//    spotLight.spotInnerAngle = 45;
//    spotLight.spotOuterAngle = 45;
    spotLight.shadowRadius = 20;
    spotLight.shadowMode=SCNShadowModeForward;
    
//      SCNLookAtConstraint* constraint = [SCNLookAtConstraint lookAtConstraintWithTarget]
    
    SCNNode *spotNode = [SCNNode new];
    spotNode.light = spotLight;
    spotNode.position = position;
    // By default the stop light points directly down the negative
    // z-axis, we want to shine it down so rotate 90deg around the
    // x-axis to point it down
//    spotNode.eulerAngles = SCNVector3Make(0, 0, -9);
    
    [self.arSCNView.scene.rootNode addChildNode: spotNode];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1创建主场景
    SCNScene *rootScene = [SCNScene new];
    self.arSCNView.scene = rootScene;
     SCNNode *rootNode = [[SCNNode alloc]init];
 
    //2,添加人物场景
    //灵活的小胖子
    
    NSString * sceneFilePath = @"art.scnassets/idle/twist_danceFixed.dae";
    //Baby Groot 木头人
//    sceneFilePath = @"babygroot.scn";
    idleScene = [SCNScene sceneNamed:sceneFilePath];
    _personNode = [[SCNNode alloc]init];
    for (SCNNode * child in idleScene.rootNode.childNodes)
    {
        [_personNode addChildNode:child];
    }
    _personNode.position = SCNVector3Make(0, -0.8, -1.6); //3D模型的位置
    _personNode.scale    = SCNVector3Make(0.08, 0.08, 0.08); //模型的大小
    [rootNode addChildNode:_personNode];
    
    [self.arSCNView.scene.rootNode addChildNode:rootNode];

    //3添加地板 用于阴影
    SCNFloor * floor = [[SCNFloor alloc] init];
    floor.reflectivity = 0;
    SCNMaterial * material = [[SCNMaterial alloc] init];
//    material.diffuse.contents = [UIColor whiteColor];
//    material.colorBufferWriteMask = SCNColorMaskGreen;
    floor.materials = @[material];
    
    SCNNode *floorNode =  [SCNNode nodeWithGeometry:floor];
    floorNode.position = SCNVector3Make(0, -20, 0);
    
    floorNode.geometry.firstMaterial.diffuse.contents = @"wood.png";
    floorNode.geometry.firstMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(2, 2, 1); //scale the wood texture
    floorNode.geometry.firstMaterial.locksAmbientWithDiffuse = YES;

//    [self.arSCNView.scene.rootNode addChildNode:floorNode];
//    [self insertSpotLight:SCNVector3Make(0, 0, 0)];
 
    
    //////////////////录制相关内容
    //录制 btn
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(bounds.size.width/2-60, bounds.size.height - 200, 120, 100)];
    [button setTitle:@"点我录制" forState:UIControlStateNormal];
    [button setTitle:@"录制中..." forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    //初始化 ar record
    self.arRecord = [[JPARRecord alloc]init];
    self.arRecord.delegate = self;
    self.arRecord.renderer.scene = self.arSCNView.scene;
    
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinch];
  


}

#pragma mark pinch 捏合手势事件 缩放人物
-(void)pinchView:(UIPinchGestureRecognizer *)sender
{
 
//    sender.view.transform = CGAffineTransformScale(sender.view.transform, sender.scale, sender.scale);
    //重新设置缩放比例 1是正常缩放.小于1时是缩小(无论何种操作都是缩小),大于1时是放大(无论何种操作都是放大)
    NSLog(@"sender.scale is %f",sender.scale);
    _personNode.scale    = SCNVector3Make(0.08*sender.scale , 0.08*sender.scale , 0.08*sender.scale ); //模型的大小
    
}


-(void)clicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self.arRecord startRecording];
    }else {
        [self.arRecord endRecording];
    }
}


#pragma mark- 点击屏幕添加飞机
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    //旋转核心动画
//    CABasicAnimation *moonRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
//    //旋转周期
//    moonRotationAnimation.duration = 30;
//    //围绕Y轴旋转360度  （不明白ARKit坐标系的可以看笔者之前的文章）
//    moonRotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
//    //无限旋转  重复次数为无穷大
//    moonRotationAnimation.repeatCount = FLT_MAX;
//
//    //开始旋转  ！！！：切记这里是让空节点旋转，而不是台灯节点。  理由同上
//    [_personNode addAnimation:moonRotationAnimation forKey:@"moon rotation around earth"];
    
}

#pragma mark - ARSCNViewDelegate
//添加节点时候调用（当开启平地捕捉模式之后，如果捕捉到平地，ARKit会自动添加一个平地节点）
- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
   
}

//刷新时调用
- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"刷新中");
}

//更新节点时调用
- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"节点更新");
    
}

//移除节点时调用
- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"节点移除");
}

#pragma mark -ARSessionDelegate

//会话位置更新（监听相机的移动），此代理方法会调用非常频繁，只要相机移动就会调用，如果相机移动过快，会有一定的误差，具体的需要强大的算法去优化，笔者这里就不深入了
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    if (_personNode)
    {
        
        NSLog(@"移动飞机");
        //捕捉相机的位置，让节点随着相机移动而移动
        //根据官方文档记录，相机的位置参数在4X4矩阵的第三列
        NSLog(@"x:%f,y:%f,z:%f",frame.camera.transform.columns[3].x,frame.camera.transform.columns[3].y,frame.camera.transform.columns[3].z);
        
//      _personNode.position =SCNVector3Make(frame.camera.transform.columns[3].x*10,frame.camera.transform.columns[3].y,frame.camera.transform.columns[3].z);
    }
    
 
    
    
}

- (void)endMerge
{
    
    //初始化警告框
    UIAlertController*alert = [UIAlertController
                               alertControllerWithTitle: @"提示"
                               message: @"视频已经保存到相册"
                               preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"确定"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                      {
                      }]];
    //弹出提示框
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
}

@end
