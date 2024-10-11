//
//  UnscheduledWorkoutsList.swift
//  BenchKit
//
//  Created by Kuba on 10/11/24.
//

import SwiftUI

struct UnscheduledWorkoutsList: View {
    @EnvironmentObject var dataModel: DataModel
    
    @State private var workouts = [Workout]()
    
    var body: some View {
        List(workouts) { workout in
            Text(workout.workoutTitle)
        }
        .task {
            workouts = await dataModel.getUnscheduledWorkouts()
        }
    }
}

#Preview {
    UnscheduledWorkoutsList()
}
