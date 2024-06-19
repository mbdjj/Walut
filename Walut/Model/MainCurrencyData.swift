//
//  MainCurrencyData.swift
//  Walut
//
//  Created by Marcin Bartminski on 19/06/2024.
//

import SwiftUI
import SwiftData

@Observable class MainCurrencyData {
    var allCurrencyData: [Currency]
    private var baseCurrency: Currency?
    
    var loading = false
    var dataUpdateControlNumber: Int = 0
    
    var errorMessage = ""
    var shouldDisplayErrorAlert = false
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.allCurrencyData = StaticData.currencyCodes.map { Currency(baseCode: $0) }
        self.modelContext = modelContext
    }
    
    func updateBase(_ base: Currency?) {
        baseCurrency = base
        Task {
            await checkRefresh()
        }
    }
    
    @MainActor
    func checkRefresh() async {
        guard baseCurrency != nil else { return }
        loading = true
        if API.shouldRefresh() {
            let fetchedData = await fetchCurrencyData()
            SwiftDataManager.saveCurrencies(data: fetchedData, to: modelContext)
            SwiftDataManager.cleanData(from: modelContext)
            guard !fetchedData.isEmpty else {
                let loaded = loadCurrencyData()
                updateCurrencies(with: loaded)
                return
            }
            updateCurrencies(with: fetchedData)
        } else if dataUpdateControlNumber == 0 {
            SwiftDataManager.cleanData(from: modelContext)
            let loadedData = loadCurrencyData()
            guard !loadedData.isEmpty else {
                let fetched = await fetchCurrencyData()
                SwiftDataManager.saveCurrencies(data: fetched, to: modelContext)
                updateCurrencies(with: fetched)
                return
            }
            updateCurrencies(with: loadedData)
        }
    }
    
    @MainActor
    func fetchCurrencyData() async -> [Currency] {
        guard let baseCurrency else { return [] }
        do {
            let data = try await API.fetchCurrencyRates(for: baseCurrency)
            let saved = SwiftDataManager.getAllSavedData(from: modelContext)
            let newData = data.map { currency in
                guard let lastRate = SwiftDataManager.getLastRate(for: currency.code, base: baseCurrency.code, from: saved) else {
                    return currency
                }
                var newCurrency = currency
                newCurrency.lastRate = lastRate
                return newCurrency
            }
            return newData
        } catch {
            DispatchQueue.main.async {
                if let error = error as? API.APIError {
                    self.errorMessage = error.localizedDesc
                } else {
                    self.errorMessage = error.localizedDescription
                }
                self.shouldDisplayErrorAlert = true
            }
            return []
        }
    }
    
    @MainActor
    func loadCurrencyData() -> [Currency] {
        guard let baseCurrency else { return [] }
        let data = SwiftDataManager.getCurrencies(from: modelContext, baseCode: baseCurrency.code)
        return Sorting.byCode(data, direction: .ascending)
    }
    
    @MainActor
    func updateCurrencies(with array: [Currency]) {
        allCurrencyData = array
        loading = false
        dataUpdateControlNumber += 1
    }
}
