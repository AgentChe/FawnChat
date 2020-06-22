//
//  GetChatsRequest.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import Alamofire

struct GetChatsRequest: APIRequestBody {
    private let userToken: String
    
    init(userToken: String) {
        self.userToken = userToken
    }
    
    var url: String {
        GlobalDefinitions.ChatService.restDomain + "/api/v1/rooms/getList"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "app_key": GlobalDefinitions.ChatService.appKey,
            "token": userToken
        ]
    }
}
