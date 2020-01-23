//
//  MensCountTableViewCell.swift
//  FAWN
//
//  Created by Алексей Петров on 02/06/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit
 
class MensCountTableViewCell: UITableViewCell {

    @IBOutlet weak var mensCounLabel: UILabel!
    @IBOutlet weak var substringLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(bundle: FirstBandleInfo) {
//        mensCounLabel.text = "\(bundle.usersCount)"
        substringLabel.text = bundle.usersSubstring
        let duration: Double = 2.0 //seconds
        DispatchQueue.global().async {
            for i in 0 ..< (bundle.usersCount + 1) {
                let sleepTime = UInt32(duration/Double(bundle.usersCount) * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    self.mensCounLabel.text = "\(i)"
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
