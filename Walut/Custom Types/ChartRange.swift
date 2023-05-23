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
}

extension ChartRange: Identifiable {
    var title: String {
        switch self {
        case .oneMonth:
            return "1M"
        case .threeMonths:
            return "3M"
        }
    }
    
    var monthValue: Int {
        switch self {
        case .oneMonth:
            return 1
        case .threeMonths:
            return 3
        }
    }
    
    var id: String { title }
}
