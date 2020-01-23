//
//  RootViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 11/06/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit

class RootViewController: UIViewController {

    private var current: UIViewController
    
    init() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Splash", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "splash")
        self.current = viewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)

    }
    
    @objc private func login() {
        switchToLogin()
    }
    
    func showLoginScreen() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Registration", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "registr")
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = viewController
    }
    
    
    func showMainScreen() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "main")
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = viewController
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        new.view.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.3, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
    func switchToMainScreen() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainScreen = mainStoryboard.instantiateViewController(withIdentifier: "main")
        animateFadeTransition(to: mainScreen)
    }
    
    func switchToLogin() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Registration", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "registr")
        animateFadeTransition(to: viewController)
    }
    
    func showSplash() {
        let splashStoryboard: UIStoryboard = UIStoryboard(name: "Splash", bundle: nil)
        let splashScreen = splashStoryboard.instantiateViewController(withIdentifier: "splash")
        animateFadeTransition(to: splashScreen)
//        PaymentFlow.shared.delegate = self
    }

}

extension RootViewController: PaymentFlowDelegate {
    
    func paymentSuccses() {
        
    }
    
    func error() {
//        ScreenManager.shared.startManagment()
    }
    
    func paymentInfoWasLoad(config bundle: ConfigBundle) {
        
        let show: Bool = UserDefaults.standard.bool(forKey: NotificationManager.kWasShow)
        
        if UserDefaults.standard.bool(forKey: NotificationManager.kWasShow) == false {
            UserDefaults.standard.set(true, forKey: NotificationManager.kWasShow)

            if !UIApplication.shared.isRegisteredForRemoteNotifications {
                NotificationManager.shared.requestAccses()
            }
            
        }
//        ScreenManager.shared.startManagment()
    }
    
    func purchase() {
        
    }
    
}
