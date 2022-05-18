//
//  ContentView.swift
//  WatchWalut WatchKit Extension
//
//  Created by Marcin Bartminski on 18/05/2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var shared = NetworkManager.shared
    
    var body: some View {
        if !shared.isBaseSelected {
            BasePickerView(selectedCurrency: shared.base)
        } else {
            CurrencyList()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
