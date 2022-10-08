//
//  CurrencyList.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI

struct CurrencyListView: View {
    
    @ObservedObject var model = CurrencyListViewModel()
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(networkManager.currencyArray) { currency in
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
                        
                        Text("\(String(format: "%.\(model.decimal)f", currency.price)) \(model.baseCurrency.symbol)")
                            .font(.system(size: 17))
                        
                    }
                }
            }
            .navigationTitle("\(model.baseCurrency.flag) \(model.baseCurrency.code)")
        }
        .onAppear {
            networkManager.fetchCurrencyData(for: model.baseCurrency)
        }
    }
}

//struct CurrencyListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrencyListView()
//    }
//}
