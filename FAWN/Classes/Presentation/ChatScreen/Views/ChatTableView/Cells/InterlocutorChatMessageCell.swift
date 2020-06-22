//
//  InterlocutorChatCell.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class InterlocutorChatMessageCell: MessageTableCell {
    lazy var messageBackgroundView = makeBackgroundView()
    lazy var messageLabel = makeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 1)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind(message: Message) {
        super.bind(message: message)
        
        messageLabel.text = message.body
    }
}

// MARK: Make constraints

private extension InterlocutorChatMessageCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            messageBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            messageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.scale),
            messageBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.scale),
            messageBackgroundView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -80.scale)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant: 12.scale),
            messageLabel.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: -12.scale),
            messageLabel.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 8.scale),
            messageLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -8.scale),
        ])
    }
}

// MARK: Lazy initialization

private extension InterlocutorChatMessageCell {
    func makeBackgroundView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 18.scale
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = .white
        view.font = Font.SFProText.regular(size: 15.scale)
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        messageBackgroundView.addSubview(view)
        return view
    }
}
