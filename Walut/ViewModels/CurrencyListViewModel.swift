//
//  CurrencyListViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI

class CurrencyListViewModel: ObservableObject {
    
    @Published var baseCurrency: Currency
    @Published var currencyArray = [Currency]()
    
    @Published var decimal: Int
    
    let defaults = UserDefaults.standard
    
    init() {
        
        baseCurrency = Currency(baseCode: defaults.string(forKey: "base") ?? "PLN")
        decimal = defaults.integer(forKey: "decimal")
        
    }
    
}
