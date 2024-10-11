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
            self.workout?.isCompleted = false
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
        newSet.workout = workout
        
        setsExercises[newSet] = []
    }
    
    func duplicatePreviousSet(andSetOrder order: Int) {
        guard let oldSet = setsExercises.keys.first(where: { $0.setOrder == focusedSet }) ?? setsExercises.keys.first else { return }
        
        let newSet = WorkoutSet(context: context)
        newSet.id = UUID()
        newSet.setOrder = order
        newSet.workout = workout
        newSet.setBreakLength = oldSet.setBreakLength
       
        for exercise in oldSet.setExercises {
            let newExercise = WorkoutExercise(context: context)
            newExercise.id = UUID()
            newExercise.exerciseOrder = exercise.exerciseOrder
            newExercise.exerciseReps = exercise.exerciseReps
            newExercise.exerciseName = exercise.exerciseName
            newExercise.exerciseWeightNumber = exercise.exerciseWeightNumber
            newExercise.exerciseMuscleGroup = exercise.exerciseMuscleGroup
            newExercise.set = newSet
        }
        
        setsExercises[newSet] = []
    }
    
    func addEmptyExercise(toSet set: WorkoutSet) {
        guard let se = setsExercises[set] else { return }
        
        let newExercise = WorkoutExercise(context: context)
        newExercise.id = UUID()
        newExercise.set = set
        newExercise.exerciseName = ""
        
        newExercise.exerciseOrder = (se.map(\.exerciseOrder).max() ?? 0) + 1
        newExercise.exerciseReps = se.map(\.exerciseReps).max() ?? 0
        newExercise.exerciseWeightNumber = se.sorted { $0.exerciseOrder < $1.exerciseOrder }.max()?.exerciseWeightNumber ?? 0
        
        setsExercises[set]?.append(newExercise)
    }
    
    
    func save(completion: @escaping () -> Void) {
        guard movementPattern != .unknown || duration > 0 || difficulty != .none || title.count > 2 else { return }
        
        workout?.workoutTitle = title
        workout?.workoutNotes = notes
        workout?.workoutMovement = movementPattern
        workout?.workoutDuration = duration
        workout?.workoutDifficulty = difficulty
        workout?.dateScheduled = isScheduled ? scheduleDate : nil
        
        try? context.save()
        
        // when repeating turned off duplicate sets
        if repeatSameSet {
            for i in 1...setCount {
                duplicatePreviousSet(andSetOrder: i+1)
            }
        }
        
        // TODO: Save as blueprint too
        
        completion()
    }
}
