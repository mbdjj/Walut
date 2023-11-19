//
//  SharedDataManager.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import Foundation

class SharedDataManager: ObservableObject {
    
    @Published var appState: AppState
    
    @Published var name: String
    @Published var titleIDArray: [Int]
    @Published var chosenTitle: String
    
    @Published var base: Currency
    @Published var decimal: Int
    @Published var quickConvert: Bool
    @Published var showPercent: Bool
    
    @Published var sortIndex: Int
    @Published var sortByFavorite: Bool
    
    @Published var isCustomDate: Bool
    @Published var customDate: Date = .now
    
    @Published var favorites: [String]
    
    let allCodesArray = ["AUD", "BGN", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "RUB", "SEK", "SGD", "THB", "TRY", "UAH", "USD", "ZAR"]
    let titleArray = [String(localized: "title0"), String(localized: "title1"), String(localized: "title2"), String(localized: "supporter_title"), String(localized: "supporter_big_title"), String(localized: "title5"), String(localized: "title6"), String(localized: "title7"), String(localized: "title8"), String(localized: "title9")]
    let secretDictionary = ["marcinBartminski": 1, "earlyAccess": 2, "crypto": 5, "appUnite": 6, "gold": 7, "reddit": 8, "zona24": 9]
    
    let defaults = UserDefaults.standard
    var formatter = DateFormatter()
    var numFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = decimal
        formatter.currencyCode = base.code
        return formatter
    }
    
    static let shared = SharedDataManager()
    
    init() {
        appState = defaults.bool(forKey: "isBaseSelected") ? .baseSelected : .onboarding
        
        name = defaults.string(forKey: "name") ?? "User"
        titleIDArray = defaults.array(forKey: "titleIDArray") as? [Int] ?? [0]
        chosenTitle = titleArray[defaults.integer(forKey: "chosenTitle")]
        
        base = Currency(baseCode: defaults.string(forKey: "base") ?? "AUD")
        let decimal = defaults.integer(forKey: "decimal")
        self.decimal = decimal == 0 ? 3 : decimal
        quickConvert = defaults.bool(forKey: "quickConvert")
        showPercent =  false //defaults.bool(forKey: "showPercent")
        
        sortIndex = defaults.integer(forKey: "sort")
        sortByFavorite = defaults.bool(forKey: "byFavorite")
        
        favorites = defaults.stringArray(forKey: "favorites") ?? []
        
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        isCustomDate = false //defaults.bool(forKey: "isCustomDate")
        customDate = customDate(from: defaults.string(forKey: "customDate") ?? "")
    }
    
    func customDate(from text: String) -> Date {
        return formatter.date(from: text) ?? .now
    }
    
    func customDateString() -> String {
        return formatter.string(from: customDate)
    }
    
    func currencyLocaleString(value: Double) -> String {
        return numFormatter.string(from: value as NSNumber) ?? "0"
    }
    func currencyLocaleString(value: Double, currencyCode: String) -> String {
        let formatter = numFormatter
        if decimal == 0 {
            formatter.maximumFractionDigits = 3
        }
        formatter.currencyCode = currencyCode
        return formatter.string(from: value as NSNumber) ?? "0"
    }
    
    func percentLocaleStirng(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: value as NSNumber) ?? "0"
    }
    
    func priceLocaleString(value: Double, currencyCode: String) -> String {
        let formatter = numFormatter
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = currencyCode
        
        return formatter.string(from: value as NSNumber) ?? "0"
    }
    
}

enum AppState {
    case baseSelected
    case onboarding
    case onboarded
}
