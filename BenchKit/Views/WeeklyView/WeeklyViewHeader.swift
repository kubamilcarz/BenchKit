//
//  WeeklyViewHeader.swift
//  BenchKit
//
//  Created by Kuba on 10/11/24.
//

import SwiftUI
import KubaComponents
import MijickCalendarView

struct WeeklyViewHeader: View {
    @EnvironmentObject var dataModel: DataModel
    
    @State private var isShowingCalendar = false
    @State private var dateSelected: DateComponents? = DateComponents(calendar: .current, timeZone: .current, year: Date.now.year, month: Date.now.month, day: Date.now.day)
    @State private var displayWorkouts = false
    
    var weeklyViewTitle: String {
        guard let startOfWeek = dataModel.startOfWeekForSelectedDate,
              let endOfWeek = dataModel.endOfWeekForSelectedDate else { return "" }
        
        if Date.now.startOfWeek == startOfWeek {
            return String(localized: "This Week")
        }
        
        return "\(startOfWeek.formatted(date: .abbreviated, time: .omitted)) - \(endOfWeek.formatted(date: .abbreviated, time: .omitted))"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button {
                        dataModel.changeDateSelected(by: -60*60*24*7)
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    Spacer()
                    Button {
                        dataModel.changeDateSelected(by: 60*60*24*7)
                    } label: {
                        Image(systemName: "chevron.forward")
                    }
                }
                
                Button {
                    isShowingCalendar = true
                } label: {
                    HStack(spacing: 10) {
                        Text(weeklyViewTitle)
                            .font(.subheadline.weight(.semibold))
                        
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.subheadline.bold())
                            .foregroundStyle(.accent)
                    }
                    .background(.background.opacity(0.01))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            
            Divider()
        }
        .sheet(isPresented: $isShowingCalendar) {
            ScrollView {
                CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), dataModel: dataModel, dateSelected: $dateSelected)
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    dataModel.selectedDate = .now
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isShowingCalendar = false
                    }
                } label: {
                    Text("Show this week")
                        .padding(10)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(BenchKitPrimaryButton())
                .padding([.horizontal])
                
            }
            .presentationDetents([.medium])
        }
        .onChange(of: dateSelected) { _, newValue in
            withAnimation {
                dataModel.selectedDate = newValue?.date ?? .now
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isShowingCalendar = false
                }
            }
        }
        .onAppear {
            dataModel.selectedDate = .now
        }
    }
}

#Preview {
    WeeklyViewHeader()
}
