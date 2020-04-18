//
//  NotificationRequest.swift
//  FAWN
//
//  Created by Алексей Петров on 03/07/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import Foundation
import DatingKit

class NotificationSetKey: APIRequestV1 {
    
    var url: String {
        return "/users/set"
    }
    
    var parameters: [String : Any]
    
    var useToken: Bool {
        return true
    }
    
    init(parameters: [String : Any]) {
        self.parameters = parameters
    }
    
    func parse(data: Data) -> Decodable! {
        do {
            let response: Technical = try JSONDecoder().decode(Technical.self, from: data)
            return response
        } catch let error {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
}

class NotificationToggle: APIRequestV1 {
    
    var url: String {
        return "/users/set"
    }
    
    var parameters: [String : Any]
    
    var useToken: Bool = true
    
    init(onMessages: Bool) {
        parameters = ["notify_on_message" : onMessages]
    }
    
    init(onKnocks: Bool) {
        parameters = ["notify_on_knocks" : onKnocks]
    }
    
    init(onMatch: Bool) {
        parameters = ["notify_on_match" : onMatch]
    }
    
    init(onUsers: Bool) {
        parameters = ["notify_on_users" : onUsers]
    }
    
    init(onMessages: Bool, onMatch: Bool, onUsers: Bool, onKnocks: Bool) {
        parameters = ["notify_on_message" : onMessages,
                      "notify_on_match" : onMatch,
                      "notify_on_users" : onUsers,
                      "notify_on_knocks" : onKnocks]
    }
    
    func parse(data: Data) -> Decodable! {
        do {
            let response: Technical = try JSONDecoder().decode(Technical.self, from: data)
            return response
        } catch let error {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
}


class NotificationGet: APIRequestV1 {
    
    var url: String {
        return "/users/show"
    }
    
    var parameters: [String : Any]
    
    var useToken: Bool = true
    
    init() {
        parameters = [String : Any]()
    }
    
    func parse(data: Data) -> Decodable! {
        do {
            let response: GetUserTogles = try JSONDecoder().decode(GetUserTogles.self, from: data)
            return response
        } catch let error {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
}
