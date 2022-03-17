//
//  SettingsView.swift
//  Walut
//
//  Created by Marcin Bartminski on 09/02/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @State var decimal: Int
    
    let defaults = UserDefaults.standard
    
    init() {
        decimal = defaults.integer(forKey: "decimal")
    }
    
    var body: some View {
        NavigationView {
            List {
                
                NavigationLink {
                    SettingsPickerView()
                } label: {
                    Text("Change base currency")
                }
                
                Stepper("Decimal numbers (\(decimal))", value: $decimal, in: 3...6)
                
            }
            .navigationTitle("Settings")
        }
        
        .onChange(of: decimal) { newValue in
            defaults.set(newValue, forKey: "decimal")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
