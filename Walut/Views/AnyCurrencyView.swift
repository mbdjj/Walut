//
//  AnyCurrencyView.swift
//  Walut
//
//  Created by Marcin Bartminski on 05/01/2023.
//

import SwiftUI

struct AnyCurrencyView: View {
    
    @ObservedObject var model = AnyCurrencyViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("from_currency", selection: $model.selectedFromCurrency) {
                        ForEach(model.pickerData) { currency in
                            Text("\(currency.flag) \(currency.code)")
                        }
                    }
                    
                    Picker("to_currency", selection: $model.selectedToCurrency) {
                        ForEach(model.pickerData) { currency in
                            Text("\(currency.flag) \(currency.code)")
                        }
                    }
                }
                
                Section {
                    if model.dataLoaded {
                        NavigationLink {
                            CalculationView(base: model.fromCurrency, foreign: model.toCurrency, decimal: SharedDataManager.shared.decimal)
                        } label: {
                            //Text("calculate")
                            CurrencyCell(for: model.toCurrency, base: model.fromCurrency)
                        }

                    } else {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("any_currency_title")
            .refreshable {
                Task {
                    await model.loadData()
                }
            }
            .onChange(of: model.selectedFromCurrency) { _ in
                Task {
                    await model.loadData()
                }
            }
            .onChange(of: model.selectedToCurrency) { _ in
                Task {
                    await model.loadData()
                }
            }
        }
    }
}

struct AnyCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        AnyCurrencyView()
    }
}
