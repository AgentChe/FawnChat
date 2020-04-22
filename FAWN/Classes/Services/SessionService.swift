//
//  SessionService.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import DatingKit

final class SessionService {
    static let shared = SessionService()
    
    private init() {}
    
    private struct Constants {
        static let userTokenKey = "user_token_key"
    }
}

// MARK: Token

extension SessionService {
    var userToken: String? {
        UserDefaults.standard.string(forKey: Constants.userTokenKey)
    }
    
    static func check(token: String) -> Single<Bool> {
        RestAPITransport()
            .callServerApi(requestBody: CheckUserTokenRequest(userToken: token))
            .map { (try? !CheckResponseForError.isError(jsonResponse: $0)) ?? false }
    }
}

// MARK: Create user

extension SessionService {
    static func createUser(with email: String) -> Single<Token?> {
        RestAPITransport()
            .callServerApi(requestBody: CreateUserRequest(email: email))
            .map { TokenTransformation.fromCreateUserResponse($0) }
            .do(onSuccess: { token in
                UserDefaults.standard.set(token?.token, forKey: Constants.userTokenKey)
                CacheTool.shared.saveToken(token: token?.token ?? "")
            })
    }
}

// MARK: Confirm code

extension SessionService {
    static func requireConfirmCode(email: String) -> Single<Bool> {
        RestAPITransport()
            .callServerApi(requestBody: RequireConfirmCodeRequest(email: email))
            .map { (try? !CheckResponseForError.isError(jsonResponse: $0)) ?? false }
    }
    
    static func confirmCode(email: String, code: String) -> Single<Token?> {
        RestAPITransport()
            .callServerApi(requestBody: ConfirmCodeRequest(email: email, code: code))
            .map { TokenTransformation.fromCreateUserResponse($0) }
            .do(onSuccess: { token in
                UserDefaults.standard.set(token?.token, forKey: Constants.userTokenKey)
                CacheTool.shared.saveToken(token: token?.token ?? "")
            })
    }
}
