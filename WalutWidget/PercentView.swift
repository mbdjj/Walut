//
//  PercentView.swift
//  WalutWidgetExtension
//
//  Created by Marcin Bartminski on 29/12/2022.
//

import SwiftUI

struct PercentView: View {
    
    let currency: Currency
    let baseCode: String
    
    var baseCurrency: Currency { Currency(baseCode: baseCode) }
    var differencePercent: Double { currency.percent }
    var percentColor: Color {
        if differencePercent == 0 {
            return .secondary
        } else if differencePercent > 0 {
            return .green
        } else {
            return .red
        }
    }
    var symbol: Image {
        if differencePercent == 0 {
            return Image(systemName: "arrow.right")
        } else if differencePercent > 0 {
            return Image(systemName: "arrow.up")
        } else {
            return Image(systemName: "arrow.down")
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                
                Text("\(currency.flag) \(currency.code)")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                
                Text(SharedDataManager.shared.currencyLocaleString(value: currency.price, currencyCode: baseCode))
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.heavy)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundColor(.walut)
                    .contentTransition(.numericText())
                
                if currency.lastRate != nil {
                    Label {
                        Text(SharedDataManager.shared.percentLocaleStirng(value: abs(differencePercent)))
                    } icon: {
                        symbol
                    }
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .foregroundColor(percentColor)
                }

                
                Spacer()
            }
            
            Spacer()
        }
    }
}
