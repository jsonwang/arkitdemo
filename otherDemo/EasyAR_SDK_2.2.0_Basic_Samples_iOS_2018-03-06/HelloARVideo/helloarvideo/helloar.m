//=============================================================================================================================
//
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "helloar.h"

#import "VideoRenderer.h"
#import "ARVideo.h"

#import <easyar/types.oc.h>
#import <easyar/camera.oc.h>
#import <easyar/frame.oc.h>
#import <easyar/framestreamer.oc.h>
#import <easyar/imagetracker.oc.h>
#import <easyar/imagetarget.oc.h>
#import <easyar/renderer.oc.h>

#include <OpenGLES/ES2/gl.h>

easyar_CameraDevice * camera = nil;
easyar_CameraFrameStreamer * streamer = nil;
NSMutableArray<easyar_ImageTracker *> * trackers = nil;
easyar_Renderer * videobg_renderer = nil;
NSMutableArray<VideoRenderer *> * video_renderers = nil;
VideoRenderer * current_video_renderer = nil;
int tracked_target = 0;
int active_target = 0;
ARVideo * video = nil;
bool viewport_changed = false;
int view_size[] = {0, 0};
int view_rotation = 0;
int viewport[] = {0, 0, 1280, 720};

void loadFromImage(easyar_ImageTracker * tracker, NSString * path)
{
    easyar_ImageTarget * target = [easyar_ImageTarget create];
    NSString * name = [path substringToIndex:[path rangeOfString:@"."].location];
    NSString * jstr = [@[@"{\n"
        "  \"images\" :\n"
        "  [\n"
        "    {\n"
        "      \"image\" : \"", path, @"\",\n"
        "      \"name\" : \"", name, @"\"\n"
        "    }\n"
        "  ]\n"
        "}"] componentsJoinedByString:@""];
    [target setup:jstr storageType:(easyar_StorageType_Assets | easyar_StorageType_Json) name:@""];
    [tracker loadTarget:target callback:^(easyar_Target * target, bool status) {
        NSLog(@"load target (%d): %@ (%d)", status, [target name], [target runtimeID]);
    }];
}

void loadAllFromJsonFile(easyar_ImageTracker * tracker, NSString * path)
{
    for (easyar_ImageTarget * target in [easyar_ImageTarget setupAll:path storageType:easyar_StorageType_Assets]) {
        [tracker loadTarget:target callback:^(easyar_Target * target, bool status) {
            NSLog(@"load target (%d): %@ (%d)", status, [target name], [target runtimeID]);
        }];
    }
}

BOOL initialize()
{
    camera = [easyar_CameraDevice create];
    streamer = [easyar_CameraFrameStreamer create];
    [streamer attachCamera:camera];

    bool status = true;
    status &= [camera open:easyar_CameraDeviceType_Default];
    [camera setSize:[easyar_Vec2I create:@[@1280, @720]]];

    if (!status) { return status; }
    easyar_ImageTracker * tracker = [easyar_ImageTracker create];
    [tracker attachStreamer:streamer];
    loadAllFromJsonFile(tracker, @"targets.json");
    loadFromImage(tracker, @"namecard.jpg");
    trackers = [[NSMutableArray<easyar_ImageTracker *> alloc] init];
    [trackers addObject:tracker];

    return status;
}

void finalize()
{
    video = nil;
    tracked_target = 0;
    active_target = 0;

    [trackers removeAllObjects];
    [video_renderers removeAllObjects];
    current_video_renderer = nil;
    videobg_renderer = nil;
    streamer = nil;
    camera = nil;
}

BOOL start()
{
    bool status = true;
    status &= (camera != nil) && [camera start];
    status &= (streamer != nil) && [streamer start];
    [camera setFocusMode:easyar_CameraDeviceFocusMode_Continousauto];
    for (easyar_ImageTracker * tracker in trackers) {
        status &= [tracker start];
    }
    return status;
}

BOOL stop()
{
    bool status = true;
    for (easyar_ImageTracker * tracker in trackers) {
        status &= [tracker stop];
    }
    status &= (streamer != nil) && [streamer stop];
    status &= (camera != nil) && [camera stop];
    return status;
}

void initGL()
{
    if (active_target != 0) {
        [video onLost];
        video = nil;
        tracked_target = 0;
        active_target = 0;
    }
    videobg_renderer = nil;
    videobg_renderer = [easyar_Renderer create];
    video_renderers = [[NSMutableArray<VideoRenderer *> alloc] init];
    for (int k = 0; k < 3; k += 1) {
        VideoRenderer * video_renderer = [[VideoRenderer alloc] init];
        [video_renderer init_];
        [video_renderers addObject:video_renderer];
    }
    current_video_renderer = nil;
}

void resizeGL(int width, int height)
{
    view_size[0] = width;
    view_size[1] = height;
    viewport_changed = true;
}

