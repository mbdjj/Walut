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
                    Picker(selection: $model.selectedBase) {
                        ForEach(model.pickerData) { currency in
                            Text("\(currency.flag) \(currency.code)")
                        }
                    } label: {
                        Label("base_currency", systemImage: "house")
                    }
                    .foregroundStyle(.primary)
                    
                    Stepper(value: $model.decimal, in: 0...7) {
                        Label("settings_decimal_numbers", systemImage: "\(model.decimal).square")
                    }
                    .foregroundStyle(.primary)
                    
                    NavigationLink {
                        FavoritesView()
                    } label: {
                        Label("favorite_currencies", systemImage: "star")
                    }
                    .foregroundStyle(.primary)
                    
                    NavigationLink {
                        SortView()
                    } label: {
                        Label("sort_nav_title", systemImage: "arrow.up.arrow.down")
                    }
                    .foregroundStyle(.primary)
                    
                    NavigationLink {
                        OnDeviceStorageView()
                    } label: {
                        Label("settings_save_data", systemImage: "square.and.arrow.down")
                    }
                    .foregroundStyle(.primary)
                    
                }
                
                Section {
                    Toggle(isOn: $model.quickConvertOn) {
                        Label("settings_quick_conversion", systemImage: "bolt.fill")
                    }
                    .foregroundStyle(.primary)
                    .onChange(of: model.quickConvertOn) { _, _ in
                        model.saveConvertMode()
                    }
                    
                    Toggle(isOn: $model.showPercent) {
                        Label("settings_show_percent", systemImage: "percent")
                    }
                    .foregroundStyle(.primary)
                    .onChange(of: model.showPercent) { _, _ in
                        model.saveShowPercent()
                    }
                }
                
                Section {
                    Button {
                        model.sendEmail()
                    } label: {
                        Label("settings_email", systemImage: "envelope")
                    }
                    .foregroundStyle(.primary)
                    
                    NavigationLink {
                        SupportDevView()
                    } label: {
                        Label("support", systemImage: "hands.and.sparkles")
                    }
                    .foregroundStyle(.primary)
                    
                    Button {
                        requestReview()
                    } label: {
                        Label("settings_rate_app", systemImage: "star.square")
                    }
                    .foregroundStyle(.primary)
                    
                    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
                    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
                    Label("\(String(localized: "settings_version")): \(version) (\(build))", systemImage: "gear")
                        .foregroundColor(.gray)

                } footer: {
                    Text("exchagerate-api")
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
