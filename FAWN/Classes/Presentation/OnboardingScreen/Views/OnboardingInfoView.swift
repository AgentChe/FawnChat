//
//  OnboardingInfoView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 19/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class OnboardingInfoView: UIView {
    var buttonTapped: (() -> Void)?
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subtitleLabel = makeSubTitleLabel()
    private lazy var videoView = makeVideoView()
    private lazy var button = makeButton()
    
    private var title: String!
    private var subTitle: String!
    private var localVideoUrl: URL!
    private var buttonText: String!
    
    init(title: String, subTitle: String, localVideoUrl: URL, buttonText: String) {
        self.title = title
        self.subTitle = subTitle
        self.localVideoUrl = localVideoUrl
        self.buttonText = buttonText
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        titleLabel.text = title
        subtitleLabel.text = subTitle
        videoView.play(localVideoUrl: localVideoUrl)
        button.setTitle(buttonText, for: .normal)
    }
    
    // MARK: Lazy initialization
    
    private func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.Merriweather.black(size: 28)
        view.textColor = .white
        view.numberOfLines = 1
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeSubTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.Montserrat.regular(size: 17)
        view.textColor = .white
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeVideoView() -> VideoView {
        let view = VideoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeButton() -> UIButton {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        view.titleLabel?.font = Font.Montserrat.semibold(size: 17)
        view.setTitleColor(.white, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    // MARK: Make constraints
    
    private func makeConstraints() {
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: SizeUtils.value(largeDevice: 48, smallDevice: 28)).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        
        videoView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 28).isActive = true
        videoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        videoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        videoView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -41).isActive = true
        
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    // MARK: Private
    
    @objc
    private func buttonTapped(sender: Any) {
        buttonTapped?()
    }
}
