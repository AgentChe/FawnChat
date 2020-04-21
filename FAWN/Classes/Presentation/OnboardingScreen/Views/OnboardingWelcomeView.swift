//
//  OnboardingWelcomeView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class OnboardingWelcomeView: UIView {
    var didContinue: (() -> Void)?
    
    private lazy var avatarImageView = makeAvatarImageView()
    private lazy var welcomeLabel = makeWelcomeLabel()
    private lazy var photoImage1 = makePhotoImageView()
    private lazy var photoImage2 = makePhotoImageView()
    private lazy var photoImage3 = makePhotoImageView()
    private lazy var activityIndicator = makeActivityIndicator()
    private lazy var continueButton = makeContinueButton()
    private lazy var randomizeButton = makeRandomizeButton()
    
    private let randomizeAvatar = PublishRelay<Void>()
    private let loading = RxActivityIndicator()
    
    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(name: String, birthdate: Date, photos: [String]) {
        let age = Calendar.current.dateComponents([.year], from: birthdate, to: Date()).year ?? 0
        let welcome = String(format: "Onboarding.WelcomeHi".localized, name, age)
        welcomeLabel.attributedText = welcome.attributed(with: makeWelcomeAttributes())
        
        let imageViews = [photoImage1, photoImage2, photoImage3]
        for (index, photo) in photos.prefix(3).enumerated() {
            imageViews[index].kf.setImage(with: URL(string: photo))
        }
    }
    
    // MARK: Lazy initialization
    
    private func makeAvatarImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 32
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeWelcomeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeWelcomeAttributes() -> TextAttributes {
        TextAttributes()
            .font(Font.Merriweather.regular(size: 34))
            .textColor(UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1))
            .lineHeight(41)
    }
    
    private func makePhotoImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        addSubview(view)
        return view
    }
    
    private func makeActivityIndicator() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeContinueButton() -> UIButton {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        view.titleLabel?.font = Font.Montserrat.semibold(size: 17)
        view.setTitle("Onboarding.WelcomeContinue".localized, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeRandomizeButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = .clear
        view.titleLabel?.font = Font.Montserrat.semibold(size: 17)
        view.setTitle("Onboarding.WelcomeRandomize".localized, for: .normal)
        view.setTitleColor(UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 0.3), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    // MARK: Make constraints
    
    private func makeConstraints() {
        avatarImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 121).isActive = true
        
        welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44).isActive = true
        welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24).isActive = true
        
        photoImage1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44).isActive = true
        photoImage1.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 24).isActive = true
        photoImage1.widthAnchor.constraint(equalTo: photoImage2.widthAnchor).isActive = true
        photoImage1.heightAnchor.constraint(equalTo: photoImage1.widthAnchor).isActive = true
        photoImage1.trailingAnchor.constraint(equalTo: photoImage2.leadingAnchor, constant: -12).isActive = true
        
        photoImage2.centerYAnchor.constraint(equalTo: photoImage1.centerYAnchor).isActive = true
        photoImage2.widthAnchor.constraint(equalTo: photoImage3.widthAnchor).isActive = true
        photoImage2.heightAnchor.constraint(equalTo: photoImage2.widthAnchor).isActive = true
        photoImage2.trailingAnchor.constraint(equalTo: photoImage3.leadingAnchor, constant: -12).isActive = true
        
        photoImage3.centerYAnchor.constraint(equalTo: photoImage1.centerYAnchor).isActive = true
        photoImage3.widthAnchor.constraint(equalTo: photoImage1.widthAnchor).isActive = true
        photoImage3.heightAnchor.constraint(equalTo: photoImage3.widthAnchor).isActive = true
        photoImage3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: photoImage1.bottomAnchor, constant: 15).isActive = true
        
        continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        continueButton.topAnchor.constraint(equalTo: photoImage1.bottomAnchor, constant: 88).isActive = true
        
        randomizeButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 24).isActive = true
        randomizeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44).isActive = true
        randomizeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44).isActive = true
        randomizeButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    // MARK: Private
    
    private func bind() {
        loading
            .drive(onNext: { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
                self?.continueButton.isUserInteractionEnabled = !isLoading
                self?.randomizeButton.isUserInteractionEnabled = !isLoading
            })
            .disposed(by: disposeBag)
        
        randomizeButton.rx.tap
            .bind(to: randomizeAvatar)
            .disposed(by: disposeBag)
        
        let randomize = randomizeAvatar
            .startWith(Void())
            .flatMapLatest { [unowned self] in
                ProfileService
                    .randomizeAvatar()
                    .trackActivity(self.loading)
                    .catchErrorJustReturn(nil)
            }
            .share()
            
        randomize
            .subscribe(onNext: { [weak self] path in
                guard let path = path, let url = URL(string: path) else {
                    return
                }
                
                self?.avatarImageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        continueButton.rx.tap
            .skipUntil(randomize)
            .subscribe(onNext: { [weak self] in
                self?.didContinue?()
            })
            .disposed(by: disposeBag)
    }
}
