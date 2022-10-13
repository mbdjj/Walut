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
                        CurrencyCell(for: currency)
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
