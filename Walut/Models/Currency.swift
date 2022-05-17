//
//  Currency.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/02/2022.
//

import Foundation

struct Currency: Identifiable, Equatable {
    
    init(code: String, rate: Double) { //We can initiate a Currency object
        self.code = code
        self.rate = rate
    }
    
    init(baseCode: String) {
        self.code = baseCode
        self.rate = 1.0
    }
    
    let code: String
    var flag: String { getEmoji(of: code) }
    var fullName: String { getName(of: code) }
    var symbol: String { getSymbol(of: code) }
    let rate: Double
    var price: Double { 1 / rate }
    
    var isFavorite: Bool = false
    
    var id: String { code }
    
    //MARK: - Manager part
    //Those are the methods that help to get all the info of specific currencies.
    
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
        "USD": "🇺🇸"
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
        "USD": "$"
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
        "USD": String(localized: "USD")
    ]
    
    private func getEmoji(of currency: String) -> String {
        return emojiDictionary[currency]!
    }
    
    private func getSymbol(of currency: String) -> String {
        return symbolDictionary[currency]!
    }
    
    private func getName(of currency: String) -> String {
        return nameDictionary[currency]!
    }
    
}
