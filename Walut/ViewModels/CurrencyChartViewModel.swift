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
    
    init(currency: Currency, base: Currency) {
        self.currency = currency
        self.base = base
    }
    
}
