//
//  Currency.swift
//  Walut
//
//  Created by Marcin Bartminski on 07/10/2022.
//

import Foundation

struct Currency: Identifiable, Equatable {
    
    init(code: String, rate: Double, yesterday: Double) {
        self.code = code
        self.rate = rate
        self.yesterdayRate = yesterday
    }
    
    init(code: String, rate: Double) {
        self.code = code
        self.rate = rate
        self.yesterdayRate = 1.0
    }
    
    init(baseCode: String) {
        self.code = baseCode
        self.rate = 1.0
        self.yesterdayRate = 1.0
    }
    
    static var placeholder: Currency {
        var currency = Currency(code: "USD", rate: 4.464, yesterday: 4.466)
        
        currency.chartData = [
            RatesData(code: "USD", date: "2023-01-12", value: 4.329),
            RatesData(code: "USD", date: "2023-01-13", value: 4.328),
            RatesData(code: "USD", date: "2023-01-14", value: 4.332),
            RatesData(code: "USD", date: "2023-01-15", value: 4.333),
            RatesData(code: "USD", date: "2023-01-16", value: 4.338),
            RatesData(code: "USD", date: "2023-01-17", value: 4.352),
            RatesData(code: "USD", date: "2023-01-18", value: 4.370),
            RatesData(code: "USD", date: "2023-01-19", value: 4.135),
            RatesData(code: "USD", date: "2023-01-20", value: 4.135),
            RatesData(code: "USD", date: "2023-01-21", value: 4.328),
            RatesData(code: "USD", date: "2023-01-22", value: 4.318),
            RatesData(code: "USD", date: "2023-01-23", value: 4.326),
            RatesData(code: "USD", date: "2023-01-24", value: 4.329),
            RatesData(code: "USD", date: "2023-01-25", value: 4.327),
            RatesData(code: "USD", date: "2023-01-26", value: 4.334),
            RatesData(code: "USD", date: "2023-01-28", value: 4.336),
            RatesData(code: "USD", date: "2023-01-29", value: 4.279),
            RatesData(code: "USD", date: "2023-01-30", value: 4.292),
            RatesData(code: "USD", date: "2023-01-31", value: 4.364),
            RatesData(code: "USD", date: "2023-02-01", value: 4.368),
            RatesData(code: "USD", date: "2023-02-02", value: 4.364),
            RatesData(code: "USD", date: "2023-02-03", value: 4.421),
            RatesData(code: "USD", date: "2023-02-04", value: 4.426),
            RatesData(code: "USD", date: "2023-02-05", value: 4.422),
            RatesData(code: "USD", date: "2023-02-06", value: 4.425),
            RatesData(code: "USD", date: "2023-02-07", value: 4.462),
            RatesData(code: "USD", date: "2023-02-08", value: 4.466),
            RatesData(code: "USD", date: "2023-02-09", value: 4.464),
            RatesData(code: "USD", date: "2023-02-10", value: 4.462),
            RatesData(code: "USD", date: "2023-02-11", value: 4.468),
            RatesData(code: "USD", date: "2023-02-12", value: 4.467)
        ]
        
        return currency
    }
    
    let code: String
    var flag: String { getEmoji(of: code) }
    var fullName: String { getName(of: code) }
    var symbol: String { getSymbol(of: code) }
    var info: String { getInfo(of: code) }
    
    let rate: Double
    let yesterdayRate: Double
    var price: Double { 1 / rate }
    var yesterdayPrice: Double { 1 / yesterdayRate }
    
    var chartData: [RatesData]?
    
    var isFavorite: Bool { SharedDataManager.shared.favorites.contains(self.code) }
    
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
        "USD": "🇺🇸",
        "UAH": "🇺🇦"
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
        "UAH": "₴"
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
        "UAH": String(localized: "UAH")
    ]
    
    private let infoDictionary = [
        "AUD": String(localized: "AUD_info"),
        "BRL": String(localized: "BRL_info"),
        "BGN": String(localized: "BGN_info"),
        "CAD": String(localized: "CAD_info"),
        "CNY": String(localized: "CNY_info"),
        "HRK": String(localized: "HRK_info"),
        "CZK": String(localized: "CZK_info"),
        "DKK": String(localized: "DKK_info"),
        "EUR": String(localized: "EUR_info"),
        "HKD": String(localized: "HKD_info"),
        "HUF": String(localized: "HUF_info"),
        "INR": String(localized: "INR_info"),
        "IDR": String(localized: "IDR_info"),
        "ILS": String(localized: "ILS_info"),
        "JPY": String(localized: "JPY_info"),
        "MYR": String(localized: "MYR_info"),
        "MXN": String(localized: "MXN_info"),
        "RON": String(localized: "RON_info"),
        "NZD": String(localized: "NZD_info"),
        "NOK": String(localized: "NOK_info"),
        "PHP": String(localized: "PHP_info"),
        "PLN": String(localized: "PLN_info"),
        "GBP": String(localized: "GBP_info"),
        "RUB": String(localized: "RUB_info"),
        "SGD": String(localized: "SGD_info"),
        "ZAR": String(localized: "ZAR_info"),
        "KRW": String(localized: "KRW_info"),
        "SEK": String(localized: "SEK_info"),
        "CHF": String(localized: "CHF_info"),
        "THB": String(localized: "THB_info"),
        "TRY": String(localized: "TRY_info"),
        "USD": String(localized: "USD_info"),
        "UAH": String(localized: "UAH_info")
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
    
    private func getInfo(of currency: String) -> String {
        return infoDictionary[currency]!
    }
}
