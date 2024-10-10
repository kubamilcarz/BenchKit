//
//  SettingsView.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI
import KubaComponents

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section("General") {
                Label("Settings", systemImage: "gear")
                Label("Will go", systemImage: "arrow.forward")
                Label("Here", systemImage: "map")
            }
            .headerProminence(.increased)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Close", systemImage: "xmark") {
                dismiss()
            }
        }
        .isNavigationStack()
    }
}
