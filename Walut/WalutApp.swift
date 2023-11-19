//
//  WalutApp.swift
//  Walut
//
//  Created by Marcin Bartminski on 07/10/2022.
//

import SwiftUI
import SwiftData

@main
struct WalutApp: App {
    @StateObject var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            ViewManagingView()
                .environmentObject(networkMonitor)
                .modelContainer(for: SavedCurrency.self)
        }
    }
}
