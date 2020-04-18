//
//  TokenTransformation.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

final class TokenTransformation {
    static func fromCreateUserResponse(_ response: Any) -> Token? {
        guard let json = response as? [String: Any], let data = json["_data"] as? [String: Any] else {
            return nil
        }
        
        return Token.parseFromDictionary(any: data)
    }
}
