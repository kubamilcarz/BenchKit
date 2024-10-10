//
//  WeeklyGoalSheet.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI

struct WeeklyGoalSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage(Defaults.weeklyGoal) var weeklyGoal = 3
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 15) {
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 15) {
                            Button {
                                withAnimation {
                                    weeklyGoal -= 1
                                }
                            } label: {
                                Image(systemName: "minus")
                                    .padding()
                                    .font(.headline)
                                    .frame(minWidth: 44, minHeight: 44)
                                    .background(.accent.secondary, in: .circle)
                            }
                            .disabled(weeklyGoal <= 0)
                            
                            Text(weeklyGoal.formatted())
                                .font(.largeTitle.bold())
                                .contentTransition(.numericText())
                                .padding()
                                .frame(minWidth: 120)
                                .background(.background, in: .rect(cornerRadius: 12))
                            
                            Button {
                                withAnimation {
                                    weeklyGoal += 1
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .padding()
                                    .font(.headline)
                                    .frame(minWidth: 44, minHeight: 44)
                                    .background(.accent.secondary, in: .circle)
                            }
                            .disabled(weeklyGoal > 14)
                            
                        }
                        
                        
                        Spacer()
                    }
                    .padding()
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }
        }
            .background(.regularMaterial)
            .safeAreaInset(edge: .top) {
                ZStack {
                    Text("Let's set your weekly goal")
                        .font(.title3.bold())
                    
                    HStack {
                        Spacer()
                        
                        Button { dismiss() } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.accent.secondary)
                        }
                    }
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                Text("Recommended workouts: 2-5 sessions per week for optimal results.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
    }
}

#Preview {
    WeeklyGoalSheet()
        .frame(maxHeight: 300)
}
