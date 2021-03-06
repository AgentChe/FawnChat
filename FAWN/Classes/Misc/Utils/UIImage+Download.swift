//
//  UIImage+Download.swift
//  FAWN
//
//  Created by Алексей Петров on 04.11.2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func downloaded(from url: URL, complation: @escaping() -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                complation()
                return
            }
            DispatchQueue.main.async() {
                self.image = image
                complation()
            }
            }.resume()
    }
    
    func downloaded(from link: String, complation: @escaping() -> Void) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url) {
            complation()
        }
    }
    
}

extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithLineFeed)
    }
    
    func ConvertImageToBase64String() -> String {
        return self.jpegData(compressionQuality: 0.4)?.base64EncodedString() ?? ""
    }
}
