//
//  CurrencyListViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 21/11/2022.
//

import SwiftUI
import SwiftData

@Observable class CurrencyListViewModel {
    
    var favoritesArray = [Currency]()
    var currencyArray = [Currency]()
    
    var selectedCurrency: Currency?
    
    var errorMessage = ""
    var shouldDisplayErrorAlert = false
    
//    func fetchCurrencyData(for baseCode: String) async -> [Currency] {
//        do {
//            let data = try await API.fetchCurrencyRates(for: Currency(baseCode: baseCode))
//            return data
//        } catch {
//            DispatchQueue.main.async {
//                if let error = error as? API.APIError {
//                    self.errorMessage = error.localizedDesc
//                } else {
//                    self.errorMessage = error.localizedDescription
//                }
//                self.shouldDisplayErrorAlert = true
//            }
//            return []
//        }
//    }
    
    func present(data: [Currency], baseCode: String, sortIndex: Int) {
//        if byFavorite {
//            var (currencyArray, favoritesArray) = splitFavorites(from: data)
//            
//            currencyArray = sort(array: currencyArray)
//            
//            DispatchQueue.main.async {
//                self.favoritesArray = favoritesArray
//                self.currencyArray = currencyArray
//            }
//        } else {
            var currencyArray = removeBase(from: data, baseCode: baseCode)
            currencyArray = sort(array: currencyArray, to: sortIndex)
            
            DispatchQueue.main.async {
                self.currencyArray = currencyArray
            }
//        }
    }
    
    private func splitFavorites(from array: [Currency], baseCode: String, favoritesOrder: [String]) -> ([Currency], [Currency]) {
        let favoritesArray = array
            .map { $0 }
            .filter { $0.isFavorite }
            .reorder(by: favoritesOrder)
        
        let currencyArray = array
            .map { $0 }
            .filter { !$0.isFavorite }
        
        return removeBase(from: (currencyArray, favoritesArray), baseCode: baseCode)
    }
    
    private func removeBase(from arrays: ([Currency], [Currency]), baseCode: String) -> ([Currency], [Currency]) {
        return (removeBase(from: arrays.0, baseCode: baseCode), removeBase(from: arrays.1, baseCode: baseCode))
    }
    
    private func removeBase(from array: [Currency], baseCode: String) -> [Currency] {
        return array.filter { $0.code != baseCode }
    }
    
    private func sort(array: [Currency], to sortIndex: Int) -> [Currency] {
        let (sortType, sortDirection) = Sorting.decodeSort(from: sortIndex)
        switch sortType {
        case .byCode:
            return Sorting.byCode(array, direction: sortDirection)
        case .byPrice:
            return Sorting.byPrice(array, direction: sortDirection)
        case .byChange:
            return Sorting.byChange(array, direction: sortDirection)
        }
    }
}
