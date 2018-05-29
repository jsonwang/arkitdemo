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
 *      Name: HelloARCloud
 *      Bundle ID: cn.easyar.samples.helloarcloud
 *  3. find the created item in the list and show key
 *  4. set key string bellow
 */
NSString * key = @"===PLEASE ENTER YOUR KEY HERE===";
NSString * cloud_server_address = @"===PLEASE ENTER YOUR CLOUD SERVER ADDRESS HERE===";
NSString * cloud_key = @"===PLEASE ENTER YOUR CLOUD KEY HERE===";
NSString * cloud_secret = @"===PLEASE ENTER YOUR CLOUD SECRET HERE===";

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
