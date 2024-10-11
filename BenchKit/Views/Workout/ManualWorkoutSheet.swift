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
    @Environment(\.dismiss) var dismiss
    @Environment(\.editMode) var editMode
    @EnvironmentObject var dataModel: DataModel
    
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
            form
            
            Section {
                if model.setCount > 1 && !model.repeatSameSet {
                    Picker("Focused Set", selection: $model.focusedSet.animation()) {
                        ForEach(0..<model.setCount, id: \.self) { counter in
                            Text("Set \(counter+1)").tag(counter+1)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                if let set = model.setsExercises.keys.first(where: { $0.setOrder == model.focusedSet }), let _ = model.setsExercises[set] {
                    Button("Add exercise", systemImage: "plus") {
                        model.addEmptyExercise(toSet: set)
                    }
                }
            } header: {
                HStack {
                    Text("Exercises")
                    Spacer()
                    EditButton()
                }
            }
            .headerProminence(.increased)
            
            Section {
                if let set = model.setsExercises.keys.first(where: { $0.setOrder == model.focusedSet }), let exercises = model.setsExercises[set]?.sorted(by: { $0.exerciseOrder < $1.exerciseOrder }) {
                    if exercises.isEmpty {
                        ContentUnavailableView("Empty Set", systemImage: "repeat")
                    } else {
                        ForEach(exercises, id: \.self) { exercise in
                            exerciseLabel(exercise: exercise)
                        }
                        .onDelete { indexSet in
                            guard let setExercises = model.setsExercises[set] else { return }

                            // Remove the exercises at the specified indices
                            var updatedExercises = setExercises
                            updatedExercises.remove(atOffsets: indexSet)
                            
                            // Update the `exerciseOrder` for the remaining exercises
                            for (index, exercise) in updatedExercises.enumerated() {
                                updatedExercises[index].exerciseOrder = index + 1 // Start from 1
                            }
                            
                            // Update the set in the dictionary
                            model.setsExercises[set] = updatedExercises
                        }
                        .onMove { sourceIndices, destinationIndex in
                            guard let setExercises = model.setsExercises[set] else { return }
                            
                            var reorderedExercises = setExercises
                            
                            // Move the items within the array
                            reorderedExercises.move(fromOffsets: sourceIndices, toOffset: destinationIndex)
                            
                            // Now update the `exerciseOrder` of each exercise based on its new position in the list
                            for (index, exercise) in reorderedExercises.enumerated() {
                                reorderedExercises[index].exerciseOrder = index + 1 // Start from 1
                            }
                            
                            // Update the set in the dictionary
                            model.setsExercises[set] = reorderedExercises
                        }
                    }
                }
            }
            .onChange(of: model.focusedSet) { _, newValue in
                if model.setsExercises.keys.first(where: { $0.setOrder == newValue }) == nil {
                    withAnimation {
                        model.duplicatePreviousSet(andSetOrder: newValue)
                    }
                }
            }
            .onChange(of: model.repeatSameSet) { _, newValue in
                if newValue {
                    withAnimation {
                        model.focusedSet = 1
                    }
                    
                    if let set = model.setsExercises.keys.first(where: { $0.setOrder == model.focusedSet }) {
                        
                        for ss in model.setsExercises.keys.filter({ $0 != set }) {
                            if let index = model.setsExercises.index(forKey: ss) {
                                model.setsExercises.remove(at: index)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("New Workout")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button {
                model.save {
                    dismiss()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        dataModel.isShowingNewWorkout = false
                    }
                }
            } label: {
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
    
    @ViewBuilder
    private var form: some View {
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
    }
    
    @ViewBuilder
    private func exerciseLabel(exercise: WorkoutExercise) -> some View {
        if let set = model.setsExercises.keys.first(where: { $0.setOrder == model.focusedSet }), let _ = model.setsExercises[set]?.sorted(by: { $0.exerciseOrder < $1.exerciseOrder }) {
            VStack(alignment: .leading, spacing: 0) {
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
                
                Divider().padding(.vertical, 5)
                
                Picker("Muscle Group", selection: Binding(get: {
                    exercise.exerciseMuscleGroup
                }, set: { newValue in
                    if let exercises = model.setsExercises[set],
                       let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
                        
                        // Update the exerciseName of the specific exercise
                        exercises[index].exerciseMuscleGroup = newValue
                        
                        // Update the array in the dictionary
                        model.setsExercises[set] = exercises
                    }
                })) {
                    ForEach(MuscleGroup.allCases, id: \.self) {
                        Text($0 == .unknown ? "Muscle" : $0.title).tag($0)
                    }
                }
                .pickerStyle(.menu)
                
                Divider().padding(.vertical, 5)
                
                HStack(spacing: 5) {
                    Label("Weight", systemImage: "scalemass.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("Weight", value: Binding(get: {
                        exercise.exerciseWeightLocale?.value ?? 0
                    }, set: { newValue in
                        if let exercises = model.setsExercises[set],
                           let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
                            if Locale.current.measurementSystem != .metric {
                                exercises[index].exerciseWeightLocale = Measurement(value: Double(newValue), unit: .pounds)
                            } else {
                                exercises[index].exerciseWeightNumber = Double(newValue)
                            }
                            // Update the array in the dictionary
                            model.setsExercises[set] = exercises
                        }
                    }), formatter: formatter)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 90)
                    
                    Text(Locale.current.measurementSystem == .metric ? "kg" : "lbs")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider().padding(.vertical, 5)
                
                HStack(spacing: 5) {
                    Label("Reps", systemImage: "arrow.circlepath")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("Reps", value: Binding(get: {
                        Double(exercise.exerciseReps)
                    }, set: { newValue in
                        if let exercises = model.setsExercises[set],
                           let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
                            
                            // Update the exerciseName of the specific exercise
                            exercises[index].exerciseReps = Int(newValue)
                            
                            // Update the array in the dictionary
                            model.setsExercises[set] = exercises
                        }
                    }), format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 90)
                }
                .keyboardType(.numberPad)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .listRowBackground(EmptyView())
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .padding()
            .background(.background.secondary, in: .rect(cornerRadius: 12))
            .listRowSeparator(.hidden)
            .padding(.bottom, 15)
        }
    }
}

#Preview {
    NavigationStack {
        ManualWorkoutSheet(mode: .new)
    }
}
