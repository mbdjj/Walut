//
//  CurrencyCell.swift
//  Walut
//
//  Created by Marcin Bartminski on 13/10/2022.
//

import SwiftUI
import SwiftData

struct CurrencyCell: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var savedCurrencies: [SavedCurrency]
    
    let currency: Currency
    let base: Currency
    
    let decimal: Int
    
    let shouldShowPercent: Bool
    var percentColor: Color {
        if currency.percent == 0 {
            return .secondary
        } else if currency.percent > 0 {
            return .green
        } else {
            return .red
        }
    }
    var arrowDirection: String {
        if currency.percent == 0 {
            return "right"
        } else if currency.percent > 0 {
            return "up"
        } else {
            return "down"
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
    
    enum CellMode {
        case normal
        case quickConvert
    }
    
    var body: some View {
        ZStack {
            HStack {
                
                Text(currency.flag)
                    .font(.system(size: 50))
                
                VStack(alignment: .leading) {
                    
                    Text(currency.fullName)
                        .font(.system(size: 19))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(currency.code)
                        .font(.system(size: 17))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    if mode == .normal {
                        Text(currency.rate != 0 ? shared.currencyLocaleString(value: currency.price, currencyCode: base.code) : String(localized: "no_data"))
                            .font(.system(size: 17))
                            .foregroundColor(.primary)
                    } else if mode == .quickConvert {
                        Text(shared.currencyLocaleString(value: currency.rate * value, currencyCode: currency.code))
                            .font(.system(size: 17))
                            .foregroundColor(.primary)
                    }
                    
                    if shouldShowPercent && currency.rate != 0 {
                        Text("\(Image(systemName: "arrow.\(arrowDirection)")) \(shared.percentLocaleStirng(value: abs(currency.percent)))")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(percentColor)
                            .contentTransition(.numericText())
                    }
                }
                
            }
            
            if currency.isFavorite {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct CurrencyCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CurrencyCell(for: Currency(baseCode: "PLN"), mode: .normal, value: 1)
        }
    }
}
