//
//  OnboardingNotificationsView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class OnboardingNotificationsView: UIView {
    var didContinueWithNotificationsToken: (() -> Void)?
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var footerLabel = makeFooterLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        NotificationManager.shared.startManagment()
        NotificationManager.shared.delegate = self
        NotificationManager.shared.requestAccess()
    }
    
    // MARK: Lazy initialization
    
    private func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Font.Montserrat.regular(size: 28))
            .lineHeight(34)
        
        let part1 = "Onboarding.NotificationsTitlePart1".localized
            .attributed(with: attrs.textColor(UIColor(red: 1, green: 150 / 255, blue: 51 / 255, alpha: 1)))
        
        let part2 = "Onboarding.NotificationsTitlePart2".localized
            .attributed(with: attrs.textColor(UIColor.white))
        
        let text = NSMutableAttributedString()
        text.append(part1)
        text.append(part2)
        
        let view = UILabel()
        view.attributedText = text
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeFooterLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Font.Montserrat.regular(size: 20))
            .lineHeight(25)
        
        let part1 = "Onboarding.NotificationsFooterPart1".localized
            .attributed(with: attrs.textColor(UIColor(red: 1, green: 150 / 255, blue: 51 / 255, alpha: 1)))
        
        let part2 = "Onboarding.NotificationsFooterPart2".localized
            .attributed(with: attrs.textColor(UIColor.white))
        
        let text = NSMutableAttributedString()
        text.append(part1)
        text.append(part2)
        
        let view = UILabel()
        view.attributedText = text
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    // MARK: Make constraints
    
    private func makeConstraints() {
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 135).isActive = true
        
        footerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35).isActive = true
        footerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35).isActive = true
        footerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -58).isActive = true
    }
}

extension OnboardingNotificationsView: NotificationDelegate {
    func notificationRequestWasEnd(success: Bool) {
        didContinueWithNotificationsToken?()
    }
}
