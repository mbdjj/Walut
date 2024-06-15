//
//  User.swift
//  Walut
//
//  Created by Marcin Bartminski on 15/06/2024.
//

import Foundation

struct User {
    var name: String
    
    var selectedTitleIndex: Int
    var unlockedTitlesArray: [Int]
    var selectedTitleLocalized: String
    
    static func loadUser() -> User? {
        let defaults = UserDefaults.standard
        
        let savedName = defaults.string(forKey: "name")
        let selectedIndex = defaults.integer(forKey: "chosenTitle")
        let unlockedTitles = defaults.array(forKey: "titleIDArray") as? [Int] ?? [0]
        let selectedTitle = StaticData.localizedTitles[selectedIndex]
        
        if let savedName {
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
}
