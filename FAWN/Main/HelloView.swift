//
//  HelloView.swift
//  FAWN
//
//  Created by Алексей Петров on 05/06/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit

class HelloView: UIView {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
//        if User.shared.isLogined() {
//            User.shared.show { (data) in
//                self.welcomeLabel.text = "Welcome Back,\n\(data.name ?? "default value")"
//                let url: NSString = User.shared.userData.avatarURLString as! NSString
//                let urlString: NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
//                self.userImageView.af_setImage(withURL: URL(string: urlString as String)!)
//            }
//        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
