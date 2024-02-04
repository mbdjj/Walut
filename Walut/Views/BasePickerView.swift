//
//  BasePickerView.swift
//  Walut
//
//  Created by Marcin Bartminski on 07/10/2022.
//

import SwiftUI

struct BasePickerView: View {
    
    @ObservedObject var model = BasePickerViewModel()
    
    @FocusState var shouldNameFieldBeFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("your_name", text: $model.name)
                    .focused($shouldNameFieldBeFocused)
                    .onSubmit {
                        shouldNameFieldBeFocused = false
                    }
                    .submitLabel(.done)
                
                Section {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        Picker("base_currency", selection: $model.selected) {
                            ForEach(model.currencyArray) { currency in
                                Text("\(currency.flag) \(currency.code)")
                            }
                        }
                    } else {
                        Picker("base_currency", selection: $model.selected) {
                            ForEach(model.currencyArray) { currency in
                                Text("\(currency.flag) (\(currency.code)) \(currency.fullName)")
                            }
                        }
                        .pickerStyle(.navigationLink)
                    }
                    
                    Stepper("\(String(localized: "settings_decimal_numbers")) (\(model.decimal))", value: $model.decimal, in: 2...7)
                }
            }
            .navigationTitle("\(String(localized: "hello"))\(model.name.isEmpty ? "" : " \(model.name)")!")
            .toolbar {
                ToolbarItem {
                    Button {
                        shouldNameFieldBeFocused = false
                        DispatchQueue.main.async {
                            model.saveAndContinue()
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
