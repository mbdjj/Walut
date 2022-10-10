//
//  TimeSeriesData.swift
//  Walut
//
//  Created by Marcin Bartminski on 10/10/2022.
//

import Foundation

struct CurrencyTimeSeriesData: Decodable {
    let success: Bool
    let rates: TimeSeriesRates
}

struct TimeSeriesRates: Decodable {
    
    var ratesArray: [[String: Double]]
    var keyArray: [String]
    
    private struct DynamicKeys: CodingKey {
        
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKeys.self)
        
        var tempArray = [[String: Double]]()
        var tempKeyArray = [String]()
        
        let allKeysSorted = container.allKeys.sorted { key1, key2 in
            if key1.stringValue < key2.stringValue {
                return true
            } else {
                return false
            }
        }
        
        for key in allKeysSorted {
            let decodedObject = try container.decode([String: Double].self, forKey: DynamicKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
            tempKeyArray.append(key.stringValue)
        }
        
        ratesArray = tempArray
        keyArray = tempKeyArray
    }
}
