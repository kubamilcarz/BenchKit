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
    @EnvironmentObject var dataModel: DataModel
    
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
        .environmentObject(dataModel)
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
            .padding(.horizontal)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(.ultraThickMaterial)
        }
        .safeAreaInset(edge: .bottom) {
            NavigationLink {
                ManualWorkoutSheet(mode: .new)
            } label: {
                Label("Manual", systemImage: "pencil")
                    .padding(10)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(BenchKitPrimaryButton())
            .padding(.horizontal)
            .padding(.top)
            .background(.regularMaterial, ignoresSafeAreaEdges: .bottom)
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
