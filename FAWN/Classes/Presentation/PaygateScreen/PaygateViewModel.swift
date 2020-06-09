//
//  PaygateViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 09/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class PaygateViewModel {
    let startPing = PublishRelay<Void>()
    let stopPing = PublishRelay<Void>()
}

// MARK: Ping

extension PaygateViewModel {
    func ping() -> Driver<Void> {
        let startTrigger = startPing
            .takeUntil(stopPing)
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                Observable<Int>
                    .interval(RxTimeInterval.seconds(1), scheduler: SerialDispatchQueueScheduler.init(qos: .background))
                    .takeUntil(self?.stopPing.asObservable() ?? Observable<Void>.never())
                    .flatMapLatest { _ in PaygateManager.ping().catchError { _ in .never() } }
            }

        let stopTrigger = stopPing
            .flatMapLatest { _ -> Observable<Void> in .empty() }

        return Observable
            .merge(startTrigger, stopTrigger)
            .asDriver(onErrorDriveWith: .never())
    }
}
