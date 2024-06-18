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
    @State var model: CurrencyListViewModel
    
    init(modelContext: ModelContext) {
        model = CurrencyListViewModel(modelContext: modelContext)
    }
    
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
                Task {
                    await loadData()
                }
            }
            .refreshable {
                Task {
                    await loadData()
                }
            }
            .navigationDestination(item: $model.selectedCurrency) { currency in
                CurrencyView(currency: currency, base: settings.baseCurrency!)
            }
        }
    }
    
    private func loadData() async {
        await model.loadData(for: settings.baseCurrency!.code, sortIndex: settings.sortIndex, storageOption: settings.storageOption)
    }
}

//struct CurrencyListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrencyListView()
//    }
//}
