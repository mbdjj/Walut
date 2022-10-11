//
//  SettingsView.swift
//  Walut
//
//  Created by Marcin Bartminski on 11/10/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var model = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                
                Picker("Base currency", selection: $model.selectedBase) {
                    ForEach(model.pickerData) { currency in
                        Text("\(currency.flag) \(currency.code)")
                    }
                }
                
                Stepper("Decimal places (\(model.decimal))", value: $model.decimal, in: 2...7)
                
            }
            .navigationTitle("Settings")
        }
        .onChange(of: model.selectedBase) { newValue in
            model.saveBase()
        }
        .onChange(of: model.decimal) { newValue in
            model.saveDecimal()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
