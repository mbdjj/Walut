//
//  SortingManager.swift
//  Walut
//
//  Created by Marcin Bartminski on 20/12/2022.
//

import Foundation

struct Sorting {
    
    static func byCode(_ array: [Currency], direction: SortDirection) -> [Currency] {
        return direction == .ascending ? array.sorted(by: { $0.code < $1.code }) : array.sorted(by: { $0.code > $1.code })
    }
    
    static func byPrice(_ array: [Currency], direction: SortDirection) -> [Currency] {
        return direction == .ascending ? array.sorted(by: { $0.price < $1.price }) : array.sorted(by: { $0.price > $1.price })
    }
    
//    static func byChange(_ array: [Currency], direction: SortDirection) -> [Currency] {
//        return direction == .ascending ? array.sorted(by: { $0.percent < $1.percent }) : array.sorted(by: { $0.percent > $1.percent })
//    }
    
}
