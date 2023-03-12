//
//  CurrencyCell.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 11/03/2023.
//

import SwiftUI

struct CurrencyCell: View {
    
    let currency: Currency
    var base: Currency { SharedDataManager.shared.base }
    
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
        CurrencyCell(currency: Currency(baseCode: "USD"))
    }
}
