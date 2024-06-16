//
//  ProfileViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 18/10/2022.
//

import SwiftUI

@Observable class ProfileViewModel {
    
    var name: String
    
    var titlePickerData: [Int]
    var selectedTitle: Int
    
    var secretCode = ""
    var shouldDisplayAlert: Bool = false
    var shouldSaveTitle = false
    var titleIDToSave = 0
    
    var alertTitle = ""
    var alertMessage = ""
    
    let titleArray: [String]
    
    private let defaults = UserDefaults.standard
    
    init(settings: AppSettings) {
        name = settings.user!.name
        
        titlePickerData = settings.user!.unlockedTitlesArray
        selectedTitle = settings.user!.selectedTitleIndex
        
        titleArray = StaticData.localizedTitles
    }
    
    @MainActor 
    func checkCode() {
        shouldSaveTitle = false
        
        if let secretID = StaticData.secretCodes[secretCode] {
            if titlePickerData.firstIndex(of: secretID) == nil {
                titleIDToSave = secretID
                shouldSaveTitle = true
                
                let t = StaticData.localizedTitles[secretID]
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
