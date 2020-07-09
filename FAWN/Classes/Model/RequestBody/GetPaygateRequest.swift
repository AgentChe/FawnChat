//
//  GetPaygateRequest.swift
//  PersonalVPN
//
//  Created by Andrey Chernyshev on 27.06.2020.
//  Copyright © 2020 org. All rights reserved.
//

import Alamofire

struct GetPaygateRequest: APIRequestBody {
    private let userToken: String?
    private let version: String
    private let appInstallKey: String
    
    init(userToken: String?, version: String, appInstallKey: String) {
        self.userToken = userToken
        self.version = version
        self.appInstallKey = appInstallKey
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/payments/paygate2"
    }
    
    var parameters: Alamofire.Parameters? {
        var params: Parameters = [
            "_api_key": GlobalDefinitions.Backend.apiKey,
            "version": version,
            "random_string": appInstallKey
        ]
        
        if let token = userToken {
            params["_user_token"] = token
        }
        
        return params
    }
    
    var method: Alamofire.HTTPMethod {
        .post
    }
}
