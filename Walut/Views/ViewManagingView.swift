//
//  ViewManagingView.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI

struct ViewManagingView: View {
    
    @State var selection = 0
    
    let defaults = UserDefaults.standard
    @ObservedObject var shared = SharedDataManager.shared
    
    var body: some View {
        if shared.isBaseSelected {
            TabView(selection: $selection) {
                CurrencyListView()
                    .tabItem {
                        Label(shared.base.code, systemImage: "dollarsign.circle")
                    }
                    .tag(0)
                AnyCurrencyView()
                    .tabItem {
                        Label(String(localized: "any_currency"), systemImage: "questionmark.circle")
                    }
                    .tag(1)
                SettingsView()
                    .tabItem {
                        Label(String(localized: "settings"), systemImage: "gear")
                    }
                    .tag(2)
            }
        } else {
            if shared.onboardingDone {
                BasePickerView()
            } else {
                HelloView()
            }
        }
    }
}

struct ViewManagingView_Previews: PreviewProvider {
    static var previews: some View {
        ViewManagingView()
    }
}
