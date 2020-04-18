//
//  UIViewExtension.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

extension Reactive where Base: UIView {
    var keyboardHeight: Observable<CGFloat> {
        Observable
            .from([
                NotificationCenter.default.rx
                    .notification(UIApplication.keyboardWillShowNotification)
                    .map { notification -> CGFloat in
                        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                    },
                
                NotificationCenter.default.rx
                    .notification(UIApplication.keyboardWillHideNotification)
                    .map { notification -> CGFloat in
                        0
                    }
            ])
            .merge()
            .distinctUntilChanged()
    }
}
