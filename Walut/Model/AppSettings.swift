//
//  AppSettings.swift
//  Walut
//
//  Created by Marcin Bartminski on 16/06/2024.
//

import Foundation
import WidgetKit

@Observable class AppSettings {
    var appstate: AppState
    
    var user: User?
    
    var baseCurrency: Currency?
    var decimal: Int
    var quickConvert: Bool
    var showPercent: Bool
    
    var sortIndex: Int
    var sortByFavorite: Bool
    
    var favorites: [String]
    
    var storageOption: StorageSavingOptions
    
    static let preview: AppSettings = {
        let settings = AppSettings()
        settings.appstate = .baseSelected
        settings.user = User(name: "Test", selectedTitleIndex: 0, unlockedTitlesArray: [0, 1])
        settings.baseCurrency = Currency(baseCode: "USD")
        settings.decimal = 3
        settings.showPercent = true
        settings.sortByFavorite = true
        settings.favorites = ["PLN", "EUR"]
        return settings
    }()
    
    init() {
        let baseCode = Defaults.baseCode()
        let baseSelected = (baseCode != nil)
        
        appstate = baseSelected ? .baseSelected : .onboarding
        
        user = User.loadUser()
        
        baseCurrency = if let baseCode { Currency(baseCode: baseCode) } else { nil }
        decimal = Defaults.decimal()
        quickConvert = Defaults.quickConvert()
        showPercent = Defaults.showPercent()
        
        sortIndex = Defaults.sortIndex()
        sortByFavorite = Defaults.byFavorite()
        
        favorites = Defaults.favorites()
        
        storageOption = Defaults.storageOption()
    }
    
    // MARK: - User methods
    @MainActor
    func updateUserName(to name: String) {
        user?.updateName(to: name)
    }
    @MainActor
    func changeUserTitle(to index: Int) {
        user?.changeTitle(to: index)
    }
    @MainActor
    func unlockUserTitle(at index: Int) {
        user?.unlockTitle(at: index)
    }
    
    // MARK: - Settings methods
    @MainActor
    func saveBase() {
        Defaults.saveBaseCode(baseCurrency!.code)
    }
    @MainActor
    func saveDecimal() {
        Defaults.saveDecimal(decimal)
        WidgetCenter.shared.reloadTimelines(ofKind: "WalutWidget")
    }
    func saveConvertMode() {
        Defaults.saveQuickConvert(quickConvert)
    }
    func saveShowPercent() {
        Defaults.saveShowPercent(showPercent)
    }
    
    // MARK: - Sorting methods
    @MainActor
    func updateSort(to index: Int) {
        sortIndex = index
        Defaults.saveSortIndex(index)
        print("Sort updated to \(index)")
    }
    @MainActor
    func updateByFavorite(_ byFavorite: Bool) {
        sortByFavorite = byFavorite
        Defaults.saveByFavorite(byFavorite)
    }
    
    // MARK: - Favorites
    @MainActor
    func updateFavorites(to array: [String]) {
        favorites = array
        Defaults.saveFavorites(array)
    }
    @MainActor
    func handleFavoriteFlip(of currency: Currency) {
        if currency.isFavorite, let i = favorites.firstIndex(of: currency.code) {
            favorites.remove(at: i)
            print("Unfavorited \(currency.code)")
        } else {
            favorites.append(currency.code)
            print("Favorited \(currency.code)")
        }
        Defaults.saveFavorites(favorites)
    }
    
    // MARK: - Storage options
    @MainActor
    func updateStorageOption(to option: StorageSavingOptions) {
        storageOption = option
        Defaults.saveStorageOption(option)
    }
}
