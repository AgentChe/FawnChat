//
//  ReasonTableViewCell.swift
//  FAWN
//
//  Created by Алексей Петров on 06/06/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit

class ReasonTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func config(reason: Reason, icon: UIImage) {
        iconImageView.image = icon
        titleLabel.text = reason.title
        subtitleLabel.text = reason.subTitle
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
