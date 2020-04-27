//
//  OnboardingPhotosManager.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 21/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class OnboardingPhotosManager {
    private struct Photo {
        let url: String
        let tag: Int
    }
    
    private var photos = [Photo]()
    private var blockedTags = [Int]()
    
    func set(url: String, for tag: Int) {
        if let index = photos.firstIndex(where: { $0.tag == tag }) {
            photos[index] = Photo(url: url, tag: tag)
        } else {
            photos.append(Photo(url: url, tag: tag))
        }
    }
    
    func blockSelect(tag: Int, isBlocked: Bool) {
        if isBlocked {
            if !blockedTags.contains(tag) {
                blockedTags.append(tag)
            }
        } else {
            if let index = blockedTags.firstIndex(of: tag) {
                blockedTags.remove(at: index)
            }
        }
    }
    
    func isEmpty() -> Bool {
        photos.isEmpty
    }
    
    func getUrls() -> [String] {
        photos.map { $0.url }
    }
    
    func isContainsUrl(for tag: Int) -> Bool {
        photos.contains(where: { $0.tag == tag })
    }
    
    func isBlocked(tag: Int) -> Bool {
        blockedTags.contains(tag)
    }
}
