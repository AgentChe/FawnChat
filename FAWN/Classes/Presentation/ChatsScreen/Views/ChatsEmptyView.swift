//
//  ChatsEmptyView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 07/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class ChatsEmptyView: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var newSearchButton = makeNewSearchButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension ChatsEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 122.scale),
            imageView.heightAnchor.constraint(equalToConstant: 121.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 239.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            newSearchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 43.scale),
            newSearchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -43.scale),
            newSearchButton.heightAnchor.constraint(equalToConstant: 56.scale),
            newSearchButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 32.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension ChatsEmptyView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "faggots")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        view.font = Font.Merriweather.bold(size: 34.scale)
        view.text = "Chats.Title".localized
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = .white
        view.numberOfLines = 0
        view.font = Font.Merriweather.regular(size: 17.scale)
        view.text = "Chats.Empty.SubTitle".localized
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeNewSearchButton() -> UIButton {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        view.titleLabel?.font = Font.Montserrat.semibold(size: 17)
        view.setTitle("Chats.Empty.Button".localized, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
