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
    
    let shared = SharedDataManager.shared
    
    init(for currency: Currency) {
        self.currency = currency
        self.base = shared.base
        self.decimal = shared.decimal
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
                            //.padding(4)
                        
                        Spacer()
                    }
                }
            }
            
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
                
                Text("\(String(format: "%.\(decimal)f", currency.price)) \(base.symbol)")
                    .font(.system(size: 17))
                
            }
        }
    }
}

struct CurrencyCell_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyCell(for: Currency(baseCode: "PLN"))
    }
}
