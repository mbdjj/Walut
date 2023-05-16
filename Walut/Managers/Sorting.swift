//
//  SortingManager.swift
//  Walut
//
//  Created by Marcin Bartminski on 20/12/2022.
//

import Foundation

struct Sorting {
    
    static func byCode(_ array: [Currency], direction: SortDirection) -> [Currency] {
        var array = array
        
        if direction == .ascending {
            array = array.sorted(by: { $0.code < $1.code })
        } else {
            array = array.sorted(by: { $0.code > $1.code })
        }
        
        return array
    }
    
    static func byPrice(_ array: [Currency], direction: SortDirection) -> [Currency] {
        var array = array
        
        if direction == .ascending {
            array = array.sorted(by: { $0.price < $1.price })
        } else {
            array = array.sorted(by: { $0.price > $1.price })
        }
        
        return array
    }
    
    static func byChange(_ array: [Currency], direction: SortDirection) -> [Currency] {
        var array = array
        
        if direction == .ascending {
            array = array.sorted(by: { ($0.price - $0.yesterdayPrice) / $0.yesterdayPrice * 100 < ($1.price - $1.yesterdayPrice) / $1.yesterdayPrice * 100 })
        } else {
            array = array.sorted(by: { ($0.price - $0.yesterdayPrice) / $0.yesterdayPrice * 100 > ($1.price - $1.yesterdayPrice) / $1.yesterdayPrice * 100 })
        }
        
        return array
    }
    
}
