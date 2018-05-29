//
//  ViewController.m
//  射击类小游戏
//
//  Created by LJP on 6/12/17.
//  Copyright © 2017年 poco. All rights reserved.
//

#import "ViewController.h"

#import "Ship.h"
#import "Bullet.h"

@interface ViewController () <ARSCNViewDelegate,SCNPhysicsContactDelegate>

@property(nonatomic, strong) UILabel * l;

//视图
@property(nonatomic, strong) ARSCNView * jpARSCNView;

//会话
@property(nonatomic, strong) ARSession * jpARSession;

//跟踪会话
@property(nonatomic, strong) ARWorldTrackingConfiguration * jpARWTkConfiguration;


@end

    
@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.view addSubview:self.jpARSCNView];
    
    [self initUI];
    
    [self addNewShip];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.jpARSCNView.session runWithConfiguration:self.jpARWTkConfiguration];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}


#pragma mark - 初始化UI

-(void)initUI {
    
    UILabel * l = [[UILabel alloc]init];
    
    l.frame = CGRectMake(self.view.frame.size.width/2-50, 60, 100, 60);
    
    l.text = @"0";
    
    l.textColor = [UIColor whiteColor];
    
    l.textAlignment = NSTextAlignmentCenter;
    
    self.l = l;
    
    [self.view addSubview:l];
}

#pragma mark - 私有方法


- (void)addNewShip {
    
    Ship * cubeNode = [[Ship alloc]init];
    
    float x = [self floatBetween];
    float y = [self floatBetween];
    
    cubeNode.position = SCNVector3Make(x, y, -1);
    
    [self.jpARSCNView.scene.rootNode addChildNode:cubeNode];
    
}


//生产随机数
- (CGFloat )floatBetween {

    CGFloat a = (float)(1+arc4random()%99)/100-0.5;
    
    NSLog(@"a == %f",a);
    
    return a;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    NSLog(@"点击了");


    Bullet * bulletsNode = [[Bullet alloc]init];

    NSArray * arr = [self getUserVector];

    NSValue * dirValue = arr[0];
    NSValue * posValue = arr[1];

    SCNVector3 direction = [dirValue SCNVector3Value];
    SCNVector3 position  = [posValue SCNVector3Value];

    bulletsNode.position = position;

    SCNVector3 bulletDirection = direction;

    [bulletsNode.physicsBody applyForce:bulletDirection impulse:YES];

    [self.jpARSCNView.scene.rootNode addChildNode:bulletsNode];

}

- (void)removeNodeWithAnimation:(SCNNode *)node explosion:(BOOL)explosion {
    
    NSLog(@"动画");
    
    if (explosion) {
        
        SCNParticleSystem * particleSystem = [SCNParticleSystem particleSystemNamed:@"explosion" inDirectory:nil];
        
        SCNNode * systemNode = [[SCNNode alloc]init];
        
        [systemNode addParticleSystem:particleSystem];
        
        systemNode.position = node.position;
        
        [self.jpARSCNView.scene.rootNode addChildNode:systemNode];
        
    }
    
    [node removeFromParentNode];
    
}

- (NSArray *)getUserVector {

    ARFrame * frame = self.jpARSCNView.session.currentFrame;
    
    if (frame) {
        
        SCNMatrix4 mat = SCNMatrix4FromMat4(frame.camera.transform);
        
        SCNVector3 dir = SCNVector3Make(-1* mat.m31, -1* mat.m32 , -1* mat.m33);
        
        SCNVector3 pos = SCNVector3Make(mat.m41,mat.m42 ,mat.m43);
        
        NSValue * dirValue = [NSValue valueWithSCNVector3:dir];
        NSValue * posValue = [NSValue valueWithSCNVector3:pos];
        
        return @[dirValue,posValue];
        
    }else {
        
        NSValue * dirValue = [NSValue valueWithSCNVector3:(SCNVector3Make(0, 0, -1))];
        NSValue * posValue = [NSValue valueWithSCNVector3:(SCNVector3Make(0, 0, -0.2))];
        
        return @[dirValue,posValue];
    }
    
}


#pragma mark - ARSCNViewDelegate

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    // Present an error message to the user
    
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
}

// 这里是自己独立开一条线程出来
- (void)physicsWorld:(SCNPhysicsWorld *)world didBeginContact:(SCNPhysicsContact *)contact {
    
    NSLog(@"触发");
    
    if (contact.nodeA.physicsBody.categoryBitMask == 2 ||
        contact.nodeB.physicsBody.categoryBitMask == 2) {
        
        [self removeNodeWithAnimation:contact.nodeB explosion:NO];
        
        dispatch_sync(dispatch_get_main_queue(), ^(){
            self.l.text = [NSString stringWithFormat:@"%ld", ([self.l.text integerValue]+1)];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self removeNodeWithAnimation:contact.nodeA explosion:YES];
            [self addNewShip];
            
        });
        
    }
    
}



#pragma mark - 访问器方法

- (ARSCNView *)jpARSCNView {
    
    if (_jpARSCNView == nil) {
        
        _jpARSCNView = [[ARSCNView alloc]init];
        
        _jpARSCNView.frame = self.view.frame;
        
        _jpARSCNView.delegate = self;
        
        _jpARSCNView.showsStatistics = YES;
        
        SCNScene * scene= [[SCNScene alloc]init];
        _jpARSCNView.scene = scene;
        
        _jpARSCNView.scene.physicsWorld.contactDelegate = self;
        
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
//        _jpARWTkConfiguration.lightEstimationEnabled = YES;
    }
    
    return _jpARWTkConfiguration;
    
}


@end
