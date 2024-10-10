//
//  Exercise.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import Foundation

extension WorkoutExercise {
    
    var exerciseCompletedDate: Date {
        get { dateCompleted ?? .distantPast }
        set { dateCompleted = newValue }
    }
    
    var exerciseName: String {
        get { name ?? String(localized: "Untitled Exercise") }
        set { name = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    var exerciseReps: Int {
        get { Int(reps) }
        set { reps = Int64(newValue) }
    }
    
    var exerciseWeightNumber: Double {
        get { weight }
        set { weight = newValue }
    }
    
    var exerciseWeightLocale: Measurement<UnitMass>? {
        get {
            guard weight > 0 else { return nil }
            
            // Determine user's locale and return the appropriate unit (kg or lbs)
            let locale = Locale.current
            if locale.measurementSystem == .metric {
                return Measurement(value: weight, unit: .kilograms)
            } else {
                return Measurement(value: weight, unit: .kilograms).converted(to: .pounds)
            }
        }
        set {
            if let newWeight = newValue {
                // Store the weight in kilograms, converting if necessary
                if newWeight.unit == .pounds {
                    weight = newWeight.converted(to: .kilograms).value
                } else {
                    weight = newWeight.value
                }
            } else {
                weight = 0
            }
        }
    }
    
    var exerciseOrder: Int {
        get { Int(order) }
        set { order = Int64(newValue) }
    }
}
