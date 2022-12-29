//
//  PercentView.swift
//  WalutWidgetExtension
//
//  Created by Marcin Bartminski on 29/12/2022.
//

import SwiftUI

struct PercentView: View {
    
    let rates: [RatesData]
    
    var entryCurrency: Currency { Currency(baseCode: rates[0].currencyString) }
    var differencePercent: Double {
        let yesterday = rates[0].value
        let today = rates[1].value
        
        return (today - yesterday) / yesterday * 100
    }
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
            return Image(systemName: "arrow.up.right")
        } else {
            return Image(systemName: "arrow.down.right")
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                
                Text("\(entryCurrency.flag) \(entryCurrency.code)")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("\(String(format: "%.3f", rates.last?.value ?? 1.2)) \(Currency(baseCode: "PLN").symbol)")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundColor(.walut)
                
                Label {
                    Text("\(String(format: "%.2f", differencePercent))%")
                } icon: {
                    symbol
                }
                .fontWeight(.semibold)
                .foregroundColor(percentColor)

                
                Spacer()
                Spacer()
            }
            .padding()
            
            Spacer()
        }
    }
}
