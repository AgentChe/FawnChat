//
//  HelloViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 14/04/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import AlamofireImage
import Amplitude_iOS
import DatingKit
import NotificationBannerSwift


class HelloViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        PaymentFlow.shared.delegate = self
        userImageView.image = UIImage()
        nameLabel.text = NSLocalizedString("hello", comment: "") + ", ..."
        DatingKit.user.show { [weak self] (userShow, status) in
            if status == .noInternetConnection {
                let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
                banner.show(on: self?.navigationController)
                return
            }
            
            if status == .succses {
                guard let user: UserShow = userShow else {
                    return
                }
                Amplitude.instance()?.setUserId(String(user.id))
                self!.nameLabel.text = NSLocalizedString("hello", comment: "") + ", " + user.name
                if let url: URL = URL(string: user.avatarURL) {
                    self!.userImageView.af_setImage(withURL: url)
                }
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Amplitude.instance()?.log(event: .avatarScr)
    }
    
    func config(user: UserShow) {
        guard let url: URL = URL(string: user.avatarURL) else { return }
        
        userImageView.af_setImage(withURL: url,
                                  placeholderImage: nil,
                                  filter: nil,
                                  progress: nil,
                                  progressQueue: DispatchQueue.main,
                                  imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                  runImageTransitionIfCached: true)
        { [weak self] (image) in
                self?.imageHeight.constant = 128
                self?.imageWeight.constant = 128
                self?.userImageView.rotate(-20)
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.userImageView.rotate(20)
                    self!.view.layoutIfNeeded()
                    self!.userImageView.layer.cornerRadius = self!.userImageView.bounds.size.height/2
                    self?.nameLabel.alpha = 1.0
                    self?.subtitleLabel.alpha = 1.0
                    self!.nameLabel.text = NSLocalizedString("hello", comment: "") + ", " + user.name
                })
            }
           
                                    
        }

    @IBAction func tapOnRandomaze(_ sender: UIButton) {
        Amplitude.instance()?.log(event: .avatarRandTap)
        imageHeight.constant = 0
        imageWeight.constant = 0
        UIView.animate(withDuration: 0.2) { [weak self] in
            self!.view.layoutIfNeeded()
            self!.userImageView.layer.cornerRadius = self!.userImageView.bounds.size.height/2
            self?.nameLabel.alpha = 0.0
            self?.subtitleLabel.alpha = 0.0
        }
        
        DatingKit.user.randomize { [weak self] (userShow, status) in
            if status == .noInternetConnection {
                let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
                banner.show(on: self?.navigationController)
                return
            }
            
            if status == .succses {
                guard let user: UserShow = userShow else {
                    return
                }
                
                self?.config(user: user)
            }
        }
        
    }
    
    @IBAction func tapOnContinue(_ sender: Any) {
        Amplitude.instance()?.log(event: .avatarContinueTap)
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
            NotificationManager.shared.startManagment()
            NotificationManager.shared.requestAccess()
            if PurchaseManager.shared.showUponLogin {
                PurchaseManager.shared.loadProducts { (config) in
                    self.performSegue(withIdentifier: "paygate", sender: config)
                    return
                }
                return
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.alpha = 0.0
            }) { (fin) in
                 self.performSegue(withIdentifier: "start_new2", sender: nil)
            }
           
        } else {
            self.performSegue(withIdentifier: "notific", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paygate" {
            let paygate: PaygateViewController = segue.destination as! PaygateViewController
            let config: ConfigBundle = sender as! ConfigBundle
//            PurchaseManager.shared.loadProducts()
            paygate.delegate = self
            paygate.config(bundle: config)
        }
    }
}


extension HelloViewController: PaygateViewDelegate {
    
    func purchaseWasEndet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0.0
        }) { (fin) in
            self.performSegue(withIdentifier: "manualySearch", sender: nil)
        }
    }
    
}

extension HelloViewController: PaymentFlowDelegate {
    
    func purchase() {
        
    }
    
    func paymentInfoWasLoad(config bundle: ConfigBundle) {
        ScreenManager.shared.showMian()
    }
    
    func paymentSuccses() {
        
    }
    
    func error() {
        
    }
    
    
}
