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
    private lazy var activityIndicator = makeActivityIndicator()
    
    private lazy var imagePicker = makeImagePicker()
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
    
    private func makeImageView(tag: Int) -> UIImageView {
        let view = UIImageView()
        view.tag = tag
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "onboarding_photo_frame")
        view.layer.cornerRadius = 12
        view.isUserInteractionEnabled = true 
        addSubview(view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(sender:)))
        view.addGestureRecognizer(tapGesture)
        
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
    
    private func makeActivityIndicator() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false 
        addSubview(view)
        return view
    }
    
    private func makeImagePicker() -> ImagePicker? {
        guard let vc = AppDelegate.shared.window?.rootViewController else {
            return nil
        }
        
        return ImagePicker(presentationController: vc, delegate: self)
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
        
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 20).isActive = true
    }
    
    // MARK: Private
    
    @objc
    private func addButtonTapped(sender: Any) {
        let imageViews = [imageView1, imageView2, imageView3]
        if let withoutImageView = imageViews.first(where: { !photosManager.isContansImage(imageViewTag: $0.tag) }) {
            photosManager.willBeAdded(for: withoutImageView.tag)
        } else {
            photosManager.willBeAdded(for: imageView3.tag)
        }
        
        imagePicker?.present(from: self)
    }
    
    @objc
    private func continueButtonTapped(sender: Any) {
        blockUI(isBlock: true)
        
        photosManager.upload { [weak self] success in
            self?.blockUI(isBlock: false)
            
            if success {
                self?.didContinueWithUrls?(self?.photosManager.getUrls() ?? [])
            } else {
                self?.showError()
            }
        }
    }
    
    @objc
    private func imageViewTapped(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else {
            return
        }
        
        photosManager.willBeAdded(for: imageView.tag)
        
        imagePicker?.present(from: self)
    }
    
    private func blockUI(isBlock: Bool) {
        imageView1.isUserInteractionEnabled = !isBlock
        imageView2.isUserInteractionEnabled = !isBlock
        imageView3.isUserInteractionEnabled = !isBlock
        addButton.isUserInteractionEnabled = !isBlock
        continueButton.isUserInteractionEnabled = !isBlock
        
        isBlock ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    private func showError() {
        guard let rootVC = AppDelegate.shared.window?.rootViewController else {
            return
        }
        
        let alert = UIAlertController(title: nil, message: "Onboarding.FailedUploadImage".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Utils.OK".localized, style: .cancel))
        
        rootVC.present(alert, animated: true)
    }
}

extension OnboardingPhotosView: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image, let imageViewTag = photosManager.willBeAddedForImageViewTag else {
            return
        }
        
        let imageViews = [imageView1, imageView2, imageView3]
        imageViews.first(where: { $0.tag == imageViewTag })?.image = image
        
        photosManager.add(image: image)
    }
}
