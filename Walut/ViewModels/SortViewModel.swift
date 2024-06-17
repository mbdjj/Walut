//
//  SortViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 20/12/2022.
//

import Foundation

class SortViewModel: ObservableObject {
    
    @Published var selectedSort: SortType = .byCode
    @Published var selectedDirection: SortDirection = .ascending
    @Published var sortByFavorite: Bool = true
    
    init(index: Int, byFavorite: Bool) {
        decodeSort(from: index, byFavorite: byFavorite)
    }
    
    private func decodeSort(from index: Int, byFavorite: Bool) {
        switch index {
            
        // Sorting by code
        case 0:
            selectedSort = .byCode
            selectedDirection = .ascending
        case 1:
            selectedSort = .byCode
            selectedDirection = .descending
            
        // Sorting by price
        case 2:
            selectedSort = .byPrice
            selectedDirection = .ascending
        case 3:
            selectedSort = .byPrice
            selectedDirection = .descending
            
        // Sorting by change
        case 4:
            selectedSort = .byChange
            selectedDirection = .ascending
        case 5:
            selectedSort = .byChange
            selectedDirection = .descending
            
        // If something goes wrong
        default:
            selectedSort = .byCode
            selectedDirection = .ascending
        }
        
        sortByFavorite = byFavorite
    }
    
    func codeSortIndex() -> Int {
        var index = 0
        
        if selectedSort == .byCode && selectedDirection == .ascending {
            index = 0
        } else if selectedSort == .byCode && selectedDirection == .descending {
            index = 1
        } else if selectedSort == .byPrice && selectedDirection == .ascending {
            index = 2
        } else if selectedSort == .byPrice && selectedDirection == .descending {
            index = 3
        } else if selectedSort == .byChange && selectedDirection == .ascending {
            index = 4
        } else if selectedSort == .byChange && selectedDirection == .descending {
            index = 5
        }
        
        return index
    }
    
}



// MARK: - Sorting enums

enum SortType {
    case byCode
    case byPrice
    case byChange
}

enum SortDirection {
    case ascending
    case descending
}
