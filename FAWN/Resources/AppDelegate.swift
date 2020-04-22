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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = FAWNNavigationController(rootViewController: SplashViewController.make())
        window?.makeKeyAndVisible()
        
        DatingKit.isLogined { (isLoginned) in
            if isLoginned {
                 NotificationManager.shared.startManagment()
            }
        }
        
        Amplitude.instance()?.initializeApiKey((Bundle.main.object(forInfoDictionaryKey: "amplitude_key") as! String))
        
        PurchaseManager.shared.gettingStart()
        
        if let options = launchOptions, let remoteNotif = options[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {
            if let aps = remoteNotif["aps"] as? [String: Any] {
                 
                 ScreenManager.shared.showChat = NotificationManager.shared.handleNotify(userInfo: aps)
               
            }
        }
        
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
