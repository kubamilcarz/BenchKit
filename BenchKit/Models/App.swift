//
//  App.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI

enum BenchKit {
    
    static let appName = "BenchKit"
    static let appHint = String(localized: "") // TODO: App Subtitle
    
    
    static let terms: URL = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula")!
    static let privacy: URL = URL(string: "https://kubamilcarz.notion.site/BenchKit-Privacy-Policy-11ea114c5abb8085b326e853eafd4e9a?pvs=4")!
    
    static let version = "1.0.0"
    static let copyright = String(localized: "© copyright 2024 Kuba Milcarz")
    
    static let updates: [Feature] = []
}


struct Feature: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var systemImage: String
}
