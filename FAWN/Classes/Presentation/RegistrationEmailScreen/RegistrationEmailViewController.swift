//
//  RegistrationEmailViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import NotificationBannerSwift

final class RegistrationEmailViewController: UIViewController {
    static func make() -> UIViewController {
        UIStoryboard(name: "RegistrationEmailScreen", bundle: .main).instantiateInitialViewController()!
    }
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var invalidEmailLabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    
    private let viewModel = RegistrationEmailViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeAnalytics.shared.log(with: .emailScr)
        
        textField.delegate = self
        
        let scrollViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToHideKeyboard))
        scrollView.addGestureRecognizer(scrollViewTapGesture)
        
        activityIndicator.isHidden = true

        textField.setLeftPaddingPoints(12)
        continueButton(disable: true)
        
        view.rx.keyboardHeight
            .subscribe(onNext: { [weak self] keyboardHeight in
                self?.scrollView.contentInset.bottom = keyboardHeight == 0 ? 0 : keyboardHeight + 100
            })
            .disposed(by: disposeBag)
        
        continueButton.rx.tap
            .subscribe(onNext: { [weak self] in
                AmplitudeAnalytics.shared.log(with: .emailTap)
                
                self?.checkEmailAndContinue()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .loading
            .drive(onNext: { [weak self] isLoading in
                self?.continueButton.isHidden = isLoading
                self?.textField.isHidden = isLoading
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .step()
            .drive(onNext: { [weak self] step in
                guard let step = step else {
                    NotificationBanner(customView: NoInternetView.instanceFromNib()).show()
                    return
                }
                
                switch step {
                case .onboarding:
                    self?.goToOnboardingScreen()
                case .confirmCode(let email):
                    self?.goToConfirmCode(with: email)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func tapToHideKeyboard() {
        textField.resignFirstResponder()
    }
    
    private func checkEmailAndContinue() {
        guard var email = self.email else {
            return
        }
        
        tapToHideKeyboard()
        
        if email.last == " " {
            email.removeLast()
        }
        
        if viewModel.isValid(email: email) {
            viewModel.createUser.accept(email)
        } else {
            showEmail(invalid: true)
        }
    }
    
    private func showEmail(invalid: Bool) {
        let image: UIImage = invalid ? #imageLiteral(resourceName: "textfield_invalid") : #imageLiteral(resourceName: "textfield_bg")
        textField.background = image
        invalidEmailLabel.isHidden = !invalid
        continueButton(disable: invalid)
    }
    
    private func continueButton(disable: Bool) {
        continueButton.isEnabled = !disable
        continueButton.alpha = disable ? 0.5 : 1.0
    }
    
    private func goToOnboardingScreen() {
        AppDelegate.shared.window?.rootViewController = OnboardingViewController.make()
    }
    
    private func goToConfirmCode(with email: String) {
        AppDelegate.shared.window?.rootViewController = RegistrationConfirmCodeViewController.make(email: email)
    }
}

extension RegistrationEmailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var email = textField.text! + string
        
        if string == "" {
            email.removeLast()
        }
        
        if email != "" {
            continueButton(disable: false)
        }  else {
            continueButton(disable: true)
        }
        
        if viewModel.isValid(email: email) {
            showEmail(invalid: false)
        }
        
        self.email = email
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkEmailAndContinue()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.email = textField.text
    }
}
