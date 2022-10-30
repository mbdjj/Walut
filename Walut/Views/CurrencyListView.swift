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
    
    @State var quickConvertValue = 1.0
    
    init() {
        networkManager.fetchCurrencyData(for: shared.base)
    }
    
    var body: some View {
        NavigationView {
            List {
                
                if shared.quickConvert {
                    Section {
                        TextField("Value", value: $quickConvertValue, format: .currency(code: shared.base.code))
                            .keyboardType(.decimalPad)
                    } header: {
                        Text(String(localized: "quick_convert"))
                    }
                }
                
                if !networkManager.favoritesArray.isEmpty {
                    Section {
                        ForEach(networkManager.favoritesArray) { currency in
                            NavigationLink {
                                CalculationView(base: shared.base, foreign: currency, decimal: shared.decimal)
                            } label: {
                                CurrencyCell(for: currency, mode: shared.quickConvert ? .quickConvert : .normal, value: quickConvertValue)
                                    .onDrag {
                                        let textToShare = "\(currency.fullName)\(String(localized: "text_to_share0"))(\(currency.code))\(String(localized: "text_to_share1"))\(String(format: "%.\(shared.decimal)f", currency.price)) \(shared.base.symbol)"
                                        return NSItemProvider(object: textToShare as NSString)
                                    }
                            }

                        }
                    }
                }
                
                Section {
                    ForEach(networkManager.currencyArray) { currency in
                        NavigationLink {
                            CalculationView(base: shared.base, foreign: currency, decimal: shared.decimal)
                        } label: {
                            CurrencyCell(for: currency, mode: shared.quickConvert ? .quickConvert : .normal, value: quickConvertValue)
                                .onDrag {
                                    let textToShare = "\(currency.fullName)\(String(localized: "text_to_share0"))(\(currency.code))\(String(localized: "text_to_share1"))\(String(format: "%.\(shared.decimal)f", currency.price)) \(shared.base.symbol)"
                                    return NSItemProvider(object: textToShare as NSString)
                                }
                        }

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
