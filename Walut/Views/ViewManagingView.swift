//
//  ViewManagingView.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI

struct ViewManagingView: View {
    
    @State var selection = 0
    
    let isBaseSelected: Bool
    
    let defaults = UserDefaults.standard
    @ObservedObject var shared = SharedDataManager.shared
    
    init() {
        self.isBaseSelected = defaults.bool(forKey: "isBaseSelected")
    }
    
    var body: some View {
        if isBaseSelected {
            TabView(selection: $selection) {
                CurrencyListView()
                    .tabItem {
                        Label(shared.base.code, systemImage: "dollarsign.circle")
                    }
                    .tag(0)
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(1)
            }
        } else {
            BasePickerView()
        }
    }
}

struct ViewManagingView_Previews: PreviewProvider {
    static var previews: some View {
        ViewManagingView()
    }
}
