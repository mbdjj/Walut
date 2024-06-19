//
//  ContentView.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 11/03/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(AppSettings.self) var settings
    @Environment(\.modelContext) var modelContext
    @State var mainCurrencyData: MainCurrencyData
    
    init(modelContext: ModelContext, settings: AppSettings) {
        mainCurrencyData = MainCurrencyData(modelContext: modelContext)
        mainCurrencyData.updateBase(settings.baseCurrency)
    }
    
    var body: some View {
        if settings.appstate == .baseSelected {
            CurrencyListView()
                .environment(mainCurrencyData)
        } else {
            BasePickerView()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
