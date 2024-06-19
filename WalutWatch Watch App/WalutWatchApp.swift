//
//  WalutWatchApp.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 11/03/2023.
//

import SwiftUI
import SwiftData

@main
struct WalutWatch_Watch_AppApp: App {
    
    @State var settings = AppSettings()
    
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
            ContentView(modelContext: container.mainContext, settings: settings)
                .environment(settings)
                .modelContainer(container)
        }
    }
}
