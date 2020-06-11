//
//  ChatsViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 05/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

protocol ChatsViewControllerDelegate: class {
    func newSearchTapped()
}

final class ChatsViewController: UIViewController {
    var chatsView = ChatsView()
    
    weak var delegate: ChatsViewControllerDelegate?
    
    private let viewModel = ChatsViewModel()
    
    private let disposeBag = DisposeBag()
    
    deinit {
        viewModel.disconnect()
    }
    
    override func loadView() {
        super.loadView()
        
        view = chatsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeAnalytics.shared.log(with: .chatListScr)
        
        chatsView.tableView.selectedChat
            .emit(onNext: { [weak self] chat in
                AmplitudeAnalytics.shared.log(with: .chatListTap("chat"))
                
                self?.goToChatScreen(with: chat)
            })
            .disposed(by: disposeBag)
        
        chatsView.tableView
            .changedItemsCount
            .emit(onNext: { [weak self] itemsCount in
                let isEmpty = itemsCount == 0
                
                self?.chatsView.tableView.isHidden = isEmpty
                self?.chatsView.titleLabel.isHidden = isEmpty
                self?.chatsView.emptyView.isHidden = !isEmpty
            })
            .disposed(by: disposeBag)
        
        viewModel.chats
            .drive(onNext: { [weak self] chats in
                self?.chatsView.tableView.add(chats: chats)
            })
            .disposed(by: disposeBag)
        
        viewModel.chatEvent()
            .drive(onNext: { [weak self] event in
                switch event {
                case .changedChat(let chat):
                    self?.chatsView.tableView.replace(chat: chat)
                case .removedChat(let chat):
                    self?.chatsView.tableView.remove(chat: chat)
                case .createdChat(let chat):
                    self?.chatsView.tableView.insert(chat: chat)
                }
            })
            .disposed(by: disposeBag)
        
        chatsView.emptyView.newSearchButton.addTarget(self, action: #selector(newSearchTapped(sender:)), for: .touchUpInside)
        
        viewModel.connect()
    }
}

// MARK: Make

extension ChatsViewController {
    static func make() -> ChatsViewController {
        ChatsViewController(nibName: nil, bundle: nil)
    }
}

// MARK: ChatsViewControllerDelegate

extension ChatsViewController: ChatViewControllerDelegate {
    func markReaded(chat: Chat, message: Message) {
        var readedChat = chat
        readedChat.change(unreadMessageCount: 0)
        
        chatsView.tableView.replace(chat: readedChat)
    }
}

// MARK: Private

private extension ChatsViewController {
    func goToChatScreen(with chat: Chat) {
        let vc = ChatViewController.make(with: chat)
        vc.delegate = self 
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func newSearchTapped(sender: Any) {
        AmplitudeAnalytics.shared.log(with: .chatListTap("new_search"))
        
        delegate?.newSearchTapped()
    }
}
