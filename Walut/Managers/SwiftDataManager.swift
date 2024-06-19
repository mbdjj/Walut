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
    static func saveCurrencies(data: [Currency], base: String = Defaults.baseCode()!, to modelContext: ModelContext) {
        do {
            let savedCurrencies = try modelContext.fetch(FetchDescriptor<SavedCurrency>())
            let nextUpdate = Defaults.nextUpdateInterval()
            
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
    
    @MainActor
    static func getCurrencies(from modelContext: ModelContext, baseCode: String) -> [Currency] {
        do {
            let savedCurrencies = try modelContext.fetch(FetchDescriptor<SavedCurrency>())
            let nextUpdate = Defaults.nextUpdateInterval()
            
            let currencies = savedCurrencies
                .filter { $0.nextRefresh == nextUpdate && $0.base == baseCode }
                .map { Currency(from: $0) }
                .map { currency in
                    let lastRate = getLastRate(for: currency.code, base: baseCode, from: savedCurrencies)
                    
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
    static func cleanData(from modelContext: ModelContext, useInterval: Bool = false, storageOption: StorageSavingOptions? = nil) {
        do {
            let nextUpdate = Defaults.nextUpdateInterval()
            
            if useInterval {
                guard let storageOption else { print("No storage option provided!"); return }
                let minInterval = decodeStorageOptionInterval(from: storageOption)
                try modelContext.delete(model: SavedCurrency.self, where: #Predicate {
                    $0.nextRefresh < minInterval || $0.nextRefresh > nextUpdate - (6 * 3600) && $0.nextRefresh < nextUpdate
                })
            } else {
                try modelContext.delete(model: SavedCurrency.self, where: #Predicate {
                    $0.nextRefresh > nextUpdate - (6 * 3600) && $0.nextRefresh < nextUpdate
                })
            }
            
            print("Old data successfully deleted")
        } catch {
            print("Error: Couldn't delete old data")
        }
    }
    
    static func decodeStorageOptionInterval(from option: StorageSavingOptions) -> Int {
        var timestamp = Date().timeIntervalSince1970
        switch option {
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
        let nextUpdate = Defaults.nextUpdateInterval()
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
    
    @MainActor
    static func getAllSavedData(from modelContext: ModelContext) -> [SavedCurrency]? {
        return try? modelContext.fetch(FetchDescriptor<SavedCurrency>())
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
