//
//  AppView.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI
import KubaComponents

struct AppView: View {
    @EnvironmentObject var dataModel: DataModel
        
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                WeeklyViewHeader()
                
                ScrollView {
                    VStack(spacing: 30) {
                        WeekStatsView()
                        
                        WeekWorkoutList()
                    }
                    .padding()
                }
            }
            
            Button {
                dataModel.isShowingNewWorkout = true
            } label: {
                Image(systemName: "plus")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .frame(width: 70, height: 70)
                    .background(.accent.gradient)
                    .clipShape(.circle)
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
        }
        .environmentObject(dataModel)
        .navigationTitle("Workouts")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.secondarySystemBackground))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Stats", systemImage: "chart.bar.doc.horizontal.fill") {
                    dataModel.isShowingStats = true
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Settings", systemImage: "gear") {
                    dataModel.isShowingSettings = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AppView()
            .environmentObject(DataModel.shared)
    }
}
