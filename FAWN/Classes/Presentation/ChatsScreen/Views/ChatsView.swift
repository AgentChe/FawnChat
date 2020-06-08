//
//  ChatsView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class ChatsView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var tableView = makeTableView()
    lazy var emptyView = makeEmptyView()
    
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

private extension ChatsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 66.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22.scale)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: bottomAnchor),
            emptyView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension ChatsView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        view.font = Font.Merriweather.bold(size: 34.scale)
        view.textAlignment = .center
        view.text = "Chats.Title".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> ChatsTableView {
        let view = ChatsTableView()
        view.backgroundColor = .black
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> ChatsEmptyView {
        let view = ChatsEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
