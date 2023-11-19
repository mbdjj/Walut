//
//  SavedCurrency.swift
//  Walut
//
//  Created by Marcin Bartminski on 19/11/2023.
//

import Foundation
import SwiftData

@Model final class SavedCurrency {
    let code: String
    let base: String
    let rate: Double
    
    let nextRefresh: Int
    let dateSaved: Date
    
    init(code: String, base: String, rate: Double, nextRefresh: Int, dateSaved: Date = .now) {
        self.code = code
        self.base = base
        self.rate = rate
        self.nextRefresh = nextRefresh
        self.dateSaved = dateSaved
    }
}
