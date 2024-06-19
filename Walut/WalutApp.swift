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
    @State var appSettings = AppSettings()
    @State var mainCurrencyData: MainCurrencyData
    @StateObject var networkMonitor = NetworkMonitor()
    
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
            ViewManagingView()
                .environment(appSettings)
                .environment(mainCurrencyData)
                .environmentObject(networkMonitor)
                .modelContainer(container)
        }
    }
}
