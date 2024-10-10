//
//  Workout.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import Foundation

extension Workout {
    
    var workoutScheduledDate: Date {
        get { dateScheduled ?? .distantPast }
        set { dateScheduled = newValue }
    }
    
    var workoutCompletedDate: Date {
        get { dateCompleted ?? .distantPast }
        set { dateCompleted = newValue }
    }
    
    var workoutTitle: String {
        get { title ?? String(localized: "Untitled Workout") }
        set { title = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    var workoutNotes: String {
        get { notes ?? "" }
        set { notes = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    var workoutKcalBurned: Int {
        get { Int(kcalBurned) }
        set { kcalBurned = Int64(newValue) }
    }
    
    var workoutDuration: TimeInterval {
        get { duration }
        set { duration = newValue }
    }
    
    var workoutDifficulty: WorkoutDifficulty {
        get { WorkoutDifficulty(rawValue: Int(difficultyScore)) ?? .none }
        set { difficultyScore = Int64(newValue.rawValue) }
    }
    
    var workoutMuscleGroup: MuscleGroup {
        get { MuscleGroup(rawValue: muscleGroup ?? "unknown") ?? .unknown }
        set { muscleGroup = newValue.rawValue }
    }
    
    var workoutMovement: MovementPattern {
        get { MovementPattern(rawValue: movementPattern ?? "unknown") ?? .unknown }
        set { movementPattern = newValue.rawValue }
    }
    
    
    var workoutSets: [WorkoutSet] { Array(sets as? Set<WorkoutSet> ?? []).sorted { $0.order > $1.order } }
}
