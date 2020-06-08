//
//  ChatsViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 05/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class ChatsViewModel {
    private let chatsService = ChatsService()
    
    func connect() {
        chatsService.connect()
    }
    
    func disconnect() {
        chatsService.disconnect()
    }
    
    var chats: Driver<[Chat]> {
        ChatsService
            .getChats()
            .asDriver(onErrorJustReturn: [])
    }
    
    func chatEvent() -> Driver<ChatsService.Event> {
        chatsService
            .event
            .asDriver(onErrorDriveWith: .never())
    }
}
