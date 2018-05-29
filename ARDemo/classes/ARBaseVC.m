//
//  ARBaseVC.m
//  ARDemo
//
//  Created by AK on 2018/5/25.
//  Copyright © 2018年 11. All rights reserved.
//

#import "ARBaseVC.h"

@interface ARBaseVC () <ARSCNViewDelegate,ARSessionDelegate>
{

    //AR会话，负责管理相机追踪配置及3D相机坐标
     ARSession *_arSession;
    
    //会话追踪配置：负责追踪相机的运动
    ARWorldTrackingConfiguration *_arSessionConfiguration;
}

@end

@implementation ARBaseVC
@synthesize deImage;

#pragma mark -搭建ARKit环境
//加载会话追踪配置
- (ARWorldTrackingConfiguration *)arSessionConfiguration
{
    if (_arSessionConfiguration != nil)
    {
        return _arSessionConfiguration;
    }
    
    //1.创建世界追踪会话配置（使用ARWorldTrackingSessionConfiguration效果更加好），需要A9芯片支持
    ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc] init];
    //2.设置追踪方向（追踪平面，后面会用到）
    if (@available(iOS 11.3, *)) {
        configuration.planeDetection = ARPlaneDetectionHorizontal | ARPlaneDetectionVertical;
    } else {
        // Fallback on earlier versions
    }
    _arSessionConfiguration = configuration;
    //3.自适应灯光（相机从暗到强光快速过渡效果会平缓一些）
    _arSessionConfiguration.lightEstimationEnabled = YES;
    
    //3创建识别图片
    if (@available(iOS 11.3, *)) {
     
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *filePath = [resourcePath stringByAppendingPathComponent:@"L3DWY888_800x600@2x.jpg"];
        deImage = [UIImage imageWithContentsOfFile:filePath];
        
        ARReferenceImage *referenceDetectedImg = [[ARReferenceImage alloc] initWithCGImage:deImage.CGImage orientation:1 physicalWidth:0.1];
        [configuration setDetectionImages:[NSSet setWithObject:referenceDetectedImg]];
    }
    
    
    
    return _arSessionConfiguration;
    
}

//加载拍摄会话
- (ARSession *)arSession
{
    if(_arSession != nil)
    {
        return _arSession;
    }
    //1.创建会话
    _arSession = [[ARSession alloc] init];
    _arSession.delegate = self;
    //2返回会话
    return _arSession;
}

//创建AR视图
- (ARSCNView *)arSCNView
{
    if (_arSCNView != nil)
    {
        return _arSCNView;
    }
    //1.创建AR视图
    _arSCNView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
    //2.设置视图会话
    _arSCNView.session = self.arSession;
    _arSCNView.delegate = self;
    //3.自动刷新灯光（3D游戏用到，此处可忽略）
    _arSCNView.automaticallyUpdatesLighting = YES;
    
    return _arSCNView;
}

#pragma mark - 搭建ARKit环境结果

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.arSession pause];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    //1.将AR视图添加到当前视图
    [self.view addSubview:self.arSCNView];
    //2.开启AR会话（此时相机开始工作）
    [self.arSession runWithConfiguration:self.arSessionConfiguration];
 
    
}

@end
