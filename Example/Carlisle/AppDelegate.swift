//
//  AppDelegate.swift
//  Carlisle
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import UIKit
import UtilCore
import Carlisle
import Alice
import URLNavigator
import IQKeyboardManagerSwift
import NetWorkCore
import Bella

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let navigator = Navigator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppRouter.initialize(navigator: navigator)
        setCommonAppleance()
        configModule()
        IQKeyboardManager.shared.enable = true
        // Override point for customization after application launch.
        return true
    }
    /**
     设置导航等 的主题颜色
     */
    internal func setCommonAppleance(){
        
        UIApplication.shared.statusBarStyle = .lightContent
        let navigationBarAppearance = UINavigationBar.appearance()
        //设置显示的颜色
        navigationBarAppearance.barTintColor = UIColor.white
        navigationBarAppearance.tintColor = Theme.btn.normal
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
    
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barTintColor = UIColor.white
        tabBarAppearance.isOpaque = true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    
    /*
     模块化基础配置
     */
       func configModule() {
        Envs.baseUrl = ["http://seongbrave.cn/api/v1/"]
        Envs.isDebug = true
        NetWorkCore.baseUrl = Envs.baseUrl
        Global.shared.updateUserFromService()
    }
}
