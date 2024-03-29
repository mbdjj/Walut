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
    
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(
                for: SavedCurrency.self,
                migrationPlan: SavedCurrencyMigrationPlan.self
            )
        } catch {
            fatalError("Failed to initialize model container.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ViewManagingView()
                .environmentObject(networkMonitor)
                .modelContainer(container)
        }
    }
}
