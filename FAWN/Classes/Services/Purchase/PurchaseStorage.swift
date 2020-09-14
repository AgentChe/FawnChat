//
//  PurchaseStorage.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 14.09.2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

final class PurchaseStorage {
    static let shared = PurchaseStorage()
    
    private var lastLoadedProductPrices: RetrievedProductsPrices?
    
    private init() {}
}

// MARK: API

extension PurchaseStorage {
    func getLastLoadedProductPrices() -> RetrievedProductsPrices? {
        lastLoadedProductPrices
    }
    
    func store(productPrices: RetrievedProductsPrices) {
        lastLoadedProductPrices = productPrices
    }
}
