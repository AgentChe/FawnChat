//
//  ChatService.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import Starscream

final class ChatService {
    enum Action {
        case sendText(text: String)
        case sendImage(imagePath: String)
        case markRead(messageId: String)
    }
    
    enum Event {
        case newMessage(Message)
        case removedChat
    }
    
    private let chat: Chat
    
    private lazy var socket: WebSocket? = {
        guard
            let userToken = SessionService.shared.userToken,
            let url = URL(string: GlobalDefinitions.ChatService.wsDomain + "/ws/room/\(chat.id)?token=\(userToken)&app_key=\(GlobalDefinitions.ChatService.appKey)")
        else {
            return nil
        }
        
        let request = URLRequest(url: url)
        return WebSocket(request: request)
    }()
    
    init(chat: Chat) {
        self.chat = chat
    }
    
    func connect() {
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    func send(action: Action) {
        switch action {
        case .sendText(let text):
            send(text: text)
        case .sendImage(let imagePath):
            send(imagePath: imagePath)
        case .markRead(let messageId):
            markRead(messageId: messageId)
        }
    }
    
    lazy var event: Observable<Event> = {
        Observable<Event>.create { [weak self] observer in
            self?.socket?.onEvent = { event in
                switch event {
                case .text(let string):
                    guard let response = ChatTransformation.from(chatWebSocket: string) else {
                        return
                    }
                    
                    observer.onNext(response)
                default:
                    break
                }
            }
            
            return Disposables.create()
        }
    }().share(replay: 1, scope: .forever)
}

extension ChatService {
    fileprivate func send(text: String) {
        guard let json = [
            "action": "send",
            "type": 0,
            "value": text
        ].jsonString() else {
            return
        }
        
        socket?.write(string: json)
    }
    
    fileprivate func send(imagePath: String) {
        guard let json = [
            "action": "send",
            "type": 1,
            "value": imagePath
        ].jsonString() else {
            return
        }
        
        socket?.write(string: json)
    }
    
    fileprivate func markRead(messageId: String) {
        guard let json = [
            "action": "read",
            "value": messageId
        ].jsonString() else {
            return
        }
        
        socket?.write(string: json)
    }
}

// MARK: REST

extension ChatService {
    static func getMessages(chatId: String, page: Int) -> Single<[Message]> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just([]) }
        }
        
        let request = GetMessagesRequest(userToken: userToken,
                                         chatId: chatId,
                                         page: page)
        
        return RestAPITransport()
            .callServerApi(requestBody: request)
            .map { MessageTransformation.from(response: $0) }
    }
}
