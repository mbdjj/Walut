//
//  CalculationViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 21/11/2022.
//

import Foundation

class CalculationViewModel: ObservableObject {
    
    @Published var ratesData: [RatesData] = []
    
    var shareChartData: [RatesData] = []
    
    let base: Currency
    let foreign: Currency
    
    let decimal: Int
    
    var isCustom: Bool { SharedDataManager.shared.isCustomDate }
    var customDate: Date { SharedDataManager.shared.customDate }
    
    @Published var foreignAmount: Double = 0.0
    @Published var baseAmount: Double = 0.0
    @Published var shouldDisableChartButton = true
    
    let networkManager = NetworkManager.shared
    
    init(base: Currency, foreign: Currency, decimal: Int) {
        self.base = base
        self.foreign = foreign
        self.decimal = decimal
        
        if !SharedDataManager.shared.reduceDataUsage {
            Task {
                await refreshData()
            }
        }
    }
    
    func refreshData() async {
        do {
            if isCustom {
                let data = try await networkManager.getChartData(for: foreign, base: base, date: customDate)
                loadData(with: data)
            } else {
                let data = try await networkManager.getChartData(for: foreign, base: base)
                loadData(with: data)
            }
        } catch {
            
        }
    }
    
    func loadData(with data: [RatesData]) {
        DispatchQueue.main.async {
            self.ratesData = data
            self.shareChartData = data
            
            self.shouldDisableChartButton = false
        }
    }
    
}
