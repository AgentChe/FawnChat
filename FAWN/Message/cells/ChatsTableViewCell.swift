//
//  ChatsTableViewCell.swift
//  FAWN
//
//  Created by Алексей Петров on 07/04/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import RevealingTableViewCell
import DatingKit


class ChatsTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var unreadedCount: UILabel!
    @IBOutlet var unreadCounter: UIView!
    
    var item: ChatItem!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(with parameters: ChatItem) {
        item = parameters
        nameLabel.text = parameters.partnerName
        avatar.af_setImage(withURL: URL(string: parameters.partnerAvatarString)!)
        if parameters.lastMessageBody == "" {
             messageLabel.text = "No Messages yet"
//            backgroundImageView.isHidden = true
        } else {
            messageLabel.text = parameters.lastMessageBody
        }
        if parameters.unreadCount > 0 {
            unreadCounter.isHidden = false
            unreadedCount.text = String(format: "%i", parameters.unreadCount)
        } else {
            unreadCounter.isHidden = true
        }
    }
}
