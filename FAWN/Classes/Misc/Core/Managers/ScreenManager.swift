//
//  ScreenManager.swift
//  FAWN
//
//  Created by Алексей Петров on 16/03/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import Foundation
import DatingKit

class ScreenManager {
    
    var pushChat: ChatItem?
    var chatItemOnScreen: ChatItem?
    var match: DKMatch?
    
    var showChat: Bool = false
    
    static let shared = ScreenManager()
    
    weak var onScreenController: UIViewController?
    
    weak var generalController: UIViewController?
    
    weak var mainViewController: MainViewController?
    
    private var wasStarted: Bool
    
    init() {
        wasStarted = false
    }
    
    func showMian() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "main")
        AppDelegate.shared.window?.rootViewController = viewController
    }
    
    func showRegistration() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Registration", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "registr")
        AppDelegate.shared.window?.rootViewController = viewController
    }
    
    func showProfile() {
        generalController?.performSegue(withIdentifier: "profile", sender: nil)
    }
    
    func startOnboarding() {
        generalController?.performSegue(withIdentifier: "Onboarding", sender: nil)
    }
    
    func setGeneralController(_ viewController: UIViewController) {
        generalController = viewController
    }
    
    func showPaygate() {
         generalController?.performSegue(withIdentifier: "paygate", sender: nil)
    }
    
    func showError(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        onScreenController!.present(alert, animated: true, completion: nil)
    }
    
    
}
