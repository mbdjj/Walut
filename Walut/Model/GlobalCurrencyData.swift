//
//  GlobalCurrencyData.swift
//  Walut
//
//  Created by Marcin Bartminski on 15/06/2024.
//

import SwiftUI

@Observable class GlobalCurrencyData {
    var appstate: AppState
    
    var user: User?
    
    var baseCurrency: Currency?
    var currencyDataLoading: Bool
    var baseCurrencyData: [Currency]
    
    let defaults = UserDefaults.standard
    let sharedDefaults = UserDefaults(suiteName: "group.dev.bartminski.Walut")!
    
    init() {
        let baseCode = defaults.string(forKey: "base")
        let baseSelected = (baseCode != nil)
        
        appstate = baseSelected ? .baseSelected : .onboarding
        
        user = User.loadUser()
        
        baseCurrency = if let baseCode { Currency(baseCode: baseCode) } else { nil }
        baseCurrencyData = []
        currencyDataLoading = true
    }
}
