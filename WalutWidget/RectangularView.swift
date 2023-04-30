//
//  RectangularView.swift
//  WalutWidgetExtension
//
//  Created by Marcin Bartminski on 13/04/2023.
//

import SwiftUI

struct RectangularView: View {
    let baseCode: String
    let rates: [RatesData]
    
    var entryCurrency: Currency { Currency(baseCode: rates[0].currencyString) }
    var baseCurrency: Currency { Currency(baseCode: baseCode) }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(entryCurrency.flag) \(entryCurrency.code)")
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.bold)
                
                Text(SharedDataManager.shared.currencyLocaleString(value: rates.last?.value ?? 1.2, currencyCode: baseCode))
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.heavy)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
            }
            
            Spacer()
        }
    }
}

//struct RectangularView_Previews: PreviewProvider {
//    static var previews: some View {
//        RectangularView(code: "PLN", rates: [RatesData])
//    }
//}
