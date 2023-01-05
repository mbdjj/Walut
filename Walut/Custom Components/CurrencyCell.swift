//
//  CurrencyCell.swift
//  Walut
//
//  Created by Marcin Bartminski on 13/10/2022.
//

import SwiftUI

struct CurrencyCell: View {
    
    let currency: Currency
    let base: Currency
    
    let decimal: Int
    
    let shouldShowPercent: Bool
    
    var percent: Double { (currency.price - currency.yesterdayPrice) / currency.yesterdayPrice * 100 }
    var percentColor: Color {
        if percent == 0 {
            return .secondary
        } else if percent > 0 {
            return .green
        } else {
            return .red
        }
    }
    
    let shared = SharedDataManager.shared
    
    let mode: CurrencyCell.CellMode
    let value: Double
    
    init(for currency: Currency, mode: CurrencyCell.CellMode, value: Double) {
        self.currency = currency
        self.base = shared.base
        self.decimal = shared.decimal
        self.mode = mode
        self.value = value
        self.shouldShowPercent = shared.showPercent
    }
    
    init(for currency: Currency, base: Currency) {
        self.currency = currency
        self.base = base
        self.decimal = shared.decimal
        self.mode = .normal
        self.value = 0
        self.shouldShowPercent = false
    }
    
    enum CellMode {
        case normal
        case quickConvert
    }
    
    var body: some View {
        HStack {
            
            Text(currency.flag)
                .font(.system(size: 50))
            
            VStack(alignment: .leading) {
                
                Text(currency.fullName)
                    .font(.system(size: 19))
                    .fontWeight(.medium)
                
                Text(currency.code)
                    .font(.system(size: 17))
                
                Spacer()
                
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                if mode == .normal {
                    Text("\(String(format: "%.\(decimal)f", currency.price)) \(base.symbol)")
                        .font(.system(size: 17))
                } else if mode == .quickConvert {
                    Text("\(String(format: "%.\(decimal)f", currency.rate * value)) \(currency.symbol)")
                        .font(.system(size: 17))
                }
                
                if shouldShowPercent {
                    Text("\(String(format: "%.2f", percent))%")
                        .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(percentColor)
                }
            }
            
        }
    }
    
    
}

struct CurrencyCell_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyCell(for: Currency(baseCode: "PLN"), mode: .normal, value: 1)
            .previewLayout(.fixed(width: 450, height: 90))
    }
}
