//
//  JPARRecord.h
//  AR的录屏demo(有声音)
//
//  Created by LJP on 30/1/18.
//  Copyright © 2018年 poco. All rights reserved.
//


/**
 使用方法：
 1.导入头文件
 2.遵循JPARRecordDelegate代理
 3.设置属性
 4.创建对象
 5.设置 renderer.scene = sceneView.scene
 6.调用开始方法
 7.调用结束方法
 **/


#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

//代理
@protocol JPARRecordDelegate <NSObject>

/**
 告诉队友 我已经合成视频了 让他们给用户提示
 */
- (void)endMerge;

@end

@interface JPARRecord : NSObject

/**
 代理
 */
@property (nonatomic,weak) id<JPARRecordDelegate> delegate;

/**
 渲染器 要给renderer赋值 renderer.scene = sceneView.scene;
 */
@property (nonatomic, strong) SCNRenderer * renderer;

/**
 开始录制
 */
- (void)startRecording;

/**
 结束录制
 */
- (void)endRecording;

@end
