//
//  RatesData.swift
//  Walut
//
//  Created by Marcin Bartminski on 10/10/2022.
//

import Foundation

struct RatesData: Identifiable, Equatable {
    
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
        self.init(code: saved.code, date: saved.dateSaved, value: (1 / saved.rate))
    }
    
}
