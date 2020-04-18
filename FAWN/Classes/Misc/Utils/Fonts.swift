//
//  Fonts.swift
//  DoggyBag
//
//  Created by Andrey Chernyshev on 18/11/2019.
//  Copyright © 2019 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class Font {
    struct Merriweather {
        static func black(size: CGFloat) -> UIFont {
            return UIFont(name: "Merriweather-Black", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            return UIFont(name: "Merriweather-Bold", size: size)!
        }
        
        static func boldItalic(size: CGFloat) -> UIFont {
            return UIFont(name: "Merriweather-BoldIt", size: size)!
        }
        
        static func italic(size: CGFloat) -> UIFont {
            return UIFont(name: "Merriweather-Italic", size: size)!
        }
        
        static func light(size: CGFloat) -> UIFont {
            return UIFont(name: "Merriweather-Light", size: size)!
        }
        
        static func lightItalic(size: CGFloat) -> UIFont {
            return UIFont(name: "Merriweather-LightIt", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            return UIFont(name: "Merriweather-Regular", size: size)!
        }
        
        static func ultraBoldItalic(size: CGFloat) -> UIFont {
            return UIFont(name: "Merriweather-UltraBdIt", size: size)!
        }
        
        static func ultraBold(size: CGFloat) -> UIFont {
            return UIFont(name: "Merriweather-UltraBold", size: size)!
        }
    }
    
    struct Montserrat {
        static func semibold(size: CGFloat) -> UIFont {
            return UIFont(name: "Montserrat-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            return UIFont(name: "Montserrat-Regular", size: size)!
        }
    }
}
