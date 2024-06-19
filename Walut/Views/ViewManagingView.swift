//
//  ViewManagingView.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI
import SwiftData

struct ViewManagingView: View {
    
    @Environment(AppSettings.self) var settings
    @Environment(\.modelContext) var modelContext
    @State var mainCurrencyData: MainCurrencyData
    @AppStorage("selectedTab") var selection: Int = 1
    
    init(modelContext: ModelContext, settings: AppSettings) {
        mainCurrencyData = MainCurrencyData(modelContext: modelContext)
        mainCurrencyData.updateBase(settings.baseCurrency)
    }
    
    var body: some View {
        switch settings.appstate {
        case .baseSelected:
            TabView(selection: $selection) {
                CurrencyListView()
                    .environment(mainCurrencyData)
                    .tabItem {
                        Label("All", systemImage: "dollarsign.circle")
                    }
                    .tag(1)
            }
            .onChange(of: settings.baseCurrency) { _, base in
                mainCurrencyData.updateBase(base)
            }
            .alert("error", isPresented: $mainCurrencyData.shouldDisplayErrorAlert) {
                Button {
                    mainCurrencyData.shouldDisplayErrorAlert = false
                    mainCurrencyData.errorMessage = ""
                } label: {
                    Text("OK")
                }
            } message: {
                Text("\(mainCurrencyData.errorMessage)")
            }
        case .onboarding:
            HelloView()
        case .onboarded:
            BasePickerView()
        }
    }
}

//struct ViewManagingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewManagingView()
//            .environment(AppSettings())
//    }
//}
