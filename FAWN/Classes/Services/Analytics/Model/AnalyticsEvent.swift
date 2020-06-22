//
//  AnalyticsEvent.swift
//  Horo
//
//  Created by Andrey Chernyshev on 01/04/2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

enum AnalyticEvent {
    // MARK: Authorization
    case loginScr
    case loginTap(String)
    case emailScr
    case emailTap
    case emailError
    case codeScr
    case codeTap(String)
    case codeError
    case codeSuccess
    case onboardingScr(Int)
    case onboardingTap(Int)
    case avatarScr
    case avatarTap(String)
    
    // MARK: Search
    case searchScr
    
    // MARK: Chats
    case chatListScr
    case chatListTap(String)
    
    // MARK: Chat
    case chatScr
    
    // MARK: Paygate
    case paygateScr
    case trialScr
    
    // MARK: Analytics
    case searchAdsInstall
    case firstLaunch
    case userIdSynced
}

extension AnalyticEvent {
    var name: String {
        switch self {
        case .loginScr:
            return "Login Scr"
        case .loginTap:
            return "Login Tap"
        case .emailScr:
            return "Email Scr"
        case .emailTap:
            return "Email Tap"
        case .emailError:
            return "Email Error"
        case .codeScr:
            return "Code Scr"
        case .codeTap:
            return "Code Tap"
        case .codeError:
            return "Code Error"
        case .codeSuccess:
            return "Code Success"
        case .onboardingScr:
            return "Onboarding Scr"
        case .onboardingTap:
            return "Onboarding Tap"
        case .avatarScr:
            return "Avatar Scr"
        case .avatarTap:
            return "Avatar Tap"
            
        case .searchScr:
            return "Search Scr"
            
        case .chatListScr:
            return "Chat List Scr"
        case .chatListTap:
            return "Chat List Tap"
            
        case .chatScr:
            return "Chat Scr"
            
        case .paygateScr:
            return "Paygate Scr"
        case .trialScr:
            return "Trial Scr"
            
        case .searchAdsInstall:
            return "Search Ads Install"
        case .firstLaunch:
            return "First Launch"
        case .userIdSynced:
            return "UserIDSynced"
        }
    }
    
    var params: [AnyHashable: Any]? {
        var result: [AnyHashable: Any] = [
            "app": GlobalDefinitions.Analytics.appNameForAmplitude
        ]
        
        switch self {
        case .loginTap(let what):
            result["what"] = what
        case .codeTap(let what):
            result["what"] = what
        case .onboardingScr(let step):
            result["step"] = step
        case .onboardingTap(let step):
            result["step"] = step
        case .avatarTap(let what):
            result["what"] = what
        case .chatListTap(let what):
            result["what"] = what
        default:
            break
        }
        
        return result 
    }
}
