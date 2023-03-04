//
//  OnboardingCell.swift
//  Walut
//
//  Created by Marcin Bartminski on 03/03/2023.
//

import SwiftUI

struct OnboardingCell: View {
    
    let iconName: String
    let title: String
    let description: String
    
    init(_ data: OnboardingData) {
        iconName = data.iconName
        title = data.title
        description = data.description
    }
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: 54))
                .foregroundColor(.walut)
                .frame(width: 70, height: 60)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                Text(description)
                    .font(.system(.body, design: .rounded))
            }
        }
    }
}

struct OnboardingCell_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCell(OnboardingData(iconName: "chart.line.uptrend.xyaxis", title: "Check current rates", description: "Walut takes data from the Internet and presents it to you in a simple way."))
    }
}
