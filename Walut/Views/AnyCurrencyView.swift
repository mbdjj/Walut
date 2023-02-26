//
//  AnyCurrencyView.swift
//  Walut
//
//  Created by Marcin Bartminski on 05/01/2023.
//

import SwiftUI

struct AnyCurrencyView: View {
    
    @ObservedObject var model = AnyCurrencyViewModel()
    @State private var showOverview = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("from_currency", selection: $model.selectedFromCurrency) {
                        if model.selectedFromCurrency == "---" {
                            Text("---")
                        }
                        ForEach(model.pickerData) { currency in
                            Text("\(currency.flag) \(currency.code)")
                        }
                    }
                    
                    Picker("to_currency", selection: $model.selectedToCurrency) {
                        if model.selectedToCurrency == "---" {
                            Text("---")
                        }
                        ForEach(model.pickerData) { currency in
                            Text("\(currency.flag) \(currency.code)")
                        }
                    }
                }
                
                Section {
                    if model.dataLoaded {
                        Button {
                            showOverview = true
                        } label: {
                            CurrencyCell(for: model.toCurrency, base: model.fromCurrency)
                        }

                    } else {
                        LoadingCell(showPercent: false)
                    }
                }
            }
            .navigationTitle("any_currency_title")
            .toolbar {
                Button {
                    model.swapSelection()
                } label: {
                    Image(systemName: "rectangle.2.swap")
                }
            }
            .refreshable {
                Task {
                    await model.loadData()
                }
            }
            .onChange(of: "\(model.selectedFromCurrency)\(model.selectedToCurrency)") { _ in
                Task {
                    await model.loadData()
                }
            }
            .sheet(isPresented: $showOverview) {
                CurrencyCalcView(currency: model.toCurrency, base: model.fromCurrency, shouldSwap: false)
            }
        }
    }
}

struct AnyCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        AnyCurrencyView()
    }
}
