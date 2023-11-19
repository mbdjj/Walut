//
//  SettingsViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 11/10/2022.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    
    @Published var name: String
    
    @Published var selectedBase: String
    @Published var decimal: Int
    @Published var quickConvertOn: Bool
    @Published var showPercent: Bool
    
    @Published var secretCode = ""
    @Published var shouldDisplayAlert: Bool = false
    private var shouldSaveTitle = false
    @Published var titleIDToSave = 0
    
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    @Published var pickerData = [Currency]()
    
    var letter: String { "\(name.first!)" }
    
    var isSupporter: Bool {
        return shared.titleIDArray.contains([3]) || shared.titleIDArray.contains([4])
    }
    var isZona24: Bool { shared.chosenTitle == shared.titleArray[9] }
    
    private let defaults = UserDefaults.standard
    private let shared = SharedDataManager.shared
    
    init() {
        name = shared.name
        
        selectedBase = shared.base.code
        decimal = shared.decimal
        quickConvertOn = shared.quickConvert
        showPercent = shared.showPercent
        
        for code in shared.allCodesArray {
            self.pickerData.append(Currency(baseCode: code))
        }
    }
    
    func saveBase() {
        shared.base = Currency(baseCode: selectedBase)
        defaults.set(selectedBase, forKey: "base")
        AppIcon.changeIcon(to: selectedBase)
    }
    
    func saveDecimal() {
        shared.decimal = decimal
        defaults.set(decimal, forKey: "decimal")
    }
    
    func saveTitles() {
        if shouldSaveTitle {
            shared.titleIDArray.append(titleIDToSave)
            shared.defaults.set(shared.titleIDArray, forKey: "titleIDArray")
        }
    }
    
    func saveConvertMode() {
        shared.quickConvert = quickConvertOn
        shared.defaults.set(quickConvertOn, forKey: "quickConvert")
    }
    
    func saveShowPercent() {
        shared.showPercent = showPercent
        shared.defaults.set(showPercent, forKey: "showPercent")
    }
    
    func checkCode() {
        shouldSaveTitle = false
        
        if let secretID = shared.secretDictionary[secretCode] {
            if shared.titleIDArray.firstIndex(of: secretID) == nil {
                titleIDToSave = secretID
                shouldSaveTitle = true
                
                let t = shared.titleArray[secretID]
                alertTitle = String(localized: "alert_positive_title")
                alertMessage = "\(String(localized: "alert_positive_message_1")) \(t)\(String(localized: "alert_positive_message_2"))"
            } else {
                alertTitle = String(localized: "alert_repeated_title")
                alertMessage = String(localized: "alert_repeated_message")
            }
        } else {
            alertTitle = String(localized: "alert_invalid_title")
            alertMessage = String(localized: "alert_invalid_message")
        }
        
        secretCode = ""
    }
    
}
