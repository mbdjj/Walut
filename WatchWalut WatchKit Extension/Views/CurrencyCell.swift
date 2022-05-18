//
//  CurrencyCell.swift
//  WatchWalut WatchKit Extension
//
//  Created by Marcin Bartminski on 17/05/2022.
//

import SwiftUI

struct CurrencyCell: View {
    
    let base: Currency
    let currency: Currency
    
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
                Text("\(currency.flag) \(currency.code)")
                
                Spacer()
                
                Text("\(String(format: "%.3f", currency.price)) \(base.symbol)")
            }
        }
        
    }
}

struct CurrencyCell_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyCell(base: Currency(baseCode: "PLN"), currency: Currency(baseCode: "PLN"))
    }
}
