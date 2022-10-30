//
//  OnboardingViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 27/10/2022.
//

import SwiftUI

class OnboardingViewModel: ObservableObject {
    
    let onboardingData = [
        OnboardingData(emoji: "👋", title: String(localized: "onboarding0"), description: String(localized: "onboarding_desc0")),
        OnboardingData(emoji: "💰", title: String(localized: "onboarding1"), description: String(localized: "onboarding_desc1")),
        OnboardingData(emoji: "🔢", title: String(localized: "onboarding2"), description: String(localized: "onboarding_desc2")),
        OnboardingData(emoji: "📈", title: String(localized: "onboarding3"), description: String(localized: "onboarding_desc3"))
    ]
    
}

struct OnboardingData: Identifiable {
    
    let emoji: String
    let title: String
    let description: String
    
    var id: String { return UUID().uuidString }
    
}
