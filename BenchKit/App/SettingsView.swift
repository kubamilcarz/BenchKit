//
//  SettingsView.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI
import KubaComponents
import StoreKit
import LocalAuthentication
import TelemetryClient

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.requestReview) var requestReview
    
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    @AppStorage(Defaults.appLock) var appLock = false
    @AppStorage(Defaults.hapticsOn) var hapticsOn = true
    @State private var isShowingMailView = false
    
    var body: some View {
        List {
            Section("General") {
                Label("Settings", systemImage: "gear")
                Label("Will go", systemImage: "arrow.forward")
                Label("Here", systemImage: "map")
                Toggle("Haptics", systemImage: "iphone.gen3.radiowaves.left.and.right", isOn: $hapticsOn)
                Toggle("Lock BenchKit", systemImage: "lock", isOn: $appLock)
                    .onChange(of: appLock) { _, newValue in
                        if newValue { toggleAppLock() }
                    }
            }
            
            Section("App") {
                NavigationLink {
                    WishKitSettingsView()
                } label: {
                    Label("Wishlist", systemImage: "heart")
                }
                
                Button {
                    isShowingMailView.toggle()
                } label: {
                    Label {
                        HStack {
                            Text("Contact us")
                            Spacer()
                            Image(systemName: "arrow.up.forward.app")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "envelope")
                            .foregroundStyle(.accent)
                    }
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $isShowingMailView, content: FeedbackMailView.init)
                
                Label("Share BenchKit", systemImage: "square.and.arrow.up")
                Label("Write a review", systemImage: "star")
            }
        }
        .headerProminence(.increased)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Close", systemImage: "xmark") {
                dismiss()
            }
        }
        .isNavigationStack()
    }
    
    private func shareApp() {
        TelemetryDeck.signal(Analytics.sentFeedback.id)
    
//        let url = URL(string: "")!
//
//        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//
//        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true)
    }
    
    private func leaveReviewAndRating() {
//        if let url = URL(string: ""),
//           UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
    }
    
    func toggleAppLock() {
        guard appLock == false else { return }
        
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    // authenticated successfully
                    appLock = true
                } else {
                    // there was a problem
                    appLock = false
                }
            }
        } else {
            // no biometrics
            appLock = false
        }
    }
}
