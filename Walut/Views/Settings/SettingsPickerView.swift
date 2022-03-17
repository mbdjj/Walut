//
//  SettingsPickerView.swift
//  Walut
//
//  Created by Marcin Bartminski on 09/02/2022.
//

import SwiftUI

struct SettingsPickerView: View {
    
    @ObservedObject var shared = NetworkManager.shared
    
    @State var currencySelected: String = "AUD"
    
    @Environment(\.dismiss) var dismiss
    
    let defaults = UserDefaults.standard
    
    var body: some View {
        VStack {
            
            Picker("Base currency", selection: $currencySelected) {
                ForEach(shared.allCurrencies) { currency in
                    
                    Text("\(currency.flag) \(currency.fullName) (\(currency.code))")
                    
                }
            }
                .pickerStyle(.wheel)
            
            Button {
                
                let oldBaseCode = defaults.string(forKey: "base")
                
                defaults.set(currencySelected, forKey: "base")
                shared.base = Currency(baseCode: currencySelected)
                
                if let index = shared.favoriteCodes.firstIndex(of: currencySelected) {
                    shared.favoriteCodes.remove(at: index)
                    defaults.set(shared.favoriteCodes, forKey: "favorites")
                }
                
                if shared.customSortCodes.firstIndex(of: oldBaseCode!) == nil {
                    shared.customSortCodes.append(oldBaseCode!)
                }
                
                shared.fetchData(forCode: shared.base.code)
                shared.changeIcon(to: shared.base.code)
                
                dismiss.callAsFunction()
                
            } label: {
                HStack {
                    
                    Spacer()
                    Text("Save")
                    Spacer()
                    
                }
            }
                .buttonStyle(.borderedProminent)
                .padding()
            
            Spacer()
            
        }
        
        .onAppear {
            currencySelected = shared.base.code
        }
    }
}

struct SettingsPickerView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPickerView()
    }
}
