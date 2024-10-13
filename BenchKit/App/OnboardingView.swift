//
//  OnboardingView.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI

enum OnboardingScreen: String {
    case welcome, features, goal, process, paywall
}

struct OnboardingView: View {
    
    @State private var currentScreen: OnboardingScreen = .welcome
    
    var body: some View {
        TabView(selection: $currentScreen) {
            WelcomeOnboardingView().tag(OnboardingScreen.welcome)
            
            PaywallView(isOnboarding: true).tag(OnboardingScreen.paywall)
        }
        .ignoresSafeArea()
        .tabViewStyle(.page(indexDisplayMode: .never))
        .safeAreaInset(edge: .bottom) {
            Button {
                withAnimation {
                    switch currentScreen {
                    case .welcome: currentScreen = .features
                    case .features: currentScreen = .goal
                    case .goal: currentScreen = .process
                    case .process: currentScreen = .paywall
                    case .paywall: break
                    }
                }
            } label: {
                Label("Start", systemImage: "arrow.forward.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .frame(maxWidth: .infinity)
                    .padding(10)
            }
            .buttonStyle(BenchKitPrimaryButton())
            .padding(.top)
            .padding(.horizontal, 30)
            .background(.regularMaterial, ignoresSafeAreaEdges: .bottom)
        }
    }
}

#Preview {
    OnboardingView()
}
