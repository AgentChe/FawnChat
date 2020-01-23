//
//  RegistrationViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 16/03/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Amplitude_iOS
import DatingKit
import NotificationBannerSwift


class RegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ScreenManager.shared.onScreenController = self
        Amplitude.instance()?.log(event: .loginScr)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func tapOnEmail(_ sender: UIButton) {
        Amplitude.instance()?.log(event: .loginEmailTap)
    }
    
    @IBAction func tapOnTerms(_ sender: Any) {
        Amplitude.instance()?.log(event: .loginTermsTap)
        guard let url = URL(string: "https://fawn.chat/legal/terms") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func tapOnFacebookLogin(_ sender: UIButton) {
        Amplitude.instance()?.log(event: .loginFBTap)
        let manager: LoginManager = LoginManager()
        AccessToken.current = nil
        manager.logOut()
        if AccessToken.current?.tokenString == nil {
            manager.logIn(permissions: ["public_profile", "email"], from: self) { (response, error) in
                if let accessToken: String = AccessToken.current?.tokenString {
                    DatingKit.user.createWithFB(token: accessToken) { (new, status) in
                        PurchaseManager.shared.getStoreContry { (store) in
                            DatingKit.updateADV(storeCountry: store) { (status) in
                                if status == .noInternetConnection {
                                    let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
                                    banner.show(on: self.navigationController)
                                    return
                                }
                                
                                if status == .succses {
                                    if new {
                                        self.performSegue(withIdentifier: "onboarding", sender: nil)
                                    } else {
                                        UIView.animate(withDuration: 0.4, animations: {
                                            self.view.alpha = 0.0
                                        }, completion: { (endet) in
                                            self.performSegue(withIdentifier: "start", sender: nil)
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            guard let accessToken: String = AccessToken.current?.tokenString else { return }
            DatingKit.user.createWithFB(token: accessToken) { (new, status) in
                PurchaseManager.shared.getStoreContry { (store) in
                    DatingKit.updateADV(storeCountry: store) { (status) in
                        if status == .noInternetConnection {
                            let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
                            banner.show(on: self.navigationController)
                            return
                        }
                        
                        if status == .succses {
                            if new {
                                self.performSegue(withIdentifier: "onboarding", sender: nil)
                            } else {
                                UIView.animate(withDuration: 0.4, animations: {
                                    self.view.alpha = 0.0
                                }, completion: { (endet) in
                                    self.performSegue(withIdentifier: "start", sender: nil)
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}


