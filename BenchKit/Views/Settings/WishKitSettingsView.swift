//
//  WishKitSettingsView.swift
//  BenchKit
//
//  Created by Kuba on 10/13/24.
//

import SwiftUI
import WishKit

struct WishKitSettingsView: View {
    
    init() {
        WishKit.config.statusBadge = .show

        // Shows full description of a feature request in the list.
        WishKit.config.expandDescriptionInList = true

        // Remove drop shadow.
        WishKit.config.dropShadow = .hide

        // Change the corner radius.
        WishKit.config.cornerRadius = 12
        
        WishKit.theme.primaryColor = .accent
        WishKit.config.allowUndoVote = true
        WishKit.config.emailField = .optional
        WishKit.config.expandDescriptionInList = true
    }
    
    var body: some View {
        WishKit.FeedbackListView()
    }
}
