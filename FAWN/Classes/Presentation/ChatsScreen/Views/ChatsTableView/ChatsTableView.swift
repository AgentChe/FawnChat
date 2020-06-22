//
//  ChatsTableView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxCocoa

final class ChatsTableView: UITableView {
    private(set) lazy var selectedChat = _selectedChat.asSignal()
    private let _selectedChat = PublishRelay<Chat>()
    
    private(set) lazy var changedItemsCount = _changedItemsCount.asSignal()
    private let _changedItemsCount = PublishRelay<Int>()
    
    private var items: [Chat] = [] {
        didSet {
            _changedItemsCount.accept(items.count)
        }
    }
    
    private let itemsQueue = DispatchQueue(label: "chats_queue")
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        backgroundColor = .black
        
        register(ChatTableCell.self, forCellReuseIdentifier: String(describing: ChatTableCell.self))
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Items management

extension ChatsTableView {
    func add(chats: [Chat]) {
        itemsQueue.sync { [weak self] in
            self?.items = chats
            
            self?.reloadData()
        }
    }
    
    func replace(chat: Chat) {
        itemsQueue.sync { [weak self] in
            guard let index = self?.items.firstIndex(where: { $0.id == chat.id }) else {
                return
            }
            
            self?.items[index] = chat
            
            self?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func remove(chat: Chat) {
        itemsQueue.sync { [weak self] in
            guard let index = self?.items.firstIndex(where: { $0.id == chat.id }) else {
                return
            }
            
            self?.items.remove(at: index)
            
            self?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func insert(chat: Chat) {
        itemsQueue.sync { [weak self] in
            self?.items.insert(chat, at: 0)
            
            self?.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }
}

// MARK: UITableViewDataSource

extension ChatsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: ChatTableCell.self), for: indexPath) as! ChatTableCell
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 1)
        cell.selectedBackgroundView = selectedView
        
        cell.setup(chat: items[indexPath.row])
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension ChatsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _selectedChat.accept(items[indexPath.row])
    }
}
