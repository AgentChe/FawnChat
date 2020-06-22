//
//  RegistrationEmailViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class RegistrationEmailViewModel {
    enum Step {
        case onboarding, confirmCode(String)
    }
    
    let createUser = PublishRelay<String>()
    
    private(set) lazy var loading = activityIndicator.asDriver()
    private let activityIndicator = RxActivityIndicator()
    
    func step() -> Driver<Step?> {
        createUser
            .flatMapLatest { [unowned self] email in
                SessionService
                    .createUser(with: email)
                    .trackActivity(self.activityIndicator)
                    .asDriver(onErrorJustReturn: nil)
                    .map { (email, $0) }
            }
            .map { stub -> Step? in
                let (email, token) = stub
                
                guard let isNewUser = token?.isNewUser else {
                    return nil
                }
                
                return isNewUser ? Step.onboarding : Step.confirmCode(email)
            }
            .asDriver(onErrorJustReturn: nil)
    }
    
    func isValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
