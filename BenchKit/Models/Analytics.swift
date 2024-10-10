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
    case telemetry
    
    var id: String {
        switch self {
        case .telemetry: return "telemetry"
        }
    }
}


class AnalyticsManager: ObservableObject {
    static let shared = AnalyticsManager()
    
    func log(_ signal: Analytics, values: [String: String] = [:]) {
        TelemetryManager.send(signal.id, for: nil, with: values)
    }
}
