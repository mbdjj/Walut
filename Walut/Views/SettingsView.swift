//
//  SettingsView.swift
//  Walut
//
//  Created by Marcin Bartminski on 11/10/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(AppSettings.self) var settings
    @Environment(\.requestReview) var requestReview
    
    @State var selectedBaseCode = Defaults.baseCode()!
    
    var isSupporter: Bool {
        settings.user!.unlockedTitlesArray.contains([3]) || settings.user!.unlockedTitlesArray.contains([4])
    }
    var isZona24: Bool { settings.user!.selectedTitleIndex == 9 }
    
    var body: some View {
        NavigationStack {
            List {
                @Bindable var settings = settings
                Section {
                    NavigationLink {
                        ProfileView(settings: settings)
                    } label: {
                        HStack {
                            Text(settings.user!.pfpLetter)
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
                                    Text(settings.user!.name)
                                        .font(.system(.title3))
                                        .fontWeight(.medium)
                                    
                                    if isSupporter {
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundColor(isZona24 ? .pinkWalut : .walut)
                                            .font(.subheadline)
                                    }
                                }
                                
                                Text(settings.user!.selectedTitleLocalized)
                                    .font(.system(.footnote))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 8)
                        }
                    }

                }
                
                Section {
                    Picker(selection: $selectedBaseCode) {
                        ForEach(StaticData.currencyCodes.map({ Currency(baseCode: $0) })) { currency in
                            Text("\(currency.flag) \(currency.code)")
                        }
                    } label: {
                        Label("base_currency", systemImage: "house")
                    }
                    .foregroundStyle(.primary)
                    .onChange(of: selectedBaseCode) { _, code in
                        settings.baseCurrency = Currency(baseCode: code)
                    }
                    
                    Stepper(value: $settings.decimal, in: 0...7) {
                        Label("settings_decimal_numbers", systemImage: "\(settings.decimal).square")
                    }
                    .foregroundStyle(.primary)
                    .onChange(of: settings.decimal) { _, _ in
                        settings.saveDecimal()
                    }
                    
                    NavigationLink {
                        FavoritesView(settings: settings)
                    } label: {
                        Label("favorite_currencies", systemImage: "star")
                    }
                    .foregroundStyle(.primary)
                    
                    NavigationLink {
                        SortView(settings: settings)
                    } label: {
                        Label("sort_nav_title", systemImage: "arrow.up.arrow.down")
                    }
                    .foregroundStyle(.primary)
                    
                    NavigationLink {
                        OnDeviceStorageView(settings: settings)
                    } label: {
                        Label("settings_save_data", systemImage: "square.and.arrow.down")
                    }
                    .foregroundStyle(.primary)
                    
                }
                
                Section {
                    Toggle(isOn: $settings.quickConvert) {
                        Label("settings_quick_conversion", systemImage: "bolt.fill")
                    }
                    .foregroundStyle(.primary)
                    .onChange(of: settings.quickConvert) { _, _ in
                        settings.saveConvertMode()
                    }
                    
                    Toggle(isOn: $settings.showPercent) {
                        Label("settings_show_percent", systemImage: "percent")
                    }
                    .foregroundStyle(.primary)
                    .onChange(of: settings.showPercent) { _, _ in
                        settings.saveShowPercent()
                    }
                }
                
                Section {
                    Button {
                        sendEmail()
                    } label: {
                        Label("settings_email", systemImage: "envelope")
                    }
                    .foregroundStyle(.primary)
                    
                    NavigationLink {
                        SupportDevView(user: settings.user!)
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
    }
    
    func sendEmail() {
        let subject = String(localized: "settings_email_subject")
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let url = URL(string: "mailto:marcin@bartminski.dev?subject=\(subjectEncoded)")
        
        if let url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("D:")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
