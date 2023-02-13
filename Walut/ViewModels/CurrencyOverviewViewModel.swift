//
//  CurrencyOverviewViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 12/02/2023.
//

import SwiftUI

class CurrencyOverviewViewModel: ObservableObject {
    
    @Published var currency: Currency
    let base: Currency
    
    @Published var shouldDisableChartButton = true
    
    var isCustom: Bool { SharedDataManager.shared.isCustomDate }
    var customDate: Date { SharedDataManager.shared.customDate }
    var decimal: Int { SharedDataManager.shared.decimal }
    
    @Published var foreignAmount: Double = 0.0
    @Published var baseAmount: Double = 0.0
    
    @Published var infoLineLimit: Int? = 8
    
    let networkManager = NetworkManager.shared
    
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
                loadData(with: data)
            } else {
                let data = try await networkManager.getChartData(for: currency, base: base)
                loadData(with: data)
            }
        } catch {
            
        }
    }
    
    private func loadData(with data: [RatesData]) {
        DispatchQueue.main.async {
            withAnimation {
                self.currency.chartData = data
                self.shouldDisableChartButton = false
            }
        }
    }
    
    func handleFavorites() {
        if !currency.isFavorite {
            favorite(currency: currency)
        } else {
            unfavorite(currency: currency)
        }
        
        UserDefaults.standard.set(SharedDataManager.shared.favorites, forKey: "favorites")
    }
    
    private func favorite(currency: Currency) {
        SharedDataManager.shared.favorites.append(currency.code)
    }
    
    private func unfavorite(currency: Currency) {
        if let i = SharedDataManager.shared.favorites.firstIndex(where: { currency.code == $0 }) {
            SharedDataManager.shared.favorites.remove(at: i)
        }
    }
    
}
