//
//  SplashViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import NotificationBannerSwift

final class SplashViewController: UIViewController {
    static func make() -> UIViewController {
        SplashViewController(nibName: nil, bundle: nil)
    }
    
    private lazy var imageView = makeImageView()
    
    private let viewModel = SplashViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeConstraints()
        
        viewModel
            .step()
            .drive(onNext: { [weak self] step in
                guard let step = step else {
                    NotificationBanner(customView: NoInternetView.instanceFromNib()).show()
                    return
                }
                
                switch step {
                case .main:
                    self?.goToMainScreen()
                case .registration:
                    self?.goToRegistrationScreen()
                }
            })
    }
    
    // MARK: Lazy initialization
    
    private func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "launch_bg")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view 
    }
    
    // MARK: Make constraints
    
    private func makeConstraints() {
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    // MARK: Private
    
    private func goToMainScreen() {
        AppDelegate.shared.window?.rootViewController = MainViewController.make()
    }
    
    private func goToRegistrationScreen() {
        AppDelegate.shared.window?.rootViewController = RegistrationViewController.make()
    }
}
