//
//  WhatsNewView.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI

struct WhatsNewSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 50) {
                    VStack(spacing: 30) {
                        Image(.logo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .clipShape(.rect(cornerRadius: 90*2/9))
                        
                        VStack(spacing: 5) {
                            Text("What's new in BenchKit")
                                .font(.title2.bold())
                                .foregroundStyle(.accent.gradient)
                            Text("Version \(BenchKit.version)")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    VStack(spacing: 20) {
                        ForEach(BenchKit.updates) { feature in
                            HStack(spacing: 15) {
                                Image(systemName: feature.systemImage)
                                    .font(.title.bold())
                                    .foregroundStyle(.accent)
                                    .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(feature.title)
                                        .font(.headline)
                                        .foregroundStyle(.accent)
                                    
                                    Text(feature.subtitle)
                                        .font(.subheadline)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .padding(30)
                .padding(.vertical, 30)
            }
            .frame(maxWidth: .infinity)
            .background(LinearGradient(colors: [.accent.opacity(0.1), .accent.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea())
            .safeAreaInset(edge: .bottom) {
                Button {
                    dismiss()
                } label: {
                    Label("Continue", systemImage: "arrow.forward.circle.fill")
                        .padding(10)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 30)
                .padding(.vertical)
                .background(.ultraThinMaterial, ignoresSafeAreaEdges: .all)
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 44).bold())
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .padding()
                }
                
                Spacer()
                
            }
        }
    }
}

#Preview {
    WhatsNewSheet()
}
