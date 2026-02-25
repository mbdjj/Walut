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
    
    @State var appSettings = AppSettings()
    @State var mainCurrencyData: MainCurrencyData
    
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(
                for: SavedCurrency.self,
                migrationPlan: SavedCurrencyMigrationPlan.self
            )
            mainCurrencyData = MainCurrencyData(modelContext: container.mainContext)
            mainCurrencyData.updateBase(appSettings.baseCurrency)
        } catch {
            fatalError("Failed to initialize model container.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appSettings)
                .environment(mainCurrencyData)
                .modelContainer(container)
        }
    }
}
