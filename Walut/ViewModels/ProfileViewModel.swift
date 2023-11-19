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
    
    @Published var secretCode = ""
    @Published var shouldDisplayAlert: Bool = false
    private var shouldSaveTitle = false
    @Published var titleIDToSave = 0
    
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    let titleArray: [String]
    
    private let shared = SharedDataManager.shared
    private let defaults = UserDefaults.standard
    
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
    
    @MainActor func saveTitles() {
        if shouldSaveTitle {
            shared.titleIDArray.append(titleIDToSave)
            shared.defaults.set(shared.titleIDArray, forKey: "titleIDArray")
            titlePickerData = shared.titleIDArray
            secretCode = ""
        }
    }
    
    @MainActor func checkCode() {
        shouldSaveTitle = false
        
        if let secretID = shared.secretDictionary[secretCode] {
            if shared.titleIDArray.firstIndex(of: secretID) == nil {
                titleIDToSave = secretID
                shouldSaveTitle = true
                
                let t = shared.titleArray[secretID]
                alertTitle = String(localized: "alert_positive_title")
                alertMessage = "\(String(localized: "alert_positive_message_1")) \(t)\(String(localized: "alert_positive_message_2"))"
            } else {
                alertTitle = String(localized: "alert_repeated_title")
                alertMessage = String(localized: "alert_repeated_message")
            }
        } else {
            alertTitle = String(localized: "alert_invalid_title")
            alertMessage = String(localized: "alert_invalid_message")
        }
    }
    
}
