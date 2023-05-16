//
//  FavoritesViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 30/10/2022.
//

import SwiftUI

class FavoritesViewModel: ObservableObject {
    
    @Published var favorites = [Currency]()
    var pickerData = [Currency]()
    
    private let shared = SharedDataManager.shared
    
    init() {
        favorites = shared.favorites
            .map { Currency(baseCode: $0) }
        
        refreshPickerData()
    }
    
    func addToFavorites(currency: Currency) {
        favorites.append(currency)
        
        if let index = pickerData.firstIndex(of: currency) {
            pickerData.remove(at: index)
        }
        
        saveFavorites()
    }
    
    func move(from offsets: IndexSet, to index: Int) {
        favorites.move(fromOffsets: offsets, toOffset: index)
        
        saveFavorites()
    }
    
    func delete(at offsets: IndexSet) {
        favorites.remove(atOffsets: offsets)
        
        refreshPickerData()
        
        saveFavorites()
    }
    
    private func refreshPickerData() {
        pickerData = []
        
        for code in shared.allCodesArray {
            let currency = Currency(baseCode: code)
            if favorites.firstIndex(of: currency) == nil {
                pickerData.append(currency)
            }
        }
    }
    
    private func saveFavorites() {
        var codeArray = [String]()
        
        for favorite in favorites {
            codeArray.append(favorite.code)
        }
        
        shared.favorites = codeArray
        shared.defaults.set(codeArray, forKey: "favorites")
    }
    
}
