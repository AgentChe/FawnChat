//
//  LoadViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 15/07/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit
import Amplitude_iOS
import Lottie
import NotificationBannerSwift

class LoadViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var helloLabel: UILabel!
    let starAnimationView: AnimationView = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        var starAnimation = Animation.named("Preloader")
        starAnimationView.animation = starAnimation
        starAnimationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 400)
        starAnimationView.center = self.view.center
        starAnimationView.contentMode = .scaleAspectFill
        view.addSubview(starAnimationView)
        starAnimationView.loopMode = .loop
        self.starAnimationView.play()
        PurchaseManager.shared.loadProducts { (bundle) in
            self.starAnimationView.stop()
            self.starAnimationView.loopMode = .playOnce
            self.starAnimationView.animation = Animation.named("FawnIntro_fin")
            DatingKit.user.show { (userShow, status) in
                if let user: UserShow = userShow {
                    Amplitude.instance()?.setUserId(String(describing: user.id))
                    self.starAnimationView.play(completion: { (fin) in
                        if fin {
                            self.starAnimationView.removeFromSuperview()
                            self.userImageView.alpha = 0.0
                            self.userImageView.isHidden = false
                            self.helloLabel.alpha = 0.0
                            self.helloLabel.isHidden = false
                            guard let url: URL = URL(string: user.avatarURL)  else { return }
                            self.userImageView.af_setImage(withURL: url,
                                                           placeholderImage: nil,
                                                           filter: nil,
                                                           progress: nil,
                                                           progressQueue: DispatchQueue.main,
                                                           imageTransition: UIImageView.ImageTransition.curlDown(0.2),
                                                           runImageTransitionIfCached: true)
                            { (data) in
                                self.userImageView.rotate(-40)
                                UIView.animate(withDuration: 0.7, animations: {
                                    self.userImageView.alpha = 1.0
                                    self.userImageView.rotate(40)
                                    self.helloLabel.alpha = 1.0
                                }, completion: { (finish) in
                                    sleep(4)
                                    self.dismiss(animated: true, completion: {
                                        ScreenManager.shared.showMian()
                                    })
                                })
                            }
                            
                        }
                    })
                }
            }
        }
        
    }

}
