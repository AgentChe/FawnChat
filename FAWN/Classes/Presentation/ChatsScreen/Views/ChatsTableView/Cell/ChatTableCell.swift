//
//  ChatTableCell.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import Kingfisher

final class ChatTableCell: UITableViewCell {
    lazy var avatarImageView = makeAvatarImageView()
    lazy var nameLabel = makeNameLabel()
    lazy var lastMessageLabel = makeLastMessageLabel()
    lazy var unreadMessagesCountContainerView = makeUnreadMessagesCountContainerView()
    lazy var unreadMessagesCountLabel = makeUnreadMessagesCountLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .black
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.kf.cancelDownloadTask()
        avatarImageView.image = nil
        
        lastMessageLabel.text = ""
    }
}

// MARK: Setup

extension ChatTableCell {
    func setup(chat: Chat) {
        if let interlocutorAvatarUrl = chat.interlocutorAvatarUrl {
            avatarImageView.kf.setImage(with: interlocutorAvatarUrl)
        }
        
        nameLabel.text = chat.interlocutorName
        
        if chat.unreadMessageCount == 0 {
            unreadMessagesCountContainerView.isHidden = true
        } else {
            unreadMessagesCountContainerView.isHidden =  false
            unreadMessagesCountLabel.text = String(format: "%i", chat.unreadMessageCount)
        }
        
        if let lastMessage = chat.lastMessage {
            switch lastMessage.type {
            case .image:
                lastMessageLabel.text = "Chats.Photo".localized
            case .text:
                lastMessageLabel.text = lastMessage.body
            }
        }
    }
}

// MARK: Make constraints

private extension ChatTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18.scale),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale),
            avatarImageView.widthAnchor.constraint(equalToConstant: 66.scale),
            avatarImageView.heightAnchor.constraint(equalToConstant: 66.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10.scale),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18.scale),
            nameLabel.trailingAnchor.constraint(equalTo: unreadMessagesCountContainerView.leadingAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            lastMessageLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10.scale),
            lastMessageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3.scale),
            lastMessageLabel.trailingAnchor.constraint(equalTo: unreadMessagesCountContainerView.leadingAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            unreadMessagesCountContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17.scale),
            unreadMessagesCountContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            unreadMessagesCountContainerView.widthAnchor.constraint(equalToConstant: 25.scale),
            unreadMessagesCountContainerView.heightAnchor.constraint(equalToConstant: 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            unreadMessagesCountLabel.centerYAnchor.constraint(equalTo: unreadMessagesCountContainerView.centerYAnchor),
            unreadMessagesCountLabel.centerXAnchor.constraint(equalTo: unreadMessagesCountContainerView.centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension ChatTableCell {
    func makeAvatarImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 32.scale
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        view.font = Font.SFProText.regular(size: 16.scale)
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLastMessageLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 1)
        view.font = Font.SFProText.regular(size: 14.scale)
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeUnreadMessagesCountContainerView() -> CircleView {
        let view = CircleView()
        view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeUnreadMessagesCountLabel() -> UILabel {
        let view = UILabel()
        view.textColor = .black
        view.font = Font.SFProText.regular(size: 14.scale)
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        unreadMessagesCountContainerView.addSubview(view)
        return view
    }
}
