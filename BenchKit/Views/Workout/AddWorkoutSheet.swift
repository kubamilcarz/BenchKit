//
//  AddWorkoutSheet.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI
import SwiftUI

struct AddWorkoutSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @SceneStorage(Defaults.showingGallery) var showingGallery = true
    @State private var search = ""
    
    var body: some View {
        ScrollView {
            if showingGallery {
                WorkoutGalleryView()
            } else {
                WorkoutLibraryView()
            }
        }
        .background(.regularMaterial)
        .safeAreaInset(edge: .top) {
            HStack {
                Picker("Show options", selection: $showingGallery.animation()) {
                    Text("Gallery")
                        .tag(true)
                    
                    Text("Library")
                        .tag(false)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.ultraThickMaterial)
        }
        .navigationTitle("Add Workout")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $search, placement: .navigationBarDrawer, prompt: Text("Search for workouts"))
        .toolbar {
            Button("Close", systemImage: "xmark") {
                dismiss()
            }
        }
        .isNavigationStack()
    }
}

#Preview {
    AddWorkoutSheet()
}
