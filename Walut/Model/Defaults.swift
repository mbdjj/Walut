//
//  Defaults.swift
//  Walut
//
//  Created by Marcin Bartminski on 17/06/2024.
//

import SwiftUI

struct Defaults {
    private static let defaults = UserDefaults.standard
    private static let sharedDefaults = UserDefaults(suiteName: "group.dev.bartminski.Walut")!
    
    
    // MARK: - Strings
    static func baseCode() -> String? { defaults.string(forKey: "base") }
    static func saveBaseCode(_ code: String) { defaults.set(code, forKey: "base") }
    
    static func userName() -> String? { defaults.string(forKey: "name") }
    static func saveUserName(_ name: String) { defaults.set(name, forKey: "name") }
    
    static func nextUpdateBaseCode() -> String { sharedDefaults.string(forKey: "nextUpdateBase") ?? "" }
    static func saveNextUpdateBaseCode(_ code: String) { sharedDefaults.set(code, forKey: "nextUpdateBase") }
    
    
    // MARK: - Integers
    static func userSelectedTitleIndex() -> Int { defaults.integer(forKey: "chosenTitle") }
    static func saveUserSelectedTitleIndex(_ index: Int) { defaults.set(index, forKey: "chosenTitle") }
    
    static func decimal() -> Int { sharedDefaults.integer(forKey: "decimal") }
    static func saveDecimal(_ decimal: Int) { sharedDefaults.set(decimal, forKey: "decimal") }
    
    static func sortIndex() -> Int { defaults.integer(forKey: "sort") }
    static func saveSortIndex(_ index: Int) { defaults.set(index, forKey: "sort") }
    
    static func storageOption() -> StorageSavingOptions {
        StorageSavingOptions(rawValue: defaults.integer(forKey: "storageOptions")) ?? .oneMonth
    }
    static func saveStorageOption(_ option: StorageSavingOptions) { defaults.set(option.rawValue, forKey: "storageOptions") }
    
    static func nextUpdateInterval() -> Int { sharedDefaults.integer(forKey: "nextUpdate") }
    static func saveNextUpdateInterval(_ interval: Int) { sharedDefaults.set(interval, forKey: "nextUpdate") }
    
    
    // MARK: - Bools
    static func quickConvert() -> Bool { defaults.bool(forKey: "quickConvert") }
    static func saveQuickConvert(_ quickConvert: Bool) { defaults.set(quickConvert, forKey: "quickConvert") }
    
    static func showPercent() -> Bool { defaults.bool(forKey: "showPercent") }
    static func saveShowPercent(_ showPercent: Bool) { defaults.set(showPercent, forKey: "showPercent") }
    
    static func byFavorite() -> Bool { defaults.bool(forKey: "byFavorite") }
    static func saveByFavorite(_ byFavorite: Bool) { defaults.set(byFavorite, forKey: "byFavorite") }
    
    
    // MARK: - Arrays
    static func unlockedTitles() -> [Int] { defaults.array(forKey: "titleIDArray") as? [Int] ?? [0] }
    static func saveUnlockedTitles(_ array: [Int]) { defaults.set(array, forKey: "titleIDArray") }
    
    static func favorites() -> [String] { defaults.stringArray(forKey: "favorites") ?? [] }
    static func saveFavorites(_ array: [String]) { defaults.set(array, forKey: "favorites") }
}

extension Color {
    static let walut = Color(red: 0, green: 0.725, blue: 0.682)
    static let pinkWalut = Color(red: 1, green: 0.78, blue: 0.87)
}
