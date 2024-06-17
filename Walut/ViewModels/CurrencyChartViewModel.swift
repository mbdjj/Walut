//
//  CurrencyOverviewViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 12/02/2023.
//

import SwiftUI

@Observable class CurrencyChartViewModel {
    
    var currency: Currency
    let base: Currency
    
    var shouldDisableChartButton = true
    
    init(currency: Currency, base: Currency) {
        self.currency = currency
        self.base = base
    }
    
}
