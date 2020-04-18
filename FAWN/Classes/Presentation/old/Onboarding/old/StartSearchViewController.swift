//
//  StartSearchViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 12.12.2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit
import Lottie
import Amplitude_iOS

class StartSearchViewController: UIViewController {
    
    let manualySearchScene: ManualySearchView = ManualySearchView.instanceFromNib()
    
     let starAnimationView: AnimationView = AnimationView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manualySearchScene.frame = self.view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(manualySearchScene)
        manualySearchScene.alpha = 0.0
        manualySearchScene.newSearchButton.addTarget(self, action: #selector(showMain), for: .touchUpInside)
        let starAnimation = Animation.named("Preloader")
        starAnimationView.animation = starAnimation
        starAnimationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 400)
        starAnimationView.center =  CGPoint(x: self.view.center.x, y: self.view.center.y - 100)
        starAnimationView.contentMode = .scaleAspectFill
        view.addSubview(starAnimationView)
        starAnimationView.loopMode = .loop
        self.starAnimationView.play()
        self.starAnimationView.stop()
        self.starAnimationView.loopMode = .playOnce
        self.starAnimationView.animation = Animation.named("FawnIntro_fin")
        DatingKit.user.show { (userShow, status) in
            if let user: UserShow = userShow {
                Amplitude.instance()?.setUserId(String(describing: user.id))
                self.starAnimationView.play(completion: { (fin) in
                    if fin {
                        self.starAnimationView.removeFromSuperview()
                        UIView.animate(withDuration: 0.2) {
                            self.manualySearchScene.alpha = 1.0
                        }
                    }
                })
            }
        }
    }
    
    @objc func showMain() {
        ScreenManager.shared.showMian()
        dismiss(animated: true, completion: nil)
    }

}
