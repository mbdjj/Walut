//
//  ViewManagingView.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI

struct ViewManagingView: View {
    
    @Environment(GlobalCurrencyData.self) var currencyData
    @State var selection = 0
    
    var body: some View {
        switch currencyData.appstate {
        case .baseSelected:
            TabView(selection: $selection) {
                CurrencyListView()
                    .tabItem {
                        Label(currencyData.baseCurrency?.code ?? "All", systemImage: "dollarsign.circle")
                    }
                    .tag(0)
                SettingsView()
                    .tabItem {
                        Label("settings", systemImage: "gear")
                    }
                    .tag(2)
            }
        case .onboarding:
            HelloView()
        case .onboarded:
            BasePickerView()
        }
    }
}

struct ViewManagingView_Previews: PreviewProvider {
    static var previews: some View {
        ViewManagingView()
    }
}
