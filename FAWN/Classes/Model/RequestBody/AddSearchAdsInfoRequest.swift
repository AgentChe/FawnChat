//
//  AddSearchAdsInfoRequest.swift
//  Horo
//
//  Created by Andrey Chernyshev on 17/12/2019.
//  Copyright © 2019 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct AddSearchAdsInfoRequest: APIRequestBody {
    private let userToken: String
    private let attributions: [String: Any]
    
    init(userToken: String, attributions: [String: Any]) {
        self.userToken = userToken
        self.attributions = attributions
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/users/add_search_ads_info?_api_key=\(GlobalDefinitions.Backend.apiKey)&_user_token=\(userToken)"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        attributions
    }
}