void updateViewport()
{
    easyar_CameraCalibration * calib = camera != nil ? [camera cameraCalibration] : nil;
    int rotation = calib != nil ? [calib rotation] : 0;
    if (rotation != view_rotation) {
        view_rotation = rotation;
        viewport_changed = true;
    }
    if (viewport_changed) {
        int size[] = {1, 1};
        if (camera && [camera isOpened]) {
            size[0] = [[[camera size].data objectAtIndex:0] intValue];
            size[1] = [[[camera size].data objectAtIndex:1] intValue];
        }
        if (rotation == 90 || rotation == 270) {
            int t = size[0];
            size[0] = size[1];
            size[1] = t;
        }
        float scaleRatio = MAX((float)view_size[0] / (float)size[0], (float)view_size[1] / (float)size[1]);
        int viewport_size[] = {(int)roundf(size[0] * scaleRatio), (int)roundf(size[1] * scaleRatio)};
        int viewport_new[] = {(view_size[0] - viewport_size[0]) / 2, (view_size[1] - viewport_size[1]) / 2, viewport_size[0], viewport_size[1]};
        memcpy(&viewport[0], &viewport_new[0], 4 * sizeof(int));
        
        if (camera && [camera isOpened])
            viewport_changed = false;
    }
}

void render()
{
    glClearColor(1.f, 1.f, 1.f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    if (videobg_renderer != nil) {
        int default_viewport[] = {0, 0, view_size[0], view_size[1]};
        easyar_Vec4I * oc_default_viewport = [easyar_Vec4I create:@[[NSNumber numberWithInt:default_viewport[0]], [NSNumber numberWithInt:default_viewport[1]], [NSNumber numberWithInt:default_viewport[2]], [NSNumber numberWithInt:default_viewport[3]]]];
        glViewport(default_viewport[0], default_viewport[1], default_viewport[2], default_viewport[3]);
        if ([videobg_renderer renderErrorMessage:oc_default_viewport]) {
            return;
        }
    }

    if (streamer == nil) { return; }
    easyar_Frame * frame = [streamer peek];
    updateViewport();
    glViewport(viewport[0], viewport[1], viewport[2], viewport[3]);

    if (videobg_renderer != nil) {
        [videobg_renderer render:frame viewport:[easyar_Vec4I create:@[[NSNumber numberWithInt:viewport[0]], [NSNumber numberWithInt:viewport[1]], [NSNumber numberWithInt:viewport[2]], [NSNumber numberWithInt:viewport[3]]]]];
    }

    NSArray<easyar_TargetInstance *> * targetInstances = [frame targetInstances];
    if ([targetInstances count] > 0) {
        easyar_TargetInstance * targetInstance = [targetInstances objectAtIndex:0];
        easyar_Target * target = [targetInstance target];
        int status = [targetInstance status];
        if (status == easyar_TargetStatus_Tracked) {
            int runtimeID = [target runtimeID];
            if (active_target != 0 && active_target != runtimeID) {
                [video onLost];
                video = nil;
                tracked_target = 0;
                active_target = 0;
            }
            if (tracked_target == 0) {
                if (video == nil && [video_renderers count] > 0) {
                    NSString * target_name = [target name];
                    if ([target_name isEqualToString:@"argame"] && [[video_renderers objectAtIndex:0] texid] != 0) {
                        video = [[ARVideo alloc] init];
                        [video openVideoFile:@"video.mp4" texid:[[video_renderers objectAtIndex:0] texid]];
                        current_video_renderer = [video_renderers objectAtIndex:0];
                    } else if ([target_name isEqualToString:@"namecard"] && [[video_renderers objectAtIndex:1] texid] != 0) {
                        video = [[ARVideo alloc] init];
                        [video openTransparentVideoFile:@"transparentvideo.mp4" texid:[[video_renderers objectAtIndex:1] texid]];
                        current_video_renderer = [video_renderers objectAtIndex:1];
                    } else if ([target_name isEqualToString:@"idback"] && [[video_renderers objectAtIndex:2] texid] != 0) {
                        video = [[ARVideo alloc] init];
                        [video openStreamingVideo:@"https://sightpvideo-cdn.sightp.com/sdkvideo/EasyARSDKShow201520.mp4" texid:[[video_renderers objectAtIndex:2] texid]];
                        current_video_renderer = [video_renderers objectAtIndex:2];
                    }
                }
                if (video != nil) {
                    [video onFound];
                    tracked_target = runtimeID;
                    active_target = runtimeID;
                }
            }
            easyar_ImageTarget * imagetarget = [target isKindOfClass:[easyar_ImageTarget class]] ? (easyar_ImageTarget *)target : nil;
            if (imagetarget != nil) {
                if (current_video_renderer != nil) {
                    [video update];
                    if ([video isRenderTextureAvailable]) {
                        [current_video_renderer render:[camera projectionGL:0.2f farPlane:500.f] cameraview:[targetInstance poseGL] size:[imagetarget size]];
                    }
                }
            }
        }
    } else {
        if (tracked_target != 0) {
            [video onLost];
            tracked_target = 0;
        }
    }
}
