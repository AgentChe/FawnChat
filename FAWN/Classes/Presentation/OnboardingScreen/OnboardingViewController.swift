//
//  OnboardingViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import NotificationBannerSwift

final class OnboardingViewController: UIViewController {
    static func make() -> UIViewController {
        OnboardingViewController()
    }
    
    private lazy var info1View = makeInfoView("Onboarding.Info1Title", "Onboarding.Info1SubTitle", "tenor-7", "Onboarding.Info1Button")
    private lazy var info2View = makeInfoView("Onboarding.Info2Title", "Onboarding.Info2SubTitle", "tenor-5", "Onboarding.Info2Button")
    private lazy var info3View = makeInfoView("Onboarding.Info3Title", "Onboarding.Info3SubTitle", "tenor-8", "Onboarding.Info3Button")
    private lazy var birthdayView = makeBirthdayView()
    private lazy var nameView = makeNameView()
    private lazy var photosView = makePhotosView()
    private lazy var welcomeView = makeWelcomeView()
    private lazy var notificationsView = makeNotificationsView()
    
    private let viewModel = OnboardingViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigate()
        
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
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Lazy initialization
    
    private func makeInfoView(_ titleKey: String, _ subTitleKey: String, _ videoName: String, _ buttonTextKey: String) -> OnboardingInfoView {
        let view = OnboardingInfoView(title: titleKey.localized,
                                      subTitle: subTitleKey.localized,
                                      localVideoUrl: Bundle.main.url(forResource: videoName, withExtension: "mp4")!,
                                      buttonText: buttonTextKey.localized)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
    
    private func makeBirthdayView() -> OnboardingBirthdayView {
        let view = OnboardingBirthdayView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
    
    private func makeNameView() -> OnboardingNameView {
        let view = OnboardingNameView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
    
    private func makePhotosView() -> OnboardingPhotosView {
        let view = OnboardingPhotosView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
    
    private func makeWelcomeView() -> OnboardingWelcomeView {
        let view = OnboardingWelcomeView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
    
    private func makeNotificationsView() -> OnboardingNotificationsView {
        let view = OnboardingNotificationsView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
    
    // MARK: Private
    
    private func navigate() {
        move(on: info1View)
        info1View.setup()
        
        info1View.buttonTapped = { [unowned self] in
            self.move(on: self.info2View, from: self.info1View)
            self.info2View.setup()
        }
        
        info2View.buttonTapped = { [unowned self] in
            self.move(on: self.info3View, from: self.info2View)
            self.info3View.setup()
        }
        
        info3View.buttonTapped = { [unowned self] in
            self.move(on: self.birthdayView, from: self.info3View)
        }
        
        birthdayView.didContinueWithData = { [unowned self] date in
            self.viewModel.birthdate.accept(date)
            
            self.move(on: self.nameView, from: self.birthdayView)
            self.nameView.setup()
        }
        
        nameView.didContinueWithName = { [unowned self] name in
            self.viewModel.name.accept(name)
            
            self.move(on: self.photosView, from: self.nameView)
        }
        
        photosView.didContinueWithUrls = { [unowned self] urls in
            self.viewModel.photoUrls.accept(urls)
            
            self.welcomeView.setup(name: self.viewModel.name.value, birthdate: self.viewModel.birthdate.value, photos: self.viewModel.photoUrls.value)
            self.move(on: self.welcomeView, from: self.photosView)
        }
        
        welcomeView.didContinue = { [unowned self] in
            self.move(on: self.notificationsView, from: self.welcomeView)
            self.notificationsView.setup()
        }
        
        notificationsView.didContinueWithNotificationsToken = { [unowned self] in
            self.notificationsView.isHidden = true
            
            self.viewModel.onboardingPassed.accept(Void())
        }
    }
    
    private func move(on view: UIView, from previous: UIView? = nil) {
        previous?.isHidden = true
        view.isHidden = false
        
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func goToMainScreen() {
        let vc = MainViewController.make()
        AppDelegate.shared.window?.rootViewController = vc
    }
}
