//
//  DataModel.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import Foundation
import CoreData

class DataModel: ObservableObject {
    
    static let shared = DataModel(context: PersistenceController.shared.container.viewContext)
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    @Published var isShowingPaywall = false
    @Published var isShowingSettings = false
    @Published var isShowingWhatsNew = false
    
}
