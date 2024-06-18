//
//  BasePickerViewModel.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 12/03/2023.
//

import SwiftUI

@Observable class BasePickerViewModel {
    
    var selectedCurrency: String
    
    init() {
        selectedCurrency = Locale.current.currency?.identifier ?? "AUD"
    }
    
    
    func saveBase() {
        Defaults.saveBaseCode(selectedCurrency)
        Defaults.saveByFavorite(true)
        Defaults.saveDecimal(3)
    }
    
}
