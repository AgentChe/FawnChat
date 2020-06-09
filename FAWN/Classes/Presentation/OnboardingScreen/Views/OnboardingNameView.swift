//
//  OnboardingNameView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 19/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class OnboardingNameView: UIView {
    var didContinueWithName: ((String) -> Void)?
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var textField = makeTextField()
    private lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        textField.becomeFirstResponder()
    }
    
    // MARK: Lazy initialization
    
    private func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.Merriweather.black(size: 28)
        view.textColor = .white
        view.numberOfLines = 1
        view.textAlignment = .center
        view.text = "Onboarding.NameTitle".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeTextField() -> UITextField {
        let view = UITextField()
        view.backgroundColor = UIColor(red: 25 / 255, green: 25 / 255, blue: 25 / 255, alpha: 1)
        view.layer.cornerRadius = 24
        view.textColor = .white
        view.font = Font.Montserrat.regular(size: 17)
        view.autocapitalizationType = .sentences
        view.leftViewMode = .always
        view.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 12, height: 17)))
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeButton() -> UIButton {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        view.titleLabel?.font = Font.Montserrat.semibold(size: 17)
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Onboarding.NameButton".localized, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEnabled = false
        view.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    // MARK: Make constraints
    
    private func makeConstraints() {
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 96).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        
        textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36).isActive = true
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    // MARK: Private
    
    @objc
    private func textFieldDidChange(textField: UITextField) {
        button.isEnabled = textField.text?.isEmpty == false
    }
    
    @objc
    private func buttonTapped(sender: Any) {
        complete(with: textField.text ?? "")
    }
    
    private func complete(with text: String) {
        textField.resignFirstResponder()
        didContinueWithName?(text)
    }
}

extension OnboardingNameView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.text?.isEmpty == false else {
            return false
        }
        
        complete(with: textField.text ?? "")
        
        return true
    }
}
