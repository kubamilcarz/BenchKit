//
//  CalendarView.swift
//  BenchKit
//
//  Created by Kuba on 10/11/24.
//

import SwiftUI

struct CalendarView: UIViewRepresentable {
    let interval: DateInterval
    @ObservedObject var dataModel: DataModel
    @Binding var dateSelected: DateComponents?
    
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.delegate = context.coordinator
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        let dateSelection = UICalendarSelectionWeekOfYear(delegate: context.coordinator)
        dateSelection.selectedWeekOfYear = dateSelected
        view.selectionBehavior = dateSelection
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, dataModel: _dataModel)
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        
    }
    
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionWeekOfYearDelegate {
        let parent: CalendarView
        @ObservedObject var dataModel: DataModel
        
        
        init(parent: CalendarView, dataModel: ObservedObject<DataModel>) {
            self.parent = parent
            self._dataModel = dataModel
        }
        
        @MainActor
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let foundWorkouts = dataModel.getWorkouts()
                .filter { $0.workoutScheduledDate.startOfDay == dateComponents.date?.startOfDay }
            
            if foundWorkouts.count == 1 {
                return .default(color: .accent, size: .large)
            } else if foundWorkouts.count > 1 {
                return .image(UIImage(systemName: "\(foundWorkouts.count).circle"), color: .accent)
            } else {
                return nil
            }
        }
                
        func week(ofYearSelection selection: UICalendarSelectionWeekOfYear, didSelectWeekOfYear weekOfYearComponents: DateComponents?) {
            parent.dateSelected = weekOfYearComponents
            guard let weekOfYearComponents else { return }
            
            let foundWorkouts = dataModel.getWorkouts()
                .filter { $0.workoutScheduledDate.startOfDay == weekOfYearComponents.date?.startOfDay }
            
            if foundWorkouts.isNotEmpty {
                // toggle seeing
            }
        }
        
        func week(ofYearSelection selection: UICalendarSelectionWeekOfYear, canSelectWeekOfYear weekOfYearComponents: DateComponents?) -> Bool {
            PurchaseManager.shared.hasUnlockedPlus
        }
    }
}

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var weekOfYear: Int {
        Calendar.current.component(.weekOfYear, from: self)
    }
}
