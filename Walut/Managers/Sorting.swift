//
//  SortingManager.swift
//  Walut
//
//  Created by Marcin Bartminski on 20/12/2022.
//

import Foundation

struct Sorting {
    
    static func decodeSort(from index: Int) -> (SortType, SortDirection) {
        switch index {
            
        // Sorting by code
        case 0:
            return (.byCode, .ascending)
        case 1:
            return (.byCode, .descending)
            
        // Sorting by price
        case 2:
            return (.byPrice, .ascending)
        case 3:
            return (.byPrice, .descending)
            
        // Sorting by change
        case 4:
            return (.byChange, .ascending)
        case 5:
            return (.byChange, .descending)
            
        // If something goes wrong
        default:
            return (.byCode, .ascending)
        }
    }
    
    static func byCode(_ array: [Currency], direction: SortDirection) -> [Currency] {
        return direction == .ascending ? array.sorted(by: { $0.code < $1.code }) : array.sorted(by: { $0.code > $1.code })
    }
    
    static func byPrice(_ array: [Currency], direction: SortDirection) -> [Currency] {
        return direction == .ascending ? array.sorted(by: { $0.price < $1.price }) : array.sorted(by: { $0.price > $1.price })
    }
    
    static func byChange(_ array: [Currency], direction: SortDirection) -> [Currency] {
        return direction == .ascending ? array.sorted { $0.percent < $1.percent } : array.sorted { $0.percent > $1.percent }
    }
    
}
