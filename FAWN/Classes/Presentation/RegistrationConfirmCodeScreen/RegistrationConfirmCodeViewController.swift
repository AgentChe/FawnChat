//
//  RegistrationConfirmCodeViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import Amplitude_iOS
import NotificationBannerSwift

final class RegistrationConfirmCodeViewController: UIViewController {
    static func make(email: String) -> UIViewController {
        let vc = UIStoryboard(name: "RegistrationConfirmCodeScreen", bundle: .main).instantiateInitialViewController() as! RegistrationConfirmCodeViewController
        vc.email = email
        return vc
    }
    
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private var textFields: [UITextField]!
    @IBOutlet private var images: [UIImageView]!
    @IBOutlet private weak var sendNewCodeButton: UIButton!
    
    private let viewModel = RegistrationConfirmCodeViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var email = ""
    private var code = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Amplitude.instance()?.log(event: .codeScr)
        
        textFields.forEach { [weak self] textField in
            textField.delegate = self
        }
        
        textFields.first?.becomeFirstResponder()
        
        messageLabel.text = "send_message".localized + email
        
        sendNewCodeButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                Amplitude.instance()?.log(event: .codeTap)
                
                self.viewModel.requireCode.accept(self.email)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .step
            .drive(onNext: { [weak self] step in
                guard let step = step else {
                    NotificationBanner(customView: NoInternetView.instanceFromNib()).show()
                    return
                }
                
                switch step {
                case .main:
                    self?.goToMainScreen()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func confirmCode() {
        viewModel.confirmCode.accept((email, code))
    }
    
    private func goToMainScreen() {
        AppDelegate.shared.window?.rootViewController = MainViewController.make()
    }
}

extension RegistrationConfirmCodeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textFields.first {
            code = ""
            textField.text = ""
            _ = textFields.map{$0.text = ""}
        }
        
        _ = textFields.map{$0.textColor = .white}
        errorLabel.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            let index = textFields.firstIndex(where: {$0 == textField})
            images[index!].isHidden = true
            code = code + string

            if textField.text == "" {
                
                textField.text = string
                return false
            } else {
                textFields.forEach { [weak self] fild in
                    if fild == textField {
                        let nextFild = textFields.next(item: fild)
                        nextFild!.becomeFirstResponder()
                        nextFild!.text = string
                        let index = textFields.firstIndex(where: {$0 == nextFild})
                        images[index!].isHidden = true
                        if (nextFild == textFields.first) {
                            if code.first != string.first {
                                code = string
                            }
                        }
                        if (nextFild == textFields.last) {
                            self?.confirmCode()
                        }
                        
                    }
                }
                return false
            }
        } else {
            textFields.first?.becomeFirstResponder()
            var increment = 0
            textFields.forEach { (fild) in
                fild.text = ""
                images[increment].isHidden = false
                increment = increment + 1
            }
        }
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if ((textField.text?.count)! > 0) {
            textFields.forEach { (fild) in
                fild.text = ""
            }
            code = ""
            images.forEach { (image) in
                image.isHidden = false
            }
            textFields.first?.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
