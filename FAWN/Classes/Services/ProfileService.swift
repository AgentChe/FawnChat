//
//  ProfileService.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift

final class ProfileService {}

// MARK: Profile

extension ProfileService {
    static func fillProfile(name: String, birthdate: Date) -> Single<Bool> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(false) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: SetRequest(userToken: userToken,
                                                   name: name,
                                                   birthdate: birthdate.yearMonthDay))
            .map { (try? !CheckResponseForError.isError(jsonResponse: $0)) ?? false }
    }
    
    static func randomizeAvatar() -> Single<String?> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(nil) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: RandomizeAvatarRequest(userToken: userToken))
            .map { ImageTransformation.avatarUrlFromRandomizeResponse(response: $0) }
    }
}
