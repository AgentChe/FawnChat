//
//  NotificationView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 23/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class NotificationView: UIView {
    private lazy var label = makeLabel()
    
    convenience init(text: String) {
        self.init(frame: .zero)
        
        label.text = text
    }
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lazy initialization
    
    private func makeLabel() -> UILabel {
        let view = UILabel()
        view.textColor = .black
        view.font = Font.Merriweather.regular(size: 16)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    // MARK: Make constraints
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
