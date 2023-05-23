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
    
    private var initialPickerValue: Int
    private var initialCustomDate: Date
    
    var changed: Bool {
        return pickerValue != initialPickerValue || customDate != initialCustomDate
    }
    
    var range: ClosedRange<Date> { formatter.date(from: "1999-05-01")! ... .now }
    
    private var formatter = DateFormatter()
    
    private let shared = SharedDataManager.shared
    private let defaults = UserDefaults.standard
    
    init() {
        let pickerValue = shared.isCustomDate ? 1 : 0
        let customDate = shared.customDate
        
        self.pickerValue = pickerValue
        self.customDate = customDate
        
        self.initialPickerValue = pickerValue
        self.initialCustomDate = customDate
        
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
    }
    
    
    func savePickerValue() {
        let isCustom = pickerValue == 1
        
        shared.isCustomDate = isCustom
        defaults.set(isCustom, forKey: "isCustomDate")
        
        if isCustom {
            shared.customDate = customDate
            defaults.set(formatter.string(from: customDate), forKey: "customDate")
        }
    }
    
}
