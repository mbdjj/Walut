//
//  User.swift
//  Walut
//
//  Created by Marcin Bartminski on 15/06/2024.
//

import Foundation

@Observable class User: Identifiable {
    var name: String
    
    var selectedTitleIndex: Int
    var unlockedTitlesArray: [Int]
    var selectedTitleLocalized: String
    
    var id: String { name }
    let defaults = UserDefaults.standard
    
    init(name: String, selectedTitleIndex: Int, unlockedTitlesArray: [Int], selectedTitleLocalized: String) {
        self.name = name
        self.selectedTitleIndex = selectedTitleIndex
        self.unlockedTitlesArray = unlockedTitlesArray
        self.selectedTitleLocalized = selectedTitleLocalized
    }
    
    static func loadUser() -> User? {
        let defaults = UserDefaults.standard
        
        let savedName = defaults.string(forKey: "name")
        let selectedIndex = defaults.integer(forKey: "chosenTitle")
        let unlockedTitles = defaults.array(forKey: "titleIDArray") as? [Int] ?? [0]
        let selectedTitle = StaticData.localizedTitles[selectedIndex]
        
        if let savedName {
            print("Loaded user (\(savedName))")
            return User(
                name: savedName,
                selectedTitleIndex: selectedIndex,
                unlockedTitlesArray: unlockedTitles,
                selectedTitleLocalized: selectedTitle
            )
        } else {
            return nil
        }
    }
    
    @MainActor
    func updateName(to name: String) {
        self.name = name
        defaults.set(name, forKey: "name")
    }
    
    @MainActor
    func changeTitle(to index: Int) {
        selectedTitleIndex = index
        selectedTitleLocalized = StaticData.localizedTitles[index]
        defaults.set(name, forKey: "chosenTitle")
    }
    
    @MainActor
    func unlockTitle(with index: Int) {
        if unlockedTitlesArray.firstIndex(of: index) == nil {
            unlockedTitlesArray.append(index)
            defaults.set(unlockedTitlesArray, forKey: "titleIDArray")
        }
    }
}
