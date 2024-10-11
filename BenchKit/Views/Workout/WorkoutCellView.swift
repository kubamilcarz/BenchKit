//
//  WorkoutCellView.swift
//  BenchKit
//
//  Created by Kuba on 10/11/24.
//

import SwiftUI

struct WorkoutCellView: View {
    @EnvironmentObject var dataModel: DataModel
    
    var workout: Workout
    
    @State private var muscleGroups: [MuscleGroup] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                HStack {
                    if workout.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.headline)
                            .foregroundStyle(.green)
                            .symbolRenderingMode(.hierarchical)
                    } else if !workout.isCompleted && workout.workoutScheduledDate < .now {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.headline)
                            .foregroundStyle(.green)
                            .symbolRenderingMode(.hierarchical)
                    }
                    
                    Text(workout.dateCompleted?.formatted(date: .abbreviated, time: .omitted) ?? workout.dateScheduled?.formatted(date: .abbreviated, time: .omitted) ?? String(localized: "No date"))
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                if muscleGroups.isNotEmpty {
                    HStack(spacing: 0) {
                        ForEach(muscleGroups) { group in
                            group.color
                        }
                    }
                    .frame(width: 100, height: 7)
                    .clipShape(.capsule)
                } else {
                    Text("Empty")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: 100, alignment: .trailing)
                }

                
                Image(systemName: "chevron.forward")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding([.top, .horizontal])
           
            Divider()
                
            Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 10) {
                GridRow {
                    label("**43** min", systemImage: "clock.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    label("**6** difficulty", systemImage: "chart.bar.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                GridRow {
                    label("**Chest**", systemImage: "dumbbell.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    label("**3** sets", systemImage: "repeat")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                GridRow {
                    label("**313** kcal", systemImage: "flame.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    label("**7-12** reps", systemImage: "arrow.circlepath")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .tint(.secondary)
            .font(.subheadline)
            .padding([.bottom, .horizontal])
        }
        .background(.background)
        .clipShape(.rect(cornerRadius: 12))
        .task {
            muscleGroups = await dataModel.getAllExercises(forWorkout: workout).map(\.exerciseMuscleGroup)
        }
    }
    
    
    private func label(_ title: LocalizedStringKey, systemImage: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: systemImage)
            
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
