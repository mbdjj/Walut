//
//  CurrencyListView.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 11/03/2023.
//

import SwiftUI
import SwiftData

struct CurrencyListView: View {
    
    @Environment(AppSettings.self) var settings
    @Environment(MainCurrencyData.self) var mainCurrencyData
    @State var model = CurrencyListViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                if !model.favoritesArray.isEmpty {
                    Section {
                        ForEach(model.favoritesArray) { currency in
                            Button {
                                model.selectedCurrency = currency
                            } label: {
                                CurrencyCell(currency: currency)
                            }
                            .swipeActions {
                                Button {
                                    settings.handleFavoriteFlip(of: currency)
                                } label: {
                                    Image(systemName: "star")
                                        .symbolVariant(currency.isFavorite ? .slash : .fill)
                                }
                                .tint(currency.isFavorite ? .red : .yellow)
                            }

                        }
                    }
                }
                
                Section {
                    ForEach(model.currencyArray) { currency in
                        Button {
                            model.selectedCurrency = currency
                        } label: {
                            CurrencyCell(currency: currency)
                        }
                        .swipeActions {
                            Button {
                                settings.handleFavoriteFlip(of: currency)
                            } label: {
                                Image(systemName: "star")
                                    .symbolVariant(currency.isFavorite ? .slash : .fill)
                            }
                            .tint(currency.isFavorite ? .red : .yellow)
                        }
                    }
                }
            }
            .containerBackground(Color.walut.gradient, for: .navigation)
            .navigationTitle("\(settings.baseCurrency!.flag) \(settings.baseCurrency!.code)")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("settings", systemImage: "gear")
                    }
                }
            }
            .onAppear {
                presentData()
            }
            .onChange(of: mainCurrencyData.dataUpdateControlNumber) { _, _ in
                presentData()
            }
            .navigationDestination(item: $model.selectedCurrency) { currency in
                CurrencyView(currency: currency, base: settings.baseCurrency!)
            }
        }
    }
    
    private func presentData() {
        model.present(
            data: mainCurrencyData.allCurrencyData,
            baseCode: settings.baseCurrency!.code,
            sortIndex: settings.sortIndex
        )
    }
}

//struct CurrencyListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrencyListView()
//    }
//}
