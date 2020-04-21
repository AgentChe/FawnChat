//
//  ProfileService.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift

final class ProfileService {
    static func randomizeAvatar() -> Single<String?> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(nil) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: RandomizeAvatarRequest(userToken: userToken))
            .map { ImageTransformation.avatarUrlFromRandomizeResponse(response: $0) } 
    }
}
