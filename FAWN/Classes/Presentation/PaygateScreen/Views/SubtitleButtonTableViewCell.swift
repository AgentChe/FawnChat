//
//  SubtitleButtonTableViewCell.swift
//  FAWN
//
//  Created by Алексей Петров on 06/06/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit

class SubtitleButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var titleButton: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var button: UIButton!
    
    
    func config(button: Button) {
        titleButton.text = button.title
        subTitle.text = button.subTitle
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
