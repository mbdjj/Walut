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
    
    @Published var favorites: [String]
    
    let allCodesArray = ["AUD", "BGN", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "RUB", "SEK", "SGD", "THB", "TRY", "USD", "ZAR"]
    let titleArray = [String(localized: "title0"), String(localized: "title1"), String(localized: "title2"), String(localized: "supporter_title"), String(localized: "supporter_big_title")]
    let secretDictionary = ["marcinBartminski": 1, "earlyAccess": 2]
    
    let defaults = UserDefaults.standard
    
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
    }
    
}
