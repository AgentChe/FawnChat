//
//  ProposedInterlocutorCollectionCell.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import Kingfisher

final class ProposedInterlocutorCollectionCell: UICollectionViewCell {
    var likeTapped: (() -> Void)?
    var dislikeTapped: (() -> Void)?
    var reportTapped: (() -> Void)?
    
    private lazy var photosSlider = makePhotoSlider()
    private lazy var reportButton = makeReportButton()
    private lazy var avatarImageView = makeAvatarImageView()
    private lazy var infoLabel = makeInfoLabel()
    private lazy var dislikeButton = makeDislikeButton()
    private lazy var likeButton = makeLikeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(proposedInterlocutor: ProposedInterlocutor) {
        avatarImageView.kf.cancelDownloadTask()
        avatarImageView.kf.setImage(with: proposedInterlocutor.interlocutorAvatarUrl)
        
        infoLabel.attributedText = String(format: "Search.HowAbout".localized,
                                          proposedInterlocutor.interlocutorFullName,
                                          proposedInterlocutor.age)
            .attributed(with: makeInfoAttributes())
        
        photosSlider.setup(urls: proposedInterlocutor.interlocutorPhotoUrls)
    }
    
    // MARK: Lazy initialization
    
    private func makePhotoSlider() -> PhotosSlider {
        let view = PhotosSlider()
        view.backgroundColor = .red
        view.layer.cornerRadius = 26
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    private func makeReportButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Shared.WhiteFlag"), for: .normal)
        view.addTarget(self, action: #selector(reportTapped(sender:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    private func makeAvatarImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = SizeUtils.value(largeDevice: 24, smallDevice: 22)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    private func makeInfoLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    private func makeInfoAttributes() -> TextAttributes {
        TextAttributes()
            .textColor(.white)
            .font(Font.Merriweather.regular(size: SizeUtils.value(largeDevice: 36, smallDevice: 34)))
            .lineHeight(SizeUtils.value(largeDevice: 43, smallDevice: 41))
    }
    
    private func makeDislikeButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
        view.setImage(UIImage(named: "close_menu_btn"), for: .normal)
        view.layer.cornerRadius = 26
        view.layer.maskedCorners = [.layerMinXMaxYCorner]
        view.addTarget(self, action: #selector(dislikeTapped(sender:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    private func makeLikeButton() -> UIButton {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "button_background_rectangle"), for: .normal)
        view.titleLabel?.font = Font.Montserrat.semibold(size: 17)
        view.setTitle("Search.Sure".localized, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.clipsToBounds = true
        view.layer.masksToBounds = true 
        view.layer.cornerRadius = 26
        view.layer.maskedCorners = [.layerMaxXMaxYCorner]
        view.addTarget(self, action: #selector(likeTapped(sender:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    // MARK: Make constraints
    
    private func makeConstraints() {
        NSLayoutConstraint.activate ([
            photosSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photosSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photosSlider.topAnchor.constraint(equalTo: contentView.topAnchor),
            photosSlider.bottomAnchor.constraint(equalTo: dislikeButton.topAnchor),
            
            reportButton.widthAnchor.constraint(equalToConstant: SizeUtils.value(largeDevice: 32, smallDevice: 28)),
            reportButton.heightAnchor.constraint(equalToConstant: SizeUtils.value(largeDevice: 32, smallDevice: 28)),
            reportButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SizeUtils.value(largeDevice: 20, smallDevice: 18)),
            reportButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: SizeUtils.value(largeDevice: -20, smallDevice: -18)),

            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            avatarImageView.widthAnchor.constraint(equalToConstant: SizeUtils.value(largeDevice: 48, smallDevice: 44)),
            avatarImageView.heightAnchor.constraint(equalToConstant:  SizeUtils.value(largeDevice: 48, smallDevice: 44)),
            avatarImageView.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -16),

            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            infoLabel.bottomAnchor.constraint(equalTo: dislikeButton.topAnchor, constant: -24),

            dislikeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dislikeButton.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor),
            dislikeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dislikeButton.widthAnchor.constraint(equalTo: likeButton.widthAnchor),
            dislikeButton.heightAnchor.constraint(equalToConstant: SizeUtils.value(largeDevice: 87, smallDevice: 72)),

            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: SizeUtils.value(largeDevice: 87, smallDevice: 72))
        ])
    }
    
    // MARK: Private
    
    @objc
    private func likeTapped(sender: Any) {
        likeTapped?()
    }
    
    @objc
    private func dislikeTapped(sender: Any) {
        dislikeTapped?()
    }
    
    @objc
    private func reportTapped(sender: Any) {
        reportTapped?()
    }
}
