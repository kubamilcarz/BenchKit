//
//  ManualWorkoutSheet.swift
//  BenchKit
//
//  Created by Kuba on 10/11/24.
//

import SwiftUI

enum SheetMode {
    case new, edit
}

struct ManualWorkoutSheet: View {
    
    @StateObject private var model: ManualWorkoutModel
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    init(workout: Workout? = nil, mode: SheetMode) {
        if let workout {
            self._model = StateObject(wrappedValue: .init(
                mode: mode,
                workout: workout,
                title: workout.workoutTitle,
                notes: workout.workoutNotes,
                movementPattern: workout.workoutMovement,
                duration: workout.workoutDuration,
                difficulty: workout.workoutDifficulty,
                setCount: workout.workoutSets.count,
                breakLength: workout.workoutSets.map(\.breakLength).reduce(0, +)/Double(workout.workoutSets.count),
                isScheduled: workout.dateScheduled != nil,
                scheduleDate: workout.workoutScheduledDate))
        } else {
            self._model = StateObject(wrappedValue: .init(
                mode: mode, workout: nil, title: "", notes: "", movementPattern: .unknown,
                duration: 60, difficulty: .medium,
                setCount: 2, breakLength: 90, isScheduled: false))
        }
    }
    
    var body: some View {
        Form {
            Label {
                TextField("Name", text: $model.title, prompt: Text("Name"))
            } icon: {
                Image(systemName: "character")
            }
            
            Section {
                Picker("Workout type", systemImage: "dumbbell", selection: $model.movementPattern) {
                    ForEach(MovementPattern.allCases, id: \.self) { pattern in
                        Text(pattern == .unknown ? String(localized: "Choose") : pattern.title).tag(pattern)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Duration (min)", systemImage: "clock", selection: $model.duration) {
                    ForEach([10, 20, 30, 40, 60, 80, 90, 100, 120], id: \.self) { time in
                        Text(String(time)).tag(Double(time))
                    }
                }
                .pickerStyle(.menu)
                
                Toggle("Schedule", systemImage: "calendar", isOn: $model.isScheduled.animation())
                
                if model.isScheduled {
                    Label {
                        HStack {
                            Spacer()
                            DatePicker("Date & time", selection: $model.scheduleDate)
                                .labelsHidden()
                        }
                    } icon: {
                        Image(systemName: "clock")
                    }
                }
            }
            
            Section {
                Picker("Sets", systemImage: "repeat", selection: $model.setCount.animation()) {
                    ForEach([1, 2, 3, 4, 5], id: \.self) { time in
                        Text(String(time)).tag(Double(time))
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Break between (s)", systemImage: "hourglass", selection: $model.breakLength) {
                    ForEach([30, 45, 60, 90, 120, 150, 180], id: \.self) { time in
                        Text(String(time)).tag(Double(time))
                    }
                }
                .pickerStyle(.menu)
                
                if model.setCount > 1 {
                    Toggle("Repeat sets", systemImage: "repeat", isOn: $model.repeatSameSet)
                }
            }
            
            Section("Exercises") {
                if model.setCount > 1 && !model.repeatSameSet {
                    Picker("Focused Set", selection: $model.focusedSet.animation()) {
                        ForEach(0..<model.setCount, id: \.self) { counter in
                            Text("Set \(counter+1)").tag(counter+1)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                if let set = model.setsExercises.keys.first(where: { $0.setOrder == model.focusedSet }), let exercises = model.setsExercises[set] {
                    Button("Add exercise", systemImage: "plus") {
                        model.addEmptyExercise(toSet: set)
                    }
                    
                    if exercises.isEmpty {
                        ContentUnavailableView("Empty Set", systemImage: "repeat")
                    } else {
                        ForEach(exercises, id: \.self) { exercise in
                            VStack(alignment: .leading) {
                                TextField("Name", text: Binding(get: {
                                    exercise.exerciseName
                                }, set: { newValue in
                                    if let exercises = model.setsExercises[set],
                                       let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
                                        
                                        // Update the exerciseName of the specific exercise
                                        exercises[index].exerciseName = newValue
                                        
                                        // Update the array in the dictionary
                                        model.setsExercises[set] = exercises
                                    }
                                }))
                                .textFieldStyle(.roundedBorder)
                                
                                HStack(spacing: 15) {
                                    HStack(spacing: 5) {
                                        TextField("Weight", value: Binding(get: {
                                            exercise.exerciseWeightLocale?.value ?? 0
                                        }, set: { newValue in
                                            if var exercises = model.setsExercises[set],
                                               let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
//                                                
//                                                // Update the exerciseName of the specific exercise
//                                                if let currentLocale = exercises[index].exerciseWeightLocale {
//                                                    exercises[index].exerciseWeightLocale = Measurement(value: newValue, unit: currentLocale.unit)
//                                                } else {
//                                                    exercises[index].exerciseWeightLocale = Measurement(value: newValue, unit: UnitMass.kilograms)
//                                                }
//                                                
//                                                // Update the array in the dictionary
//                                                model.setsExercises[set] = exercises
                                            }
                                        }), formatter: formatter)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 90)
                                        
                                        Text(Locale.current.measurementSystem == .metric ? "kg" : "lbs")
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    HStack(spacing: 5) {
                                        TextField("Reps", value: Binding(get: {
                                            Double(exercise.exerciseReps)
                                        }, set: { newValue in
                                            if var exercises = model.setsExercises[set],
                                               let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
//                                                
//                                                // Update the exerciseName of the specific exercise
//                                                exercises[index].exerciseReps = newValue
//                                                
//                                                // Update the array in the dictionary
//                                                model.setsExercises[set] = exercises
                                            }
                                        }), format: .number)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 90)
                                        
                                        Text("reps")
                                            .font(.headline)
                                    }
                                    .keyboardType(.numberPad)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                }
            }
            .headerProminence(.increased)
        }
        .navigationTitle("New Workout")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button(action: model.save) {
                Label("Add Workout", systemImage: "plus")
                    .padding(10)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(BenchKitPrimaryButton())
            .disabled(model.movementPattern == .unknown || model.duration == 0 || model.difficulty == .none)
            .padding([.horizontal, .top])
            .background(.regularMaterial, ignoresSafeAreaEdges: .bottom)
        }
    }
}

#Preview {
    NavigationStack {
        ManualWorkoutSheet(mode: .new)
    }
}
