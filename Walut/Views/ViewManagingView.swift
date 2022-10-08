//
//  ViewManagingView.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI

struct ViewManagingView: View {
    
    let isBaseSelected: Bool
    
    let defaults = UserDefaults.standard
    
    init() {
        self.isBaseSelected = defaults.bool(forKey: "isBaseSelected")
    }
    
    var body: some View {
        if isBaseSelected {
            CurrencyListView()
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
