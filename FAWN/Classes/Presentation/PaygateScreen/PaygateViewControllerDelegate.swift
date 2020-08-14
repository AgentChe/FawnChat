//
//  PaygateViewControllerDelegate.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08.07.2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

protocol PaygateViewControllerDelegate: class {
    func wasPurchased()
    func wasRestored()
}
