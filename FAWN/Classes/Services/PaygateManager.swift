//
//  PaygateManager.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 09/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift

final class PaygateManager {
    static let shared = PaygateManager()
    
    private init() {}
}

// MARK: Ping

extension PaygateManager {
    static func ping() -> Single<Bool> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(false) }
        }
        
        let request = PaygatePingRequest(randomKey: IDFAService.shared.getAppKey(), userToken: userToken)
        
        return RestAPITransport()
            .callServerApi(requestBody: request)
            .map { _ in true }
    }
}
