//
//  BasePickerViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 07/10/2022.
//

import SwiftUI

class BasePickerViewModel: ObservableObject {
    
    @Published var currencyArray = [Currency]()
    @Published var selected = "AUD"
    
    @Published var name = ""
    @Published var shouldNameTextFieldBeFocused = true
    
    @Published var decimal = 3
    
    @Published var saveButtonDisabled = true
    
    private let defaults = UserDefaults.standard
    //private let shared = SharedDataManager.shared
    
    init() {
        currencyArray = StaticData.currencyCodes
            .map { Currency(baseCode: $0) }
        
        self.selected = Locale.current.currency?.identifier ?? "AUD"
    }
    
    
    func saveUserData() {
        Defaults.saveUserName(name)
        Defaults.saveDecimal(decimal)
        Defaults.saveBaseCode(selected)
        Defaults.saveShowPercent(true)
        Defaults.saveByFavorite(true)
        
        AppIcon.changeIcon(to: selected)
    }
    
}
