//
//  NotificationSetKey.swift
//  FAWN
//
//  Created by Алексей Петров on 03/07/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import Foundation
import DatingKit

class NotificationSetKey: APIRequest {
    
    var url: String {
        return "/notifications/set_key"
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
