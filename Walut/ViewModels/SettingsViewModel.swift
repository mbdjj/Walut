//
//  SettingsViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 11/10/2022.
//

import SwiftUI
import WidgetKit

class SettingsViewModel: ObservableObject {
    
    @Published var name: String
    
    @Published var selectedBase: String
    @Published var decimal: Int
    @Published var quickConvertOn: Bool
    @Published var showPercent: Bool
    
    @Published var pickerData = [Currency]()
    
    var letter: String { "\(name.first!)" }
    
    var isSupporter: Bool {
        return shared.titleIDArray.contains([3]) || shared.titleIDArray.contains([4])
    }
    var isZona24: Bool { shared.chosenTitle == shared.titleArray[9] }
    
    private let defaults = UserDefaults.standard
    private let sharedDefaults = UserDefaults(suiteName: "group.dev.bartminski.Walut")!
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
        sharedDefaults.set(decimal, forKey: "decimal")
        WidgetCenter.shared.reloadTimelines(ofKind: "WalutWidget")
    }
    
    func saveConvertMode() {
        shared.quickConvert = quickConvertOn
        shared.defaults.set(quickConvertOn, forKey: "quickConvert")
    }
    
    func saveShowPercent() {
        shared.showPercent = showPercent
        shared.defaults.set(showPercent, forKey: "showPercent")
    }
    
    func sendEmail() {
        let subject = String(localized: "settings_email_subject")
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let url = URL(string: "mailto:marcin@bartminski.dev?subject=\(subjectEncoded)")
        
        if let url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("D:")
        }
    }
    
}
