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
            if UIDevice.current.userInterfaceIdiom == .phone {
                HelloView()
            } else {
                HelloiPadView()
            }
        case .onboarded:
            BasePickerView()
        case .baseSelected:
            if UIDevice.current.userInterfaceIdiom == .phone {
                CurrencyListView()
            } else {
                CurrencyListiPadView()
            }
        }
    }
}

struct ViewManagingView_Previews: PreviewProvider {
    static var previews: some View {
        ViewManagingView()
    }
}
