//
//  SearchView.swift
//  FAWN
//
//  Created by Алексей Петров on 12.11.2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit
import AlamofireImage

class SearchView: UIView {
    
    @IBOutlet weak var partnerImageCenter: NSLayoutConstraint!
    @IBOutlet weak var torWidth: NSLayoutConstraint!
    @IBOutlet weak var torHeight: NSLayoutConstraint!
    @IBOutlet weak var userImageCenter: NSLayoutConstraint!
    @IBOutlet weak var buttonsHeight: NSLayoutConstraint!
    
    private var animationTimer: Timer!
    
    class func instanceFromNib() -> SearchView {
        return UINib(nibName: "SearchView", bundle: .main).instantiate(withOwner: nil, options: nil)[0] as! SearchView
    }

  
    @IBOutlet weak var waitngLabel: UILabel!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var sureButton: GradientButton!
    @IBOutlet weak var partnerImageView: UIImageView!
    @IBOutlet weak var generalScene: UIStackView!
    @IBOutlet weak var howAboutLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var torImageView: UIImageView!
    @IBOutlet weak var lookingLabel: UILabel!
    
    func config(user: UserShow) {
        guard let url: URL = URL(string: user.avatarURL) else {return}
        userImageView.af_setImage(withURL: url)
        UIView.animate(withDuration: 0.4, animations: {
            self.generalScene.alpha = 1.0
        }) { (_) in
            self.torAnimation()
        }
    }
    
    func torAnimation() {
        torWidth.constant = 1000.0
        torHeight.constant = 1000.0
        
        UIView.animate(withDuration: 10, animations: {
            self.torImageView.alpha = 0.0
            self.layoutIfNeeded()
        }) { (_) in
            self.torWidth.constant = 128.0
            self.torHeight.constant = 128.0
            self.torImageView.alpha = 1.0
            self.layoutIfNeeded()

            self.animationTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (timer) in
                
                self.torWidth.constant = 1000.0
                self.torHeight.constant = 1000.0
                
                UIView.animate(withDuration: 10, animations: {
                    self.torImageView.alpha = 0.0
                    self.layoutIfNeeded()
                }) { (_) in
                    self.torWidth.constant = 128.0
                    self.torHeight.constant = 128.0
                    self.torImageView.alpha = 1.0
                    self.layoutIfNeeded()
                }
            })
        }
        
  
    }
    
    @IBAction func tapOnSure(_ sender: GradientButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.howAboutLabel.alpha = 0.0
            
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                self.waitngLabel.alpha = 1.0
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.buttonsView.alpha = 0.0
        }
    }
    
    @IBAction func tapOnSkip(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.howAboutLabel.alpha = 0.0
            
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                self.lookingLabel.alpha = 1.0
            }
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.buttonsView.alpha = 0.0
        }) { (_) in
            self.partnerImageCenter.constant = -320
            self.userImageCenter.constant = 0
            self.buttonsHeight.constant = 60
            
            UIView.animate(withDuration: 1.5, animations: {
                self.layoutIfNeeded()
            }) { (_) in
                self.partnerImageView.image = UIImage()
                self.torAnimation()
            }
            
        }
        
    }
    
    func set(match: DKMatch) {
        if animationTimer != nil {
            animationTimer.invalidate()
        }
        torImageView.alpha = 0.0
        howAboutLabel.text = NSLocalizedString("how_ask", comment: "") + match.matchedUserName + "?"
        layoutIfNeeded()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.lookingLabel.alpha = 0.0
            
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                self.howAboutLabel.alpha = 1.0
            }
        }
        
        guard let url: URL = URL(string: match.matchedAvatarString) else {return}
        partnerImageView.af_setImage(withURL: url)
        partnerImageCenter.constant = -68
        userImageCenter.constant = 68
        buttonsHeight.constant = 180
       
        UIView.animate(withDuration: 1.5, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                self.buttonsView.alpha = 1.0
            }
        }
        
    }
    
}
