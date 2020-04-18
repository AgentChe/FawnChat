//
//  BundleTableViewCell.swift
//  FAWN
//
//  Created by Алексей Петров on 02/06/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit

class BundleTableViewCell: UITableViewCell {

    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var centralView: CentralPriceTagView!
    @IBOutlet weak var leftView: LeftView!
    @IBOutlet weak var rightView: RightView!
    @IBOutlet weak var containerStack: UIStackView!
    
    @IBOutlet weak var centralButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        centralView.select(true)
        leftView.select(false)
        rightView.select(false)
    }
    
    override func layoutSubviews() {
//        super.layoutSubviews()
        if UIDevice.modelName.contains("SE") || UIDevice.modelName.contains("5s")  {
            height.constant = 40
        } else {
            height.constant = 174
        }
        if UIDevice.modelName.contains("8") ||
            UIDevice.modelName.contains("6") ||
            UIDevice.modelName.contains("7")
        {
            height.constant = 174
        }
    }

    func config(with bundle: SecondBandleInfo) {
        if PurchaseManager.shared.isLoaded {
            UIView.animate(withDuration: 0.4) {
                self.containerStack.alpha = 1.0
            }
        }
        centralView.config(with: bundle.centralPriceTag)
        leftView.config(with: bundle.leftPriceTag)
        rightView.config(with: bundle.reightPriceTag)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func tapOnPrice(_ sender: UIButton) {
        centralView.select(true)
        leftView.select(false)
        rightView.select(false)
    }
    
    @IBAction func tapOnLeft(_ sender: Any) {
        centralView.select(false)
        leftView.select(true)
        rightView.select(false)
    }
    
    @IBAction func tapOnRight(_ sender: Any) {
        centralView.select(false)
        leftView.select(false)
        rightView.select(true)
    }
    
}
