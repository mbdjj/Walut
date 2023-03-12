//
//  BasePickerView.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 12/03/2023.
//

import SwiftUI

struct BasePickerView: View {
    
    @ObservedObject var model = BasePickerViewModel()
    
    var body: some View {
        VStack {
            
            Picker(String(localized: "base_currency"), selection: $model.selectedCurrency) {
                ForEach(SharedDataManager.shared.allCodesArray, id: \.self) { code in
                    let currency = Currency(baseCode: code)
                    
                    Text("\(currency.flag) \(currency.code)")
                    
                }
            }
                //.pickerStyle(.wheel)
            
            Button {
                model.selectBase()
            } label: {
                HStack {
                    
                    Spacer()
                    Text("save")
                    Spacer()
                    
                }
            }
                .buttonStyle(.borderedProminent)
                .padding()
            
            Spacer()
            
        }
        .navigationTitle(String(localized: "base_choose"))
        
        .onAppear {
            let localeBase = Locale.current.currency?.identifier ?? "AUD"
            withAnimation {
                model.selectedCurrency = localeBase
            }
        }
    }
}

struct BasePickerView_Previews: PreviewProvider {
    static var previews: some View {
        BasePickerView()
    }
}
