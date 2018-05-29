//=============================================================================================================================
//
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "OpenGLView.h"
#import "AppDelegate.h"

#import "helloar.h"

#import <easyar/engine.oc.h>

@interface OpenGLView ()
{
}

@end

@implementation OpenGLView {
    BOOL initialized;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self->initialized = false;
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    self.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    self.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    [self bindDrawable];
    return self;
}

- (void)dealloc
{
}

- (void)start
{
    if (initialize(^(NSString * s) {
        [OpenGLView displayToastWithMessage:s];
    })) {
        start();
    }
}

- (void)stop
{
    stop();
    finalize();
}

- (void)resize:(CGRect)frame orientation:(UIInterfaceOrientation)orientation
{
    float scale;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
        scale = [[UIScreen mainScreen] nativeScale];
#pragma clang diagnostic pop
    } else {
        scale = [[UIScreen mainScreen] scale];
    }

    resizeGL(frame.size.width * scale, frame.size.height * scale);
}

- (void)drawRect:(CGRect)rect
{
    if (!initialized) {
        initGL();
        initialized = YES;
    }
    render();
}

- (void)setOrientation:(UIInterfaceOrientation)orientation
{
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
            [easyar_Engine setRotation:270];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            [easyar_Engine setRotation:90];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [easyar_Engine setRotation:180];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [easyar_Engine setRotation:0];
            break;
        default:
            break;
    }
}

+ (void)displayToastWithMessage:(NSString *)toastMessage
{
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UILabel * toastView = [[UILabel alloc] init];
    toastView.text = toastMessage;
    toastView.textAlignment = NSTextAlignmentCenter;
    toastView.lineBreakMode = NSLineBreakByWordWrapping;
    toastView.numberOfLines = 0;
    toastView.frame = CGRectMake(0.0, 0.0, keyWindow.frame.size.width/2.0, 200.0);
    toastView.layer.cornerRadius = 10;
    toastView.layer.masksToBounds = YES;
    toastView.center = keyWindow.center;

    [keyWindow addSubview:toastView];

    [UIView animateWithDuration: 3.0f
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         toastView.alpha = 0.0;
                     }
                     completion: ^(BOOL finished) {
                         [toastView removeFromSuperview];
                     }
     ];
}

@end
