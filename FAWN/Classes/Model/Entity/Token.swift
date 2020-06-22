//
//  Token.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

struct Token {
    let token: String?
    let userId: Int?
    let isNewUser: Bool
}

extension Token: Model {
    private enum Keys: String, CodingKey {
        case token
        case userId = "user_id"
        case isNewUser = "new"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        token = try? container.decode(String.self, forKey: .token)
        userId = try? container.decode(Int.self, forKey: .userId)
        isNewUser = (try? container.decode(Bool.self, forKey: .isNewUser)) ?? false
    }
}
