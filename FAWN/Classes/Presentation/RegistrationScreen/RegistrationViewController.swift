//
//  RegistrationViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 16/03/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import Amplitude_iOS
import NotificationBannerSwift
import RxSwift

final class RegistrationViewController: UIViewController {
    static func make() -> UIViewController {
        UIStoryboard(name: "RegistrationScreen", bundle: .main).instantiateInitialViewController()!
    }
    
    @IBOutlet private weak var continueWithFBButton: GradientButton!
    @IBOutlet private weak var continueWithAnotherOptionButton: UIButton!
    @IBOutlet private weak var termsButton: UIButton!
    
    private let viewModel = RegistrationViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Amplitude.instance()?.log(event: .loginScr)
        
        viewModel.authWithFBComplete(vc: self)
            .drive(onNext: { [weak self] new in
                guard let isNew = new else {
                    NotificationBanner(customView: NoInternetView.instanceFromNib()).show()
                    return
                }
                
                isNew ? self?.goToOnboardingScreen() : self?.goToConfirmCodeScreen()
            })
            .disposed(by: disposeBag)
        
        continueWithFBButton.rx.tap
            .subscribe(onNext: { [weak self] in
                Amplitude.instance()?.log(event: .loginFBTap)
                
                self?.viewModel.authWithFB.accept(Void())
            })
            .disposed(by: disposeBag)
        
        continueWithAnotherOptionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.goToRegistrationEmailScreen()
            })
            .disposed(by: disposeBag)
        
        termsButton.rx.tap
            .subscribe(onNext: {
                Amplitude.instance()?.log(event: .loginTermsTap)
                
                if let url = URL(string: GlobalDefinitions.TermsOfService.termsUrl) {
                    UIApplication.shared.open(url)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func goToConfirmCodeScreen() {
        navigationController?.pushViewController(RegistrationConfirmCodeViewController.make(email: ""), animated: true)
    }
    
    private func goToOnboardingScreen() {
        AppDelegate.shared.window?.rootViewController = OnboardingViewController.make()
    }
    
    private func goToRegistrationEmailScreen() {
        Amplitude.instance()?.log(event: .loginEmailTap)
        
        navigationController?.pushViewController(RegistrationEmailViewController.make(), animated: true)
    }
}
