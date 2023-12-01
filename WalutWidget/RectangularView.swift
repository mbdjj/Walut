//
//  RectangularView.swift
//  WalutWidgetExtension
//
//  Created by Marcin Bartminski on 13/04/2023.
//

import SwiftUI

struct RectangularView: View {
    let baseCode: String
    let currency: Currency
    
    var baseCurrency: Currency { Currency(baseCode: baseCode) }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(currency.flag) \(currency.code)")
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.bold)
                
                Text(SharedDataManager.shared.currencyLocaleString(value: currency.price, currencyCode: baseCode))
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.heavy)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .contentTransition(.numericText())
            }
            
            Spacer()
        }
    }
}
