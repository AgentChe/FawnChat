//
//  User+Extention.swift
//  FAWN
//
//  Created by Алексей Петров on 28/07/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import Foundation
import DatingKit

//class SetLocale: APIRequest {
//    var url: String {
//        return "/users/set_locale"
//    }
//    
//    var parameters: [String : Any]
//    
//    var useToken: Bool {
//        return true
//    }
//    
//    init(locale: String) {
//        parameters = ["locale" : locale]
//    }
//    
//    func parse(data: Data) -> Decodable! {
//        do {
//            let response: Technical = try JSONDecoder().decode(Technical.self, from: data)
//            return response
//        } catch let error {
//            debugPrint(error.localizedDescription)
//            return nil
//        }
//    }
//    
//    
//}
//
//class SetVersion: APIRequest {
//    
//    var url: String {
//        return "/users/set_version"
//    }
//    
//    var parameters: [String : Any]
//    
//    var useToken: Bool {
//        return true
//    }
//    
//    init(version: String) {
//        parameters = ["version" : version]
//    }
//    
//    func parse(data: Data) -> Decodable! {
//        do {
//            let response: Technical = try JSONDecoder().decode(Technical.self, from: data)
//            return response
//        } catch let error {
//            debugPrint(error.localizedDescription)
//            return nil
//        }
//    }
//    
//    
//}
//
//extension User {
//    
//    func setLocale() {
//        guard let locale: String = Locale.current.languageCode else { return }
//        let request: SetLocale = SetLocale(locale: locale)
//        RequestManager.shared.requset(request) { (resukt) in
//            var i = 0
//        }
//    }
//    
//    func setVersion() {
//        guard let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
//        let request: SetVersion = SetVersion(version: version)
//        RequestManager.shared.requset(request) { (result) in
//
//        }
//    }
//}

