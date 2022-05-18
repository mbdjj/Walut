//
//  BasePickerView.swift
//  WatchWalut WatchKit Extension
//
//  Created by Marcin Bartminski on 18/05/2022.
//

import SwiftUI

struct BasePickerView: View {
    @ObservedObject var shared = NetworkManager.shared
    
    @State var currencySelected: String
    @State var shouldShowTabBar = false
    
    let defaults = UserDefaults.standard
    
    init(selectedCurrency: Currency) {
        self.currencySelected = selectedCurrency.code
    }
    
    var body: some View {
        VStack {
            
            Picker(String(localized: "base_currency"), selection: $currencySelected) {
                ForEach(shared.allCurrencies) { currency in
                    
                    Text("\(currency.flag) \(currency.code)")
                    
                }
            }
                //.pickerStyle(.wheel)
            
            Button {
                
                defaults.set(currencySelected, forKey: "base")
                defaults.set(true, forKey: "isBaseSelected")
                shared.base = Currency(baseCode: currencySelected)
                shared.isBaseSelected = true
                shared.fetchData(forCode: currencySelected)
                
                DispatchQueue.main.async {
                    shouldShowTabBar.toggle()
                }
                
            } label: {
                HStack {
                    
                    Spacer()
                    Text(String(localized: "save"))
                    Spacer()
                    
                }
            }
                .buttonStyle(.borderedProminent)
                .padding()
            
            Spacer()
            
        }
        .navigationTitle(String(localized: "base_choose"))
        
        .fullScreenCover(isPresented: $shouldShowTabBar, onDismiss: nil, content: {
            CurrencyList()
        })
        
        .onAppear {
            currencySelected = shared.base.code
        }
    }
}

struct BasePickerView_Previews: PreviewProvider {
    static var previews: some View {
        BasePickerView(selectedCurrency: Currency(baseCode: "PLN"))
    }
}
