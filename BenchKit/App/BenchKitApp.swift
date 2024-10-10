//
//  BenchKitApp.swift
//  BenchKit
//
//  Created by Kuba on 10/9/24.
//

import SwiftUI
import LocalAuthentication
import KubaComponents
import TelemetryClient
import WishKit
import RevenueCat

@main
struct BenchKitApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistence = PersistenceController.shared
    
    @StateObject var dataModel = DataModel.shared
    @StateObject var purchaseManager = PurchaseManager.shared
    @StateObject var networkManager = NetworkManager.shared
    @StateObject private var qaService = QuickActionsManager.shared
    
    @Environment(\.openURL) var openURL
    @Environment(\.scenePhase) var scenePhase
    @AppStorage(Defaults.appLock) var appLock = false
    @State private var appIsLocked = false
    
    init() {
        // RevenueCat
        Purchases.configure(withAPIKey: "appl_mZbRPiEJmjcuWZWKOknphyAQAMS")
        Purchases.logLevel = .verbose
        
        // TelemetryDeck
        let configuration = TelemetryManagerConfiguration(appID: "549FD258-998B-4E95-BD4A-2F8458B89C61")
        TelemetryDeck.initialize(config: configuration)
        
        // WishKit
        WishKit.configure(with: "67E6D14A-8604-4991-861F-61FB392F43BE")
        
        // TODO: implement WishKit
    }
    
    var content: some View {
        ZStack {
            RootView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .environmentObject(persistence)
                .environmentObject(dataModel)
                .environmentObject(purchaseManager)
                .environmentObject(networkManager)
            
            if appIsLocked {
                appLockView
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            content
                .onChange(of: scenePhase) { _, newValue in
                    switch newValue {
                    case .background:
                        addQuickActions()
                    default:
                        break
                    }
                }
                .sheet(item: $qaService.action) { action in
                    switch action {
                    case .feedback: FeedbackMailView()
                    case .rating:
                        Image(systemName: "star").onAppear {
                            openURL(URL(string: "https://kubamilcarz.com/benchkit")!)
                        }
                    }
                }
                .onChange(of: scenePhase) { _, newPhase in
                    if appLock {
                        switch newPhase {
                        case .background, .inactive:
                            withAnimation {
                                appIsLocked = true
                            }
                        case .active:
                            if appIsLocked {
                                unlock()
                            }
                        default: break
                        }
                    }
                    
                }
                .onAppear {
                    if appLock {
                        appIsLocked = true
                        Task.detached { @MainActor in
                            unlock()
                        }
                    } else {
                        appIsLocked = false
                    }
                }
        }
    }
    
    
    private var appLockView: some View {
        VStack(spacing: 15) {
            VStack(spacing: 0) {
                Image(systemName: "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(spacing: 10) {
                    Image(.logo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipShape(.rect(cornerRadius: 90*2/9))
                    
                    Text("BenchKit")
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 5)
            }
            
            Text("Unlock with biometrics to continue")
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
            
            VStack(spacing: 0) {
                Spacer()
                Spacer()
                Spacer()
            }
                
            Button {
                unlock()
            } label: {
                Text("Unlock")
                    .padding(.horizontal, 5)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, ignoresSafeAreaEdges: .all)
    }
    
    
    private func unlock() {
        //        guard appLock else { return }
        
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    appIsLocked = false
                    appLock = true
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
            appIsLocked = false
            appLock = false
        }
    }
    
    
    func addQuickActions() {
        UIApplication.shared.shortcutItems = [
            UIApplicationShortcutItem(type: "com.kubamilcarz.benchkit.qa.feedback", localizedTitle: "Something wrong?", localizedSubtitle: "Tell us what's wrong, so we'll fix it!", icon: UIApplicationShortcutIcon.init(type: .mail), userInfo: ["com.kubamilcarz.benchkit.qa.feedback": "com.kubamilcarz.benchkit.qa.feedback" as NSSecureCoding]),
            UIApplicationShortcutItem(type: "com.kubamilcarz.benchkit.qa.rating", localizedTitle: "Rate BenchKit", localizedSubtitle: "How do you like BenchKit so far?", icon: UIApplicationShortcutIcon.init(type: .favorite), userInfo: ["om.kubamilcarz.benchkit.qa.rating": "om.kubamilcarz.benchkit.qa.rating" as NSSecureCoding])
        ]
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            QuickActionsManager.shared.action = QuickActionsManager.QA(shortcutItem: shortcutItem)
        }
        
        let configuration = UISceneConfiguration(name: connectingSceneSession.configuration.name, sessionRole: connectingSceneSession.role)
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        QuickActionsManager.shared.action = QuickActionsManager.QA(shortcutItem: shortcutItem)
    }
}


class QuickActionsManager: ObservableObject {
    static let shared = QuickActionsManager()
    
    @Published var action: QA?
    
    
    
    enum QuickAction: String {
        case feedback = "com.kubamilcarz.benchkit.qa.feedback"
        case rating = "com.kubamilcarz.benchkit.qa.rating"
    }
    
    enum QA: String, Equatable, Identifiable {
        case feedback = "com.kubamilcarz.benchkit.qa.feedback"
        case rating = "com.kubamilcarz.benchkit.qa.rating"
        
        var id: UUID { UUID() }
        
        init?(shortcutItem: UIApplicationShortcutItem) {
            guard let action = QuickAction(rawValue: shortcutItem.type) else {
                return nil
            }
            
            switch action {
            case .feedback:
                self = .feedback
            case .rating:
                self = .rating
            }
        }
    }
}

