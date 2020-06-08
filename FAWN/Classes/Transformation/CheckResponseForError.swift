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
        
        return code < 200 || code > 299
    }
    
    @discardableResult
    static func letThroughError(response: Any) throws -> Any {
        try throwIfError(response: response)
        
        return response
    }
    
    static func throwIfError(response: Any) throws  {
        guard let json = response as? [String: Any] else {
            throw ApiError.serverNotAvailable
        }
        
        if let needPayment = json["_need_payment"] as? Bool, needPayment == true {
            throw PaymentError.needPayment
        }
        
        if let code = json["_code"] as? Int, code < 200 || code > 299 {
            throw ApiError.serverNotAvailable
        }
    }
}
