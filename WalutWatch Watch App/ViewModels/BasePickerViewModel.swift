//
//  BasePickerViewModel.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 12/03/2023.
//

import SwiftUI

class BasePickerViewModel: ObservableObject {
    
    @Published var selectedCurrency: String
    
    let defaults = UserDefaults.standard
    let shared = SharedDataManager.shared
    
    init() {
        selectedCurrency = Locale.current.currency?.identifier ?? shared.base.code
    }
    
    
    func selectBase() {
        defaults.set(selectedCurrency, forKey: "base")
        defaults.set(true, forKey: "isBaseSelected")
        defaults.set(true, forKey: "byFavorite")
        shared.base = Currency(baseCode: selectedCurrency)
        shared.sortByFavorite = true
        
        DispatchQueue.main.async {
            self.shared.appState = .baseSelected
        }
    }
    
}
