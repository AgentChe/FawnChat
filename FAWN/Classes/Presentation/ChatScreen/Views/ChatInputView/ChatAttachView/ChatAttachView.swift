//
//  AttachView.swift
//  RACK
//
//  Created by Andrey Chernyshev on 03/03/2020.
//  Copyright © 2020 fawn.team. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatAttachView: UIView {
    enum Case {
        case photo
    }
    
    lazy var photoCaseView = makePhotoCaseView()
    
    private let photoCaseTapGesture = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 225 / 255, green: 225 / 255, blue: 225 / 255, alpha: 1)
        layer.cornerRadius = 12
        
        _ = photoCaseView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Rx

extension ChatAttachView {
    var caseTapped: Signal<Case> {
        photoCaseTapGesture.rx.event
            .map { _ in ChatAttachView.Case.photo }
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Lazy initialization

private extension ChatAttachView {
    func makePhotoCaseView() -> ChatAttachCaseView {
        let view = ChatAttachCaseView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 60))
        view.imageView.image = UIImage(named: "photo_btn")
        view.label.text = "Chat.Attach.Photo".localized
        view.label.sizeToFit()
        view.addGestureRecognizer(photoCaseTapGesture)
        addSubview(view)
        return view
    }
}
