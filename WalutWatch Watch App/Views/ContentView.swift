//
//  ContentView.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 11/03/2023.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var shared = SharedDataManager.shared
    
    var body: some View {
        if shared.isBaseSelected {
            CurrencyListView()
        } else {
            BasePickerView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
