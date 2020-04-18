//
//  CheckResponseForError.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 19/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

final class CheckResponseForError {
    @discardableResult
    static func isError(jsonResponse: Any) throws -> Bool {
        guard let json = jsonResponse as? [String: Any] else {
            throw ApiError.serverNotAvailable
        }
        
        guard let code = json["_code"] as? Int else {
            throw ApiError.serverNotAvailable
        }
        
        return code < 200 && code > 299
    }
}
