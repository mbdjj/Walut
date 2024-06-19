//
//  BasePickerView.swift
//  Walut
//
//  Created by Marcin Bartminski on 07/10/2022.
//

import SwiftUI

struct BasePickerView: View {
    
    @Environment(AppSettings.self) var settings
    @Environment(MainCurrencyData.self) var mainCurrencyData
    @StateObject var model = BasePickerViewModel()
    
    @FocusState var shouldNameFieldBeFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                TextField("your_name", text: $model.name)
                    .focused($shouldNameFieldBeFocused)
                    .onSubmit {
                        shouldNameFieldBeFocused = false
                    }
                    .submitLabel(.done)
                
                Section {
                    Picker("base_currency", selection: $model.selected) {
                        ForEach(model.currencyArray) { currency in
                            Text("\(currency.flag) \(currency.code)")
                        }
                    }
                    
                    Stepper("\(String(localized: "settings_decimal_numbers")) (\(model.decimal))", value: $model.decimal, in: 0...7)
                }
            }
            .navigationTitle("\(String(localized: "hello"))\(model.name.isEmpty ? "" : " \(model.name)")!")
            .toolbar {
                ToolbarItem {
                    Button {
                        shouldNameFieldBeFocused = false
                        DispatchQueue.main.async {
                            model.saveUserData()
                            
                            settings.user = User.loadUser()
                            settings.decimal = model.decimal
                            settings.baseCurrency = Currency(baseCode: model.selected)
                            settings.showPercent = true
                            settings.sortByFavorite = true
                            
                            settings.appstate = .baseSelected
                            mainCurrencyData.updateBase(settings.baseCurrency)
                        }
                    } label: {
                        Text(String(localized: "save"))
                    }
                    .bold()
                    .disabled(model.saveButtonDisabled)
                    .onChange(of: model.name) { _, newValue in
                        if newValue == "" {
                            model.saveButtonDisabled = true
                        } else {
                            model.saveButtonDisabled = false
                        }
                    }
                }
            }
        }
        .onAppear {
            shouldNameFieldBeFocused = true
        }
    }
}

struct BasePickerView_Previews: PreviewProvider {
    static var previews: some View {
        BasePickerView()
    }
}
