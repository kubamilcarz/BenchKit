//
//  MovementPattern.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

enum MovementPattern: String, Codable, CaseIterable {
    case unknown
    case push, pull, pushPull
    case chest, back, abs, legs, shoulders
    
    var title: String {
        switch self {
        case .push:
            String(localized: "Push")
        case .pull:
            String(localized: "Pull")
        case .pushPull:
            String(localized: "Push-pull")
        case .chest:
            String(localized: "Chest")
        case .back:
            String(localized: "Back")
        case .abs:
            String(localized: "Abs")
        case .shoulders:
            String(localized: "Shoulders")
        case .legs:
            String(localized: "Legs")
        case .unknown:
            String("Unknown")
        }
    }
}
