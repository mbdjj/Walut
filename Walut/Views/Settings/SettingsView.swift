//
//  SettingsView.swift
//  Walut
//
//  Created by Marcin Bartminski on 09/02/2022.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                
                NavigationLink {
                    SettingsPickerView()
                } label: {
                    Text("Change base currency")
                }
                
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
