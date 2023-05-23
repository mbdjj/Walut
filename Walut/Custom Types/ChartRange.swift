//
//  ChartRange.swift
//  Walut
//
//  Created by Marcin Bartminski on 23/05/2023.
//

import Foundation

enum ChartRange {
    case oneMonth
    case threeMonths
    case sixMonths
    case year
}

extension ChartRange: Identifiable {
    var title: String {
        let mSym = String(localized: "overview_month_symbol")
        let ySym = String(localized: "overview_year_symbol")
        switch self {
        case .oneMonth:
            return "1\(mSym)"
        case .threeMonths:
            return "3\(mSym)"
        case .sixMonths:
            return "6\(mSym)"
        case .year:
            return "1\(ySym)"
        }
    }
    
    var monthValue: Int {
        switch self {
        case .oneMonth:
            return 1
        case .threeMonths:
            return 3
        case .sixMonths:
            return 6
        case .year:
            return 12
        }
    }
    
    var lastXString: String {
        switch self {
        case .oneMonth:
            return String(localized: "overview_past_month")
        case .threeMonths:
            return String(localized: "overview_past_3months")
        case .sixMonths:
            return String(localized: "overview_past_6months")
        case .year:
            return String(localized: "overview_past_year")
        }
    }
    
    var id: String { title }
}
