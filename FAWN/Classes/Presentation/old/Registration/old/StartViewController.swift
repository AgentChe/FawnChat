//
//  StartViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 14/07/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit
import Lottie
import Amplitude_iOS
import NotificationBannerSwift

class StartViewController: UIViewController {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var submessageLabel: UILabel!
    @IBOutlet weak var continueButton: GradientButton!
    
    let starAnimationView: AnimationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let starAnimation = Animation.named("Preloader_v2") //FawnIntro2(2)
        starAnimationView.animation = starAnimation
        starAnimationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 400)
        starAnimationView.center = self.view.center
        starAnimationView.contentMode = .scaleAspectFill
        view.addSubview(starAnimationView)
        starAnimationView.loopMode = .loop
        starAnimationView.play()
        self.starAnimationView.stop()
        self.starAnimationView.loopMode = .playOnce
        self.starAnimationView.animation = Animation.named("FawnIntro2(2)")

        DatingKit.user.show { (userShow, status) in
            guard let user: UserShow = userShow else { return }
            Amplitude.instance()?.setUserId(String(user.id))
            
            self.messageLabel.text = "Hi, \(user.name)"
            UIView.animate(withDuration: 0.4, animations: {
                self.messageLabel.alpha = 1.0
            })
            self.starAnimationView.play(completion: { (fin) in
                if fin {
                    self.starAnimationView.animation = Animation.named("FawnIntro3")
                    guard let url: URL = URL(string: user.avatarURL)  else { return }
                    self.userImageView.af_setImage(withURL: url,
                                                   placeholderImage: nil,
                                                   filter: nil,
                                                   progress: nil,
                                                   progressQueue: DispatchQueue.main,
                                                   imageTransition: UIImageView.ImageTransition.crossDissolve(0.3),
                                                   runImageTransitionIfCached: true)
                    { (data) in
                        self.starAnimationView.play(completion: { (fin) in
                            if fin {
                                self.userImageView.rotate(-40)
                                self.starAnimationView.removeFromSuperview()

                                UIView.animate(withDuration: 0.4, animations: {
                                    self.userImageView.rotate(40)
                                    self.userImageView.alpha = 1.0
                                    self.continueButton.alpha = 1.0
                                    self.submessageLabel.alpha = 1.0
                                }) { (_) in
                                    self.requestNotify()
                                }
                            }
                        })
                    }
                }
            })
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func tapOnContinue(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            ScreenManager.shared.showMian()
        })
    }
    
    func requestNotify() {
        NotificationManager.shared.startManagment()
        NotificationManager.shared.requestAccses()
//        let show: Bool = UserDefaults.standard.bool(forKey: NotificationManager.kWasShow)
//
//        if UserDefaults.standard.bool(forKey: NotificationManager.kWasShow) == false {
//            UserDefaults.standard.set(true, forKey: NotificationManager.kWasShow)
//
//        }
    }
}
