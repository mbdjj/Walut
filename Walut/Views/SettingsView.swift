//
//  SettingsView.swift
//  Walut
//
//  Created by Marcin Bartminski on 11/10/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var model = SettingsViewModel()
    
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        NavigationStack {
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
                                    Color.walut
                                        .clipShape(Circle())
                                )
                                .padding(.vertical, 4)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(model.name)
                                        .font(.system(.title3))
                                        .fontWeight(.medium)
                                    
                                    if model.isSupporter {
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundColor(model.isZona24 ? .pinkWalut : .walut)
                                            .font(.subheadline)
                                    }
                                }
                                
                                Text(SharedDataManager.shared.chosenTitle)
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
                    
                    NavigationLink {
                        FavoritesView()
                    } label: {
                        Text(String(localized: "favorite_currencies"))
                    }
                    
                    NavigationLink {
                        SortView(isSheet: false)
                    } label: {
                        Text(String(localized: "sort_nav_title"))
                    }
                    
                }
                
                Section {
                    
                    Toggle(String(localized: "settings_quick_conversion"), isOn: $model.quickConvertOn)
                        .onChange(of: model.quickConvertOn) { _, _ in
                            model.saveConvertMode()
                        }
                    
                    Toggle(String(localized: "settings_show_percent"), isOn: $model.showPercent)
                        .onChange(of: model.showPercent) { _, _ in
                            model.saveShowPercent()
                        }
                        .disabled(true)
                    
                    Toggle(String(localized: "settings_reduce_data"), isOn: $model.reduceDataUsage)
                        .onChange(of: model.reduceDataUsage) { _, _ in
                            model.saveReduceDataUsage()
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
                        FeatureRoadmapView()
                    } label: {
                        Text("settings_roadmap")
                    }
                    
                    NavigationLink {
                        SupportDevView()
                    } label: {
                        Text("support")
                    }
                    
                    Button {
                        requestReview()
                    } label: {
                        Text("settings_rate_app")
                            .foregroundColor(.primary)
                    }
                    
                    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
                    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
                    Text("\(String(localized: "settings_version")): \(version) (\(build))")
                        .foregroundColor(.gray)

                }
                
            }
            .navigationTitle("settings")
        }
        .onChange(of: model.selectedBase) { _, _ in
            model.saveBase()
        }
        .onChange(of: model.decimal) { _, _ in
            model.saveDecimal()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
