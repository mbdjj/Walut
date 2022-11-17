//
//  RatesData.swift
//  Walut
//
//  Created by Marcin Bartminski on 10/10/2022.
//

import Foundation

struct RatesData: Identifiable {
    
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
    
    static let placeholderArraySmall = [
        RatesData(code: "EUR", date: "2022-11-16", value: 1.0),
        RatesData(code: "EUR", date: "2022-11-17", value: 1.1)
    ]
    
}
