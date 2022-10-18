//
//  ProfileViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 18/10/2022.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    
    @Published var name: String
    
    @Published var titlePickerData: [Int]
    @Published var selectedTitle: Int
    
    let titleArray: [String]
    
    var letter: String { "\(name.first ?? "U")" }
    
    var shared = SharedDataManager.shared
    let defaults = UserDefaults.standard
    
    init() {
        name = shared.name
        
        titlePickerData = shared.titleIDArray
        selectedTitle = shared.defaults.integer(forKey: "chosenTitle")
        
        titleArray = shared.titleArray
    }
    
    func save() {
        shared.name = name
        shared.chosenTitle = titleArray[selectedTitle]
        
        defaults.set(name, forKey: "name")
        defaults.set(selectedTitle, forKey: "chosenTitle")
    }
    
}
