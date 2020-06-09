//
//  AppDelegate.swift
//  FAWN
//
//  Created by Алексей Петров on 16/03/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import DatingKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = FAWNNavigationController(rootViewController: SplashViewController.make())
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        IDFAService.shared.configure()
        AmplitudeAnalytics.shared.configure()
        FacebookAnalytics.shared.configure()
        
        DatingKit.isLogined { (isLoginned) in
            if isLoginned {
                 NotificationManager.shared.startManagment()
            }
        }
        
        PurchaseManager.shared.gettingStart()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, options: options)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        NotificationManager.shared.application(application: application, didReceiveRemoteNotification: userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NotificationManager.shared.application(application: application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
}
