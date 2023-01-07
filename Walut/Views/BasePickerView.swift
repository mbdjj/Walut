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
        NavigationView {
            Form {
                TextField(String(localized: "your_name"), text: $model.name)
                    .focused($shouldNameFieldBeFocused)
                    .onSubmit {
                        shouldNameFieldBeFocused = false
                    }
                    .submitLabel(.done)
                
                Section {
                    Picker(String(localized: "base_currency"), selection: $model.selected) {
                        ForEach(model.currencyArray) { currency in
                            Text("\(currency.flag) \(currency.code)")
                        }
                    }
                    
                    Stepper("\(String(localized: "settings_decimal_numbers")) (\(model.decimal))", value: $model.decimal, in: 2...7)
                }
            }
            .navigationTitle(model.name == "" ? "\(String(localized: "hello"))!" : "\(String(localized: "hello")) \(model.name)!")
            .toolbar {
                ToolbarItem {
                    Button {
                        shouldNameFieldBeFocused = false
                        model.saveAndContinue()
                    } label: {
                        Text(String(localized: "save"))
                    }
                    .bold()
                    .disabled(model.saveButtonDisabled)
                    .onChange(of: model.name) { newValue in
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
