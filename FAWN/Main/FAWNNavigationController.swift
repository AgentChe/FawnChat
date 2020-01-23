//
//  FAWNNavigationController.swift
//  FAWN
//
//  Created by Алексей Петров on 16/03/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit

class FAWNNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
//        view.backgroundColor = .clear
        

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
