//
//  CurrencyList.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI

struct CurrencyListView: View {
    
    @ObservedObject var networkManager = NetworkManager()
    @ObservedObject var shared = SharedDataManager.shared
    
    @State var quichConvertValue = 1.0
    
    init() {
        networkManager.fetchCurrencyData(for: shared.base)
    }
    
    var body: some View {
        NavigationView {
            List {
                
                if shared.quickConvert {
                    Section {
                        TextField("Value", value: $quichConvertValue, format: .currency(code: shared.base.code))
                            .keyboardType(.decimalPad)
                    } header: {
                        Text(String(localized: "quick_convert"))
                    }
                }
                
                ForEach(networkManager.currencyArray) { currency in
                    NavigationLink {
                        CalculationView(base: shared.base, foreign: currency)
                    } label: {
                        CurrencyCell(for: currency, mode: shared.quickConvert ? .quickConvert : .normal, value: quichConvertValue)
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
            .alert(String(localized: "error"), isPresented: $networkManager.shouldDisplayErrorAlert) {
                Button {
                    networkManager.shouldDisplayErrorAlert = false
                    networkManager.errorMessage = ""
                } label: {
                    Text("OK")
                }
            } message: {
                Text("\(networkManager.errorMessage)")
            }
            .scrollDismissesKeyboard(.immediately)
        }
    }
}

//struct CurrencyListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrencyListView()
//    }
//}
