//
//  PurchaseError.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

enum PurchaseError: Error {
    case nonProductsForRestore, failedRestorePurchases, failedPurchaseProduct
}
