//=============================================================================================================================
//
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "AppDelegate.h"

#import <easyar/engine.oc.h>

/*
 * Steps to create the key for this sample:
 *  1. login www.easyar.com
 *  2. create app with
 *      Name: HelloARMultiTargetMT
 *      Bundle ID: cn.easyar.samples.helloarmultitargetmt
 *  3. find the created item in the list and show key
 *  4. set key string bellow
 */
NSString * key = @"GyxFVgHeOCqUk0I8pWc3VasPumKwVwd5a68UguYRCl4Gu1kYCbNWjwEE4e9Wa8egoU90iUeqGWymD0oJ9o8a5FdZleW0Z0pt3TYx0RINsOozO77JexWmWIQJ8RpZU70AZeYJlit66IUvAvUNSeFO8uiuudzQAZEZe9cVI7NNTI4ZqggDnCysOAzdhsy7KFOmXRLw0Oas";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    (void)application;
    (void)launchOptions;
    if (![easyar_Engine initialize:key]) {
        NSLog(@"Initialization Failed.");
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    (void)application;
    [easyar_Engine onPause];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    (void)application;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    (void)application;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    (void)application;
    [easyar_Engine onResume];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    (void)application;
}

@end
