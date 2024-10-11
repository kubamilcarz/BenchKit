//
//  DataModel.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import Foundation
import CoreData

class DataModel: ObservableObject {
    
    static let shared = DataModel(context: PersistenceController.shared.container.viewContext)
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    @Published var isShowingPaywall = false
    @Published var isShowingSettings = false
    @Published var isShowingWhatsNew = false
    @Published var isShowingGoalsSheet = false
    @Published var isShowingStats = false
    
    @Published var isShowingNewWorkout = false

    func getCountOfUnscheduledWorkouts() async -> Int {
        await context.perform { [weak self] in
            let fetchRequest = Workout.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "dateScheduled == nil AND isCompleted == false")
            
            do {
                let count = try self?.context.count(for: fetchRequest) ?? 0
                return count
            } catch {
                print("Failed to count unscheduled workouts: \(error)")
                return 0
            }
        }
    }
    
    
    func getUnscheduledWorkouts() async -> [Workout] {
        await context.perform { [weak self] in
            let fetchRequest = Workout.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Workout.dateCompleted, ascending: false),
                NSSortDescriptor(keyPath: \Workout.title, ascending: true)
            ]
            fetchRequest.predicate = NSPredicate(format: "dateScheduled == nil AND isCompleted == false")
            
            do {
                let count = try self?.context.fetch(fetchRequest) ?? []
                return count
            } catch {
                print("Failed to fetch unscheduled workouts: \(error)")
                return []
            }
        }
    }
    
}
