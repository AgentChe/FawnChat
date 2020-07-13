//
//  AppStateProxy.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 09/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class AppStateProxy {
    struct ApplicationProxy {
        static let didEnterBackground = PublishRelay<Void>()
        static let didBecomeActive = PublishRelay<Void>()
    }
    
    struct UserTokenProxy {
        static let didUpdatedUserToken = PublishRelay<Void>()
        static let userTokenCheckedWithSuccessResult = PublishRelay<Void>()
    }
}
