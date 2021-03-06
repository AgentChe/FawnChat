//
//  NotifySetingUiTableViewCell.swift
//  FAWN
//
//  Created by Алексей Петров on 07/07/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit

class NotifySetingUiTableViewCell: UITableViewCell {

    @IBOutlet weak var notifySwither: UISwitch!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    private var type: NotifyCellTypes!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(model: SwitchCellModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        notifySwither.setOn(model.enabled, animated: true)
        type = model.type
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapOnSwith(_ sender: UISwitch) {
        switch type {
        case .match?:
            NotificationManager.shared.matchPush(enable: sender.isOn)
            break
        case .users?:
            NotificationManager.shared.usersPush(enable: sender.isOn)
            break
        case .message?:
            NotificationManager.shared.messagePush(enable: sender.isOn)
            break
        case .none:
            break
        case .knocks?:
            NotificationManager.shared.knocksPush(enable: sender.isOn)
            break
        }
        
    }
}
