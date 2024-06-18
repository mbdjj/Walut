//
//  TextFormat.swift
//  Walut
//
//  Created by Marcin Bartminski on 15/06/2024.
//

import Foundation

struct Formatter {
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static private let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    static private let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    static private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter
    }()
    
    static func date(from string: String) -> Date {
        dateFormatter.date(from: string) ?? .now
    }
    
    static func string(from date: Date) -> String {
        dateFormatter.string(from: date)
    }
    
    static func percent(value: Double) -> String {
        percentFormatter.string(from: value as NSNumber) ?? "0"
    }
    
    static func price(value: Double, currencyCode: String) -> String {
        priceFormatter.currencyCode = currencyCode
        return priceFormatter.string(from: value as NSNumber) ?? "0"
    }
    
    static func currency(value: Double, currencyCode: String, decimal: Int) -> String {
        currencyFormatter.currencyCode = currencyCode
        currencyFormatter.maximumFractionDigits = decimal
        return currencyFormatter.string(from: value as NSNumber) ?? "0"
    }
}
