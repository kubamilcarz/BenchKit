//
//  AppView.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI
import KubaComponents

struct AppView: View {
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                WeeklyViewHeader()
                
                ScrollView {
                    VStack(spacing: 30) {
                        WeekStatsView()
                        
                        VStack(spacing: 15) {
                            NavigationLink {
                                WorkoutDetailView()
                            } label: {
                                workout
                            }
                            .buttonStyle(.plain)
                            
                            workout
                            workout
                        }
                    }
                    .padding()
                }
            }
            
            Button {
                dataModel.isShowingNewWorkout = true
            } label: {
                Image(systemName: "plus")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .frame(width: 70, height: 70)
                    .background(.accent.gradient)
                    .clipShape(.circle)
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
        }
        .environmentObject(dataModel)
        .navigationTitle("Workouts")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.secondarySystemBackground))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Stats", systemImage: "chart.bar.doc.horizontal.fill") {
                    dataModel.isShowingStats = true
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Settings", systemImage: "gear") {
                    dataModel.isShowingSettings = true
                }
            }
        }
    }
    
    
    private var workout: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                label("Oct 3, 2024", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .tint(.green)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                HStack(spacing: 0) {
                    Color.yellow
                    Color.blue
                    Color.blue
                    Color.green
                    Color.red
                    Color.red
                    Color.green
                    Color.blue
                    Color.green
                    Color.blue
                    Color.blue
                    Color.yellow
                }
                .frame(width: 100, height: 7)
                .clipShape(.capsule)
                
                Image(systemName: "chevron.forward")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding([.top, .horizontal])
           
            Divider()
                
            Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 10) {
                GridRow {
                    label("**43** min", systemImage: "clock.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    label("**6** difficulty", systemImage: "chart.bar.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                GridRow {
                    label("**Chest**", systemImage: "dumbbell.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    label("**3** sets", systemImage: "repeat")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                GridRow {
                    label("**313** kcal", systemImage: "flame.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    label("**7-12** reps", systemImage: "arrow.circlepath")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .tint(.secondary)
            .font(.subheadline)
            .padding([.bottom, .horizontal])
        }
        .background(.background)
        .clipShape(.rect(cornerRadius: 12))
    }
    
    
    private func label(_ title: LocalizedStringKey, systemImage: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: systemImage)
            
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    NavigationStack {
        AppView()
            .environmentObject(DataModel.shared)
    }
}
