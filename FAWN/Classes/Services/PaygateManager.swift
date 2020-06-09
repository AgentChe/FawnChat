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
    static func ping() -> Single<Void> {
        RestAPITransport()
            .callServerApi(requestBody: PaygatePingRequest(randomKey: IDFAService.shared.getAppKey()))
            .map { _ in Void() }
    }
}
