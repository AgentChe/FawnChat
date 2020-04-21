//
//  OnboardingViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

struct OnboardingViewModel {
    let name = BehaviorRelay<String>(value: "")
    let birthdate = BehaviorRelay<Date>(value: Date())
    let photoUrls = BehaviorRelay<[String]>(value: [])
    let notificationsToken = BehaviorRelay<String?>(value: "")
}
