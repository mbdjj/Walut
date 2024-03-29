//
//  ViewManagingView.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI

struct ViewManagingView: View {
    
    @State var selection = 0
    
    private let defaults = UserDefaults.standard
    @ObservedObject var shared = SharedDataManager.shared
    
    var body: some View {
        switch shared.appState {
        case .onboarding:
            HelloView()
        case .onboarded:
            BasePickerView()
        case .baseSelected:
            TabView(selection: $selection) {
                CurrencyListView()
                    .tabItem {
                        Label(shared.base.code, systemImage: "dollarsign.circle")
                    }
                    .tag(0)
                SettingsView()
                    .tabItem {
                        Label("settings", systemImage: "gear")
                    }
                    .tag(2)
            }
        }
    }
}

struct ViewManagingView_Previews: PreviewProvider {
    static var previews: some View {
        ViewManagingView()
    }
}
