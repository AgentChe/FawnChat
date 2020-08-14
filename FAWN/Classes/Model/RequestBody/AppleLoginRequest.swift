//
//  AppleLoginRequest.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 28.07.2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import Alamofire

struct AppleLoginRequest: APIRequestBody {
    private let identificator: String
    
    init(identificator: String) {
        self.identificator = identificator
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/auth/apple"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.Backend.apiKey,
            "identificator": identificator
        ]
    }
}
