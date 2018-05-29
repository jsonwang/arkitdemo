//=============================================================================================================================
//
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "ARVideo.h"
#import <easyar/player.oc.h>

@implementation ARVideo {
    easyar_VideoPlayer * player;
    BOOL prepared;
    BOOL found;
    NSString * path_;
}

- (instancetype)init
{
    player = [easyar_VideoPlayer create];
    prepared = NO;
    found = NO;
    return self;
}

- (void)openVideoFile:(NSString *)path texid:(int)texid
{
    self->path_ = path;
    [player setRenderTexture:(void *)(texid)];
    [player setVideoType:easyar_VideoType_Normal];
    __weak ARVideo * weak_self = self;
    [player open:path_ storageType:easyar_StorageType_Assets callback:^(easyar_VideoStatus status) {
        [weak_self setVideoStatus:status];
    }];
}

- (void)openTransparentVideoFile:(NSString *)path texid:(int)texid
{
    self->path_ = path;
    [player setRenderTexture:(void *)(texid)];
    [player setVideoType:easyar_VideoType_TransparentSideBySide];
    __weak ARVideo * weak_self = self;
    [player open:path_ storageType:easyar_StorageType_Assets callback:^(easyar_VideoStatus status) {
        [weak_self setVideoStatus:status];
    }];
}

- (void)openStreamingVideo:(NSString *)url texid:(int)texid
{
    self->path_ = url;
    [player setRenderTexture:(void *)(texid)];
    [player setVideoType:easyar_VideoType_Normal];
    __weak ARVideo * weak_self = self;
    [player open:url storageType:easyar_StorageType_Absolute callback:^(easyar_VideoStatus status) {
        [weak_self setVideoStatus:status];
    }];
}

- (void)setVideoStatus:(int)status
{
    NSLog(@"video: %@ (%d)", path_, status);
    if (status == easyar_VideoStatus_Ready) {
        prepared = YES;
        if (found) {
            [player play];
        }
    } else if (status == easyar_VideoStatus_Completed) {
        if (found) {
            [player play];
        }
    }
}

- (void)onFound
{
    found = YES;
    if (prepared) {
        [player play];
    }
}

- (void)onLost
{
    found = NO;
    if (prepared) {
        [player pause];
    }
}

- (void)update
{
    [player updateFrame];
}

- (bool)isRenderTextureAvailable
{
    return [player isRenderTextureAvailable];
}

@end
