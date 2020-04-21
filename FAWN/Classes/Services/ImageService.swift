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
    static func upload(image: UIImage) -> Single<String?> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(nil) }
        }
        
        return upload(url: GlobalDefinitions.Backend.domain + "/api/users/add_photo",
                      image: image,
                      parameters: ["_api_key": GlobalDefinitions.Backend.apiKey,
                                   "_user_token": userToken])
            .map { ImageTransformation.imageUrlFromUploadedImageResponse(response: $0) }
    }
}

// MARK: Foundation

extension ImageService {
    fileprivate static func upload(url: String,
                               image: UIImage,
                               imageFieldKey: String = "photo",
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
                                         withName: imageFieldKey,
                                         fileName: String(format: "%@%@", UUID().uuidString, String(Date().timeIntervalSinceNow)),
                                         mimeType: "image/jpg")
                
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
