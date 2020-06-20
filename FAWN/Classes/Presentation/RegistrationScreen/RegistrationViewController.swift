//
//  RegistrationViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 16/03/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import RxSwift

final class RegistrationViewController: UIViewController {
    static func make() -> UIViewController {
        let vc = UIStoryboard(name: "RegistrationScreen", bundle: .main).instantiateInitialViewController()!
        return FAWNNavigationController(rootViewController: vc)
    }
    
    @IBOutlet private weak var continueWithFBButton: GradientButton!
    @IBOutlet private weak var continueWithAnotherOptionButton: UIButton!
    @IBOutlet private weak var termsButton: UIButton!
    
    private let viewModel = RegistrationViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeAnalytics.shared.log(with: .loginScr)
        
        viewModel.authWithFBComplete(vc: self)
            .drive(onNext: { [weak self] new in
                guard let isNew = new else {
                    NotificationBanner(customView: NoInternetView.instanceFromNib()).show()
                    return
                }
                
                isNew ? self?.goToOnboardingScreen() : self?.goToMainScreen()
            })
            .disposed(by: disposeBag)
        
        continueWithFBButton.rx.tap
            .subscribe(onNext: { [weak self] in
                AmplitudeAnalytics.shared.log(with: .loginTap("facebook_login"))
                
                self?.viewModel.authWithFB.accept(Void())
            })
            .disposed(by: disposeBag)
        
        continueWithAnotherOptionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                AmplitudeAnalytics.shared.log(with: .loginTap("email_login"))
                
                self?.goToRegistrationEmailScreen()
            })
            .disposed(by: disposeBag)
        
        termsButton.rx.tap
            .subscribe(onNext: {
                AmplitudeAnalytics.shared.log(with: .loginTap("terms_and_conditions"))
                
                if let url = URL(string: GlobalDefinitions.TermsOfService.termsUrl) {
                    UIApplication.shared.open(url)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func goToMainScreen() {
        AppDelegate.shared.window?.rootViewController = MainViewController.make()
    }
    
    private func goToOnboardingScreen() {
        AppDelegate.shared.window?.rootViewController = OnboardingViewController.make()
    }
    
    private func goToRegistrationEmailScreen() {
        navigationController?.pushViewController(RegistrationEmailViewController.make(), animated: true)
    }
}
