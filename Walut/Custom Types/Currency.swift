//
//  Currency.swift
//  Walut
//
//  Created by Marcin Bartminski on 07/10/2022.
//

import Foundation

struct Currency: Identifiable, Equatable, Hashable {
    
    init(code: String, rate: Double) {
        self.code = code
        self.rate = rate
    }
    
    init(baseCode: String) {
        self.code = baseCode
        self.rate = 1.0
    }
    
    init(from saved: SavedCurrency) {
        self.code = saved.code
        self.rate = saved.rate
    }
    
    static var placeholder: Currency { Currency(code: "EUR", rate: 1.234) }
    
    static var empty: Currency { Currency(code: "---", rate: 0) }
    
    let code: String
    var flag: String { CurrencyDataManager.shared.getEmoji(of: code) }
    var fullName: String { CurrencyDataManager.shared.getName(of: code) }
    var symbol: String { CurrencyDataManager.shared.getSymbol(of: code) }
    
    let rate: Double
    var price: Double { 1 / rate }
    
    var lastRate: Double?
    var lastPrice: Double? {
        if let lastRate {
            return 1 / lastRate
        } else {
            return nil
        }
    }
    
    var percent: Double {
        if let lastPrice {
            return (price - lastPrice) / lastPrice
        } else {
            return 0
        }
    }
    
    var isFavorite: Bool { Defaults.favorites().contains(self.code) }
    
    var id: String { code }
}

//MARK: - Manager part
//Those are the methods that help to get all the info of specific currencies.

struct CurrencyDataManager {
    static let shared = CurrencyDataManager()
    
    private let emojiDictionary = [
        "AUD": "🇦🇺",
        "BRL": "🇧🇷",
        "BGN": "🇧🇬",
        "CAD": "🇨🇦",
        "CNY": "🇨🇳",
        "HRK": "🇭🇷",
        "CZK": "🇨🇿",
        "DKK": "🇩🇰",
        "EUR": "🇪🇺",
        "HKD": "🇭🇰",
        "HUF": "🇭🇺",
        "INR": "🇮🇳",
        "IDR": "🇮🇩",
        "ILS": "🇮🇱",
        "JPY": "🇯🇵",
        "MYR": "🇲🇾",
        "MXN": "🇲🇽",
        "RON": "🇷🇴",
        "NZD": "🇳🇿",
        "NOK": "🇳🇴",
        "PHP": "🇵🇭",
        "PLN": "🇵🇱",
        "GBP": "🇬🇧",
        "RUB": "🇷🇺",
        "SGD": "🇸🇬",
        "ZAR": "🇿🇦",
        "KRW": "🇰🇷",
        "SEK": "🇸🇪",
        "CHF": "🇨🇭",
        "THB": "🇹🇭",
        "TRY": "🇹🇷",
        "USD": "🇺🇸",
        "UAH": "🇺🇦",
        "---": " "
    ]
    
    private let symbolDictionary = [
        "AUD": "$",
        "BRL": "R$",
        "BGN": "лв.",
        "CAD": "$",
        "CNY": "¥",
        "HRK": "kn",
        "CZK": "Kč",
        "DKK": "kr",
        "EUR": "€",
        "HKD": "$",
        "HUF": "Ft",
        "INR": "₹",
        "IDR": "Rp",
        "ILS": "₪",
        "JPY": "¥",
        "MYR": "RM",
        "MXN": "$",
        "RON": "lei",
        "NZD": "$",
        "NOK": "kr",
        "PHP": "₱",
        "PLN": "zł",
        "GBP": "£",
        "RUB": "₽",
        "SGD": "$",
        "ZAR": "R",
        "KRW": "₩",
        "SEK": "kr",
        "CHF": "Fr.",
        "THB": "฿",
        "TRY": "₺",
        "USD": "$",
        "UAH": "₴",
        "---": " "
    ]
    
    private let nameDictionary = [
        "AUD": String(localized: "AUD"),
        "BRL": String(localized: "BRL"),
        "BGN": String(localized: "BGN"),
        "CAD": String(localized: "CAD"),
        "CNY": String(localized: "CNY"),
        "HRK": String(localized: "HRK"),
        "CZK": String(localized: "CZK"),
        "DKK": String(localized: "DKK"),
        "EUR": String(localized: "EUR"),
        "HKD": String(localized: "HKD"),
        "HUF": String(localized: "HUF"),
        "INR": String(localized: "INR"),
        "IDR": String(localized: "IDR"),
        "ILS": String(localized: "ILS"),
        "JPY": String(localized: "JPY"),
        "MYR": String(localized: "MYR"),
        "MXN": String(localized: "MXN"),
        "RON": String(localized: "RON"),
        "NZD": String(localized: "NZD"),
        "NOK": String(localized: "NOK"),
        "PHP": String(localized: "PHP"),
        "PLN": String(localized: "PLN"),
        "GBP": String(localized: "GBP"),
        "RUB": String(localized: "RUB"),
        "SGD": String(localized: "SGD"),
        "ZAR": String(localized: "ZAR"),
        "KRW": String(localized: "KRW"),
        "SEK": String(localized: "SEK"),
        "CHF": String(localized: "CHF"),
        "THB": String(localized: "THB"),
        "TRY": String(localized: "TRY"),
        "USD": String(localized: "USD"),
        "UAH": String(localized: "UAH"),
        "---": " "
    ]
    
    func getEmoji(of currency: String) -> String {
        return emojiDictionary[currency]!
    }
    
    func getSymbol(of currency: String) -> String {
        return symbolDictionary[currency]!
    }
    
    func getName(of currency: String) -> String {
        return nameDictionary[currency]!
    }
}

extension Currency: Reorderable {
    typealias OrderElement = String
    var orderElement: String { code }
}

// MARK: - Reorderable protocol

protocol Reorderable {
    associatedtype OrderElement: Equatable
    var orderElement: OrderElement { get }
}

extension Array where Element: Reorderable {

    func reorder(by preferredOrder: [Element.OrderElement]) -> [Element] {
        sorted {
            guard let first = preferredOrder.firstIndex(of: $0.orderElement) else {
                return false
            }

            guard let second = preferredOrder.firstIndex(of: $1.orderElement) else {
                return true
            }

            return first < second
        }
    }
}
