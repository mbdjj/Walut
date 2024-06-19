//
//  CurrencyList.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI
import StoreKit
import SwiftData

struct CurrencyListView: View {
    
    @State var model = CurrencyListViewModel()
    @State var quickConvertValue = 1.0
    @State var queryString: String = ""
    
    @Environment(AppSettings.self) var settings
    @Environment(MainCurrencyData.self) var mainCurrencyData
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @AppStorage("openCount") var openCount = 0
    @AppStorage("nextUpdate", store: Defaults.sharedDefaults) var nextUpdate = 0
    
    @Environment(\.modelContext) var modelContext
    @Query var savedCurrencies: [SavedCurrency]
    
    var body: some View {
        NavigationStack {
            List {
                
                if settings.quickConvert {
                    Section {
                        TextField("Value", value: $quickConvertValue, format: .currency(code: settings.baseCurrency!.code))
                            .keyboardType(.decimalPad)
                    } header: {
                        Text("quick_convert")
                    }
                }
                

//                if !model.favoritesArray.isEmpty {
//                    Section {
//                        ForEach(model.favoritesArray) { currency in
//                            Button {
//                                model.selectedCurrency = currency
//                            } label: {
//                                CurrencyCell(for: currency, mode: settings.quickConvert ? .quickConvert : .normal, value: quickConvertValue)
//                                    .onDrag {
//                                        let textToShare = "\(currency.fullName)\(String(localized: "text_to_share0"))(\(currency.code))\(String(localized: "text_to_share1"))\(String(format: "%.\(settings.decimal)f", currency.price)) \(settings.baseCurrency!.symbol)"
//                                        return NSItemProvider(object: textToShare as NSString)
//                                    }
//                            }
//
//                        }
//                    }
//                }
                
                Section {
                    ForEach(model.currencyArray) { currency in
                        Button {
                            model.selectedCurrency = currency
                        } label: {
                            CurrencyCell(for: currency, mode: settings.quickConvert ? .quickConvert : .normal, value: quickConvertValue)
                                .onDrag {
                                    let textToShare = "\(currency.fullName)\(String(localized: "text_to_share0"))(\(currency.code))\(String(localized: "text_to_share1"))\(String(format: "%.\(settings.decimal)f", currency.price)) \(settings.baseCurrency!.symbol)"
                                    return NSItemProvider(object: textToShare as NSString)
                                }
                        }
                    }
                }

            }
            .navigationTitle("\(settings.baseCurrency!.flag) \(settings.baseCurrency!.code)")
            .toolbar {
                if nextUpdate < Int(Date().timeIntervalSince1970) && !mainCurrencyData.loading {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(systemName: "wifi.slash")
                            .foregroundColor(.gray)
                            .fontWeight(.medium)
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SortView(settings: settings)
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.circle)
                }
            }
            .alert("error", isPresented: $model.shouldDisplayErrorAlert) {
                Button {
                    model.shouldDisplayErrorAlert = false
                    model.errorMessage = ""
                } label: {
                    Text("OK")
                }
            } message: {
                Text("\(model.errorMessage)")
            }
            .scrollDismissesKeyboard(.immediately)
            .onChange(of: networkMonitor.isConnected) { _, connected in
                if connected {
                    Task {
                        model.shouldDisplayErrorAlert = false
                        presentData()
                    }
                }
            }
            .onChange(of: mainCurrencyData.dataUpdateControlNumber) { _, _ in
                presentData()
                if mainCurrencyData.allCurrencyData.isEmpty {
                    printSwiftData()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                presentData()
                
                if openCount < 6 {
                    openCount += 1
                    print(openCount)
                }
                
                if openCount == 5 {
                    requestReview()
                }
            }
            .navigationDestination(item: $model.selectedCurrency) { currency in
                CalculationView(currency: currency, base: settings.baseCurrency!)
            }
        }
    }
    
    private func presentData() {
        model.present(
            data: mainCurrencyData.allCurrencyData,
            baseCode: settings.baseCurrency!.code,
            sortIndex: settings.sortIndex
        )
    }
    
    private func printSwiftData() {
        var str = ""
        for saved in savedCurrencies {
            str += saved.dataIdentity + " "
        }
        print(nextUpdate)
        print(str)
    }
}

//struct CurrencyListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrencyListView()
//    }
//}
