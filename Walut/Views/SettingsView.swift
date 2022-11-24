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
                    NavigationLink {
                        ProfileView()
                    } label: {
                        HStack {
                            Text(model.letter)
                                .font(.system(.title, design: .rounded))
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
                                
                                Text(model.shared.chosenTitle)
                                    .font(.system(.footnote))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 8)
                        }
                    }

                }
                
                Section {
                    Picker(String(localized: "base_currency"), selection: $model.selectedBase) {
                        ForEach(model.pickerData) { currency in
                            Text("\(currency.flag) \(currency.code)")
                        }
                    }
                    
                    Stepper("\(String(localized: "settings_decimal_numbers")) (\(model.decimal))", value: $model.decimal, in: 2...7)
                    
                    Toggle(String(localized: "settings_quick_conversion"), isOn: $model.quickConvertOn)
                        .onChange(of: model.quickConvertOn) { _ in
                            model.saveConvertMode()
                        }
                    
                    Toggle(String(localized: "settings_show_percent"), isOn: $model.showPercent)
                        .onChange(of: model.showPercent) { _ in
                            model.saveShowPercent()
                        }
                    
                    NavigationLink {
                        FavoritesView()
                    } label: {
                        Text(String(localized: "favorite_currencies"))
                    }

                }
                
                Section {
                    TextField(String(localized: "settings_enter_code"), text: $model.secretCode)
                        .onSubmit {
                            model.checkCode()
                            model.shouldDisplayAlert = true
                        }
                        .submitLabel(.done)
                        .alert(model.alertTitle, isPresented: $model.shouldDisplayAlert) {
                            Button {
                                model.saveTitles()
                            } label: {
                                Text("OK")
                            }
                        } message: {
                            Text(model.alertMessage)
                        }

                }
                
                Section {
                    NavigationLink {
                        SupportDevView()
                    } label: {
                        Text(String(localized: "support"))
                    }

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
