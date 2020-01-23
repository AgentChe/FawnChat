//
//  AppManager.swift
//  FAWN
//
//  Created by Алексей Петров on 04.11.2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import Foundation
import DatingKit
import iAd
import Amplitude_iOS


class AppManager {

    static let shared: AppManager = AppManager()
    
    var showPaygate: Bool = false
    
    func setLocale() {
//        DatingKit.set(locale: Locale.current.languageCode!) { (status) in
//            
//        }
    }
    
    func configurate(_ completion: @escaping() -> Void) {
        
        let timing: Settings.Timings = Settings.Timings(chatsUpdatingTime: 3.0,
                                                        chatUpdatingTimer: 2.0,
                                                        searchTime: 2.0,
                                                        matchChekTime: 2.0,
                                                        searchStopTime: 100)
        Settings.currentBundle = Bundle.main.buildVersionNumber
               
        Settings.currentLocale = Locale.current.languageCode!
        
        DatingKit.config(timings: timing) { (status) in
            if status == .succses {
                self.showPaygate = Settings.showUponRegistrationMale
                _ = 0
            }
            completion()
        }
       
    }
    
    func confirmADV() {
//        DatingKit.updateADV()
    }
    
    func setVercion() {
        DatingKit.isLogined { (isLogined) in
            if isLogined {
//                guard let build: Int = Int(Bundle.main.buildVersionNumber) else { return }

            }
        }
    }
    
    func ads() {
        DatingKit.setADV { (ads) in
            if ads != nil {
                Amplitude.instance()?.log(event: .searchAd)
                Amplitude.instance()?.setUserProperties(ads)
            }
        }
       
    }

}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String {
        
        guard let bundleString: String = infoDictionary?["CFBundleVersion"] as? String else {
            return ""
        }
        
        return bundleString
        
    }
}

class APSRequest: APIRequestV1 {
    var url: String {
        return "/users/add_search_ads_info"
    }
    
    var parameters: [String : Any]
    
    var useToken: Bool {
        return true
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
    
    /*
     clicked_ad_at — дата и время клика по рекламному объявлению, формат Y-m-d H:i:s (например 2017-01-31 23:26:59), необязательно
     downloaded_app_at — дата и время скачивания приложения, формат Y-m-d H:i:s (например 2017-01-31 23:26:59), необязательно
     company_name — название организации, от имени которой была запущена реклама, необязательно
     campaign_id — id рекламной кампании, integer
     campaign_name — название рекламной кампании, строка
     ad_group_id — id группы рекламных объявлений, integer, необязательно
     ad_group_name — название группы рекламных объявлений, строка, необязательно
     keyword — ключевое слово, по которому пользователь увидел объявление, строка, необязательно
     */
    
    init (ads: [String : Any]) {
        parameters = ads
//        parameters = ["clicked_ad_at" : ads["iad-click-date" ] as! String,
//                      "downloaded_app_at" : ads["iad-purchase-date" ] as! String,
//                      "campaign_id" : ads["iad-campaign-id"] as! String,
//                      "campaign_name" : ads["iad-campaign-name"] as! String,
//                      "ad_group_id" : ads["iad-adgroup-id"] as! String,
//                      "ad_group_name" : ads["iad-adgroup-name"] as! String,
//                      "keyword" : ads["iad-keyword"]  as! String]
    }
    
    
}



