//
//  CurrencyCell.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 11/03/2023.
//

import SwiftUI

struct CurrencyCell: View {
    
    @Environment(AppSettings.self) var settings
    
    let currency: Currency
    var base: Currency { settings.baseCurrency! }
    
    let mode: CurrencyCell.CellMode
    
    init(currency: Currency) {
        self.currency = currency
        currency.price == 1 ? (self.mode = .loading) : (self.mode = .normal)
    }
    
    enum CellMode {
        case normal
        case loading
    }
    
    var body: some View {
        
        ZStack {
            if currency.isFavorite {
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color.yellow)
                            .font(.system(size: 10))
                        
                        Spacer()
                    }
                }
            }
            
            HStack {
                Text("\(currency.flag) \(currency.code)")
                
                Spacer()
                
                switch mode {
                case .normal:
                    Text(currency.rate != 0 ? Formatter.currency(value: currency.price, currencyCode: base.code, decimal: Defaults.decimal()) : String(localized: "no_data"))
                case .loading:
                    Text("1,234 zł")
                        .redacted(reason: .placeholder)
                }
            }
        }
        
    }
}

struct CurrencyCell_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyCell(currency: Currency(baseCode: "USD"))
    }
}
