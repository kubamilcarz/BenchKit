//
//  Analytics.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import Foundation
import TelemetryClient

enum Analytics {
    
    // TODO: - Telemetry Analytics
    case showedPaywall
    case finishedOnboarding
    case openedSettings
    case sentFeedback
    
    var id: String {
        switch self {
            
            
            case .showedPaywall: return "Showed-Paywall"
            case .finishedOnboarding: return "Finished-Onboarding"
            case .openedSettings: return "Opened-Settings"
            case .sentFeedback: return "Sent-Feedback"
        }
    }
}


class AnalyticsManager: ObservableObject {
    static let shared = AnalyticsManager()
    
    func log(_ signal: Analytics, values: [String: String] = [:]) {
        TelemetryDeck.signal(signal.id, parameters: values)
    }
}
