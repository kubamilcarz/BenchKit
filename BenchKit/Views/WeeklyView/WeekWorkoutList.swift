//
//  WeekWorkoutList.swift
//  BenchKit
//
//  Created by Kuba on 10/11/24.
//

import SwiftUI

struct WeekWorkoutList: View {
    @EnvironmentObject var dataModel: DataModel
    
    @State private var unscheduledCount = 0
    @State private var isToggled = false
    
    @State private var workouts: [Workout] = []
    
    var body: some View {
        VStack(spacing: 15) {
            if unscheduledCount > 0 {
                unscheduledLabel
            }
            
            VStack(spacing: 15) {
                if workouts.isEmpty {
                    ContentUnavailableView("A lazy week", systemImage: "powersleep", description: Text("Try scheduling more workouts to see them here."))
                } else {
                    ForEach(workouts) { workout in
                        NavigationLink {
                            WorkoutDetailView()
                        } label: {
                            WorkoutCellView(workout: workout)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .background(.background.opacity(0.01), ignoresSafeAreaEdges: .all)
        }
        .onChange(of: dataModel.selectedDate) { _, newValue in
            if let newValue {
                withAnimation {
                    isToggled.toggle()
                }
                
                Task {
                    workouts = await dataModel.getWeeklyWorkouts()
                }
            }
        }
        .onChange(of: dataModel.isShowingNewWorkout) { _, _ in
            Task {
                unscheduledCount = await dataModel.getCountOfUnscheduledWorkouts()
            }
        }
        .task {
            unscheduledCount = await dataModel.getCountOfUnscheduledWorkouts()
        }
    }
    
    
    private var unscheduledLabel: some View {
        NavigationLink {
            UnscheduledWorkoutsList()
                .navigationTitle("Unscheduled Workouts")
                .navigationBarTitleDisplayMode(.inline)
                .environmentObject(dataModel)
        } label: {
            HStack {
                Label("You have \(unscheduledCount) unscheduled workouts.", systemImage: "exclamationmark.triangle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.forward")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.background)
            .clipShape(.rect(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    WeekWorkoutList()
}
