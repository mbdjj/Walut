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
    
    var pfpLetter: String { "\(name.first!)" }
    
    var id: String { name }
    
    init(name: String, selectedTitleIndex: Int, unlockedTitlesArray: [Int]) {
        self.name = name
        self.selectedTitleIndex = selectedTitleIndex
        self.unlockedTitlesArray = unlockedTitlesArray
        self.selectedTitleLocalized = StaticData.localizedTitles[selectedTitleIndex]
    }
    
    static func loadUser() -> User? {
        let savedName = Defaults.userName()
        let selectedIndex = Defaults.userSelectedTitleIndex()
        let unlockedTitles = Defaults.unlockedTitles()
        
        if let savedName {
            print("Loaded user (\(savedName))")
            return User(
                name: savedName,
                selectedTitleIndex: selectedIndex,
                unlockedTitlesArray: unlockedTitles
            )
        } else {
            return nil
        }
    }
    
    @MainActor
    func updateName(to name: String) {
        self.name = name
        Defaults.saveUserName(name)
    }
    
    @MainActor
    func changeTitle(to index: Int) {
        selectedTitleIndex = index
        selectedTitleLocalized = StaticData.localizedTitles[index]
        Defaults.saveUserSelectedTitleIndex(index)
    }
    
    @MainActor
    func unlockTitle(at index: Int) {
        if unlockedTitlesArray.firstIndex(of: index) == nil {
            unlockedTitlesArray.append(index)
            Defaults.saveUnlockedTitles(unlockedTitlesArray)
        }
    }
}
