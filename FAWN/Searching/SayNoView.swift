//
//  SayNoView.swift
//  FAWN
//
//  Created by Алексей Петров on 13.11.2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit

class SayNoView: UIView {

    @IBOutlet weak var newSearchButton: GradientButton!
    @IBOutlet weak var content: UIStackView!
    
    class func instanceFromNib() -> SayNoView {
        return UINib(nibName: "SayNoView", bundle: .main).instantiate(withOwner: nil, options: nil)[0] as! SayNoView
    }
    
    func config() {
        UIView.animate(withDuration: 0.5) {
            self.content.alpha = 1.0
        }
    }

}
