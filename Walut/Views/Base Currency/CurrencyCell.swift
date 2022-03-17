//
//  CurrencyCell.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/02/2022.
//

import SwiftUI

struct CurrencyCell: View {
    
    let base: Currency
    let currency: Currency
    
    let decimal: Int
    
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
        CurrencyCell(base: Currency(baseCode: "PLN"), currency: Currency(baseCode: "USD"), decimal: 3)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/75.0/*@END_MENU_TOKEN@*/))
    }
}
