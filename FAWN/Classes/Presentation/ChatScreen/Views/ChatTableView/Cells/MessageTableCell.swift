//
//  ChatTableCell.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

class MessageTableCell: UITableViewCell {
    var tapped: ((Message) -> Void)?
    
    var message: Message!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(sender:)))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(message: Message) {
        self.message = message
    }
}

// MARK: Private

private extension MessageTableCell {
    @objc
    func tapped(sender: Any) {
        tapped?(message)
    }
}
