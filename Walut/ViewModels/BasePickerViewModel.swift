//
//  BasePickerViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 07/10/2022.
//

import Foundation

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
    let shared = SharedDataManager.shared
    
    init() {
        for code in shared.allCodesArray {
            currencyArray.append(Currency(baseCode: code))
        }
        
        self.selected = Locale.current.currency?.identifier ?? "AUD"
    }
    
    
    func saveAndContinue() {
        defaults.set(name, forKey: "name")
        defaults.set(decimal, forKey: "decimal")
        defaults.set(selected, forKey: "base")
        defaults.set(true, forKey: "isBaseSelected")
        
        iconManager.changeIcon(to: selected)
        
        shouldDisplayFullScreenCover.toggle()
    }
    
}
