//
//  PurchaseManager.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import SwiftUI
import StoreKit

class PurchaseManager: ObservableObject {
    
    static let shared = PurchaseManager()
    
    private var productIds: [String] {
        let (isSpecial, _) = isTodaySpecial()
        
        if isSpecial {
            return ["com.benchkit.plus.annual.sale", "com.benchkit.plus.lifetime.sale"]
        } else {
            return ["com.benchkit.plus.annual", "com.benchkit.plus.lifetime"]
        }
    }
    
    // MARK: - Constants
//    static let TripsLimitConstant: Int = 3
//    static let MomentsLimitConstant: Int = 3
//   
//    static let TripsLimit = String(localized: "Get Escape+ to add more trips.")
//    static let MomentsLimit = String(localized: "Get Escape+ to add more moments.")
    
    @Published private(set) var products: [Product] = []
    private var productsLoaded = false
    
    private var updates: Task<Void, Never>? = nil
    
    @Published private(set) var purchasedProductIDs = Set<String>()
    
    var hasUnlockedPlus: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    init() {
       updates = observeTransactionUpdates()
    }
    
    deinit {
        updates?.cancel()
    }
    
    
    func isTodaySpecial() -> (Bool, String) {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let specialDates: [DateComponents: String] = [
            // 3-day birthday celebration
            DateComponents(month: 6, day: 17): String(localized: "Birthday Sale"),
            DateComponents(month: 6, day: 18): String(localized: "Birthday Sale"),
            DateComponents(month: 6, day: 19): String(localized: "Birthday Sale"),
            
            // annual
            DateComponents(month: 1, day: 1): String(localized: "New Year's Sale"),
            DateComponents(month: 2, day: 14): String(localized: "Valentine's Day Sale"),
            DateComponents(month: 3, day: 8): String(localized: "Women's Day Sale"),
            DateComponents(month: 4, day: 22): String(localized: "Earth Day's Sale"),
            DateComponents(month: 7, day: 4): String(localized: "Independence Day's Sale"),
            DateComponents(month: 12, day: 23): String(localized: "Christmas Sale"),
            DateComponents(month: 12, day: 24): String(localized: "Christmas Sale"),
            DateComponents(month: 12, day: 25): String(localized: "Christmas Sale"),
            DateComponents(month: 12, day: 26): String(localized: "Christmas Sale"),
            DateComponents(month: 12, day: 27): String(localized: "Christmas Sale"),
            DateComponents(month: 12, day: 31): String(localized: "New Year's Sale"),
        ]
        
        let specialDatesWithYear = specialDates.compactMap { (components, title) -> (Date?, String)? in
            var yearComponents = components
            yearComponents.year = calendar.component(.year, from: currentDate)
            return (calendar.date(from: yearComponents), title)
        }
        
        for (date, title) in specialDatesWithYear {
            if let date = date, calendar.isDate(date, inSameDayAs: currentDate) {
                return (true, title)
            }
        }
        
        return (false, "")
    }
    
    
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.products = products.sorted { $0.price < $1.price }
        self.productsLoaded = true
    }
    
    func purchase(_ product: Product) async throws {
        #if os(visionOS)
        if let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let result = try await product.purchase(confirmIn: scene)
            
            switch result {
            case .success(let verificationResult):
                // Handle the successful transaction
                switch verificationResult {
                case .verified(let transaction):
                    // Transaction is verified. Update your app state or unlock features.
                    await updatePurchasedProducts()
//                    AnalyticsManager.shared.log(.purchasedPlus)
                    
                default: break
                    // Handle other verification results
                }
                
            case .pending: break
                // Handle pending transaction
                
            case .userCancelled: break
                // Handle user cancellation
                
            default: break
                // Handle other cases
            }
        }
        #else
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
            
        case .success(_):
            break
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            break
        case .userCancelled:
            // ^^^
            break
        @unknown default:
            break
        }
        #endif
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task { [unowned self] in
            for await _ in Transaction.updates {
                // Using verificationResult directly would be better
                // but this way works for this tutorial
                await self.updatePurchasedProducts()
            }
        }
    }
}
