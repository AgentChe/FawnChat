//
//  ProposedInterlocutorTransformation.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

final class ProposedInterlocutorTransformation {
    static func from(response: Any) -> [ProposedInterlocutor] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [[String: Any]]
        else {
            return []
        }
        
        return data.compactMap { ProposedInterlocutor.parseFromDictionary(any: $0) }
    }
}
