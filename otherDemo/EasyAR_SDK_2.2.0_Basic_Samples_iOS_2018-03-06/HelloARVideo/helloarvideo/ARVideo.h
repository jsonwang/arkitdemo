//=============================================================================================================================
//
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import <Foundation/Foundation.h>

@interface ARVideo : NSObject

- (void)openVideoFile:(NSString *)path texid:(int)texid;
- (void)openTransparentVideoFile:(NSString *)path texid:(int)texid;
- (void)openStreamingVideo:(NSString *)url texid:(int)texid;
- (void)setVideoStatus:(int)status;
- (void)onFound;
- (void)onLost;
- (void)update;
- (bool)isRenderTextureAvailable;

@end
