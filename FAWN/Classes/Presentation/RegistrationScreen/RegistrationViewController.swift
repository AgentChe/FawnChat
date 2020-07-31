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
import RxCocoa
import AuthenticationServices

final class RegistrationViewController: UIViewController {
    static func make() -> UIViewController {
        let vc = UIStoryboard(name: "RegistrationScreen", bundle: .main).instantiateInitialViewController()!
        return FAWNNavigationController(rootViewController: vc)
    }
    
    @IBOutlet private weak var continueWithFBButton: GradientButton!
    @IBOutlet private weak var continueWithAnotherOptionButton: UIButton!
    @IBOutlet private weak var termsButton: UIButton!
    
    @available(iOS 13.0, *)
    lazy var appleSingInButton = makeAppleSignInButton()
    
    private let viewModel = RegistrationViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeAnalytics.shared.log(with: .loginScr)
        
        makeConstraints()
        
        viewModel
            .authWithFBComplete()
            .drive(onNext: { [weak self] new in
                guard let isNew = new else {
                    NotificationBanner(customView: NoInternetView.instanceFromNib()).show()
                    return
                }
                
                isNew ? self?.goToOnboardingScreen() : self?.goToMainScreen()
            })
            .disposed(by: disposeBag)
        
        if #available(iOS 13.0, *) {
            viewModel
                .authWithAppleComlete()
                .drive(onNext: { [weak self] new in
                    guard let isNew = new else {
                        NotificationBanner(customView: NoInternetView.instanceFromNib()).show()
                        return
                    }
                    
                    isNew ? self?.goToOnboardingScreen() : self?.goToMainScreen()
                })
                .disposed(by: disposeBag)
        }
        
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
}

// MARK: Private

private extension RegistrationViewController {
    @objc
    func appleSignInTapped() {
        viewModel.authWithApple.accept(Void())
    }
    
    func goToMainScreen() {
        AppDelegate.shared.window?.rootViewController = MainViewController.make()
    }
    
    func goToOnboardingScreen() {
        AppDelegate.shared.window?.rootViewController = OnboardingViewController.make()
    }
    
    func goToRegistrationEmailScreen() {
        navigationController?.pushViewController(RegistrationEmailViewController.make(), animated: true)
    }
}

// MARK: Make constraints

private extension RegistrationViewController {
    func makeConstraints() {
        if #available(iOS 13.0, *) {
            NSLayoutConstraint.activate([
                appleSingInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
                appleSingInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
                appleSingInButton.heightAnchor.constraint(equalToConstant: 44),
                appleSingInButton.bottomAnchor.constraint(equalTo: continueWithFBButton.topAnchor, constant: -24.scale)
            ])
        }
    }
}

// MARK: Lazy initialization

private extension RegistrationViewController {
    @available(iOS 13.0, *)
    func makeAppleSignInButton() -> ASAuthorizationAppleIDButton {
        let view = ASAuthorizationAppleIDButton(type: .default, style: .white)
        view.cornerRadius = 22
        view.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
}
