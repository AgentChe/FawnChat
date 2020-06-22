//
//  ChatInpuTextView.swift
//  RACK
//
//  Created by Andrey Chernyshev on 01/03/2020.
//  Copyright © 2020 fawn.team. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatInpuTextView: UIView {
    private static let maxLines = 4
    
    lazy var textView = makeTextView()
    lazy var button = makeButton()
    
    private let disposeBag = DisposeBag()
    
    private var textViewHeightConstraint: NSLayoutConstraint!
    
    private var currentLinesCount = 1
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        makeConstraints()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if currentLinesCount > 1 && currentLinesCount <= ChatInpuTextView.maxLines {
            textView.setContentOffset(.zero, animated: true)
        }
    }
    
    func set(text: String) {
        textView.text = text
    }
}

// MARK: Rx

extension ChatInpuTextView {
    var tapSend: Signal<Void> {
        button.rx.tap.asSignal()
    }
    
    var text: Observable<String?> {
        textView.rx.text.asObservable()
    }
}

// MARK: Private

private extension ChatInpuTextView {
    func addActions() {
        textView.rx.text
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else {
                    return
                }
                
                let linesCount = Int(self.textView.contentSize.height / self.textView.font!.lineHeight)
                
                if linesCount != self.currentLinesCount && linesCount <= ChatInpuTextView.maxLines {
                    self.currentLinesCount = linesCount
                    
                    self.textViewHeightConstraint.constant = self.textView.contentSize.height
                    self.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        textView.rx.text
            .map { $0?.isEmpty == true || $0 == "Chat.Input.Placeholder".localized }
            .bind(to: button.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints

private extension ChatInpuTextView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8)
        ])
        
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 37)
        textViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}

// MARK: Lazy initialization

private extension ChatInpuTextView {
    func makeTextView() -> ChatInputPlaceholderTextView {
        let view = ChatInputPlaceholderTextView()
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = .clear
        view.font = Font.SFProText.regular(size: 17.scale)
        view.textColor = UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 1)
        view.text = "Chat.Input.Placeholder".localized
        view.sizeToFit()
        view.delegate = view
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "send_btn"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
