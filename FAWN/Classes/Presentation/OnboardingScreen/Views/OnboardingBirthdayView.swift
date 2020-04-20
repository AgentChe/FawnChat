//
//  OnboardingBirthdayView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 19/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class OnboardingBirthdayView: UIView {
    var didContinueWithData: ((Date) -> Void)?
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subTitleLabel = makeSubTitleLabel()
    private lazy var datePicker = makeDatePicker()
    private lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lazy initialization
    
    private func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.Merriweather.black(size: 28)
        view.textColor = .white
        view.numberOfLines = 1
        view.textAlignment = .center
        view.text = "Onboarding.BirthdayTitle".localized
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
        view.text = "Onboarding.BirthdaySubTitle".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeDatePicker() -> UIDatePicker {
        let view = UIDatePicker()
        view.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        view.minimumDate = Calendar.current.date(byAdding: .year, value: -80, to: Date())
        view.setValue(UIColor.white, forKeyPath: "textColor")
        view.datePickerMode = .countDownTimer
        view.datePickerMode = .date
        view.timeZone = NSTimeZone.local
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeButton() -> UIButton {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        view.titleLabel?.font = Font.Montserrat.semibold(size: 17)
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Onboarding.BirthdayButton".localized, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    // MARK: Make constraints
    
    private func makeConstraints() {
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: SizeUtils.value(largeDevice: 106, smallDevice: 106)).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        
        datePicker.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 40).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        
        button.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 40).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    // MARK: Private
    
    @objc
    private func buttonTapped(sender: Any) {
        didContinueWithData?(datePicker.date)
    }
}
