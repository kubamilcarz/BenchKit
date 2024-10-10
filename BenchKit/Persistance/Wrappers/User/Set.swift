//
//  WorkoutSet.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import Foundation

extension WorkoutSet {
    
    var setOrder: Int {
        get { Int(order) }
        set { order = Int64(newValue) }
    }
    
    var setCompletedDate: Date {
        get { dateCompleted ?? .distantPast }
        set { dateCompleted = newValue }
    }
    
    var setBreakLength: TimeInterval {
        get { breakLength }
        set { breakLength = newValue }
    }
    
    
    var workoutExercises: [WorkoutExercise] { Array(exercises as? Set<WorkoutExercise> ?? []).sorted { $0.order > $1.order } }
}
