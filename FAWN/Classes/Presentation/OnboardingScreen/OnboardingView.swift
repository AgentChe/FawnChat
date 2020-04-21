//
//  OnboardingView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 19/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class OnboardingView: UIView {
    private lazy var info1View = makeInfoView("Onboarding.Info1Title", "Onboarding.Info1SubTitle", "tenor-7", "Onboarding.Info1Button")
    private lazy var info2View = makeInfoView("Onboarding.Info2Title", "Onboarding.Info2SubTitle", "tenor-5", "Onboarding.Info2Button")
    private lazy var info3View = makeInfoView("Onboarding.Info3Title", "Onboarding.Info3SubTitle", "tenor-8", "Onboarding.Info3Button")
    private lazy var birthdayView = makeBirthdayView()
    private lazy var nameView = makeNameView()
    private lazy var photosView = makePhotosView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        navigate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lazy initialization
    
    private func makeInfoView(_ titleKey: String, _ subTitleKey: String, _ videoName: String, _ buttonTextKey: String) -> OnboardingInfoView {
        let view = OnboardingInfoView(title: titleKey.localized,
                                      subTitle: subTitleKey.localized,
                                      localVideoUrl: Bundle.main.url(forResource: videoName, withExtension: "mp4")!,
                                      buttonText: buttonTextKey.localized)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeBirthdayView() -> OnboardingBirthdayView {
        let view = OnboardingBirthdayView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeNameView() -> OnboardingNameView {
        let view = OnboardingNameView()
        view.isHidden = true 
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makePhotosView() -> OnboardingPhotosView {
        let view = OnboardingPhotosView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
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
            self.move(on: self.nameView, from: self.birthdayView)
            self.nameView.setup()
        }
        
        nameView.didContinueWithName = { [unowned self] name in
            self.move(on: self.photosView, from: self.nameView)
        }
        
        photosView.didContinueWithUrls = { [unowned self] urls in
            print(urls)
        }
    }
    
    private func move(on view: UIView, from previous: UIView? = nil) {
        previous?.isHidden = true
        view.isHidden = false
        
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
