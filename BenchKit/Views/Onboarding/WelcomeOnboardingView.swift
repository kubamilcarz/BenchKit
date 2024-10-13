//
//  WelcomeOnboardingView.swift
//  BenchKit
//
//  Created by Kuba on 10/13/24.
//

import SwiftUI

struct WelcomeOnboardingView: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Text("Plan, schedule, track workouts on the go")
                    .font(.title.bold())
                    .foregroundStyle(.accent.gradient)
                Text("BenchKit empowers aethlets with the right tools to make real progress in the gym.")
                    .foregroundStyle(.secondary)
                
                Spacer(minLength: 0)
            }
            .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 30)
        .safeAreaInset(edge: .top) {
            VStack(spacing: 0) {
                Image("workoutOnb")
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .containerRelativeFrame(.vertical, { len, _ in len * 0.7 })
                    .ignoresSafeArea()
                
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)
                    .clipShape(.rect(cornerRadius: 110*2/9))
                    .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: -3)
                    .padding(.top, -120)
            }
        }
        .background(LinearGradient(colors: [.accent.opacity(0.1), .accent.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea())
    }
}

#Preview {
    WelcomeOnboardingView()
}
