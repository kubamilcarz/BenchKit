//
//  WeekStatsView.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI

struct WeekStatsView: View {
    @EnvironmentObject var dataModel: DataModel
    
    @AppStorage(Defaults.weeklyGoal) var weeklyGoal = 3
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                ForEach(0..<7, id: \.self) { id in
                    VStack {
                        Circle().fill(.secondary)
                        
                        Text("M")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .id(id)
                }
            }
            .padding()
            
            Divider()
            
            HStack(alignment: .top, spacing: 5) {
                VStack(alignment: .leading) {
                    Text("Goals")
                        .font(.title3.bold())
                    Text("2 of \(weeklyGoal.formatted()) completed")
                        .foregroundStyle(.secondary)
                    
                    Button("Update") {
                        dataModel.isShowingGoalsSheet = true
                    }
                    .controlSize(.small)
                    .background(.secondary, in: .capsule)
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Circle().fill(.ultraThinMaterial).frame(height: 80)
            }
            .padding()
        }
        .background(.background, in: .rect(cornerRadius: 12))
        .sheet(isPresented: $dataModel.isShowingGoalsSheet) {
            WeeklyGoalSheet()
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    WeekStatsView()
}
