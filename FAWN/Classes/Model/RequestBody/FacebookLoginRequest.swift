//
//  FacebookLoginRequest.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 13.07.2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import Alamofire

struct FacebookLoginRequest: APIRequestBody {
    private let facebookToken: String
    
    init(facebookToken: String) {
        self.facebookToken = facebookToken
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/auth/facebook_login_token"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "fb_token": facebookToken,
            "_api_key": GlobalDefinitions.Backend.apiKey
        ]
    }
}
