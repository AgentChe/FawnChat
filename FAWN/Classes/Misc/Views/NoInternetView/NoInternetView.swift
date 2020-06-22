//
//  NoInternetView.swift
//  FAWN
//
//  Created by Алексей Петров on 04.11.2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit

class NoInternetView: UIView {
    class func instanceFromNib() -> NoInternetView {
        return UINib(nibName: "NoInternetView", bundle: .main).instantiate(withOwner: nil, options: nil)[0] as! NoInternetView
    }
}
