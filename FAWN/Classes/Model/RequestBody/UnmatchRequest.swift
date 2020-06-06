//
//  UnmatchRequest.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import Alamofire

struct UnmatchRequest: APIRequestBody {
    private let userToken: String
    private let chatId: String
    
    init(userToken: String, chatId: String) {
        self.userToken = userToken
        self.chatId = chatId
    }
    
    var url: String {
        GlobalDefinitions.ChatService.restDomain + "/api/v1/rooms/unmatch"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "app_key": GlobalDefinitions.ChatService.appKey,
            "token": userToken,
            "room": chatId
        ]
    }
}

