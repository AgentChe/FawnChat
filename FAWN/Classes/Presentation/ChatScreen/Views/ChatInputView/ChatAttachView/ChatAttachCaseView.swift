//
//  ChatAttachCaseView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class ChatAttachCaseView: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        _ = imageView
        _ = label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Lazy initialization

private extension ChatAttachCaseView {
    func makeImageView() -> UIImageView {
        let view = UIImageView(frame: CGRect(x: 14, y: 15, width: 32, height: 32))
        view.contentMode = .scaleAspectFit
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let x: CGFloat = 14 + 32 + 15
        let view = UILabel(frame: CGRect(x: x,
                                         y: 19,
                                         width: self.bounds.width - x - 16,
                                         height: 23))
        view.font = Font.SFProText.regular(size: 19)
        view.textColor = .black
        addSubview(view)
        return view
    }
}
