//
//  ImageTransformation.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 21/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

final class ImageTransformation {
    static func imageUrlFromUploadedImageResponse(response: Any) -> String? {
        guard let json = response as? [String: Any], let data = json["_data"] as? [String: Any] else {
            return nil
        }
        
        return data["url"] as? String
    }
    
    static func avatarUrlFromRandomizeResponse(response: Any) -> String? {
        guard let json = response as? [String: Any], let data = json["_data"] as? [String: Any] else {
            return nil
        }
        
        return data["avatar"] as? String
    }
}
