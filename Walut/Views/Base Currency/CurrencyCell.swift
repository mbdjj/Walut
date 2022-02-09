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
            
            Text("\(String(format: "%.3f", currency.price)) \(base.symbol)")
                .font(.system(size: 17))
            
        }
    }
}
