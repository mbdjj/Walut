//
//  CurrencyListView.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 11/03/2023.
//

import SwiftUI

struct CurrencyListView: View {
    
    @ObservedObject var model = CurrencyListViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("settings", systemImage: "gear")
                    }
                    .swipeActions {
                        NavigationLink {
                            
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    }
                }
                
                if !model.loading {
                    ForEach(model.currencyArray) { currency in
                        CurrencyCell(currency: currency)
                    }
                } else {
                    ForEach(0 ..< 33) { _ in
                        CurrencyCell(currency: Currency.placeholder)
                            .redacted(reason: .placeholder)
                    }
                }
            }
            .navigationTitle("\(SharedDataManager.shared.base.flag) \(SharedDataManager.shared.base.code)")
        }
    }
}

struct CurrencyListView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyListView()
    }
}
