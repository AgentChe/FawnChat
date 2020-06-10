//
//  ChatInputPlaceholderTextView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class ChatInputPlaceholderTextView: UITextView {
    private let placeholder = "Chat.Input.Placeholder".localized
    
    private var flag: Int = 1
}

// MARK: UITextViewDelegate

extension ChatInputPlaceholderTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            flag = 1
            
            textView.text = placeholder
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if !text.isEmpty && flag == 1 {
            flag = 0
            
            textView.text = text
        } else {
            return true
        }
        
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if window != nil {
            if flag == 1 {
                selectedTextRange = textRange(from: beginningOfDocument, to: beginningOfDocument)
            }
        }
    }
}
