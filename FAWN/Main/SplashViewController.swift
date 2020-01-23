//
//  SplashViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 11/06/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit
import Amplitude_iOS
import Lottie
import NotificationBannerSwift

class SplashViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var animationBack: AnimationSubview!
    let starAnimationView: AnimationView = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let starAnimation = Animation.named("Preloader")
        starAnimationView.animation = starAnimation
        starAnimationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 400)
        starAnimationView.center = self.view.center
        starAnimationView.contentMode = .scaleAspectFill
        view.addSubview(starAnimationView)
        starAnimationView.loopMode = .loop
        starAnimationView.play()
        AppManager.shared.configurate {
            AppManager.shared.ads()
            DatingKit.isLogined { (isLoggined) in
                if isLoggined {
                    PurchaseManager.shared.getStoreContry { (storeCoutry) in
                        DatingKit.coldStart(storeCountry: storeCoutry) { (status) in
                            if status == .noInternetConnection {
                                let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
                                banner.show(on: self)
                                return
                            }
                            
                            if status == .succses {
                                PurchaseManager.shared.loadResipt()
                                self.starAnimationView.stop()
                                AppManager.shared.setLocale()
                                AppManager.shared.setVercion()
                                ScreenManager.shared.showMian()
                            } else {
                                self.starAnimationView.stop()
                                ScreenManager.shared.showRegistration()
                            }
                        }
                    }
                    
                } else {
                    self.starAnimationView.stop()
                    ScreenManager.shared.showRegistration()
                }
            }
        }
        
    }
    
    func requestNotify() {
        let show: Bool = UserDefaults.standard.bool(forKey: NotificationManager.kWasShow)
        
        if UserDefaults.standard.bool(forKey: NotificationManager.kWasShow) == false {
            UserDefaults.standard.set(true, forKey: NotificationManager.kWasShow)
            
            if !UIApplication.shared.isRegisteredForRemoteNotifications {
                NotificationManager.shared.requestAccses()
            }
            
        }
    }
    
}
