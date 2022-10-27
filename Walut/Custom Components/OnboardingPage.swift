//
//  OnboardingPage.swift
//  Walut
//
//  Created by Marcin Bartminski on 27/10/2022.
//

import SwiftUI

struct OnboardingPage: View {
    
    let emoji: String
    let title: String
    let description: String
    
    init(_ data: OnboardingData) {
        emoji = data.emoji
        title = data.title
        description = data.description
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(emoji)
                .font(.system(size: 150))
            
            Text(title)
                .font(.system(size: 35, weight: .heavy, design: .rounded))
                .padding(.bottom, 12)
            
            Text(description)
                .font(.system(size: 18, weight: .light, design: .rounded))
        }
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
        .padding()
    }
}

struct OnboardingPage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPage(OnboardingData(emoji: "👋", title: "Welcome to Walut!", description: "Check current currency rates and quickly calculate from your home currency"))
            .previewLayout(.sizeThatFits)
            .background(Color.accentColor)
    }
}
