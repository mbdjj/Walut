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
    
    let defaults = UserDefaults.standard
    let sharedDefaults = UserDefaults(suiteName: "group.dev.bartminski.Walut")!
    
    init() {
        let baseCode = defaults.string(forKey: "base")
        let baseSelected = (baseCode != nil)
        
        appstate = baseSelected ? .baseSelected : .onboarding
        
        user = User.loadUser()
        
        baseCurrency = if let baseCode { Currency(baseCode: baseCode) } else { nil }
        decimal = sharedDefaults.integer(forKey: "decimal")
        quickConvert = defaults.bool(forKey: "quickConvert")
        showPercent = defaults.bool(forKey: "showPercent")
        
        sortIndex = defaults.integer(forKey: "sort")
        sortByFavorite = defaults.bool(forKey: "byFavorite")
        
        favorites = defaults.stringArray(forKey: "favorites") ?? []
        
        let option = defaults.integer(forKey: "storageOptions")
        storageOption = StorageSavingOptions(rawValue: option) ?? .oneMonth
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
    func saveBase() {
        defaults.set(baseCurrency!.code, forKey: "base")
        AppIcon.changeIcon(to: baseCurrency!.code)
    }
    func saveDecimal() {
        sharedDefaults.set(decimal, forKey: "decimal")
        WidgetCenter.shared.reloadTimelines(ofKind: "WalutWidget")
    }
    func saveConvertMode() {
        defaults.set(quickConvert, forKey: "quickConvert")
    }
    func saveShowPercent() {
        defaults.set(showPercent, forKey: "showPercent")
    }
    
    // MARK: - Sorting methods
    @MainActor
    func updateSort(to index: Int) {
        sortIndex = index
        defaults.set(index, forKey: "sort")
        print("sort updated to \(index)")
    }
    @MainActor
    func updateByFavorite(_ byFavorite: Bool) {
        sortByFavorite = byFavorite
        defaults.set(byFavorite, forKey: "byFavorite")
    }
    
    // MARK: - Favorites
    @MainActor
    func updateFavorites(to array: [String]) {
        favorites = array
        defaults.set(array, forKey: "favorites")
    }
    
    // MARK: - Storage options
    @MainActor
    func updateStorageOption(to option: StorageSavingOptions) {
        storageOption = option
        defaults.set(option.rawValue, forKey: "storageOptions")
    }
}
