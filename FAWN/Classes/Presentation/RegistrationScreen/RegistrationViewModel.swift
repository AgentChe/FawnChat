//
//  RegistrationViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa
import FBSDKLoginKit
import DatingKit

struct RegistrationViewModel {
    let authWithFB = PublishRelay<Void>()
    
    func authWithFBComplete(vc: UIViewController) -> Driver<Bool?> {
        authWithFB
            .flatMapLatest {
                Single<Bool?>.create { event in
                    AccessToken.current = nil
                    
                    let manager = LoginManager()
                    manager.logOut()
                    
                    if let accessToken = AccessToken.current?.tokenString {
                        DatingKit.user.createWithFB(token: accessToken) { (user, status) in
                            UserDefaults.standard.set(user?.token, forKey: "user_token_key")
                            UserDefaults.standard.set(user?.userId, forKey: "user_id_key")
                            
                            event(.success(status == .succses ? user?.new : nil))
                        }
                    } else {
                        manager.logIn(permissions: ["public_profile", "email"], from: vc) { _, _ in
                            if let accessToken = AccessToken.current?.tokenString {
                                DatingKit.user.createWithFB(token: accessToken) { (user, status) in
                                    UserDefaults.standard.set(user?.token, forKey: "user_token_key")
                                    UserDefaults.standard.set(user?.userId, forKey: "user_id_key")
                                    
                                    event(.success(status == .succses ? user?.new : nil))
                                }
                            } else {
                                event(.success(nil))
                            }
                        }
                    }
                    
                    return Disposables.create()
                }
            }
            .asDriver(onErrorJustReturn: false)
    }
}
