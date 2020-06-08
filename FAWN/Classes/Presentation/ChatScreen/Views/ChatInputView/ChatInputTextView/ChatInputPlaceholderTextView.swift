//
//  ChatInputPlaceholderTextView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class ChatInputPlaceholderTextView: UITextView {
    private lazy var placeholder = "Chat.Input.Placeholder".localized
}

// MARK: UITextViewDelegate

extension ChatInputPlaceholderTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        
        if currentText.isEmpty {
            textView.text = placeholder
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        } else if !currentText.isEmpty && textView.text == placeholder {
            textView.text = nil
        }
        
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.text == placeholder {
            let selectRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            if textView.selectedTextRange != selectRange {
                textView.selectedTextRange = selectRange
            }
        }
    }
}
