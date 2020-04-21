//
//  OnboardingPhotosManager.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 21/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

final class OnboardingPhotosManager {
    final class Photo {
        var imageViewTag: Int
        var image: UIImage
        var isUploaded: Bool?
        var url: String? = nil 
        
        init(imageViewTag: Int, image: UIImage, isUploaded: Bool?) {
            self.imageViewTag = imageViewTag
            self.image = image
            self.isUploaded = isUploaded
        }
    }
    
    private(set) var willBeAddedForImageViewTag: Int?
    
    private var photos: [Photo] = []
    
    private var disposable: Disposable?
    
    func willBeAdded(for imageViewTag: Int) {
        willBeAddedForImageViewTag = imageViewTag
    }
    
    func add(image: UIImage) {
        guard let imageViewTag = willBeAddedForImageViewTag else {
            return
        }
        
        if let already = photos.first(where: { $0.imageViewTag == imageViewTag }) {
            already.image = image
            already.isUploaded = nil 
            return
        }
        
        photos.append(Photo(imageViewTag: imageViewTag, image: image, isUploaded: nil))
    }
    
    func getUrls() -> [String] {
        photos.compactMap { $0.url }
    }
    
    func isEmpty() -> Bool {
        photos.isEmpty
    }
    
    func isContansImage(imageViewTag: Int) -> Bool {
        photos.contains(where: { $0.imageViewTag == imageViewTag })
    }
    
    func upload(completion: @escaping (Bool) -> Void) {
        guard !isEmpty() else {
            completion(false)
            return
        }
        
        upload { [weak self] in
            guard let `self` = self else {
                return
            }
            
            completion(!self.photos.contains(where: { $0.isUploaded == false }))
        }
    }
    
    private func upload(completion: @escaping () -> Void) {
        disposable?.dispose()
        disposable = nil
        
        let nonUploadedPhotos = photos.filter { $0.isUploaded != true }
        
        disposable = Single
            .zip(nonUploadedPhotos.compactMap { ImageService.upload(image: $0.image) })
            .subscribe(onSuccess: { result in
                for (index, url) in result.enumerated() {
                    nonUploadedPhotos[index].isUploaded = url != nil
                    nonUploadedPhotos[index].url = url
                }
                
                completion()
            })
    }
}
