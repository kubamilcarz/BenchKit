//
//  ManualWorkoutModel.swift
//  BenchKit
//
//  Created by Kuba on 10/11/24.
//

import SwiftUI

class ManualWorkoutModel: ObservableObject {
    
    let context = PersistenceController.shared.container.viewContext
    
    @Published var workout: Workout?
    @Published var mode: SheetMode
    @Published var title: String
    @Published var notes: String
    @Published var movementPattern: MovementPattern
    @Published var duration: Double
    @Published var difficulty: WorkoutDifficulty
    @Published var setCount: Int
    @Published var breakLength: Double
    @Published var isScheduled: Bool
    @Published var scheduleDate: Date
    
    @Published var repeatSameSet: Bool = true
    @Published var focusedSet = 1
    
    @Published var setsExercises: [WorkoutSet: [WorkoutExercise]] = [:]
    
    init(mode: SheetMode, workout: Workout?, title: String, notes: String, movementPattern: MovementPattern, duration: Double, difficulty: WorkoutDifficulty, setCount: Int, breakLength: Double, isScheduled: Bool, scheduleDate: Date? = nil) {
        self.mode = mode
        self.workout = workout
        self.title = title
        self.notes = notes
        self.movementPattern = movementPattern
        self.duration = duration
        self.difficulty = difficulty
        self.setCount = setCount
        self.breakLength = breakLength
        self.isScheduled = isScheduled
        self.scheduleDate = scheduleDate ?? .now
        
        if workout == nil {
            let newWorkout = Workout(context: context)
            newWorkout.id = UUID()
            self.workout = newWorkout
        }
        
        makeEmptySet(order: 1)
    }
    
    deinit {
        context.rollback()
    }
    
    func makeEmptySet(order: Int) {
        let newSet = WorkoutSet(context: context)
        newSet.id = UUID()
        newSet.setOrder = order
        
        setsExercises[newSet] = []
    }
    
    func addEmptyExercise(toSet set: WorkoutSet) {
        let newExercise = WorkoutExercise(context: context)
        newExercise.id = UUID()
        newExercise.set = set
        newExercise.exerciseName = ""
        newExercise.exerciseOrder = setsExercises[set]?.map(\.exerciseOrder).sorted { $0 > $1 }.max() ?? 0 + 1
        newExercise.exerciseReps = setsExercises[set]?.sorted { $0.exerciseOrder > $1.exerciseOrder }.max()?.exerciseReps ?? 0
        newExercise.exerciseWeightNumber = setsExercises[set]?.sorted { $0.exerciseOrder > $1.exerciseOrder }.max()?.exerciseWeightNumber ?? 0
        
        setsExercises[set]?.append(newExercise)
    }
    
    
    func save() {
        
    }
}
