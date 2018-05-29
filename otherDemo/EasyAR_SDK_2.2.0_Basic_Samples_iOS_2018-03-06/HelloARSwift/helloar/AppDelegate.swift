//=============================================================================================================================
//
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

import UIKit
import EasyARSwift

//
// Steps to create the key for this sample:
//  1. login www.easyar.com
//  2. create app with
//      Name: HelloAR
//      Bundle ID: cn.easyar.samples.helloar
//  3. find the created item in the list and show key
//  4. set key string bellow
//
let key = "===PLEASE ENTER YOUR KEY HERE==="

@UIApplicationMain
internal class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if !Engine.initialize(key) {
            print("Initialization Failed.")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        Engine.onPause()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Engine.onResume()
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
