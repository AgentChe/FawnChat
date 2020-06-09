//
//  PaygatePingRequest.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 09/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import Alamofire

struct PaygatePingRequest: APIRequestBody {
    private let randomKey: String
    private let userToken: String
    
    init(randomKey: String, userToken: String) {
        self.randomKey = randomKey
        self.userToken = userToken
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/payments/ping"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.Backend.apiKey,
            "_user_token": userToken,
            "random_string": randomKey
        ]
    }
}
