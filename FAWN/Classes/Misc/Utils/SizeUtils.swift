//
//  ConstraintUtils.swift
//  DoggyBag
//
//  Created by Andrey Chernyshev on 26/11/2019.
//  Copyright © 2019 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class SizeUtils {
    static func value(largeDevice: CGFloat, smallDevice: CGFloat) -> CGFloat {
        return UIDevice.current.isSmallScreen ? smallDevice : largeDevice
    }
    
    static func value(largeDevice: CGFloat, smallDevice: CGFloat, verySmallDevice: CGFloat) -> CGFloat {
        let device = UIDevice.current
        
        if device.isSmallScreen {
            if device.isVerySmallScreen {
                return verySmallDevice
            }
            
            return smallDevice
        }
        
        return largeDevice
    }
}
