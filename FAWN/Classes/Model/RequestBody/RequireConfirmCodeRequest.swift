//
//  GenerateConfirmCodeRequest.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 19/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import Alamofire

struct RequireConfirmCodeRequest: APIRequestBody {
    private let email: String
    
    init(email: String) {
        self.email = email
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/users/generate_code"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "email": email,
            "_api_key": GlobalDefinitions.Backend.apiKey
        ]
    }
}
