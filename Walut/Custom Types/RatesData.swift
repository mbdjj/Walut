//
//  RatesData.swift
//  Walut
//
//  Created by Marcin Bartminski on 10/10/2022.
//

import Foundation

struct RatesData: Identifiable, Equatable, Hashable {
    
    let currencyString: String
    
    let dateString: String
    let value: Double
    
    var date: Date {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "rrrr-MM-dd"
        
        return formatter.date(from: dateString) ?? Date.now
    }
    
    var dateFormattedString: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("d MMMM rrrr")
        
        return formatter.string(from: date)
    }
    
    var animate: Bool = false
    
    var id: String { dateString }
    
    init(code: String, date: String, value: Double) {
        self.currencyString = code
        self.dateString = date
        self.value = value
    }
    
    init(code: String, date: Date, value: Double) {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "rrrr-MM-dd"
        let dateString = formatter.string(from: date)
        
        self.currencyString = code
        self.dateString = dateString
        self.value = value
    }
    
    init(from saved: SavedCurrency) {
        var date = Date(timeIntervalSince1970: Double(saved.nextRefresh))
        date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        self.init(code: saved.code, date: date, value: (1 / saved.rate))
    }
    
}

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
