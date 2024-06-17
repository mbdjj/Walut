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
    @Environment(AppSettings.self) var settings
    @Query var savedCurrencies: [SavedCurrency]
    
    let currency: Currency
    
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
    
    let mode: CurrencyCell.CellMode
    let value: Double
    
    init(for currency: Currency, mode: CurrencyCell.CellMode, value: Double) {
        self.currency = currency
        currency.price == 1 && mode != .picker ? (self.mode = .loading) : (self.mode = mode)
        self.value = value
    }
    
    enum CellMode {
        case normal
        case quickConvert
        case picker
        case loading
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
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    if mode == .normal {
                        Text(currency.rate != 0 ? Formatter.currency(value: currency.price, currencyCode: settings.baseCurrency?.code ?? "PLN", decimal: settings.decimal) : String(localized: "no_data"))
                            .foregroundColor(.primary)
                    } else if mode == .quickConvert {
                        Text(Formatter.currency(value: currency.rate * value, currencyCode: currency.code, decimal: settings.decimal))
                            .foregroundColor(.primary)
                    } else if mode == .loading {
                        Text("1.001 zł")
                            .foregroundColor(.primary)
                            .redacted(reason: .placeholder)
                        if settings.showPercent {
                            Text("\(Image(systemName: "arrow.right")) 12%")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(percentColor)
                                .redacted(reason: .placeholder)
                        }
                    }
                    
                    if settings.showPercent && currency.rate != 0 && [CellMode.normal, CellMode.quickConvert].contains(mode) {
                        Text("\(Image(systemName: "arrow.\(arrowDirection)")) \(Formatter.percent(value: abs(currency.percent)))")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(percentColor)
                            .contentTransition(.numericText())
                            
                    }
                }
                
            }
            
            if currency.isFavorite && mode != .picker {
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
            CurrencyCell(for: Currency(baseCode: "EUR"), mode: .picker, value: 1)
            CurrencyCell(for: Currency.placeholder, mode: .normal, value: 1)
            CurrencyCell(for: Currency.placeholder, mode: .quickConvert, value: 1)
            CurrencyCell(for: Currency(baseCode: "EUR"), mode: .loading, value: 1)
        }
        .environment(AppSettings.preview)
    }
}
