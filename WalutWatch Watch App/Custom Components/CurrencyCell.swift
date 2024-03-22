//
//  CurrencyCell.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 11/03/2023.
//

import SwiftUI

struct CurrencyCell: View {
    
    let currency: Currency
    var base: Currency { shared.base }
    
    let shared = SharedDataManager.shared
    
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
                
                Text(currency.rate != 0 ? shared.currencyLocaleString(value: currency.price, currencyCode: base.code, decimal: 3) : String(localized: "no_data"))
            }
        }
        
    }
}

struct CurrencyCell_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyCell(currency: Currency(baseCode: "USD"))
    }
}
