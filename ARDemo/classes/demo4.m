

//
//  demo4.m
//  ARDemo
//
//  Created by AK on 2018/5/28.
//  Copyright © 2018年 11. All rights reserved.
//https://mp.weixin.qq.com/s/YJ82vQYHAMmtueDgHgKcNA
//http://fighting300.com/2017/09/13/ARKit-Face/
#import <ARKit/ARKit.h>
#import "demo4.h"

@interface demo4 ()<ARSCNViewDelegate>
{
    
   
}
@property (strong, nonatomic) ARSCNView *sceneView;
@property (nonatomic) BOOL needRenderNode;
@property (strong, nonatomic) SCNNode *faceNode;
@end

@implementation demo4

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _needRenderNode=YES;
    
    [self.view addSubview:self.sceneView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Start the view's session
    ARFaceTrackingConfiguration *configuration = [ARFaceTrackingConfiguration new];
    [self.sceneView.session runWithConfiguration:configuration];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    [self.sceneView.session pause];
}

#pragma mark config lazy
- (ARSCNView *)sceneView
{
    if (!_sceneView) {
        _sceneView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        // 显示fps等信息
        _sceneView.showsStatistics = YES;
        // set up delegate
        _sceneView.delegate = self;
        
        // config camera
        _sceneView.pointOfView.camera.wantsHDR = YES;
        _sceneView.pointOfView.camera.exposureOffset = -1;
        _sceneView.pointOfView.camera.minimumExposure = -1;
        _sceneView.pointOfView.camera.maximumExposure = 3;
        _sceneView.automaticallyUpdatesLighting = NO;
  
    }
    return _sceneView;
}


- (SCNNode *)faceNode{
    if (!_faceNode) {
        _faceNode = [self makeFaceGeometry:^(SCNMaterial *material) {
            material.fillMode = SCNFillModeFill;
            material.diffuse.contents = [UIImage imageNamed:@"wood.png"];
        } fillMesh: NO];//fillMesh 设置为 no 时眼睛和嘴都是镂空的
        _faceNode.name = @"myFace";
        
        SCNLight *directional = [SCNLight light];
        directional.type  = SCNLightTypeDirectional;
        directional.color = [UIColor colorWithWhite:1 alpha:1.0];
        directional.castsShadow = YES;
        _faceNode.light=directional;
    }
    return _faceNode;
}
- (SCNNode*)makeFaceGeometry:(void (^)(SCNMaterial*))materialSetup fillMesh:(BOOL)fillMesh
{
#if TARGET_OS_SIMULATOR
    return [SCNNode new];
#else
    id<MTLDevice> device = self.sceneView.device;
    
    ARSCNFaceGeometry *geometry = [ARSCNFaceGeometry faceGeometryWithDevice:device fillMesh:fillMesh];
    SCNMaterial *material = geometry.firstMaterial;
    if(material && materialSetup)
        materialSetup(material);
    return [SCNNode nodeWithGeometry:geometry];
#endif
}


#pragma mark - ARSCNViewDelegate
- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    if (!faceAnchor || ![faceAnchor isKindOfClass:[ARFaceAnchor class]]) {
        return;
    }
    
    if (_needRenderNode) {
        [node addChildNode:self.faceNode];
        _needRenderNode = NO;
    }
    
    ARSCNFaceGeometry *faceGeometry = (ARSCNFaceGeometry *)self.faceNode.geometry;
    if( faceGeometry && [faceGeometry isKindOfClass:[ARSCNFaceGeometry class]] ) {
        [faceGeometry updateFromFaceGeometry:faceAnchor.geometry];
    }
    [self performSelectorOnMainThread:@selector(faceLog:) withObject:faceAnchor waitUntilDone:YES];
    //[self faceLog:faceAnchor];
}

-(void)faceLog:(ARFaceAnchor *)faceAnchor{
//    NSMutableAttributedString *mouthAndJawLogStr=[[NSMutableAttributedString alloc] init];
//    NSMutableAttributedString *eyeAndOtherLogStr=[[NSMutableAttributedString alloc] init];
//    
//    NSDictionary *blendShapes = faceAnchor.blendShapes;
//    NSArray *keys =[blendShapes allKeys];
//    NSArray *sortedArray = [keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//    for (int i=0; i<sortedArray.count; i++) {
//        //key
//        NSString *key = [sortedArray objectAtIndex:i];
//        NSDictionary *keyStringColor = [NSDictionary dictionaryWithObjectsAndKeys:
//                                        [UIColor blackColor],NSForegroundColorAttributeName,
//                                        nil];
//        NSAttributedString *keyStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ : ",key] attributes:keyStringColor];
//        if ([key containsString:@"mouth"] || [key containsString:@"jaw"]) {
//            [mouthAndJawLogStr appendAttributedString:keyStr];
//        }else{
//            [eyeAndOtherLogStr appendAttributedString:keyStr];
//        }
//        
//        //value
//        float value = [[blendShapes objectForKey:key] floatValue];
//        UIColor *txtColor = [UIColor colorWithRed:(1-value) green:(1-value) blue:(1-value) alpha:1.0];
//        NSDictionary *valueStringColor = [NSDictionary dictionaryWithObjectsAndKeys:
//                                          txtColor,NSForegroundColorAttributeName,
//                                          nil];
//        NSAttributedString *valueStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.4f\n",value] attributes:valueStringColor];
//        if ([key containsString:@"mouth"] || [key containsString:@"jaw"]) {
//            [mouthAndJawLogStr appendAttributedString:valueStr];
//        }else{
//            [eyeAndOtherLogStr appendAttributedString:valueStr];
//        }
//    }
//    self.mouthAndJawLogView.attributedText=mouthAndJawLogStr;
//    self.eyeAndOtherLogView.attributedText=eyeAndOtherLogStr;
}


@end
