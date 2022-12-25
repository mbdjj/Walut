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
    @Published var shouldDisplayFullScreenCover = false
    
    let defaults = UserDefaults.standard
    let iconManager = AppIconManager()
    var shared = SharedDataManager.shared
    
    init() {
        for code in shared.allCodesArray {
            currencyArray.append(Currency(baseCode: code))
        }
        
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
        
        shared.name = name
        shared.base = Currency(baseCode: selected)
        shared.decimal = decimal
        shared.showPercent = true
        shared.sortByFavorite = true
        
        iconManager.changeIcon(to: selected)
        
        DispatchQueue.main.async {
            withAnimation {
                self.shared.isBaseSelected = true
            }
        }
    }
    
}
