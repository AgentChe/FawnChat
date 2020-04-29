//
//  NoProposedInterlocutorsView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class NoProposedInterlocutorsView: UIView {
    enum DisplayType {
        case noProposedInterlocutors, needPayment
    }
    
    var newSearchTapped: (() -> Void)?
    
    private lazy var imageView = makeImageView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subTitleLabel = makeSubTitleLabel()
    private lazy var newSearchButton = makeNewSearchButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(type: DisplayType) {
        switch type {
        case .noProposedInterlocutors:
            titleLabel.attributedText = "Search.NoProposedInterlocutorsTitle".localized.attributed(with: makeTitleAttrs())
            subTitleLabel.attributedText = "Search.NoProposedInterlocutorsSubTitle".localized.attributed(with: makeSubTitleAttrs())
        case .needPayment:
            titleLabel.attributedText = "Search.NeedPaymentTitle".localized.attributed(with: makeTitleAttrs())
            subTitleLabel.attributedText = "Search.NeedPaymentSubTitle".localized.attributed(with: makeSubTitleAttrs())
        }
    }
    
    // MARK: Lazy initialization
    
    private func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Search.NoProposedInterlcutors")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeSubTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeNewSearchButton() -> UIButton {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        view.titleLabel?.font = Font.Montserrat.semibold(size: 17)
        view.setTitle("Search.NoProposedInterlocutorsNewSearch".localized, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(newSearchTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    private func makeTitleAttrs() -> TextAttributes {
        TextAttributes()
            .textColor(UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1))
            .font(Font.Merriweather.regular(size: 22))
            .lineHeight(28)
            .textAlignment(.center)
    }
    
    private func makeSubTitleAttrs() -> TextAttributes {
        TextAttributes()
            .textColor(.white)
            .font(Font.Merriweather.regular(size: 17))
            .lineHeight(22)
            .letterSpacing(-0.6)
            .textAlignment(.center)
    }
    
    // MARK: Make constraints
    
    private func makeConstraints() {
        imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 150).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24).isActive = true
        
        subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        
        newSearchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44).isActive = true
        newSearchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44).isActive = true
        newSearchButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 32).isActive = true
        newSearchButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    // MARK: Private
    
    @objc
    private func newSearchTapped(sender: Any) {
        newSearchTapped?()
    }
}
