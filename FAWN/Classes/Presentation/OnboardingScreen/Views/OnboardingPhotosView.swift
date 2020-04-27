//
//  OnboardingPhotosView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 19/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import DatingKit

final class OnboardingPhotosView: UIView {
    var didContinueWithUrls: (([String]) -> Void)?
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subTitleLabel = makeSubTitleLabel()
    private lazy var imageView1 = makeImageView(tag: 1)
    private lazy var imageView2 = makeImageView(tag: 2)
    private lazy var imageView3 = makeImageView(tag: 3)
    private lazy var addButton = makeAddButton()
    private lazy var continueButton = makeContinueButton()
    
    private let photosManager = OnboardingPhotosManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lazy initialization
    
    private func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.Merriweather.black(size: 28)
        view.textColor = .white
        view.numberOfLines = 1
        view.textAlignment = .center
        view.text = "Onboarding.PhotosTitle".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeSubTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.Montserrat.regular(size: 17)
        view.textColor = .white
        view.numberOfLines = 0
        view.textAlignment = .center
        view.text = "Onboarding.PhotosSubTitle".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeImageView(tag: Int) -> OnboardingPhotoView {
        let view = OnboardingPhotoView(tag: tag)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeAddButton() -> UIButton {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        view.titleLabel?.font = Font.Montserrat.semibold(size: 17)
        view.setTitle("Onboarding.PhotosAdd".localized, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    private func makeContinueButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = .clear
        view.titleLabel?.font = Font.Montserrat.semibold(size: 17)
        view.setTitle("Onboarding.PhotosContinue".localized, for: .normal)
        view.setTitleColor(UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 0.3), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(continueButtonTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    // MARK: Make constraints
    
    private func makeConstraints() {
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 130).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        
        imageView1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 43).isActive = true
        imageView1.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 40).isActive = true
        imageView1.widthAnchor.constraint(equalTo: imageView2.widthAnchor).isActive = true
        imageView1.heightAnchor.constraint(equalTo: imageView1.widthAnchor).isActive = true
        imageView1.trailingAnchor.constraint(equalTo: imageView2.leadingAnchor, constant: -12).isActive = true
        
        imageView2.centerYAnchor.constraint(equalTo: imageView1.centerYAnchor).isActive = true
        imageView2.widthAnchor.constraint(equalTo: imageView3.widthAnchor).isActive = true
        imageView2.heightAnchor.constraint(equalTo: imageView2.widthAnchor).isActive = true
        imageView2.trailingAnchor.constraint(equalTo: imageView3.leadingAnchor, constant: -12).isActive = true
        
        imageView3.centerYAnchor.constraint(equalTo: imageView1.centerYAnchor).isActive = true
        imageView3.widthAnchor.constraint(equalTo: imageView1.widthAnchor).isActive = true
        imageView3.heightAnchor.constraint(equalTo: imageView3.widthAnchor).isActive = true
        imageView3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -43).isActive = true
        
        addButton.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: 40).isActive = true
        addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        continueButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 24).isActive = true
        continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    // MARK: Private
    
    @objc
    private func addButtonTapped(sender: Any) {
        let imageViews = [imageView1, imageView2, imageView3]
        if let withoutImageView = imageViews.first(where: { !photosManager.isContainsUrl(for: $0.tag) && !photosManager.isBlocked(tag: $0.tag) }) {
            withoutImageView.select()
        } else if let lastImageView = imageViews.last, !photosManager.isBlocked(tag: lastImageView.tag) {
            lastImageView.select()
        }
    }
    
    @objc
    private func continueButtonTapped(sender: Any) {
        guard !photosManager.isEmpty() else {
            return
        }
        
        [imageView1, imageView2, imageView3].forEach { $0.cancel() }
        
        didContinueWithUrls?(photosManager.getUrls())
    }
}

// MARK: OnboardingPhotoViewDelegate

extension OnboardingPhotosView: OnboardingPhotoViewDelegate {
    func photoUploadSuccessfully(with url: String, for tag: Int) {
        photosManager.set(url: url, for: tag)
    }
    
    func photoUploadFailure(with error: String) {
        guard let rootVC = AppDelegate.shared.window?.rootViewController else {
            return
        }
        
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Utils.OK".localized, style: .cancel))
        
        rootVC.present(alert, animated: true)
    }
    
    func blockTagForSelect(tag: Int, isBlocked: Bool) {
        photosManager.blockSelect(tag: tag, isBlocked: isBlocked)
    }
}
