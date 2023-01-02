//
//  DatePickViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 02/01/2023.
//

import Foundation

class DatePickViewModel: ObservableObject {
    
    @Published var pickerValue = 0
    @Published var customDate = Date()
    
    var initialPickerValue: Int
    var initialCustomDate: Date
    
    var changed: Bool {
        return pickerValue != initialPickerValue || customDate != initialCustomDate
    }
    
    var range: ClosedRange<Date> { formatter.date(from: "2005-07-02")! ... .now }
    
    var formatter = DateFormatter()
    
    let shared = SharedDataManager.shared
    let defaults = UserDefaults.standard
    
    init() {
        pickerValue = shared.isCustomDate ? 1 : 0
        customDate = shared.customDate
        
        initialPickerValue = shared.isCustomDate ? 1 : 0
        initialCustomDate = shared.customDate
        
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
    }
    
    
    func savePickerValue() {
        let isCustom = pickerValue == 1 ? true : false
        
        shared.isCustomDate = isCustom
        defaults.set(isCustom, forKey: "isCustomDate")
        
        if isCustom {
            shared.customDate = customDate
            defaults.set(formatter.string(from: customDate), forKey: "customDate")
        }
    }
    
}
