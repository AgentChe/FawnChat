//
//  UIDeviceExtension.swift
//  DoggyBag
//
//  Created by Andrey Chernyshev on 26/11/2019.
//  Copyright © 2019 Andrey Chernyshev. All rights reserved.
//

import UIKit

extension UIDevice {
    private static let maxHeightSmallDevice: CGFloat = 1334
    private static let maxHeightVerySmallDevice: CGFloat = 1136
    
    var isSmallScreen: Bool {
        return UIScreen.main.nativeBounds.height <= UIDevice.maxHeightSmallDevice
    }
    
    var isVerySmallScreen: Bool {
        return UIScreen.main.nativeBounds.height <= UIDevice.maxHeightVerySmallDevice
    }
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }

        return false
    }
    
    var hasBottomNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 20
        }

        return false
    }
}

// MARK: Locale

extension UIDevice {
    static var deviceLanguageCode: String? {
        guard let mainPreferredLanguage = Locale.preferredLanguages.first else {
            return nil
        }
        
        return Locale(identifier: mainPreferredLanguage).languageCode
    }
}

// MARK: Version

extension UIDevice {
    static var version: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    static var appVersion: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
}
