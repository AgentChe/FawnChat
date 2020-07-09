//
//  PaymentValidateRequest.swift
//  SleepWell
//
//  Created by Andrey Chernyshev on 25/10/2019.
//  Copyright © 2019 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct PurchaseValidateRequest: APIRequestBody {
    private let receipt: String
    private let userToken: String?
    private let version: String?
    
    init(receipt: String, userToken: String?, version: String?) {
        self.receipt = receipt
        self.userToken = userToken
        self.version = version
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/payments/validate_receipt"
    }
    
    var parameters: Parameters? {
        var params = [
            "receipt": receipt,
            "version": version ?? "1",
            "_api_key": GlobalDefinitions.Backend.apiKey
        ]
        
        if let userToken = userToken {
            params["_user_token"] = userToken
        }
        
        return params
    }
}
