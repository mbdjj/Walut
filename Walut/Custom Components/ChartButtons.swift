//
//  ChartButtons.swift
//  Walut
//
//  Created by Marcin Bartminski on 23/05/2023.
//

import SwiftUI

struct ChartButtons: View {
    
    @Binding var selected: ChartRange
    
    let ranges: [ChartRange] = [.oneMonth, .threeMonths, .sixMonths, .year]
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(ranges) { range in
                Text(range.title)
                    .foregroundColor(selected == range ? .primary : .gray)
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .frame(width: 40, height: 35)
                    .onTapGesture { selected = range }
            }
        }
        .frame(height: 50)
        .background {
            HStack {
                if selected == .year { Spacer() }
                if selected == .threeMonths { Spacer() }
                if selected == .sixMonths { Spacer(); Spacer() }
                
                Color(uiColor: .systemGray5)
                    .frame(width: 40, height: 35)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                if selected == .threeMonths { Spacer(); Spacer() }
                if selected == .sixMonths { Spacer() }
                if selected == .oneMonth { Spacer() }
            }
        }
        .animation(.spring(), value: selected)
    }
}

struct ChartButtons_Previews: PreviewProvider {
    static var previews: some View {
        ChartButtons(selected: .constant(.oneMonth))
    }
}
