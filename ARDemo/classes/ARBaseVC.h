//
//  ARBaseVC.h
//  ARDemo
//
//  Created by AK on 2018/5/25.
//  Copyright © 2018年 11. All rights reserved.
//

//AR的基础VC类
/*
 1.ARSCNView                 负责展示AR内容
 2.ARSession                 负责管理AR事务
 3.ARSessionConfiguration    负责处理现实世界内容跟踪 ,负责追踪相机的运动
 4.SCNNode                   负责创建节点(模型)
 5.SCNScene                  负责描述3D场景(装模型的容器)
 模版地址  https://www.turbosquid.com/
 http://blog.csdn.net/column/details/16036.html
 
 
 */

#import <UIKit/UIKit.h>
//一个供AR实现内容的平台
#import <SceneKit/SceneKit.h>
//一个实现AR内容的框架
#import <ARKit/ARKit.h>

@interface ARBaseVC : UIViewController
{
    
    
}
//AR视图：展示3D界面
@property(nonatomic,strong)ARSCNView *arSCNView;

//识别特征图片
@property(nonatomic,strong) UIImage * deImage;



@end
