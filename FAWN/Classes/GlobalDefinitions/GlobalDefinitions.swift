//
//  GlobalDefinitions.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

final class GlobalDefinitions {
    struct ChatService {
        static let wsDomain = "ws://84.201.169.190"
        static let restDomain = "http://84.201.169.190"
        static let appKey = "9df4d65b-3e28-4a5e-89a2-364d20bc353c"
    }
    
    struct Backend {
        static let domain = "https://fawn.chat" // prod
//        static let domain = "http://test.fawn.chat" // dev
        
        static let apiKey = "v23mM-4?L6$cT!Lk" // prod
//        static let apiKey = "aIlfMTHipXdSapMc" // dev
    }
    
    struct Analytics {
        static let appNameForAmplitude = "FAWN"
        
        static let amplitudeAPIKey = "b503251969f4b1d7901d2f7d1388d476" // prod
//            static let amplitudeAPIKey = "dde6c038a32c3082b6debe249fad5d34" // dev
    }
    
    struct TermsOfService {
        static let termsUrl = "https://test.fawn.chat/legal/terms"
        static let policyUrl = "https://test.fawn.chat/legal/policy"
        static let contactUrl = "https://test.fawn.chat/legal/contact"
    }
}
