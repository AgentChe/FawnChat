//
//  ChatsService.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import Starscream

final class ChatsService {
    enum Event {
        case changedChat(Chat)
        case removedChat(Chat)
        case createdChat(Chat)
    }
    
    private lazy var socket: WebSocket? = {
        guard
            let userToken = SessionService.shared.userToken,
            let url = URL(string: GlobalDefinitions.ChatService.wsDomain + "/ws/rooms?token=\(userToken)&app_key=\(GlobalDefinitions.ChatService.appKey)")
        else {
            return nil
        }
        
        let request = URLRequest(url: url)
        return WebSocket(request: request)
    }()
    
    func connect() {
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    lazy var event: Observable<Event> = {
        Observable<Event>.create { [weak self] observer in
            self?.socket?.onEvent = { event in
                switch event {
                case .text(let string):
                    guard let response = ChatTransformation.from(chatsWebSocket: string) else {
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

// MARK: REST

extension ChatsService {
    static func getChats() -> Single<[Chat]> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just([]) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: GetChatsRequest(userToken: userToken))
            .map { ChatTransformation.from(response: $0) }
    }
}
