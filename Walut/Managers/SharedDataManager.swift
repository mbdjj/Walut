//
//  SharedDataManager.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import Foundation

class SharedDataManager: ObservableObject {
    
    @Published var base: Currency
    @Published var decimal: Int
    
    let allCodesArray = ["AUD", "BGN", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "RUB", "SEK", "SGD", "THB", "TRY", "USD", "ZAR"]
    
    let defaults = UserDefaults.standard
    
    static let shared = SharedDataManager()
    
    init() {
        base = Currency(baseCode: defaults.string(forKey: "base") ?? "AUD")
        decimal = defaults.integer(forKey: "decimal")
    }
    
}
