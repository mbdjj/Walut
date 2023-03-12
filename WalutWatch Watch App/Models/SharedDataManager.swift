//
//  SharedDataManager.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 11/03/2023.
//

import Foundation

class SharedDataManager: ObservableObject {
    
    @Published var isBaseSelected: Bool
    @Published var base: Currency
    
    @Published var favorites: [String]
    
    let allCodesArray = ["AUD", "BGN", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "RUB", "SEK", "SGD", "THB", "TRY", "UAH", "USD", "ZAR"]
    
    let defaults = UserDefaults.standard
    
    static let shared = SharedDataManager()
    
    init() {
        isBaseSelected = defaults.bool(forKey: "isBaseSelected")
        base = Currency(baseCode: defaults.string(forKey: "base") ?? "AUD")
        favorites = defaults.array(forKey: "favorites") as? [String] ?? []
    }
    
}
