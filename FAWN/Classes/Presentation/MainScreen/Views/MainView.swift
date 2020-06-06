//
//  MainView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class MainView: UIView {
    lazy var pageContainerView = makePageContainerView()
    lazy var buttonsBackgroundView = makeButtonsBackgroundView()
    lazy var searchButton = makeButton()
    lazy var chatsButton = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension MainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageContainerView.topAnchor.constraint(equalTo: topAnchor),
            pageContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonsBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonsBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonsBackgroundView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            buttonsBackgroundView.heightAnchor.constraint(equalToConstant: 100.scale)
        ])
        
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 78.scale),
            searchButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -48.scale),
            searchButton.widthAnchor.constraint(equalToConstant: 50.scale),
            searchButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            chatsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -78.scale),
            chatsButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -48.scale),
            chatsButton.widthAnchor.constraint(equalToConstant: 50.scale),
            chatsButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension MainView {
    func makePageContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButtonsBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.image = UIImage(named: "gard")
        view.translatesAutoresizingMaskIntoConstraints = false 
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
