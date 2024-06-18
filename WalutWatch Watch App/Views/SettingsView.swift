//
//  SettingsView.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 12/03/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(AppSettings.self) var settings
    
    var body: some View {
        List {
            Button {
                DispatchQueue.main.async {
                    settings.appstate = .onboarding
                }
            } label: {
                Text("settings_change_base")
            }
            
            NavigationLink {
                SortView(settings: settings)
                EmptyView()
            } label: {
                Text("sort_nav_title")
            }

        }
        .navigationTitle("settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
