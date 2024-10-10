//
//  StatsSheet.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI
import KubaComponents

struct StatsSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section("This Month") {
                Grid(alignment: .center, horizontalSpacing: 15, verticalSpacing: 15) {
                    GridRow {
                        VStack {
                            Text("431")
                                .foregroundStyle(.accent.gradient)
                                .font(.title.bold())
                            
                            Text("kcal burned")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.background, in: .rect(cornerRadius: 12))
                        
                        VStack {
                            Text("5h 41min")
                                .foregroundStyle(.accent.gradient)
                                .font(.title.bold())
                            
                            Text("total time")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.background, in: .rect(cornerRadius: 12))
                    }
                    
                    GridRow {
                        VStack {
                            Text("13")
                                .foregroundStyle(.accent.gradient)
                                .font(.title.bold())
                            
                            Text("workouts")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.background, in: .rect(cornerRadius: 12))
                        
                        VStack {
                            Text("7")
                                .foregroundStyle(.accent.gradient)
                                .font(.title.bold())
                            
                            Text("weekly goals hit")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.background, in: .rect(cornerRadius: 12))
                    }
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(EmptyView())
                
            }
            .headerProminence(.increased)
        }
        .navigationTitle("Stats")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Close", systemImage: "xmark.circle.fill") {
                dismiss()
            }
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.accent)
            .buttonStyle(.plain)
        }
        .isNavigationStack()
    }
}

#Preview {
    StatsSheet()
}
