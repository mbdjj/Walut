//
//  SettingsViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 11/10/2022.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    @Published var selectedBase: String
    @Published var decimal: Int
    
    @Published var pickerData = [Currency]()
    
    let defaults = UserDefaults.standard
    var shared = SharedDataManager.shared
    let iconManager = AppIconManager()
    
    init() {
        selectedBase = shared.base.code
        decimal = shared.decimal
        
        for code in shared.allCodesArray {
            self.pickerData.append(Currency(baseCode: code))
        }
    }
    
    func saveBase() {
        shared.base = Currency(baseCode: selectedBase)
        defaults.set(selectedBase, forKey: "base")
        iconManager.changeIcon(to: selectedBase)
    }
    
    func saveDecimal() {
        shared.decimal = decimal
        defaults.set(decimal, forKey: "decimal")
    }
    
}
