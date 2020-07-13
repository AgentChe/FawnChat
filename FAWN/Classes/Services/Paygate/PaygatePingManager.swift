//
//  PaygatePingManager.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 13.07.2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift

final class PaygatePingManager {
    static let shared = PaygatePingManager()
    
    private var disposable: Disposable?
    
    private init() {
        _ = AppStateProxy
            .ApplicationProxy
            .didEnterBackground
            .subscribe(onNext: {
                self.stop()
            })
    }
    
    func start() {
        disposable = ping()
            .subscribe()
    }
    
    func stop() {
        disposable?.dispose()
    }
}

// MARK: Private

private extension PaygatePingManager {
    func ping() -> Observable<Void> {
        guard let userToken = SessionService.shared.userToken else {
            return .empty()
        }
        
        return Observable<Int>
            .interval(RxTimeInterval.seconds(2), scheduler: SerialDispatchQueueScheduler.init(qos: .background))
            .flatMapLatest { _ in 
                RestAPITransport()
                    .callServerApi(requestBody: PaygatePingRequest(randomKey: IDFAService.shared.getAppKey(),
                                                                   userToken: userToken))
                    .map { _ in Void() }
                    .catchError { _ in .never() }
            }
    }
}
