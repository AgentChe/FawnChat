//
//  ConfirmCodeRequest.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 19/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import Alamofire

struct ConfirmCodeRequest: APIRequestBody {
    private let email: String
    private let code: String
    
    init(email: String, code: String) {
        self.email = email
        self.code = code
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/users/verify_code"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "email": email,
            "code": code,
            "_api_key": GlobalDefinitions.Backend.apiKey
        ]
    }
}
