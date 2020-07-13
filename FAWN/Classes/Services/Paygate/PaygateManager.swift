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

// MARK: Retrieve

extension PaygateManager {
    static func retrievePaygate() -> Single<PaygateMapper.PaygateResponse?> {
        let request = GetPaygateRequest(userToken: SessionService.shared.userToken,
                                        version: UIDevice.appVersion ?? "1",
                                        appInstallKey: IDFAService.shared.getAppKey())
        
        return RestAPITransport()
            .callServerApi(requestBody: request)
            .map { PaygateMapper.parse(response: $0, productsPrices: nil) }
    }
}

// MARK: Prepare prices

extension PaygateManager {
    static func prepareProductsPrices(for paygate: PaygateMapper.PaygateResponse) -> Single<PaygateMapper.PaygateResponse?> {
        guard !paygate.productsIds.isEmpty else {
            return .deferred { .just(paygate) }
        }
        
        return PurchaseService
            .productsPrices(ids: paygate.productsIds)
            .map { PaygateMapper.parse(response: paygate.json, productsPrices: $0.retrievedPrices) }
    }
}
