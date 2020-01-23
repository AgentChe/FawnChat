//
//  CodeViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 30/03/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import Amplitude_iOS
import DatingKit
import NotificationBannerSwift


class CodeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var images: [UIImageView]!
    var email: String?
    
    private var code: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScreenManager.shared.onScreenController = self
        weak var weakSelf = self
        textFields.forEach { (textField) in
            textField.delegate = weakSelf
        }
//        User.shared.generateCode()
        textFields.first?.becomeFirstResponder()
        code = ""
        let str = ""
        messageLabel.text = NSLocalizedString("send_message", comment: "") + email!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Amplitude.instance()?.log(event: .codeScr)
        
        guard let emailStr: String = email else {
            return
        }
        
        DatingKit.user.generateValidationCode(email: emailStr) { (status) in
            
            if status == .noInternetConnection {
                let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
                banner.show(on: self.navigationController)
                return
            }
            
            
        }
    }
    
    @IBAction func tapOnSendNewCode(_ sender: UIButton) {
        Amplitude.instance()?.log(event: .codeTap)
        
        guard let emailStr: String = email else {
            return
        }
        
        DatingKit.user.generateValidationCode(email: emailStr) { (status) in
            
            if status == .noInternetConnection {
                let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
                banner.show(on: self.navigationController)
                return
            }
            
            
        }
        
    }
    
    func confirm(_ code: String) {
        guard let emailStr: String = self.email else { return }
        DatingKit.user.verify(code: code, email: emailStr) { (new, status) in
            PurchaseManager.shared.getStoreContry { (store) in
                DatingKit.updateADV(storeCountry: store) { (status) in
                    if status == .noInternetConnection {
                        let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
                        banner.show(on: self.navigationController)
                        return
                    }
                    
                    if status == .succses {
                        AppManager.shared.setLocale()
                        AppManager.shared.setVercion()
                        AppManager.shared.confirmADV()
                        self.view.endEditing(true)
                        UIView.animate(withDuration: 0.4, animations: {
                            self.view.alpha = 0.0
                        }, completion: { (endet) in
                            self.navigationController?.setNavigationBarHidden(true, animated: false)
                             self.performSegue(withIdentifier: "start_email", sender: nil)
                        })
                    }

                }
            }
        }
    }
    
    @objc func tapToHideKeyboard() {
        view.endEditing(true)
    }

}

extension CodeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textFields.first {
            code = ""
            textField.text = ""
            _ = textFields.map{$0.text = ""}
        }
    _ = textFields.map{$0.textColor = .white}
        errorLabel.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
     
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string != "" {
            let index = textFields.index(where: {$0 == textField})
            images[index!].isHidden = true
            code = code + string


            if textField.text == "" {
                
                textField.text = string
                return false
            } else {
                textFields.forEach { (fild) in
                    if fild == textField {
                        let nextFild = textFields.next(item: fild)
                        nextFild!.becomeFirstResponder()
                        nextFild!.text = string
                        let index = textFields.index(where: {$0 == nextFild})
                        images[index!].isHidden = true
                        if (nextFild == textFields.first) {
                            if code.first != string.first {
                                code = string
                            }
                        }
                        if (nextFild == textFields.last) {
                            confirm(code)
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
