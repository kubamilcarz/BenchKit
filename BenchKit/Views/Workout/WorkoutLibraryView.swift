//
//  WorkoutLibraryView.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI

struct WorkoutLibraryView: View {
    var body: some View {
        LazyVStack {
            VStack(spacing: 0) {
                ContentUnavailableView("Library", systemImage: "tray", description: Text("Add workouts to the library to see them here."))
                
                Button("Manual", systemImage: "pencil") {
                    
                }
                .buttonStyle(BenchKitPrimaryButton())
            }
            .padding()
            .background(.background, in: .rect(cornerRadius: 12))
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

#Preview {
    WorkoutLibraryView()
        .background(.regularMaterial)
}
