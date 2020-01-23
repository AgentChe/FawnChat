//
//  ButtonTableViewCell.swift
//  FAWN
//
//  Created by Алексей Петров on 02/06/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var animateView: GradientView!
    
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func startAnimation() {
   
        animateView.alpha = 1.0
        animateView.center = continueButton.center
        self.height.constant = 74
        self.width.constant = 308
        UIView.animate(withDuration: 0.8, delay: 0.9,
                       options: .repeat,
                       animations: {
                        self.animateView.layoutIfNeeded()
                        self.animateView.alpha = 0.0

        },
                       completion: {(succses) in
                        self.animateView.alpha = 1.0
                        self.height.constant = 54
                        self.width.constant = 288
                        self.setNeedsLayout()

        }
        )

    }
}
