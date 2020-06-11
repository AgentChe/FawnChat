//
//  ChatTableView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatTableView: UITableView {
    let viewedMessage = PublishRelay<Message>()
    let reachedTop = PublishRelay<Void>()
    let selectedMessage = PublishRelay<Message>()
    
    private var items: [Message] = []
    private var itemsCount = 0
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        backgroundColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 1)
        
        register(InterlocutorChatMessageCell.self, forCellReuseIdentifier: String(describing: InterlocutorChatMessageCell.self))
        register(InterlocutorChatImageCell.self, forCellReuseIdentifier: String(describing: InterlocutorChatImageCell.self))
        register(MyChatMessageCell.self, forCellReuseIdentifier: String(describing: MyChatMessageCell.self))
        register(MyChatImageCell.self, forCellReuseIdentifier: String(describing: MyChatImageCell.self))
        
        dataSource = self
        delegate = self
        
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Messages management

extension ChatTableView {
    func add(messages: [Message]) {
        items.append(contentsOf: messages)
        itemsCount = items.count
        
        let isScrollAtBottom = indexPathsForVisibleRows?.contains(IndexPath(row: 0, section: 0)) ?? false
        
        
        items.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
        
        reloadData()
        
        if isScrollAtBottom {
            let indexPath = IndexPath(row: 0, section: 0)
            scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

// MARK: UITableViewDelegate

extension ChatTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let message = items[indexPath.row]
        viewedMessage.accept(message)
        
        if indexPath.row == itemsCount - 1 {
            reachedTop.accept(Void())
        }
    }
}

// MARK: UITableViewDataSource

extension ChatTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        let identifier: String
        
        switch item.type {
        case .text:
            identifier = item.isOwner ? String(describing: MyChatMessageCell.self) : String(describing: InterlocutorChatMessageCell.self)
        case .image:
            identifier = item.isOwner ? String(describing: MyChatImageCell.self) : String(describing: InterlocutorChatImageCell.self)
        }
        
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 1)
        cell.selectedBackgroundView = selectedView
        
        (cell as? MessageTableCell)?.bind(message: item)
        
        (cell as? MessageTableCell)?.tapped = { [weak self] message in
            self?.selectedMessage.accept(message)
        }
    
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell
    }
}
