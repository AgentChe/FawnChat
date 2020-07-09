//
//  PurchaseService.swift
//  Horo
//
//  Created by Andrey Chernyshev on 02/09/2019.
//  Copyright © 2019 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import SwiftyStoreKit

final class PurchaseService {
    static let shared = PurchaseService()
    
    private init() {}
    
    func configure() {
        SwiftyStoreKit.completeTransactions { purchases in
            for purchase in purchases {
                let state = purchase.transaction.transactionState
                if state == .purchased || state == .restored {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
        }
        
        SwiftyStoreKit.shouldAddStorePaymentHandler = { _, _ in
            return true 
        }
    }
}

// MARK: Validate

extension PurchaseService {
    func paymentValidate(receipt: String) -> Single<Bool> {
        let request = PurchaseValidateRequest(receipt: receipt,
                                              userToken: SessionService.shared.userToken,
                                              version: UIDevice.appVersion)
        
        return RestAPITransport()
            .callServerApi(requestBody: request)
            .map { try CheckResponseForError.isError(jsonResponse: $0) }
    }
    
    func paymentValidate() -> Single<Bool> {
        PurchaseService.receipt
            .flatMap { [weak self] receiptBase64 -> Single<Bool> in
                guard let `self` = self, let receipt = receiptBase64 else {
                    return .just(false)
                }
                
                return self.paymentValidate(receipt: receipt)
            }
    }
}

// MARK: Purchase

extension PurchaseService {
    static func buySubscription(productId: String) -> Single<Void> {
        Single<Void>.create { event in
            SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
                switch result {
                case .success(_):
                    event(.success(Void()))
                case .error(_):
                    event(.error(PurchaseError.failedPurchaseProduct))
                }
            }
            
            return Disposables.create()
        }
    }
    
    static func restoreSubscription(productId: String) -> Single<Void> {
        Single<Void>.create { event in
            SwiftyStoreKit.restorePurchases(atomically: true) { result in
                if result.restoredPurchases.isEmpty {
                    event(.error(PurchaseError.nonProductsForRestore))
                } else if result.restoredPurchases.contains(where: { $0.productId == productId }) {
                    event(.success(Void()))
                } else {
                    event(.error(PurchaseError.failedPurchaseProduct))
                }
            }
            
            return Disposables.create()
        }
    }
}

// MARK: Retrieved

extension PurchaseService {
    static func productPrice(productId: String) -> Single<String?> {
        Single<String?>.create { event in
            SwiftyStoreKit.retrieveProductsInfo([productId]) { products in
                var price: String? = nil
                
                if let product = products.retrievedProducts.first {
                    price = product.localizedPrice
                }
                
                event(.success(price))
            }
            
            return Disposables.create()
        }
    }
    
    static func productsPrices(ids: [String]) -> Single<RetrievedProductsPrices> {
        Single<RetrievedProductsPrices>.create { event in
            SwiftyStoreKit.retrieveProductsInfo(Set(ids)) { products in
                let retrieved: [ProductPrice] = products
                    .retrievedProducts
                    .compactMap { ProductPrice(product: $0) }
                
                let invalidated = products
                    .invalidProductIDs
                
                let result = RetrievedProductsPrices(retrievedPrices: retrieved, invalidatedIds: Array(invalidated))
                
                event(.success(result))
            }
            
            return Disposables.create()
        }
    }
}

// MARK: Private

private extension PurchaseService {
    static var receipt: Single<String?> {
        .deferred { .just(SwiftyStoreKit.localReceiptData?.base64EncodedString()) }
    }
}
