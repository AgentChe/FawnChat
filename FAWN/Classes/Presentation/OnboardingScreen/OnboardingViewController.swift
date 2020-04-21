//
//  OnboardingViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

final class OnboardingViewController: UIViewController {
    static func make() -> UIViewController {
        OnboardingViewController()
    }
    
    let onboardingView = OnboardingView()
    
    private let viewModel = OnboardingViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingView.delegate = self
    }
}

// MARK: OnboardingViewDelegate

extension OnboardingViewController: OnboardingViewDelegate {
    func didSettedName(name: String) {
        viewModel.name.accept(name)
    }
    
    func didSettedBirthdate(birthdate: Date) {
        viewModel.birthdate.accept(birthdate)
    }
    
    func didSettedPhotos(urls: [String]) {
        viewModel.photoUrls.accept(urls)
    }
    
    func didSettedNotificationsToken(token: String?) {
        viewModel.notificationsToken.accept(token)
    }
}
