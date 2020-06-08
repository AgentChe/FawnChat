//
//  ImageService.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 21/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

final class ImageService {
    static func upload(image: UIImage) -> Single<ImageTransformation.UploadedImage> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just((nil, nil)) }
        }
        
        return upload(url: GlobalDefinitions.Backend.domain + "/api/users/add_photo",
                      image: image,
                      fileName: String(format: "%@%@", UUID().uuidString, String(Date().timeIntervalSinceNow)),
                      parameters: ["_api_key": GlobalDefinitions.Backend.apiKey,
                                   "_user_token": userToken])
            .map { ImageTransformation.imageUrlFromUploadedImageResponse(response: $0) }
    }
    
    static func upload(chatImage: UIImage) -> Single<ImageTransformation.UploadedImage> {
        upload(url: GlobalDefinitions.ChatService.restDomain + "/api/v1/data/uploadFile",
               image: chatImage,
               mimeType: "image/jpeg",
               name: "file",
               fileName: String(format: "%@%@.jpeg", UUID().uuidString, String(Date().timeIntervalSinceNow)),
               parameters: ["app_key": GlobalDefinitions.ChatService.appKey])
        .map { ImageTransformation.imageUrlFromUploadChatImageResponse(response: $0) }
    }
}

// MARK: Foundation

extension ImageService {
    fileprivate static func upload(url: String,
                               image: UIImage,
                               mimeType: String = "image/jpg",
                               name: String = "photo",
                               fileName: String,
                               parameters: [String: String] = [:],
                               progress: ((Double) -> Void)? = nil) -> Single<Any> {
        Single<Any>.create { event in
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                event(.error(ApiError.serverNotAvailable))
                return Disposables.create()
            }
            
            var uploadRequest: UploadRequest?
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData,
                                         withName: name,
                                         fileName: fileName,
                                         mimeType: mimeType)
                
                for (key, value) in parameters {
                    if let data = value.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            }, to: url) { result in
                switch result {
                case .success(let request, _, _):
                    uploadRequest = request
                    
                    request.uploadProgress { value in
                        progress?(value.fractionCompleted)
                    }
                    
                    request.responseJSON { response  in
                        if let result = response.result.value {
                            event(.success(result))
                        } else {
                            event(.error(ApiError.serverNotAvailable))
                        }
                    }
                case .failure(_):
                    event(.error(ApiError.serverNotAvailable))
                }
            }
            
            return Disposables.create {
                uploadRequest?.cancel()
            }
        }
    }
}
