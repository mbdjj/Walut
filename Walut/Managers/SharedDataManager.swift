//
//  SharedDataManager.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import Foundation

class SharedDataManager: ObservableObject {
    
    @Published var onboardingDone = false
    @Published var isBaseSelected = false
    
    @Published var name: String
    @Published var titleIDArray: [Int]
    @Published var chosenTitle: String
    
    @Published var base: Currency
    @Published var decimal: Int
    @Published var quickConvert: Bool
    @Published var showPercent: Bool
    @Published var reduceDataUsage: Bool
    
    @Published var sortIndex: Int
    @Published var sortByFavorite: Bool
    
    @Published var isCustomDate: Bool
    @Published var customDate: Date = .now
    
    @Published var favorites: [String]
    
    let allCodesArray = ["AUD", "BGN", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "RUB", "SEK", "SGD", "THB", "TRY", "UAH", "USD", "ZAR"]
    let titleArray = [String(localized: "title0"), String(localized: "title1"), String(localized: "title2"), String(localized: "supporter_title"), String(localized: "supporter_big_title"), String(localized: "title5"), String(localized: "title6"), String(localized: "title7"), String(localized: "title8")]
    let secretDictionary = ["marcinBartminski": 1, "earlyAccess": 2, "crypto": 5, "appUnite": 6, "gold": 7, "reddit": 8]
    
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
        isBaseSelected = defaults.bool(forKey: "isBaseSelected")
        
        name = defaults.string(forKey: "name") ?? "User"
        titleIDArray = defaults.array(forKey: "titleIDArray") as? [Int] ?? [0]
        chosenTitle = titleArray[defaults.integer(forKey: "chosenTitle")]
        
        base = Currency(baseCode: defaults.string(forKey: "base") ?? "AUD")
        decimal = defaults.integer(forKey: "decimal")
        quickConvert = defaults.bool(forKey: "quickConvert")
        showPercent = defaults.bool(forKey: "showPercent")
        reduceDataUsage = defaults.bool(forKey: "reduceData")
        
        sortIndex = defaults.integer(forKey: "sort")
        sortByFavorite = defaults.bool(forKey: "byFavorite")
        
        favorites = defaults.stringArray(forKey: "favorites") ?? []
        
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        isCustomDate = defaults.bool(forKey: "isCustomDate")
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
        var formatter = numFormatter
        formatter.currencyCode = currencyCode
        return formatter.string(from: value as NSNumber) ?? "0"
    }
    
}
