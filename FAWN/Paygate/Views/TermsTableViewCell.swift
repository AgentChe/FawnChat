//
//  TermsTableViewCell.swift
//  FAWN
//
//  Created by Алексей Петров on 02/06/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit

class TermsTableViewCell: UITableViewCell {

    @IBOutlet weak var topHeight: NSLayoutConstraint!
    
    override func layoutSubviews() {
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.modelName.contains("SE") || UIDevice.modelName.contains("5s")  {
            topHeight.constant = 0
        } else {
            topHeight.constant = 60
        }
        if UIDevice.modelName.contains("8") ||
            UIDevice.modelName.contains("6") ||
            UIDevice.modelName.contains("7")
        {
            topHeight.constant = 35
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
