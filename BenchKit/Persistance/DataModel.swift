//
//  DataModel.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI
import CoreData
import KubaComponents

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
    
    // Week view
    @Published var selectedDate: Date?
    var startOfWeekForSelectedDate: Date? {
        selectedDate?.startOfWeek
    }
    var endOfWeekForSelectedDate: Date? {
        startOfWeekForSelectedDate?.addingTimeInterval(60 * 60 * 24 * 7)
    }
    
    func changeDateSelected(by amount: Int) {
        withAnimation {
            selectedDate = selectedDate?.addingTimeInterval(TimeInterval(amount))
        }
    }
    

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
    
    
    func getWorkouts() -> [Workout] {
        let fetchRequest = Workout.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Workout.dateScheduled, ascending: true)
        ]
        fetchRequest.predicate = NSPredicate(format: "dateScheduled != nil")
        
        do {
            let count = try context.fetch(fetchRequest)
            return count
        } catch {
            print("Failed to fetch unscheduled workouts: \(error)")
            return []
        }
    }
    
    
    func getWeeklyWorkouts() async -> [Workout] {
        await context.perform {
            let fetchRequest = Workout.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Workout.dateScheduled, ascending: true)
            ]
            fetchRequest.predicate = NSPredicate(format: "dateScheduled >= %@ AND dateScheduled < %@", (self.startOfWeekForSelectedDate ?? Date.now) as NSDate, (self.endOfWeekForSelectedDate ?? Date.now) as NSDate)
            
            do {
                let count = try self.context.fetch(fetchRequest)
                return count
            } catch {
                print("Failed to fetch unscheduled workouts: \(error)")
                return []
            }
        }
    }
    
    
    func getAllExercises(forWorkout workout: Workout) async -> [WorkoutExercise] {
        await context.perform {
            let fetchRequest = WorkoutSet.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "workout == %@", workout)
                
                do {
                    let sets = try self.context.fetch(fetchRequest)
                    
                    // Combine the exercises from each WorkoutSet
                    var allExercises: [WorkoutExercise] = []
                    
                    for set in sets {
                        allExercises.append(contentsOf: set.setExercises)
                    }
                    
                    return allExercises
                } catch {
                    print("Failed to fetch exercises: \(error)")
                    return []
                }
        }
    }
    
}
