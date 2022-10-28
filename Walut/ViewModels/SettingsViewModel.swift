//
//  SettingsViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 11/10/2022.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    @Published var name: String
    
    @Published var selectedBase: String
    @Published var decimal: Int
    
    @Published var secretCode = ""
    @Published var shouldDisplayAlert: Bool = false
    @Published var titleIDToSave = 0
    
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    @Published var pickerData = [Currency]()
    
    var letter: String { "\(name.first!)" }
    
    let defaults = UserDefaults.standard
    var shared = SharedDataManager.shared
    let iconManager = AppIconManager()
    
    init() {
        name = shared.name
        
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
    
    func saveTitles() {
        shared.titleIDArray.append(titleIDToSave)
        shared.defaults.set(shared.titleIDArray, forKey: "titleIDArray")
    }
    
    func checkCode() {
        if let secretID = shared.secretDictionary[secretCode] {
            if shared.titleIDArray.firstIndex(of: secretID) == nil {
                titleIDToSave = secretID
                
                let t = shared.titleArray[secretID]
                alertTitle = "Unlocked new title!"
                alertMessage = "You have unlocked the \(t) title! You can equip it in you profile."
            } else {
                alertTitle = "You already have this title."
                alertMessage = "You've unlocked this title in the past. No worries, you already have it."
            }
        } else {
            alertTitle = "Invalid code"
            alertMessage = "Unfortunately there is no title for this code (yet)."
        }
        
        secretCode = ""
    }
    
}
