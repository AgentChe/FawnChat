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
    
    init(randomKey: String) {
        self.randomKey = randomKey
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/payments/ping?_api_key=\(GlobalDefinitions.Backend.apiKey)"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "random_string": randomKey
        ]
    }
}
