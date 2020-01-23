//
//  EmailViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 28/03/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import Amplitude_iOS
import DatingKit
import NotificationBannerSwift


class EmailViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var invalidEmailLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    private var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScreenManager.shared.onScreenController = self
        textField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapToHideKeyboard))
        tap.delegate = self
        scrollView.addGestureRecognizer(tap)
        activityIndicator.isHidden = true

        textField.setLeftPaddingPoints(12)
        continueButton(disable: true)

        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Amplitude.instance()?.log(event: .emailScr)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        textField.isHidden = false
        continueButton.isHidden = false
        activityIndicator.isHidden = true
    }
    
    private func continueButton(disable: Bool) {
        continueButton.isEnabled = !disable
        continueButton.alpha = disable ? 0.5 : 1.0
    }
    
    
    private func isValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    @objc func tapToHideKeyboard() {
        textField.resignFirstResponder()
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func checkEmailAndContinue() {
        Amplitude.instance()?.log(event: .emailTap)
        tapToHideKeyboard()
        if self.email!.last == " " {
            email?.removeLast()
        }
        if isValid(email: self.email!) {
            continueButton.isHidden = true
            textField.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            guard let email: String = self.email else { return }
            DatingKit.user.create(email: email) { (new, status) in
                PurchaseManager.shared.getStoreContry { (store) in
                    DatingKit.updateADV(storeCountry: store) { (status) in
                        DispatchQueue.main.async {
                            self.continueButton.isHidden = false
                            self.textField.isHidden = false
                            self.activityIndicator.isHidden = true
                            self.activityIndicator.startAnimating()
                            if status == .noInternetConnection {
                                let banner = NotificationBanner(customView: NoInternetView.instanceFromNib())
                                banner.show(on: self.navigationController)
                                return
                            }
                            if status == .succses {
                                if new {
                                    self.performSegue(withIdentifier: "onboarding", sender: nil)
                                } else {
                                    self.performSegue(withIdentifier: "code", sender: nil)
                                }
                          
                            } else {
                                Amplitude.instance()?.log(event: .emailError)
                            }
                        }
                    }
                }
            }
        } else {
            showEmail(invalid: true)
            Amplitude.instance()?.log(event: .emailError)
        }
    }
    
    func showEmail(invalid: Bool) {
        let image: UIImage = invalid ? #imageLiteral(resourceName: "textfield_invalid") : #imageLiteral(resourceName: "textfield_bg")
        textField.background = image
        invalidEmailLabel.isHidden = !invalid
        continueButton(disable: invalid)
    }

    @IBAction func tapOnContinue(_ sender: UIButton) {
        checkEmailAndContinue()
    }
    
}

extension EmailViewController: UITextFieldDelegate {
    
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
        
        if isValid(email: email) {
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
    
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 100.0
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        navigationController?.isNavigationBarHidden = false
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "code" {
            guard let codeVC: CodeViewController = segue.destination as? CodeViewController else { return }
            guard let emailStr: String = email else { return }
            codeVC.email = emailStr
        }
    }
    
}
