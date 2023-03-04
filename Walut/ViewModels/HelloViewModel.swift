//
//  OnboardingViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 27/10/2022.
//

import SwiftUI

class HelloViewModel: ObservableObject {
    
    let onboardingData = [
        OnboardingData(iconName: "dollarsign", title: String(localized: "onboarding1"), description: String(localized: "onboarding_desc1")),
        OnboardingData(iconName: "x.squareroot", title: String(localized: "onboarding2"), description: String(localized: "onboarding_desc2")),
        OnboardingData(iconName: "chart.line.uptrend.xyaxis", title: String(localized: "onboarding3"), description: String(localized: "onboarding_desc3"))
    ]
    
}

struct OnboardingData: Identifiable {
    
    let iconName: String
    let title: String
    let description: String
    
    var id: String { UUID().uuidString }
    
}
