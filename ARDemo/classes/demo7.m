//
//  demo7.m
//  ARDemo
//
//  Created by AK on 2018/5/29.
//  Copyright © 2018年 11. All rights reserved.
//

#import "demo7.h"

@interface demo7 ()

@end

@implementation demo7

- (void)viewDidLoad { [super viewDidLoad]; }
- (void)viewWillAppear:(BOOL)animated { [super viewWillAppear:animated]; }
- (void)viewWillDisappear:(BOOL)animated { [super viewWillDisappear:animated]; }
#pragma mark ============================== 私有方法 ==============================

- (void)addNode
{
    for (int i = -2; i < 2; i++)
    {
        for (int j = -2; j < 2; j++)
        {
            SCNVector3 position =
                SCNVector3Make(i * 5 + [self getRandomNumber:-3 to:3], 30, j * 5 + [self getRandomNumber:-3 to:3]);

            NSLog(@"x == %lf  z == %lf", position.x, position.z);

            if (position.x == 0 && position.z == 0)
            {
            }
            else
            {
                [self initNodeWithPosition:position];
            }
        }
    }
}

//获取一个随机整数，范围在[from,to），包括from，不包括to
- (int)getRandomNumber:(int)from to:(int)to { return (int)(from + (arc4random() % (to - from + 1))); }
- (void)initNodeWithPosition:(SCNVector3)position
{
    SCNGeometry *geometer = [SCNGeometry geometry];

    geometer = [SCNBox boxWithWidth:1.0 height:1.0 length:0.01 chamferRadius:0];

    SCNMaterial *material = [[SCNMaterial alloc] init];

    material.diffuse.contents = [UIImage imageNamed:@"honbao.png"];

    geometer.materials = @[ material, material, material, material, material, material ];

    SCNNode *geometerNode = [SCNNode nodeWithGeometry:geometer];

    geometerNode.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:nil];

    //设置力
    NSInteger X = (NSInteger)(arc4random_uniform(9)) - 4;

    NSInteger Y = (NSInteger)(1);

    NSInteger Z = (NSInteger)(arc4random_uniform(9)) - 4;

    [geometerNode.physicsBody applyForce:SCNVector3Make(X, -Y, Z)
                              atPosition:SCNVector3Make(0.05, 0.05, 0.05)
                                 impulse:YES];

    geometerNode.position = position;

    [self.arSCNView.scene.rootNode addChildNode:geometerNode];
}

- (void)clean
{
    for (SCNNode *node in self.arSCNView.scene.rootNode.childNodes)
    {
        if (node.presentationNode.position.y < -26)
        {
            @try
            {
                [node removeFromParentNode];
            }
            @catch (NSException *exception)
            {
                NSLog(@"%s:%@", __func__, exception.description);
            }
        }
    }
}

#pragma mark ============================== 代理方法 ==============================
- (void)renderer:(id<SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time
{
    //太快了 限制一下
    if (arc4random() % 3 == 0)
    {
        [self addNode];
        [self clean];
    }
}

@end
