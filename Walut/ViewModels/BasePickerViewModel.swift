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
    private let shared = SharedDataManager.shared
    
    init() {
        currencyArray = shared.allCodesArray
            .map { Currency(baseCode: $0) }
        
        self.selected = Locale.current.currency?.identifier ?? "AUD"
    }
    
    
    func saveAndContinue() {
        defaults.set(name, forKey: "name")
        defaults.set([0], forKey: "titleIDArray")
        defaults.set(0, forKey: "chosenTitle")
        defaults.set(decimal, forKey: "decimal")
        defaults.set(selected, forKey: "base")
        defaults.set(true, forKey: "isBaseSelected")
        defaults.set(true, forKey: "showPercent")
        defaults.set(true, forKey: "byFavorite")
        defaults.set(true, forKey: "reduceData")
        
        shared.name = name
        shared.base = Currency(baseCode: selected)
        shared.decimal = decimal
        shared.showPercent = true
        shared.sortByFavorite = true
        shared.reduceDataUsage = true
        
        AppIcon.changeIcon(to: selected)
        
        DispatchQueue.main.async {
            withAnimation {
                self.shared.appState = .baseSelected
            }
        }
    }
    
}
