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
        "AUD": "Australian dollar",
        "BRL": "Brazilian real",
        "BGN": "Bulgarian lev",
        "CAD": "Canadian dollar",
        "CNY": "Chinese yuan",
        "HRK": "Croatian kuna",
        "CZK": "Czech koruna",
        "DKK": "Danish krone",
        "EUR": "Euro",
        "HKD": "Hong Kong dollar",
        "HUF": "Hungarian forint",
        "INR": "Indian rupee",
        "IDR": "Indonesian rupiah",
        "ILS": "Israeli new shekel",
        "JPY": "Japanese yen",
        "MYR": "Malaysian ringgit",
        "MXN": "Mexican peso",
        "RON": "Romanian leu",
        "NZD": "New Zealand dollar",
        "NOK": "Norwegian krone",
        "PHP": "Phillippine peso",
        "PLN": "Polish złoty",
        "GBP": "British pound",
        "RUB": "Russian ruble",
        "SGD": "Singapure dollar",
        "ZAR": "South African rand",
        "KRW": "South Korean won",
        "SEK": "Swedish krona",
        "CHF": "Swiss franc",
        "THB": "Thai baht",
        "TRY": "Turkish lira",
        "USD": "US dollar"
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
