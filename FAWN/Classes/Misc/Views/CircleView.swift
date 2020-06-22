//
//  CircleView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class CircleView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = max(frame.width, frame.height) / 2
    }
}
