//
//  IDFAService.swift
//  Horo
//
//  Created by Andrey Chernyshev on 28/10/2019.
//  Copyright © 2019 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import AdSupport
import iAd

final class IDFAService {
    static let shared = IDFAService()
    
    private let appRegisteredKey = "app_registered_key"
    
    private init() {}
    
    func configure() {
        appRegister()
        setIDFAWhenUserTokenUpdated()
        setAttributionsWhenUserTokenUpdated()
    }
    
    func getIDFA() -> String {
        ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    func isAdvertisingTrackingEnabled() -> Bool {
        ASIdentifierManager.shared().isAdvertisingTrackingEnabled
    }
    
    func getAppKey() -> String {
        let udKey = "app_random_key"
        
        if let randomKey = UserDefaults.standard.string(forKey: udKey) {
            return randomKey
        } else {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let randomKey = String((0..<128).map{ _ in letters.randomElement()! })
            UserDefaults.standard.set(randomKey, forKey: udKey)
            return randomKey
        }
    }
}

// MARK: Private

private extension IDFAService {
    func appRegister() {
        if UserDefaults.standard.bool(forKey: appRegisteredKey) {
            return
        }
        
        let idfa = getIDFA()
        let randomKey = getAppKey()
        let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        
        SearchAttributionsDetails.request { attributionsDetails in
            let request = AppRegisterRequest(idfa: idfa,
                                             randomKey: randomKey,
                                             version: version,
                                             attributions: attributionsDetails)
            
            _ = RestAPITransport().callServerApi(requestBody: request)
                .subscribe(onSuccess: { _ in
                    UserDefaults.standard.set(true, forKey: self.appRegisteredKey)
                })
        }
    }
    
    func setIDFAWhenUserTokenUpdated() {
        _ = Observable
            .merge(AppStateProxy.UserTokenProxy.didUpdatedUserToken.asObservable(),
                   AppStateProxy.UserTokenProxy.userTokenCheckedWithSuccessResult.asObservable())
            .flatMapLatest { userToken -> Single<Any> in
                guard let userToken = SessionService.shared.userToken else {
                    return .never()
                }
                
                let request = SetRequest(userToken: userToken,
                                         storeCountry: Locale.current.currencyCode ?? "",
                                         version: UIDevice.version ?? "1",
                                         locale: UIDevice.deviceLanguageCode ?? "en",
                                         appUUID:  self.getAppKey(),
                                         idfa: self.getIDFA(),
                                         isAdvertisingTrackingEnabled: self.isAdvertisingTrackingEnabled(),
                                         timezone: TimeZone.current.identifier)
                
                return RestAPITransport()
                    .callServerApi(requestBody: request)
                    .catchError { _ in .never() }
            }
            .subscribe()
    }
    
    func setAttributionsWhenUserTokenUpdated() {
        _ = Observable
            .merge(AppStateProxy.UserTokenProxy.didUpdatedUserToken.asObservable(),
                   AppStateProxy.UserTokenProxy.userTokenCheckedWithSuccessResult.asObservable())
            .flatMapLatest {
                Observable<[String: Any]>.create { observer in
                    SearchAttributionsDetails.request { attributionsDetails in
                        observer.onNext(attributionsDetails)
                        observer.onCompleted()
                    }
                    
                    return Disposables.create()
                }
            }
            .flatMapLatest { attributionsDetails -> Single<Any> in
                guard let userToken = SessionService.shared.userToken else {
                    return .never()
                }
                        
                let request = AddSearchAdsInfoRequest(userToken: userToken, attributions: attributionsDetails)
                
                return RestAPITransport()
                    .callServerApi(requestBody: request)
                    .catchError { _ in .never() }
            }
            .subscribe()
    }
}
