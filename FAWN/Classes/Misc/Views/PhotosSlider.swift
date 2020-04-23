//
//  PhotosSlider.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 23/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import Kingfisher

final class PhotosSlider: UIView {
    struct Constants {
        static let selectedColor = UIColor.white
        static let unselectedColor = UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 1)
        
        static let sliderIndicatorWidth = 20
        static let sliderIndicatorMargin = 4
    }
    
    private lazy var slideIndicators = [UIView]()
    private lazy var slides = [UIImageView]()
    
    private var urls: [URL] = []
    
    private var isConfigured = false
    
    func setup(urls: [URL]) {
        self.urls = urls + urls + urls
        
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !isConfigured && !urls.isEmpty else {
            return
        }
        
        configure()
        
        isConfigured = true
    }
    
    // MARK: Private
    
    private func configure() {
        backgroundColor = .black
        
        let scrollView = makeScrollView()
        scrollView.frame.size = CGSize(width: frame.width, height: frame.height)
        scrollView.frame.origin = CGPoint(x: 0, y: 0)
        scrollView.contentSize = CGSize(width: frame.width * CGFloat(urls.count), height: frame.height)
        addSubview(scrollView)
        
        var sliderIndicatorX = (frame.width - CGFloat(Constants.sliderIndicatorWidth * urls.count + (urls.count - 1) * Constants.sliderIndicatorMargin)) / 2
        
        for (index, url) in urls.enumerated() {
            let slide = makeSlide()
            slide.frame.size = CGSize(width: frame.width, height: frame.height)
            slide.frame.origin = CGPoint(x: frame.width * CGFloat(index), y: 0)
            slide.kf.setImage(with: url)
            slides.append(slide)
            scrollView.addSubview(slide)
            
            let slideIndicator = makeSlideIndicator()
            slideIndicator.frame.size = CGSize(width: Constants.sliderIndicatorWidth, height: 4)
            slideIndicator.frame.origin = CGPoint(x: sliderIndicatorX, y: 16)
            slideIndicator.backgroundColor = index == 0 ? Constants.selectedColor : Constants.unselectedColor
            slideIndicators.append(slideIndicator)
            
            sliderIndicatorX += CGFloat(Constants.sliderIndicatorWidth + Constants.sliderIndicatorMargin)
        }
    }
    
    // MARK: Lazy initialization
    
    private func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false 
        addSubview(view)
        return view
    }
    
    private func makeSlide() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 26
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }
    
    private func makeSlideIndicator() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 2
        addSubview(view)
        return view
    }
}

extension PhotosSlider: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let slideIndex = Int(round(scrollView.contentOffset.x / frame.width))
        
        for (index, slideIndicator) in slideIndicators.enumerated() {
            slideIndicator.backgroundColor = slideIndex == index ? Constants.selectedColor : Constants.unselectedColor
        }
    }
}
