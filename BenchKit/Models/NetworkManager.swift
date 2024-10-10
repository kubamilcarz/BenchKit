//
//  NetworkManager.swift
//  BenchKit
//
//  Created by Kuba on 10/10/24.
//

import Network
import Foundation
import UIKit

class NetworkManager: ObservableObject {
    
    static let shared = NetworkManager()
    
    let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected = false

    init() {
        monitor.pathUpdateHandler =  { [weak self] path in
           DispatchQueue.main.async {
               self?.isConnected = path.status == .satisfied ? true : false
           }
       }
       monitor.start(queue: queue)
    }
}
