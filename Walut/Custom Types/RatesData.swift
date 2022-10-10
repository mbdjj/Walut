//
//  RatesData.swift
//  Walut
//
//  Created by Marcin Bartminski on 10/10/2022.
//

import Foundation

class RatesData: Identifiable {
    
    let date: String
    let value: Double
    
    var id: String { date }
    
    init(date: String, value: Double) {
        self.date = date
        self.value = value
    }
    
}
