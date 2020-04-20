//
//  SetRequest.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 19/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import Alamofire

struct SetRequest: APIRequestBody {
    private let userToken: String
    private let name: String?
    private let birthdate: String?
    private let storeCountry: String?
    private let version: String?
    private let market: String?
    private let locale: String?
    private let notifyOnMessage: Bool?
    private let notifyOnMatch: Bool?
    private let notifyOnUsers: Bool?
    private let notifyOnKnocks: Bool?
    private let pushNotificationsToken: String?
    private let appUUID: String?
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: Parameters = [
            "_api_key": GlobalDefinitions.Backend.apiKey,
            "_user_token": userToken
        ]
        
        if let name = self.name {
            params["name"] = name
        }
        
        if let birthdate = self.birthdate {
            params["birthdate"] = birthdate
        }
        
        if let storeCountry = self.storeCountry {
            params["store_country"] = storeCountry
        }
        
        if let version = self.version {
            params["version"] = version
        }
        
        if let market = self.market {
            params["market"] = market
        }
        
        if let locale = self.locale {
            params["locale"] = locale
        }
        
        if let notifyOnMessage = self.notifyOnMessage {
            params["notify_on_message"] = notifyOnMessage
        }
        
        if let notifyOnMatch = self.notifyOnMatch {
            params["notify_on_match"] = notifyOnMatch
        }
        
        if let notifyOnUsers = self.notifyOnUsers {
            params["notify_on_users"] = notifyOnUsers
        }
        
        if let notifyOnKnocks = self.notifyOnKnocks {
            params["notify_on_knocks"] = notifyOnKnocks
        }
        
        if let pushNotificationsToken = self.pushNotificationsToken {
            params["notification_key"] = pushNotificationsToken
        }
        
        if let appUUID = self.appUUID {
            params["random_string"] = appUUID
        }
        
        return params
    }
}
