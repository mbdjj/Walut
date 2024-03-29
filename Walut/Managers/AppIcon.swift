//
//  AppIcon.swift
//  Walut
//
//  Created by Marcin Bartminski on 07/10/2022.
//

import SwiftUI

struct AppIcon {
    
    static func changeIcon(to iconName: String) {
        guard UIApplication.shared.supportsAlternateIcons else { return }
        
        if iconName == "AUD" || iconName == "CAD" || iconName == "HKD" || iconName == "MXN" || iconName == "NZD" || iconName == "SGD" || iconName == "USD" {
            UIApplication.shared.setAlternateIconName(nil) { error in
                if let error {
                    print("Failed to change app icon: \(error.localizedDescription)")
                } else {
                    print("App icon changed successfully")
                }
                
                return
            }
        } else {
            UIApplication.shared.setAlternateIconName(iconName) { error in
                if let error {
                    print("Failed to change app icon: \(error.localizedDescription)")
                } else {
                    print("App icon changed successfully")
                }
            }
        }
    }
    
}
