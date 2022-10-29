//
//  RatesData.swift
//  Walut
//
//  Created by Marcin Bartminski on 10/10/2022.
//

import Foundation

struct RatesData: Identifiable {
    
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
    
    init(date: String, value: Double) {
        self.dateString = date
        self.value = value
    }
    
}
