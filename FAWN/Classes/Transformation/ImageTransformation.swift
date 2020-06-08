//
//  ImageTransformation.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 21/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

final class ImageTransformation {
    typealias UploadedImage = (url: String?, error: String?)
    
    static func imageUrlFromUploadedImageResponse(response: Any) -> UploadedImage {
        guard let json = response as? [String: Any] else {
            return (nil, nil)
        }
        
        if let data = json["_data"] as? [String: Any], let url = data["url"] as? String {
            return (url, nil)
        } else {
            return (nil, json["_msg"] as? String)
        }
    }
    
    static func avatarUrlFromRandomizeResponse(response: Any) -> String? {
        guard let json = response as? [String: Any], let data = json["_data"] as? [String: Any] else {
            return nil
        }
        
        return data["avatar"] as? String
    }
    
    static func imageUrlFromUploadChatImageResponse(response: Any) -> UploadedImage {
        guard let json = response as? [String: Any] else {
            return (nil, nil)
        }
        
        return (json["result"] as? String, nil)
    }
}
