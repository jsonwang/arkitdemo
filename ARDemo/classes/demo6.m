//
//  ViewController.h
//  传送门
//
//  Created by LJP on 11/1/18.
//  Copyright © 2018年 poco. All rights reserved.
//

#import "demo6.h"


@interface demo6 ()<ARSCNViewDelegate>

//视图
@property (nonatomic, strong) ARSCNView * jpARSCNView;

//会话
@property (nonatomic, strong) ARSession * jpARSession;

//跟踪会话
@property (nonatomic, strong) ARWorldTrackingConfiguration * jpARWTkConfiguration;

//检测到的平面数据
@property (nonatomic, strong) ARPlaneAnchor * planeAnchor;

//是否显示了房子
@property (nonatomic, assign) BOOL isShow;

@end

@implementation demo6

#pragma mark ============================== 生命周期 ==============================

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.jpARSCNView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.jpARSCNView.session runWithConfiguration:self.jpARWTkConfiguration];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.jpARSCNView.session pause];
}

#pragma mark ============================== 私有方法 ==============================

- (void)addPortalWithTransform:(matrix_float4x4)transform {
    
    self.isShow = YES;
    
    SCNScene * portalScene = [SCNScene sceneNamed:@"Model.scnassets/tjgc.scn"];
    
    if (portalScene == nil) return;
    
    SCNNode * portalNode = [portalScene.rootNode childNodeWithName:@"tjgc" recursively:YES];
    
    SCNVector3 newVector3 = SCNVector3Make(transform.columns[3].x, transform.columns[3].y-1, transform.columns[3].z-1);
    
    portalNode.position = newVector3;
    
    [self.jpARSCNView.scene.rootNode addChildNode: portalNode];
    
    //按照顺序渲染节点
    [self addPlaneWithNodeName:@"roof"  portalNode:portalNode imageName:@"top"];
    [self addPlaneWithNodeName:@"floor" portalNode:portalNode imageName:@"bottom"];
    
    [self addWallsWithNodeName:@"backWall"   portalNode:portalNode imageName:@"back"];
    [self addWallsWithNodeName:@"sideWallA"  portalNode:portalNode imageName:@"sideA"];
    [self addWallsWithNodeName:@"sideWallB"  portalNode:portalNode imageName:@"sideB"];
    [self addWallsWithNodeName:@"sideDoorA"  portalNode:portalNode imageName:@"sideDoorA"];
    [self addWallsWithNodeName:@"sideDoorB"  portalNode:portalNode imageName:@"sideDoorB"];
    [self addWallsWithNodeName:@"doorHeader" portalNode:portalNode imageName:@"top"];
    
    [self addNodeWithNodeName:@"tower" portalNode:portalNode imageName:@""];
    
}

- (void)addPlaneWithNodeName:(NSString *)nodeName portalNode:(SCNNode *)portalNode imageName:(NSString *)imageName {
    
    SCNNode * childNode = [portalNode childNodeWithName:nodeName recursively:YES];
    
    if (childNode != nil) {
        
        NSString * path = [NSString stringWithFormat:@"Model.scnassets/%@.png",imageName];
        
        childNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:path];
        
        childNode.renderingOrder = 200;
    }
    
}


- (void)addWallsWithNodeName:(NSString *)nodeName portalNode:(SCNNode *)portalNode imageName:(NSString *)imageName {
    
    SCNNode * childNode = [portalNode childNodeWithName:nodeName recursively:YES];
    
    if (childNode != nil) {
        NSString * path = [NSString stringWithFormat:@"Model.scnassets/%@.png",imageName];
        childNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:path];
        
        childNode.renderingOrder = 200;
    }
    
    SCNNode * maskNode = [childNode childNodeWithName:@"mask" recursively:YES];
    maskNode.renderingOrder = 150;
    maskNode.geometry.firstMaterial.transparency = 0.00001; //透明度
    
}

- (void)addNodeWithNodeName:(NSString *)nodeName portalNode:(SCNNode *)portalNode imageName:(NSString *)imageName {
    
    SCNNode * childNode = [portalNode childNodeWithName:nodeName recursively:YES];
    childNode.renderingOrder = 200;
    
}


#pragma mark ============================== 代理方法 ==============================

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
    if ([anchor isKindOfClass: [ARPlaneAnchor class]] == NO) return;
    
    self.planeAnchor = (ARPlaneAnchor *)anchor;
    
    if (self.isShow == NO) {
        [self addPortalWithTransform:self.planeAnchor.transform];
    }
    
}


#pragma mark ============================== 访问器方法 ==============================

- (ARSCNView *)jpARSCNView {
    
    if (_jpARSCNView == nil) {
        
        _jpARSCNView = [[ARSCNView alloc]init];
        
        _jpARSCNView.frame = self.view.frame;
        
        _jpARSCNView.showsStatistics = YES;
        
        _jpARSCNView.delegate = self;
        
        _jpARSCNView.automaticallyUpdatesLighting = YES;
        
        _jpARSCNView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
        
        SCNScene * scene= [[SCNScene alloc]init];
        _jpARSCNView.scene = scene;
        
    }
    
    return _jpARSCNView;
}

- (ARSession *)jpARSession {
    
    if (_jpARSession == nil) {
        _jpARSession = [[ARSession alloc]init];
    }
    
    return _jpARSession;
    
}

- (ARWorldTrackingConfiguration *)jpARWTkConfiguration {
    
    if (_jpARWTkConfiguration == nil) {
        _jpARWTkConfiguration = [[ARWorldTrackingConfiguration alloc]init];
        _jpARWTkConfiguration.planeDetection = ARPlaneDetectionHorizontal;
    }
    
    return _jpARWTkConfiguration;
}

@end

