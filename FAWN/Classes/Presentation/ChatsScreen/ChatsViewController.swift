//
//  ChatsViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 05/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class ChatsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red 
    }
}

// MARK: Make

extension ChatsViewController {
    static func make() -> ChatsViewController {
        ChatsViewController(nibName: nil, bundle: nil)
    }
}
