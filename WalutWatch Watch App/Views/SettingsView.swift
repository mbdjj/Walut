//
//  SettingsView.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 12/03/2023.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Button {
                DispatchQueue.main.async {
                    SharedDataManager.shared.isBaseSelected = false
                }
            } label: {
                Text("settings_change_base")
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
