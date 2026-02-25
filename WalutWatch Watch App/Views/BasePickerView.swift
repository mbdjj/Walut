//
//  BasePickerView.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 12/03/2023.
//

import SwiftUI

struct BasePickerView: View {
    
    @Environment(AppSettings.self) var settings
    @Environment(MainCurrencyData.self) var mainCurrencyData
    @State var model = BasePickerViewModel()
    
    var body: some View {
        VStack {
            Picker(String(localized: "base_currency"), selection: $model.selectedCurrency) {
                ForEach(StaticData.currencyCodes, id: \.self) { code in
                    let currency = Currency(baseCode: code)
                    Text("\(currency.flag) \(currency.code)")
                }
            }
            
            Button {
                model.saveBase()
                settings.baseCurrency = Currency(baseCode: model.selectedCurrency)
                settings.sortByFavorite = true
                settings.decimal = 3
                settings.appstate = .baseSelected
                
                mainCurrencyData.updateBase(settings.baseCurrency)
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
    }
}

struct BasePickerView_Previews: PreviewProvider {
    static var previews: some View {
        BasePickerView()
    }
}
