//
//  FAWNNavigationController.swift
//  FAWN
//
//  Created by Алексей Петров on 16/03/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit

final class FAWNNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.tintColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
