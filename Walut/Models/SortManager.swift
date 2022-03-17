//
//  SortManager.swift
//  Walut
//
//  Created by Marcin Bartminski on 09/02/2022.
//

import Foundation

struct SortManager {
    
    func sortByCode(array: [Currency], atoz: Bool) -> [Currency] {
        if atoz {
            let sorted = array.sorted { $0.code < $1.code }
            return sorted
        } else {
            let sorted = array.sorted { $0.code > $1.code }
            return sorted
        }
    }
    
    func sortByPrice(array: [Currency], fromLargest: Bool) -> [Currency] {
        if fromLargest {
            let sorted = array.sorted { $0.price > $1.price }
            return sorted
        } else {
            let sorted = array.sorted { $0.price < $1.price }
            return sorted
        }
    }
    
    func favoritesFirst(array: [Currency], favorites: [String]) -> [Currency] {
        
        var sorted = array
        var i = 0
        
        for code in favorites {
            for currency in array {
                if currency.code == code {
                    let index = sorted.firstIndex(of: currency)!
                    sorted.remove(at: index)
                    sorted.insert(currency, at: i)
                }
            }
            
            i += 1
        }
        return sorted
    }
    
    func customSort(array: [Currency], toPattern: [String]) -> [Currency] {
        
        var sorted = array
        var i = 0
        
        for code in toPattern {
            for currency in array {
                if currency.code == code {
                    let index = sorted.firstIndex(of: currency)!
                    sorted.remove(at: index)
                    sorted.insert(currency, at: i)
                }
            }
            
            i += 1
        }
        
        return sorted
        
    }
    
}
