//
//  NotificationResponce.swift
//  FAWN
//
//  Created by Алексей Петров on 03/07/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import Foundation

struct GetUserTogles: Decodable {
    
    var httpCode: Int
    var message: String
    var needPayment: Bool
    var onMessage: Bool
    var onMatch: Bool
    var onUsers: Bool
    var onKnocks: Bool
    
    enum CodingKeys: String, CodingKey {
        case httpCode = "_code"
        case message = "_msg"
        case needPayment = "_need_payment"
        case data = "_data"
        case onMessage = "notify_on_message"
        case onMatch = "notify_on_match"
        case onUsers = "notify_on_users"
        case onKnocks = "notify_on_knocks"
    }
    
    public init(from decoder: Decoder) throws {
        let contanier = try decoder.container(keyedBy: CodingKeys.self)
        httpCode = try contanier.decode(Int.self, forKey: .httpCode)
        message = try contanier.decode(String.self, forKey: .message)
        needPayment = try contanier.decode(Bool.self, forKey: .needPayment)
        let userBox = try contanier.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        onMessage = try userBox.decode(Int.self, forKey: .onMessage).boolValue
        onMatch = try userBox.decode(Int.self, forKey: .onMatch).boolValue
        onUsers = try userBox.decode(Int.self, forKey: .onUsers).boolValue
        onKnocks = try userBox.decode(Int.self, forKey: .onKnocks).boolValue
    }
    
}


extension Int {
    var boolValue: Bool { return self != 0 }
}
