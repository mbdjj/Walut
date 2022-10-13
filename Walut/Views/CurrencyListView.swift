//
//  CurrencyList.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI

struct CurrencyListView: View {
    
    //@ObservedObject var model = CurrencyListViewModel()
    @ObservedObject var networkManager = NetworkManager()
    @ObservedObject var shared = SharedDataManager.shared
    
    init() {
        networkManager.fetchCurrencyData(for: shared.base)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(networkManager.currencyArray) { currency in
                    NavigationLink {
                        CalculationView(base: shared.base, foreign: currency)
                    } label: {
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
                            
                            Text("\(String(format: "%.\(shared.decimal)f", currency.price)) \(shared.base.symbol)")
                                .font(.system(size: 17))
                            
                        }
                    }
                    .contextMenu {
                        CellContextMenu(for: currency)
                    }

                }
            }
            .navigationTitle("\(shared.base.flag) \(shared.base.code)")
            .refreshable {
                networkManager.fetchCurrencyData(for: shared.base)
            }
        }
    }
}

//struct CurrencyListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrencyListView()
//    }
//}
