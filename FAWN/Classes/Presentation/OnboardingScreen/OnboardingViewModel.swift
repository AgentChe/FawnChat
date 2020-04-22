//
//  OnboardingViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class OnboardingViewModel {
    enum Step {
        case main
    }
    
    let name = BehaviorRelay<String>(value: "")
    let birthdate = BehaviorRelay<Date>(value: Date())
    let photoUrls = BehaviorRelay<[String]>(value: [])
    let onboardingPassed = PublishRelay<Void>()
    
    func step() -> Driver<Step?> {
        let fillProfile = Observable
            .zip(name.skip(1).asObservable(), birthdate.skip(1).asObservable())
            .flatMap { ProfileService.fillProfile(name: $0, birthdate: $1) }
        
        let passed = onboardingPassed.map { true }
        
        return Observable
            .zip(fillProfile, passed) { $0 && $1 }
            .map { $0 ? Step.main : nil }
            .asDriver(onErrorJustReturn: nil)
    }
}
