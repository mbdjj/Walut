//
//  SwiftDataManager.swift
//  Walut
//
//  Created by Marcin Bartminski on 20/12/2023.
//

import Foundation
import SwiftData

struct SwiftDataManager {
    @MainActor
    static func saveCurrencies(data: [Currency], base: String = SharedDataManager.shared.base.code, to modelContext: ModelContext) {
        do {
            let savedCurrencies = try modelContext.fetch(FetchDescriptor<SavedCurrency>())
            let nextUpdate = UserDefaults(suiteName: "group.dev.bartminski.Walut")!.integer(forKey: "nextUpdate")
            
            data.forEach { item in
                if !savedCurrencies.contains(where: { $0.code == item.code && $0.base == base && $0.nextRefresh == nextUpdate }) {
                    let newSaved = SavedCurrency(code: item.code, base: base, rate: item.rate, nextRefresh: nextUpdate)
                    modelContext.insert(newSaved)
                    print("Saved \(item.code) to SwiftData")
                }
            }
        } catch {
            print("Error: Saving currencies failed")
        }
    }
    
    static func getCurrencies(from modelContext: ModelContext) -> [Currency] {
        do {
            let savedCurrencies = try modelContext.fetch(FetchDescriptor<SavedCurrency>())
            let shared = SharedDataManager.shared
            let nextUpdate = UserDefaults(suiteName: "group.dev.bartminski.Walut")!.integer(forKey: "nextUpdate")
            
            let currencies = savedCurrencies
                .filter { $0.nextRefresh == nextUpdate && $0.base == shared.base.code }
                .map { Currency(from: $0) }
                .map { currency in
                    let lastRate = savedCurrencies
                        .filter { $0.code == currency.code && $0.base == shared.base.code }
                        .sorted { $0.nextRefresh > $1.nextRefresh }
                        .dropFirst()
                        .first?
                        .rate
                    
                    if let lastRate {
                        var newCurrency = currency
                        newCurrency.lastRate = lastRate
                        return newCurrency
                    } else {
                        return currency
                    }
                }
            return currencies
        } catch {
            print("Error: Fetching currencies failed")
            return []
        }
    }
    
    @MainActor
    static func cleanData(from modelContext: ModelContext, useInterval: Bool = false) {
        do {
            let nextUpdate = UserDefaults(suiteName: "group.dev.bartminski.Walut")!.integer(forKey: "nextUpdate")
            
            if useInterval {
                let minInterval = decodeStorageOptionInterval()
                try modelContext.delete(model: SavedCurrency.self, where: #Predicate {
                    $0.nextRefresh < minInterval || $0.nextRefresh > nextUpdate - (12 * 3600) && $0.nextRefresh < nextUpdate
                })
            } else {
                try modelContext.delete(model: SavedCurrency.self, where: #Predicate {
                    $0.nextRefresh > nextUpdate - (12 * 3600) && $0.nextRefresh < nextUpdate
                })
            }
            
            print("Old data successfully deleted")
        } catch {
            print("Error: Couldn't delete old data")
        }
    }
    
    static func decodeStorageOptionInterval() -> Int {
        var timestamp = Date().timeIntervalSince1970
        switch SharedDataManager.shared.storageOption {
        case .twoDays:
            timestamp -= 86400 * 2
        case .oneWeek:
            timestamp -= 86400 * 7
        case .oneMonth:
            timestamp -= 86400 * 30
        case .threeMonths:
            timestamp -= 86400 * 90
        case .sixMonths:
            timestamp -= 86400 * 180
        case .oneYear:
            timestamp -= 86400 * 365
        }
        return Int(timestamp)
    }
    
    @MainActor
    static func getWidgetData(for code: String, base: String, from modelContext: ModelContext) -> Currency? {
        let descriptor = FetchDescriptor<SavedCurrency>()
        let saved = try? modelContext.fetch(descriptor)
        let nextUpdate = UserDefaults(suiteName: "group.dev.bartminski.Walut")!.integer(forKey: "nextUpdate")
        let currency = saved?
            .filter { $0.nextRefresh == nextUpdate && $0.base == base }
            .map { Currency(from: $0) }
            .filter { $0.code == code }
            .first
        
        return currency
    }
    
    static func getLastRate(for code: String, base: String, from savedCurrencies: [SavedCurrency]?) -> Double? {
        let lastRate = savedCurrencies?
            .filter { $0.code == code && $0.base == base }
            .sorted { $0.nextRefresh > $1.nextRefresh }
            .dropFirst()
            .first?
            .rate
        
        return lastRate
    }
    
    static func getChartData(for code: String, base: String, from savedCurrencies: [SavedCurrency]?) -> [RatesData] {
        let chartData = savedCurrencies?
            .filter { $0.code == code && $0.base == base }
            .sorted { $0.nextRefresh < $1.nextRefresh }
            .map { RatesData(from: $0) }
            .uniqued()
        
        return chartData ?? []
    }
}
