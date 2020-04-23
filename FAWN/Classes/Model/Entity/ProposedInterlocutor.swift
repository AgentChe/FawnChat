//
//  ProposedInterlocutor.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import Foundation.NSURL

struct ProposedInterlocutor {
    let id: Int
    let interlocutorFullName: String
    let interlocutorAvatarUrl: URL?
    let interlocutorPhotoUrls: [URL]
    let age: Int
}

extension ProposedInterlocutor: Model {
    private enum Keys: String, CodingKey {
        case id
        case name
        case avatarUrl = "avatar"
        case photos = "photos"
        case age
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        interlocutorFullName = try container.decode(String.self, forKey: .name)
        
        age = try container.decode(Int.self, forKey: .age)
        
        let avatarPath = try? container.decode(String.self, forKey: .avatarUrl)
        interlocutorAvatarUrl = URL(string: avatarPath ?? "")
        
        let photosPaths = (try? container.decode([String].self, forKey: .photos)) ?? []
        interlocutorPhotoUrls = photosPaths.compactMap { URL(string: $0) }
    }
    
    func encode(to encoder: Encoder) throws {}
}
