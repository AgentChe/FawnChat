//
//  AmplitudeAnalytics.swift
//  Horo
//
//  Created by Andrey Chernyshev on 01/04/2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Amplitude_iOS
import iAd
import RxSwift

final class AmplitudeAnalytics {
    static let shared = AmplitudeAnalytics()
    
    private init() {}
    
    func configure() {
        Amplitude.instance()?.initializeApiKey(GlobalDefinitions.Analytics.amplitudeAPIKey)
        
        setInitialProperties()
        syncedUserPropertiesWithUserId()
    }
    
    func log(with event: AnalyticEvent) {
        Amplitude.instance()?.logEvent(event.name, withEventProperties: event.params)
    }
}

// MARK: Private

private extension AmplitudeAnalytics {
    func setInitialProperties() {
        guard !UserDefaults.standard.bool(forKey: "amplitude_initial_properties_is_set") else {
            return
        }
        
        set(userAttributes: ["app": GlobalDefinitions.Analytics.appNameForAmplitude])
        
        SearchAttributionsDetails.request { attributionsDetails in
            var userAttributes: [String: Any] = [
                "app": GlobalDefinitions.Analytics.appNameForAmplitude,
                "IDFA": IDFAService.shared.getIDFA(),
                "ad_tracking": IDFAService.shared.isAdvertisingTrackingEnabled() ? "idfa enabled" : "idfa disabled"
            ]
            
            self.log(with: .firstLaunch)
            
            if !SearchAttributionsDetails.isTest(attributionsDetails: attributionsDetails) {
                userAttributes.merge(dict: attributionsDetails)
                
                self.log(with: .searchAdsInstall)
            }
            
            self.set(userAttributes: userAttributes)
            
            UserDefaults.standard.set(true, forKey: "amplitude_initial_properties_is_set")
        }
    }
    
    func syncedUserPropertiesWithUserId() {
            guard !UserDefaults.standard.bool(forKey: "amplitude_initial_properties_is_synced") else {
                return
            }
            
            _ = Observable
                .merge(AppStateProxy.UserTokenProxy.didUpdatedUserToken.asObservable(),
                       AppStateProxy.UserTokenProxy.userTokenCheckedWithSuccessResult.asObservable())
                .subscribe(onNext: { properties in
                    if let userId = SessionService.shared.userId {
                        self.set(userId: String(format: "%@_%i", GlobalDefinitions.Analytics.appNameForAmplitude, userId))
                    }
                    
                    self.log(with: .userIdSynced)
                    
                    UserDefaults.standard.set(true, forKey: "amplitude_initial_properties_is_synced")
                })
        }
    
    func set(userId: String) {
        Amplitude.instance()?.setUserId(userId)
    }
    
    func set(userAttributes: [String: Any]) {
        Amplitude.instance()?.setUserProperties(userAttributes)
    }
}
