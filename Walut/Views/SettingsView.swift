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
                        List {
                            HStack {
                                Text(String(localized: "support"))
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                VStack {
                                    Text("☕️")
                                        .font(.title)
                                    Text("5,99 zł")
                                        .foregroundColor(.accentColor)
                                }
                            }
                            
                            HStack {
                                Text(String(localized: "support_plus"))
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                VStack {
                                    Text("🌯")
                                        .font(.title)
                                    Text("24,99 zł")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
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
