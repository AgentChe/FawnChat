//
//  ChatViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 07/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class ChatViewModel {
    let nextPage = PublishRelay<Void>()
    let viewedMessage = PublishRelay<Message>()
    let sendText = PublishRelay<String>()
    let sendImage = PublishRelay<UIImage>()
    
    private let chat: Chat
    private let chatService: ChatService
    
    private lazy var loader = createLoader()
    
    init(chat: Chat) {
        self.chat = chat
        chatService = ChatService(chat: chat)
    }
    
    func connect() {
        chatService.connect()
    }
    
    func disconnect() {
        chatService.disconnect()
    }
    
    func chatRemoved() -> Signal<Void> {
        chatService.event
            .flatMap { event -> Observable<Void> in
                switch event {
                case .removedChat:
                    return .just(Void())
                default:
                    return .never()
                }
            }
            .asSignal(onErrorSignalWith: .never())
    }
    
    func sender() -> Observable<Never> {
        let text = sendText
            .concatMap { text in
                Completable.create { [weak self] event in
                    self?.chatService.send(action: .sendText(text: text))
                    
                    event(.completed)
                    
                    return Disposables.create()
                }
            }
        
        let image = sendImage
            .concatMap { ImageService.upload(chatImage: $0) }
            .flatMap { (result: ImageTransformation.UploadedImage) in
                Completable.create { [weak self] event in
                    if let path = result.url {
                        self?.chatService.send(action: .sendImage(imagePath: path))
                    }
                    
                    event(.completed)
                    
                    return Disposables.create()
                }
            }
        
        let viewed = viewedMessage
            .filter { !$0.isOwner }
            .throttle(RxTimeInterval.milliseconds(500), scheduler: SerialDispatchQueueScheduler.init(qos: .default))
            .flatMap { viewedMessage in
                Completable.create { [weak self] event in
                    self?.chatService.send(action: .markRead(messageId: viewedMessage.id))
                    
                    event(.completed)
                
                    return Disposables.create()
                }
            }
        
        return Observable<Never>.merge(text, image, viewed)
    }
    
    var newMessages: Driver<[Message]> {
        Driver
            .merge(loader.elements,
                   receiveNewMessages().map { [$0] })
    }
}

// MARK: Private

private extension ChatViewModel {
    private func createLoader() -> PaginatedDataLoader<Message> {
        let chatId = chat.id
        
        let firstTrigger = Observable<Void>
            .deferred {
                .just(Void())
            }
        
        let nextTrigger = nextPage
            .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.asyncInstance)
        
        return PaginatedDataLoader(firstTrigger: firstTrigger,
                                   nextTrigger: nextTrigger) { page in
            ChatService
                .getMessages(chatId: chatId, page: page)
                .map { Page(page: page, data: $0) }
                .asObservable()
        }
    }
    
    private func receiveNewMessages() -> Driver<Message> {
        chatService
            .event
            .flatMap { event -> Observable<Message> in
                switch event {
                case .newMessage(let message):
                    return .just(message)
                default:
                    return .never()
                }
            }
            .asDriver(onErrorDriveWith: .never())
    }
}
