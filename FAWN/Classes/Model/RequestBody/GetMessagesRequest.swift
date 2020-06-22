//
//  GetMessagesRequest.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import Alamofire

struct GetMessagesRequest: APIRequestBody {
    private let userToken: String
    private let chatId: String
    private let page: Int
    
    init(userToken: String, chatId: String, page: Int) {
        self.userToken = userToken
        self.chatId = chatId
        self.page = page
    }
    
    var url: String {
        GlobalDefinitions.ChatService.restDomain + "/api/v1/rooms/getRoom"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "app_key": GlobalDefinitions.ChatService.appKey,
            "token": userToken,
            "room": chatId,
            "page": page
        ]
    }
}

