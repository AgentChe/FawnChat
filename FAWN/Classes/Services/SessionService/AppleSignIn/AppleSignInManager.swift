//
//  AppleSignInManager.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 28.07.2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import AuthenticationServices
import RxSwift
import RxCocoa

final class AppleSignInManager: NSObject {
    private let trigger = PublishRelay<AppleSignInCredentials?>()
    
    @available(iOS 13.0, *)
    func signIn() -> Single<AppleSignInCredentials?> {
        Single
            .zip(request(), trigger.take(1).asSingle()) { $1 }
    }
}

// MARK: ASAuthorizationControllerDelegate

extension AppleSignInManager: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let code = appleIDCredential.authorizationCode,
            let codeStr = String(data: code, encoding: .utf8)
        else {
            trigger.accept(nil)
            
            return
        }
        
        let credentials = AppleSignInCredentials(identifier: codeStr,
                                                 firstName: appleIDCredential.fullName?.givenName ?? "",
                                                 lastName: appleIDCredential.fullName?.familyName ?? "",
                                                 email: appleIDCredential.email ?? "")
        
        trigger.accept(credentials)
    }

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        trigger.accept(nil)
    }
}

// MARK: Private

private extension AppleSignInManager {
    @available(iOS 13.0, *)
    func request() -> Single<Void> {
        Single.deferred {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
            
            return .just(Void())
        }
    }
}
