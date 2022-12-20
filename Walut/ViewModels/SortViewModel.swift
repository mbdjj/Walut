//
//  SortViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 20/12/2022.
//

import Foundation

class SortViewModel: ObservableObject {
    
    @Published var selectedSort: SortType
    
    @Published var sortByFavorite: Bool
    
    init() {
        self.selectedSort = .byCode
        self.sortByFavorite = true
    }
    
}

enum SortType {
    case byCode
    case byPrice
    case byChange
}
