//
//  RootView.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import StoreKit
import SwiftUI
import KubaComponents
import TelemetryDeck

struct RootView: View {
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var model: DataModel
    
    @AppStorage(Defaults.onboardingShown) var isShowingOnboarding = true
    @State private var isShowingPaywall = false
    @AppStorage(Defaults.launchCount) var launchCount = 0
    @AppStorage(Defaults.lastVersion) var lastVersion = "1.0"

    @AppStorage(Defaults.hapticsOn) var hapticsOn = true
    
    var content: some View {
        AppView()
    }
    
    var body: some View {
        content
            .sheet(isPresented: $model.isShowingStats) {
                StatsSheet()
                    .environmentObject(model)
                    #if os(visionOS) || os(macOS)
                    .frame(width: 500, height: 700)
                    #endif
            }
            .sheet(isPresented: $model.isShowingNewWorkout) {
                AddWorkoutSheet()
                    .interactiveDismissDisabled(true)
                    .environmentObject(model)
                    #if os(visionOS) || os(macOS)
                    .frame(width: 500, height: 700)
                    #endif
            }
            .sheet(isPresented: $model.isShowingSettings) {
                SettingsView()
                    .environmentObject(model)
                    #if os(visionOS) || os(macOS)
                    .frame(width: 500, height: 700)
                    #endif
            }
            .sheet(isPresented: $model.isShowingWhatsNew) {
                WhatsNewSheet()
                    #if os(visionOS) || os(macOS)
                    .frame(width: 500, height: 700)
                    #endif
            }
            .sheet(isPresented: $model.isShowingPaywall) {
                PaywallView()
                    #if os(visionOS) || os(macOS)
                    .frame(width: 500, height: 700)
                    #endif
            }
            .fullScreenCover(isPresented: $isShowingOnboarding) {
                TelemetryDeck.signal(Analytics.finishedOnboarding.id)
                
                requestReview()
            } content: {
                OnboardingView()
            }
            .task {
                await purchaseManager.updatePurchasedProducts()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if !purchaseManager.hasUnlockedPlus && BenchKit.version == lastVersion {
                        if  launchCount % 3 == 0 {
                            isShowingPaywall = true
                        }
                    }
                }
            }
            .onAppear(perform: configure)
            .isNavigationStack()
    }
    
    
    private func configure() {
        launchCount += 1
        
        if launchCount != 1 && BenchKit.version != lastVersion {
            model.isShowingWhatsNew = true
            lastVersion = BenchKit.version
        }
        
        if launchCount % 3 == 0 {
            requestReview()
        }
    }
}

#Preview {
    RootView()
}
