//
//  CurrencyListView.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 11/03/2023.
//

import SwiftUI

struct CurrencyListView: View {
    
    @ObservedObject var model = CurrencyListViewModel()
    let shared = SharedDataManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                
//                Section {
//                    NavigationLink {
//                        SettingsView()
//                    } label: {
//                        Label("settings", systemImage: "gear")
//                    }
//                    .swipeActions {
//                        NavigationLink {
//                            SortView()
//                        } label: {
//                            Image(systemName: "arrow.up.arrow.down")
//                        }
//                    }
//                }
                
                if !model.loading {
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
                                        model.handleFavorites(for: currency)
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
                                    model.handleFavorites(for: currency)
                                } label: {
                                    Image(systemName: "star")
                                        .symbolVariant(currency.isFavorite ? .slash : .fill)
                                }
                                .tint(currency.isFavorite ? .red : .yellow)
                            }
                        }
                    }
                } else {  // placeholder cells while loading
                    if shared.sortByFavorite {
                        Section {
                            ForEach(0 ..< model.numbersForPlaceholders().0, id: \.self) { _ in
                                CurrencyCell(currency: Currency.placeholder)
                                    .redacted(reason: .placeholder)
                            }
                        }
                    }
                    
                    Section {
                        ForEach(shared.sortByFavorite ? 0 ..< model.numbersForPlaceholders().1 : 0 ..< shared.allCodesArray.count - 1, id: \.self) { _ in
                            CurrencyCell(currency: Currency.placeholder)
                                .redacted(reason: .placeholder)
                        }
                    }
                }
            }
            .navigationTitle("\(SharedDataManager.shared.base.flag) \(SharedDataManager.shared.base.code)")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("settings", systemImage: "gear")
                    }
                }
            }
        }
    }
}

struct CurrencyListView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyListView()
    }
}
