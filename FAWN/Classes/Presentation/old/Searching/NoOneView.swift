//
//  NoOneView.swift
//  FAWN
//
//  Created by Алексей Петров on 13.11.2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit

class NoOneView: UIView {
    
    
    class func instanceFromNib() -> NoOneView {
        return UINib(nibName: "NoOneView", bundle: .main).instantiate(withOwner: nil, options: nil)[0] as! NoOneView
    }

    @IBOutlet weak var contentStackWithNewSearch: UIStackView!
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var newSearchButton: GradientButton!
    @IBOutlet weak var sureButton: GradientButton!
    @IBOutlet weak var skipButton: UIButton!
    
    func config() {
        contentStack.isHidden = true
        contentStack.alpha = 0.0
        contentStackWithNewSearch.isHidden = true
        contentStackWithNewSearch.alpha = 0.0
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications == false {
            contentStack.isHidden = false
            UIView.animate(withDuration: 0.4) {
                self.contentStack.alpha = 1.0
            }
        } else {
            self.contentStackWithNewSearch.isHidden = false
            UIView.animate(withDuration: 0.4) {
                self.contentStackWithNewSearch.alpha = 1.0
            }
        }
                            
    }
    
    func showSearchView() {
        contentStack.isHidden = true
        self.contentStackWithNewSearch.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.contentStackWithNewSearch.alpha = 1.0
        }
    }
    
}
