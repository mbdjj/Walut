//
//  CurrencyOverviewViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 12/02/2023.
//

import SwiftUI

class CurrencyChartViewModel: ObservableObject {
    
    @Published var currency: Currency
    let base: Currency
    
    @Published var shouldDisableChartButton = true
    
    var isCustom: Bool { SharedDataManager.shared.isCustomDate }
    var customDate: Date { SharedDataManager.shared.customDate }
    
    private let networkManager = NetworkManager.shared
    
    init(currency: Currency, base: Currency) {
        self.currency = currency
        self.base = base
        
        Task {
            await refreshData()
        }
    }
    
    func refreshData() async {
        do {
            if isCustom {
                let data = try await networkManager.getChartData(for: currency, base: base, date: customDate)
                await loadData(with: data)
            } else {
                let data = try await networkManager.getChartData(for: currency, base: base)
                await loadData(with: data)
            }
        } catch {
            
        }
    }
    
    @MainActor private func loadData(with data: [RatesData]) {
        withAnimation {
            self.currency.chartData = data
            self.shouldDisableChartButton = false
        }
    }
    
}
