//
//  ViewManagingView.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI
import SwiftData

struct ViewManagingView: View {
    
    @Environment(AppSettings.self) var settings
    @Environment(\.modelContext) var modelContext
    @State var mainCurrencyData: MainCurrencyData
    @State var selection = 0
    
    init(modelContext: ModelContext, settings: AppSettings) {
        mainCurrencyData = MainCurrencyData(modelContext: modelContext)
        mainCurrencyData.updateBase(settings.baseCurrency)
    }
    
    var body: some View {
        switch settings.appstate {
        case .baseSelected:
            TabView(selection: $selection) {
                CurrencyListView()
                    .environment(mainCurrencyData)
                    .tabItem {
                        Label("All", systemImage: "dollarsign.circle")
                    }
                    .tag(0)
                SettingsView()
                    .tabItem {
                        Label("settings", systemImage: "gear")
                    }
                    .tag(2)
            }
            .onChange(of: settings.baseCurrency) { _, base in
                mainCurrencyData.updateBase(base)
            }
        case .onboarding:
            HelloView()
        case .onboarded:
            BasePickerView()
        }
    }
}

//struct ViewManagingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewManagingView()
//            .environment(AppSettings())
//    }
//}
