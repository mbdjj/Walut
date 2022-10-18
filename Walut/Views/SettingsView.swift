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
                
                Section {
                    HStack {
                        Text(model.letter)
                            .font(.system(.title))
                            .bold()
                            .padding()
                            .foregroundColor(.white)
                            .background(
                                Color.accentColor
                                    .clipShape(Circle())
                            )
                            .padding(.vertical, 4)
                        
                        VStack(alignment: .leading) {
                            Text(model.name)
                                .font(.system(.title3))
                                .fontWeight(.medium)
                            
                            Text("Walut user")
                                .font(.system(.footnote))
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading, 8)
                    }
                }
                
                Section {
                    Picker(String(localized: "base_currency"), selection: $model.selectedBase) {
                        ForEach(model.pickerData) { currency in
                            Text("\(currency.flag) \(currency.code)")
                        }
                    }
                    
                    Stepper("\(String(localized: "settings_decimal_numbers")) (\(model.decimal))", value: $model.decimal, in: 2...7)
                }
                
            }
            .navigationTitle(String(localized: "settings"))
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
