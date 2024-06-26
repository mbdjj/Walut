//
//  FavoritesViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 30/10/2022.
//

import SwiftUI

@Observable class FavoritesViewModel {
    
    var favorites: [Currency]
    var pickerData: [Currency]
    
    let updateFavorites: ([String]) -> ()
    
    init(settings: AppSettings, updateFavorites: @escaping ([String]) -> ()) {
        let favorites = settings.favorites
            .map { Currency(baseCode: $0) }
        
        self.favorites = favorites
        
        pickerData = StaticData.currencyCodes
            .map { Currency(baseCode: $0) }
            .filter { !favorites.contains($0) }
        
        self.updateFavorites = updateFavorites
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
        pickerData = StaticData.currencyCodes
            .map { Currency(baseCode: $0) }
            .filter { !favorites.contains($0) }
    }
    
    private func saveFavorites() {
        let codeArray = favorites
            .map { $0.code }
        updateFavorites(codeArray)
    }
    
}
