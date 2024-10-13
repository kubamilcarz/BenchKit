//
//  PaywallView.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import StoreKit
import SwiftUI
import TelemetryClient
import KubaComponents

struct PremiumFeatures: Identifiable {
    var id = UUID()
    var title: LocalizedStringKey
    var subtitle: LocalizedStringKey
    var icon: String
}

struct Opinion: Identifiable {
    var id = UUID()
    var title: LocalizedStringKey
    var review: LocalizedStringKey
    var name: String
}

struct PaywallView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
//    @EnvironmentObject private var analytics: AnalyticsManager
    
    @State private var chosenProduct = PlusProduct.lifetime
    @AppStorage(Defaults.hapticsOn) var allowsHaptics = true
    
    @State private var isShowingManageSubscription = false
    @State private var isLoading = true
    
    var isNested: Bool
    var isSimple: Bool
    var isOnboarding: Bool
    
    init(isNested: Bool = false, isSimple: Bool = false, isOnboarding: Bool = false) {
        self.isNested = isNested
        self.isSimple = isSimple
        self.isOnboarding = isOnboarding
    }
    
    enum PlusProduct: String {
        case monthly = "com.kubamilcarz.benchkit.monthly", monthlySale = "com.kubamilcarz.benchkit.monthly.sale"
        case annual = "com.kubamilcarz.benchkit.annual", annualSale = "com.kubamilcarz.benchkit.annual.sale"
        case lifetime = "com.kubamilcarz.benchkit.lifetime", lifetimeSale = "com.kubamilcarz.benchkit.lifetime.sale"
    }
    
    var premiumFeatures: [PremiumFeatures] = [
        // TODO: premium features
    ]
    
    let opinions: [Opinion] = [
        // TODO: testimonials
    ]
    
    var body: some View {
        if isNested {
            content
        } else {
            NavigationStack {
                content
            }
        }
    }
    
    var content: some View {
        ZStack(alignment: .top) {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    VStack(spacing: 15) {
                        Image("logo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 90)
                            .clipShape(.rect(cornerRadius: 90*2/9))
                        
                        Text("Workout Tracking, Unlimited with BenchKit+")
                            .foregroundStyle(.accent.gradient)
                            .font(.title2)
                            .bold()
                            .padding(.top, 10)
                        
                        let (specialDate, title) = purchaseManager.isTodaySpecial()
                        
                        if specialDate {
                            Text("Celebrate \(title) with 50% sale!")
                                .font(.headline)
                                .foregroundStyle(.accent.secondary)
                        }
                    }
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, isOnboarding ? 90 : 0)
                    
                    VStack(spacing: 30) {
                        if !purchaseManager.hasUnlockedPlus {
                            if isLoading {
                                VStack {
                                    ProgressView()

                                    Text("Fetching offers...")
                                        .font(.title3.bold())
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 50)
                                .foregroundStyle(.accent.gradient)
                            } else {
                                PlanList
                            }
                            
                            Features
                            
                            SocialProof
                            
                            VStack(spacing: 15) {
                                HStack(spacing: 10) {
                                    Image(systemName: "dumbbell.fill")
                                        .font(.title3.bold())
                                        .foregroundStyle(.accent.gradient)
                                        .symbolRenderingMode(.hierarchical)
                                    
                                    Text("Choose your Plan")
                                        .font(.title3)
                                        .bold()
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: .infinity)
                                
                                PlanList
                            }
                        } else {
                            VStack(spacing: 10) {
                                Text("Welcome to BenchKit+")
                                    .font(.title2.bold())
                                    .foregroundStyle(.accent.gradient)
                                
                                Text("Enjoy your access to a range of essential features!") // TODO: UX copy
                                Text("Thank you for subscribing and supporting BenchKit.")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.top, isNested ? 30 : 65)
                            
                            Features
                            
                            PlanList.disabled(true)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 100)
                }
                .padding(.bottom, 75)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 15) {
                    PurchaseButton
                        .padding(.horizontal, isSimple && isNested ? 44 : 15)

                    HStack(spacing: 30) {
                        Link("Terms of Use", destination: BenchKit.terms)

                        Link("Privacy Policy", destination: BenchKit.privacy)
                        
                        Button("Restore") {
                            Task {
                                do {
                                    try await AppStore.sync()
                                } catch {
                                    print(error)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
                    .font(.caption)
                }
                .background(
                    BlurView(removeAllFilters: true)
                        .ignoresSafeArea(.container, edges: .bottom)
                        .blur(radius: 30)
                        .padding([.bottom, .horizontal], -200)
                )
            }
            .background(!isSimple ? LinearGradient(colors: [.accent.opacity(0.1), .accent.opacity(0.5)], startPoint: .bottom, endPoint: .top).ignoresSafeArea() : nil)
            
            BlurView(removeAllFilters: true)
                .ignoresSafeArea(.container, edges: .top)
                .blur(radius: 30)
                .padding([.top, .horizontal], -200)
                .frame(height: 40)
                .padding(.top, isOnboarding ? 0 : -40)
            
            if !isNested {
                CloseButton
                    .padding(.top, isOnboarding ? 60 : 0)
            }
        }
        #if !os(macOS)
        .manageSubscriptionsSheet(isPresented: $isShowingManageSubscription)
        #endif
        .task {
            do {
                try await purchaseManager.loadProducts()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        isLoading = false
                        
                        let (isSpecial, _) = purchaseManager.isTodaySpecial()
                        
                        if isSpecial {
                            chosenProduct = .annualSale
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        .onDisappear { isLoading = true }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("BenchKit+")
                    .font(.headline)
                    .foregroundStyle(LinearGradient(colors: [.primary, .accent], startPoint: .topLeading, endPoint: .bottomTrailing))
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                if isNested {
                    Button {
                        #if os(iOS)
                        if allowsHaptics {
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                        }
                        #endif
                        dismiss()
                    } label: {
                        Label("Close", systemImage: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.accent)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var PurchaseButton: some View {
        Button {
            #if os(iOS)
            if allowsHaptics {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.impactOccurred()
            }
            #endif
            
            if !purchaseManager.hasUnlockedPlus {
                Task {
                    if let product = purchaseManager.products.first(where: { $0.id == chosenProduct.rawValue }) {
                        do {
                            try await purchaseManager.purchase(product)
                        } catch {
                            print(error)
                        }
                    }
                }
            } else {
                isShowingManageSubscription = true
            }
        } label: {
            Group {
                if purchaseManager.hasUnlockedPlus {
                    Text("Manage Subscription")
                } else {
                    Text(chosenProduct == .annual ? "Try For Free" : "Get BenchKit+")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var CloseButton: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    #if os(iOS)
                    if allowsHaptics {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }
                    #endif
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .bold()
                        .foregroundStyle(.accent.secondary)
                }
                .buttonStyle(.plain)
                .padding()
            }
            Spacer()
        }
    }
    
    private var PlanList: some View {
        VStack(spacing: 15) {
            ForEach(purchaseManager.products.filter { !purchaseManager.hasUnlockedPlus ? true : $0.id == purchaseManager.purchasedProductIDs.first }) { product in
                let selected = PlusProduct(rawValue: product.id)
                
                if selected == .annual || selected == .annualSale {
                    HStack(spacing: 10) {
                        VStack { Divider() }
                        Text("OR")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        VStack { Divider() }
                    }
                }
                
                PlanItem(product: product, appProduct: selected)
            }

        }
        .padding(.vertical)
    }
    
    @ViewBuilder
    private func PlanItem(product: Product, appProduct: PlusProduct?) -> some View {
        Button {
            if let appProduct {
                #if os(iOS)
                if allowsHaptics {
                    let generator = UIImpactFeedbackGenerator(style: .soft)
                    generator.impactOccurred()
                }
                #endif
                
                withAnimation {
                    chosenProduct = appProduct
                }
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Group {
                        switch appProduct {
                        case .annual, .annualSale: Text("Annual")
                        case .lifetime, .lifetimeSale: Text("Lifetime")
                        case .monthly, .monthlySale: Text("Monthly")
                        case nil: Text("")
                        }
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Group {
                        // TODO: UX copy
                        switch appProduct {
                        case .monthly, .monthlySale:
                            Text("Ideal for a weekend escape • Now just \(product.displayPrice)/month")
                        case .annual, .annualSale:
                            Text("7 days for free • Now just \(product.displayPrice)/year")
                        case .lifetime, .lifetimeSale:
                            Text("Best Value • Now just \(product.displayPrice)")
                        default: Text("Access now for just \(product.displayPrice)")
                        }
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .tint(LinearGradient(colors: [.primary, .accent], startPoint: .topLeading, endPoint: .bottomTrailing))
                }
                
                Spacer()
                
                if appProduct == .annualSale || appProduct == .lifetimeSale {
                    Text("Save 50%")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.red)
                        .padding(7)
                        .background(.red.opacity(0.3), in: .rect(cornerRadius: 9))
                }
            }
            .padding()
            .background(
                ZStack {
                    Rectangle().fill(.regularMaterial)
                    
                    if chosenProduct == appProduct {
                        Rectangle().fill(.background)
                    }
                }
                .opacity(chosenProduct == appProduct ? 1 : 0.2)
                .clipShape(.rect(cornerRadius: 12))
            )
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.secondary.opacity(0.3), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .buttonBorderShape(.roundedRectangle(radius: 12))
    }
    
    private var Features: some View {
        VStack(spacing: 30) {
            HStack(spacing: 10) {
                Image(systemName: "gym.bag.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.title3)
                    
                Text("Most-loved Benefits")
                    .font(.title3)
                    .bold()
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)


            VStack(spacing: 20) {
                ForEach(premiumFeatures) { feature in
                    HStack(spacing: 10) {
                        Image(systemName: feature.icon)
                            .symbolRenderingMode(.hierarchical)
                            .font(.title3.bold())
                            .foregroundStyle(LinearGradient(colors: feature.icon == "heart.fill" ? [.pink, .red] : [.red, .accent], startPoint: .bottomLeading, endPoint: .topTrailing))
                            .frame(width: 44, height: 44)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(feature.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(feature.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .opacity(0.8)
                    }
                }
            }
        }
    }
    
    
    private var SocialProof: some View {
        VStack(spacing: 15) {
            HStack(spacing: 10) {
                Image(systemName: "heart.fill")
                    .font(.title3.bold())
                    .foregroundStyle(.yellow.gradient)
                
                Text("Recommended By Many")
                    .font(.title3)
                    .bold()
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            
            VStack(spacing: 15) {
                ForEach(opinions.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(opinions[index].title)
                                .font(.subheadline)
                                .bold()
                            
                            Spacer()
                            
                            HStack(spacing: 2) {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.caption2)
                                        .foregroundStyle(.yellow.gradient)
                                }
                            }
                        }
                        
                        Text(opinions[index].review)
                            .font(.caption)
                            .foregroundStyle(.primary.opacity(0.8))
                        
                        HStack {
                            Spacer()
                            
                            Text(opinions[index].name)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.thinMaterial, in: .rect(cornerRadius: 12))
                    .offset(x: index % 2 == 0 ? -15 : 15)
                }
            }
            .padding(.horizontal)
        }
    }
}

