//
//  ChatInterlocutorView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 09/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import Kingfisher

final class ChatInterlocutorView: UIView {
    lazy var avatarImageView = makeAvatarImageView()
    lazy var nameLabel = makeNameLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup

extension ChatInterlocutorView {
    func setup(chat: Chat) {
        avatarImageView.kf.setImage(with: chat.interlocutorAvatarUrl)
        nameLabel.text = chat.interlocutorName
    }
}

// MARK: Make constraints

private extension ChatInterlocutorView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 38.scale),
            avatarImageView.heightAnchor.constraint(equalToConstant: 38.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8.scale),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension ChatInterlocutorView {
    func makeAvatarImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 19.scale
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.textColor = .white
        view.font = Font.Montserrat.semibold(size: 15.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
