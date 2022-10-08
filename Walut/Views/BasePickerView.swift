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
                TextField("Your name", text: $model.name)
                    .focused($shouldNameFieldBeFocused)
                    .onSubmit {
                        shouldNameFieldBeFocused = false
                    }
                    .submitLabel(.done)
                
                Section {
                    Picker("Base currency", selection: $model.selected) {
                        ForEach(model.currencyArray) { currency in
                            Text("\(currency.flag) \(currency.code)")
                        }
                    }
                    
                    Stepper("Decimal places (\(model.decimal))", value: $model.decimal, in: 2...7)
                }
            }
            .navigationTitle(model.name == "" ? "Hello!" : "Hello \(model.name)!")
            .toolbar {
                ToolbarItem {
                    Button {
                        shouldNameFieldBeFocused = false
                        model.saveAndContinue()
                    } label: {
                        Text("Save")
                    }
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
        .fullScreenCover(isPresented: $model.shouldDisplayFullScreenCover) {
            ViewManagingView()
        }
    }
}

struct BasePickerView_Previews: PreviewProvider {
    static var previews: some View {
        BasePickerView()
    }
}
