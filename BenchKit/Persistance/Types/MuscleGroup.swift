//
//  MuscleGroup.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

enum MuscleGroup: String, Codable, CaseIterable {
    case chest, back, arms, shoulders, triceps, biceps, legs, abs, unknown
    
    var title: String {
        switch self {
        case .chest:
            return String(localized: "Chest")
        case .back:
            return String(localized: "Back")
        case .arms:
            return String(localized: "Arms")
        case .shoulders:
            return String(localized: "Shoulders")
        case .triceps:
            return String(localized: "Triceps")
        case .biceps:
            return String(localized: "Biceps")
        case .legs:
            return String(localized: "Legs")
        case .abs:
            return String(localized: "Abs")
        case .unknown:
            return String(localized: "Unknown")
        }
    }
}
