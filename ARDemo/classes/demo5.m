//
//  demo5.m
//  ARDemo
//
//  Created by AK on 2018/5/29.
//  Copyright © 2018年 11. All rights reserved.
//

#import "demo5.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface demo5 ()

@property(nonatomic, strong) NSMutableDictionary *animations;

@property(nonatomic, strong) SCNSceneSource *sceneSource;

@property(nonatomic, assign) BOOL idle;

@end

@implementation demo5

#pragma mark ======================== 生命周期 ========================

- (void)viewDidLoad
{
    [super viewDidLoad];

    SCNScene *scene = [[SCNScene alloc] init];

    self.arSCNView.scene = scene;

    self.animations = [[NSMutableDictionary alloc] init];

    self.idle = YES;

    [self loadAnimations];

    [self initBtn];
}

//按钮控制动画从何时开始 持续多久
- (void)initBtn
{
    UIButton *b1 = [UIButton buttonWithType:0];
    UIButton *b2 = [UIButton buttonWithType:0];
    UIButton *b3 = [UIButton buttonWithType:0];
    b1.tag = 0;
    b2.tag = 2;
    b3.tag = 5;

    b1.frame = CGRectMake(SCREEN_WIDTH / 5 - 30, SCREEN_HEIGHT * 0.8, 60, 30);
    [b1 setTitle:@"0-2s" forState:0];
    [b1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

    b2.frame = CGRectMake(SCREEN_WIDTH / 5 * 2, SCREEN_HEIGHT * 0.8, 60, 30);
    [b2 setTitle:@"2-5s" forState:0];
    [b2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

    b3.frame = CGRectMake(SCREEN_WIDTH / 5 * 3 + 20, SCREEN_HEIGHT * 0.8, 60, 30);
    [b3 setTitle:@"5-~" forState:0];
    [b3 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:b1];
    [self.view addSubview:b2];
    [self.view addSubview:b3];
}

- (void)click:(UIButton *)btn
{
    [self.arSCNView.scene.rootNode removeAllAnimations];

    //在场景源中返回指定的类
    CAAnimation *animation1 =
        [self.sceneSource entryWithIdentifier:@"twist_danceFixed-1" withClass:[CAAnimation class]];

    if (animation1)
    {
        animation1.repeatCount = 1;       //动画次数
        animation1.fadeInDuration = 1.0;  //让动画开始得没那么突兀
        animation1.fadeOutDuration = 0.5;

        animation1.timeOffset = 0;
        animation1.duration = btn.tag;  //播放时间
    }
    
    [self.arSCNView.scene.rootNode addAnimation:animation1 forKey:@"dancing"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self.arSCNView.scene.rootNode removeAnimationForKey:@"dancing" blendOutDuration:0.5];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];

    [self.arSCNView.session runWithConfiguration:configuration];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.arSCNView.session pause];
}

#pragma mark ======================== 私有方法 ========================

- (void)loadAnimations
{
    SCNScene *idleScene = [SCNScene sceneNamed:@"art.scnassets/idle/idleFixed.dae"];  //获取.dae文件都是用SCNScene来接收

    SCNNode *node = [[SCNNode alloc] init];  //一个节点可以有很多子节点

    for (SCNNode *child in idleScene.rootNode.childNodes)
    {
        [node addChildNode:child];
    }

    SCNVector3 extractedExpr = SCNVector3Make(0, -1, -2);
    node.position = extractedExpr;
    node.scale = SCNVector3Make(0.2, 0.2, 0.2);  //模型的大小

    [self.arSCNView.scene.rootNode addChildNode:node];

    [self loadAnimationWithKey:@"dancing"
                     sceneName:@"art.scnassets/idle/twist_danceFixed"
           animationIdentifier:@"twist_danceFixed-1"];
}

// 把动画准备好 装在字典里
- (void)loadAnimationWithKey:(NSString *)key
                   sceneName:(NSString *)sceneName
         animationIdentifier:(NSString *)animationIdentifier
{
    NSString *sceneURL = [[NSBundle mainBundle] pathForResource:sceneName ofType:@"dae"];

    NSURL *url = [NSURL fileURLWithPath:sceneURL];

    SCNSceneSource *sceneSource = [SCNSceneSource sceneSourceWithURL:url options:nil];
    self.sceneSource = sceneSource;

    //在场景源中返回指定的类
    CAAnimation *animationObject = [sceneSource entryWithIdentifier:animationIdentifier withClass:[CAAnimation class]];

    if (animationObject)
    {
        NSLog(@"获取到了这个对象");
        animationObject.repeatCount = 1;       //动画次数
        animationObject.fadeInDuration = 1.0;  //让动画开始得没那么突兀
        animationObject.fadeOutDuration = 0.5;

        [self.animations setObject:animationObject forKey:key];
        ;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点击了屏幕");

    // 获取到手势的对象
    UITouch *touch = [touches allObjects].firstObject;

    // 手势在SCNView中的位置
    CGPoint touchPoint = [touch locationInView:self.arSCNView];

    //该方法会返回一个SCNHitTestResult数组，这个数组中每个元素的node都包含了指定的点（CGPoint）
    NSArray *hitResults = [self.arSCNView hitTest:touchPoint options:nil];

    if (hitResults.count > 0)
    {
        if (self.idle)
        {
            [self playAnimation:@"dancing"];
        }
        else
        {
            [self stopAnimation:@"dancing"];
        }
        self.idle = !self.idle;
        return;
    }
}

- (void)playAnimation:(NSString *)key
{
    CAAnimation *animationObject = self.animations[key];
    if (animationObject)
    {
        [self.arSCNView.scene.rootNode addAnimation:animationObject forKey:key];
    }
}

- (void)stopAnimation:(NSString *)key
{
    self.idle = NO;

    [self.arSCNView.scene.rootNode removeAnimationForKey:key blendOutDuration:0.5];
}

@end
