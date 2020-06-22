//
//  ChatAttachButton.swift
//  RACK
//
//  Created by Andrey Chernyshev on 01/03/2020.
//  Copyright © 2020 fawn.team. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatAttachButton: UIView {
    enum State {
        case close, attach
    }
    
    lazy var imageView = makeImageView()
    
    let event = PublishRelay<State>()
    
    private var state: State = .attach
    
    private let disposeBag = DisposeBag()
    
    private let closeImage = UIImage(named: "close_menu_btn")
    private let attachImage = UIImage(named: "plus_btn")
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor(red: 102 / 255, green: 102 / 255, blue: 102 / 255, alpha: 0.6)
        
        makeConstraints()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
    
    func apply(state: State) {
        self.state = state
        
        exchange()
    }
}

// MARK: Private

private extension ChatAttachButton {
    func addActions() {
        let tapGesture = UITapGestureRecognizer()
        addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .throttle(RxTimeInterval.milliseconds(250), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] _ in
                let currentState = self.state
                
                switch self.state {
                case .attach:
                    self.state = .close
                case .close:
                    self.state = .attach
                }
                
                self.exchange {
                    self.event.accept(currentState)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func exchange(comleteAnimations: (() -> ())? = nil) {
        let rotateValue: CGFloat
        let image: UIImage?
        
        switch state {
        case .attach:
            rotateValue = -45
            image = attachImage
        case .close:
            rotateValue = 45
            image = closeImage
        }
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.imageView.rotate(rotateValue)
        }, completion: { [weak self] _ in
            self?.imageView.rotate(-rotateValue)
            self?.imageView.image = image
            
            comleteAnimations?()
        })
    }
}

// MARK: Make constraints

private extension ChatAttachButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension ChatAttachButton {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "plus_btn")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
