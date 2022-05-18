//
//  ContentView.swift
//  WatchWalut WatchKit Extension
//
//  Created by Marcin Bartminski on 17/05/2022.
//

import SwiftUI

struct CurrencyList: View {
    
    @ObservedObject var shared = NetworkManager.shared
    let defaults = UserDefaults.standard
    
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    Toggle(String(localized: "sort_by_favorite"), isOn: $shared.byFavorite)
                }
                
                ForEach(shared.sortedCurrencies) { currency in
                    NavigationLink {
                        DetailView(base: shared.base, foreign: currency)
                    } label: {
                        CurrencyCell(base: shared.base, currency: currency)
                    }
                    .swipeActions {
                        Button {
                            withAnimation {
                                currency.isFavorite ? unfavoriteCurrency(currency) : favoriteCurrency(currency)
                            }
                        } label: {
                            Image(systemName: currency.isFavorite ? "star.slash" : "star")
                        }
                    }

                }
            }
            .navigationTitle("\(shared.base.flag) \(shared.base.code)")
            .onChange(of: shared.byFavorite) { newValue in
                defaults.set(newValue, forKey: "byFavorite")
                shared.decodeAndSort()
            }
        }
    }
    
    //MARK: - methods
    
    func favoriteCurrency(_ currency: Currency) {
        let code = currency.code
        shared.favoriteCodes.append(code)
        
        if let index = shared.sortedCurrencies.firstIndex(of: currency) {
            shared.sortedCurrencies[index].isFavorite = true
        }
        
        if let index = shared.currencies.firstIndex(of: currency) {
            shared.currencies[index].isFavorite = true
        }
        
        defaults.set(shared.favoriteCodes, forKey: "favorites")
        shared.decodeAndSort()
    }
    
    func unfavoriteCurrency(_ currency: Currency) {
        let code = currency.code
        guard let i = shared.favoriteCodes.firstIndex(of: code) else { return }
        shared.favoriteCodes.remove(at: i)
        
        if let index = shared.sortedCurrencies.firstIndex(of: currency) {
            shared.sortedCurrencies[index].isFavorite = false
        }
        
        if let index = shared.currencies.firstIndex(of: currency) {
            shared.currencies[index].isFavorite = false
        }
        
        defaults.set(shared.favoriteCodes, forKey: "favorites")
        shared.decodeAndSort()
    }
}

struct CurrencyList_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyList()
    }
}
