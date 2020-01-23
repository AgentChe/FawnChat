//
//  AppDelegate.swift
//  FAWN
//
//  Created by Алексей Петров on 16/03/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Amplitude_iOS
import DatingKit
import Firebase
import UserNotifications
import SwiftyStoreKit
import iAd


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
//        Settings.currentBundle =
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
        DatingKit.isLogined { (isLoginned) in
            if isLoginned {
                 NotificationManager.shared.startManagment()
            }
        }
        Amplitude.instance()?.initializeApiKey((Bundle.main.object(forInfoDictionaryKey: "amplitude_key") as! String))
        UIApplication.shared.statusBarStyle = .lightContent
        PurchaseManager.shared.gettingStart()
//        ScreenManager.shared.startManagment()
        
        if let options = launchOptions, let remoteNotif = options[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {
            if let aps = remoteNotif["aps"] as? [String: Any] {
                 
                 ScreenManager.shared.showChat = NotificationManager.shared.handleNotify(userInfo: aps)
               
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = (ApplicationDelegate.shared.application(app, open: url, options: options))
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if self.window?.rootViewController is UINavigationController {
//            let viewController: UINavigationController = self.window?.rootViewController as! UINavigationController
//            ScreenManager.shared.setGeneralController(viewController.viewControllers.first!)
//            ScreenManager.shared.startManagment()
        }
//        if self.window?.rootViewController is UINavigationController {
//            let viewController: UINavigationController = self.window?.rootViewController as! UINavigationController
//            ScreenManager.shared.setGeneralController(viewController.viewControllers.first!)
//            ScreenManager.shared.startManagment()
//        }
//        UIApplication.shared.statusBarStyle = .lightContent        //Set Style UIApplication.shared.isStatusBarHidden = false //Set if hidden
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        NotificationManager.shared.application(application: application, didReceiveRemoteNotification: userInfo)
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NotificationManager.shared.application(application: application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NotificationManager.shared.application(application: application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
}

