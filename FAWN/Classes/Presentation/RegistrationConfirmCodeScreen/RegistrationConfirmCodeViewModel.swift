//
//  RegistrationConfirmCodeViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class RegistrationConfirmCodeViewModel {
    enum Step {
        case main
    }
    
    let requireCode = PublishRelay<String>()
    let confirmCode = PublishRelay<(email: String, code: String)>()
    
    private(set) lazy var isLoading = activityIndicator.asDriver()
    private let activityIndicator = RxActivityIndicator()
    
    private(set) lazy var step = createStep()
    
    private func createStep() -> Driver<Step?> {
        let confirm = confirmCode
            .flatMapLatest { [unowned self] stub -> Observable<Token?> in
                let (email, code) = stub
                
                return SessionService
                    .confirmCode(email: email, code: code)
                    .trackActivity(self.activityIndicator)
                    .catchErrorJustReturn(nil)
            }
            .map { $0 == nil ? nil : Step.main }
            .asDriver(onErrorJustReturn: nil)
        
        let require = createRequireCodeAction()
        
        return Driver
            .merge(confirm, require)
    }
    
    private func createRequireCodeAction() -> Driver<Step?> {
        requireCode
            .flatMapLatest { email in
                SessionService
                    .requireConfirmCode(email: email)
                    .catchErrorJustReturn(false)
            }
            .flatMap { _ -> Single<Step?> in .never() }
            .asDriver(onErrorDriveWith: .never())
    }
}
