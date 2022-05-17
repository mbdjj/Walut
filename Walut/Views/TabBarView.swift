//
//  TabBarView.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/02/2022.
//

import SwiftUI

struct TabBarView: View {
    
    @State var tabSelection = 0
    
    @ObservedObject var shared = NetworkManager.shared
    
    var body: some View {
        if !shared.isBaseSelected {
            NavigationView {
                BasePickerView(selectedCurrency: shared.base)
            }
        } else {
            TabView(selection: handler) {
                CurrencyList()
                    .tabItem {
                        Label(shared.base.code, systemImage: "dollarsign.circle")
                    }
                    .tag(0)
                
                SettingsView()
                    .tabItem {
                        Label(String(localized: "settings"), systemImage: "gear")
                    }
                    .tag(1)
            }
        }
    }
    
    var handler: Binding<Int> { Binding(
        get: { self.tabSelection },
        set: {
            if $0 == self.tabSelection {
                shared.tappedTwice = true
            }
            
            self.tabSelection = $0
            shared.tabSelection = $0
        }
    )}
}

struct TabBarViewPreviews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
