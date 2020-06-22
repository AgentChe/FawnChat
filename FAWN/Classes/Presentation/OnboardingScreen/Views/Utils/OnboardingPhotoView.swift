//
//  OnboardingPhotoView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 27/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

@objc protocol OnboardingPhotoViewDelegate: class {
    @objc optional func photoUploadSuccessfully(with url: String, for tag: Int)
    @objc optional func photoUploadFailure(with error: String)
    @objc optional func blockTagForSelect(tag: Int, isBlocked: Bool)
}

final class OnboardingPhotoView: UIImageView {
    weak var delegate: OnboardingPhotoViewDelegate?
    
    private var disposable: Disposable?
    
    private let uploadPhoto = PublishRelay<UIImage>()
    
    private lazy var imagePicker = makeImagePicker()
    
    init(tag: Int) {
        super.init(frame: .zero)
        
        configure()
        self.tag = tag
    }
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func select() {
        openImagePicker()
    }
    
    func cancel() {
        disposable?.dispose()
        disposable = nil
    }
    
    // MARK: Lazy initialization
    
    private func makeImagePicker() -> ImagePicker? {
        guard let vc = AppDelegate.shared.window?.rootViewController else {
            return nil
        }
        
        return ImagePicker(presentationController: vc, delegate: self)
    }
    
    // MARK: Private
    
    private func configure() {
        clipsToBounds = true
        contentMode = .scaleAspectFill
        image = UIImage(named: "onboarding_photo_frame")
        layer.cornerRadius = 12
        isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(sender:)))
        addGestureRecognizer(tapGesture)
        
        disposable = uploadPhoto
            .flatMapLatest { ImageService.upload(image: $0) }
            .catchErrorJustReturn((nil, nil))
            .subscribe(onNext: { [weak self] response in
                guard let `self` = self else {
                    return
                }
                
                if let path = response.url, let url = URL(string: path) {
                    self.kf.cancelDownloadTask()
                    self.kf.setImage(with: url)
                    
                    self.delegate?.photoUploadSuccessfully?(with: path, for: self.tag)
                } else {
                    self.isUserInteractionEnabled = true
                    self.delegate?.blockTagForSelect?(tag: self.tag, isBlocked: false)
                    
                    self.delegate?.photoUploadFailure?(with: response.error ?? "Onboarding.FailedUploadImage".localized)
                }
            })
    }
    
    @objc
    private func imageViewTapped(sender: UITapGestureRecognizer) {
        openImagePicker()
    }
    
    private func openImagePicker() {
        imagePicker?.present(from: self)
    }
}

extension OnboardingPhotoView: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        isUserInteractionEnabled = false
        delegate?.blockTagForSelect?(tag: tag, isBlocked: true)
        
        uploadPhoto.accept(image)
    }
}
