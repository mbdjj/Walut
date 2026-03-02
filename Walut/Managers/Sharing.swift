//
//  Sharing.swift
//  Walut
//
//  Created by Marcin Bartminski on 02/03/2026.
//

import Foundation

struct Sharing {
    
    static func dragText(currency: Currency, settings: AppSettings) -> String {
        "\(currency.fullName)\(String(localized: "text_to_share0"))(\(currency.code))\(String(localized: "text_to_share1"))\(String(format: "%.\(settings.decimal)f", currency.price)) \(settings.baseCurrency!.symbol)"
    }
    
    static func valueText(firstCurrency: Currency, secondCurrency: Currency, firstValue: Double, secondValue: Double) -> String {
        var first = ""
        var second = ""
        
        first = Formatter.price(value: firstValue, currencyCode: firstCurrency.code)
        second = Formatter.price(value: secondValue, currencyCode: secondCurrency.code)
        
        return "\(first) = \(second)"
    }
    
    static func descText(currency: Currency, base: Currency) -> String {
        "\(currency.fullName)\(String(localized: "text_to_share0"))(\(currency.code))\(String(localized: "text_to_share1"))\(Formatter.currency(value: currency.price, currencyCode: base.code, decimal: UserDefaults.standard.integer(forKey: "decimal")))"
    }
    
}
