//
//  InterlocutorChatImageCell.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import Kingfisher

final class InterlocutorChatImageCell: MessageTableCell {
    lazy var messageImageView = makeImageView()
    
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
        
        messageImageView.kf.cancelDownloadTask()
        messageImageView.image = nil
        
        if let url = URL(string: message.body) {
            messageImageView.kf.setImage(with: url)
        }
    }
}

// MARK: Make constraints

private extension InterlocutorChatImageCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            messageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            messageImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.scale),
            messageImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.scale),
            messageImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -80.scale),
            messageImageView.heightAnchor.constraint(equalToConstant: 196.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension InterlocutorChatImageCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 18.scale
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
