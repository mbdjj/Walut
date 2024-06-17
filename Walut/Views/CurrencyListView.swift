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
    
    @State var model: CurrencyListViewModel
    @State var quickConvertValue = 1.0
    @State var queryString: String = ""
    
    @Environment(AppSettings.self) var settings
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @AppStorage("openCount") var openCount = 0
    @AppStorage("nextUpdate", store: UserDefaults(suiteName: "group.dev.bartminski.Walut")) var nextUpdate = 0
    
    @Environment(\.modelContext) var modelContext
    @Query var savedCurrencies: [SavedCurrency]
    
    init(modelContext: ModelContext) {
        model = CurrencyListViewModel(modelContext: modelContext)
    }
    
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
                
//                if !model.loading {
                    if !model.favoritesArray.isEmpty {
                        Section {
                            ForEach(model.favoritesArray) { currency in
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
//                } else {  // placeholder cells while loading
//                    if settings.sortByFavorite {
//                        Section {
//                            ForEach(0 ..< model.numbersForPlaceholders().0, id: \.self) { _ in
//                                LoadingCell()
//                            }
//                        }
//                    }
//                    
//                    Section {
//                        ForEach(settings.sortByFavorite ? 0 ..< model.numbersForPlaceholders().1 : 0 ..< StaticData.currencyCodes.count - 1, id: \.self) { _ in
//                            LoadingCell()
//                        }
//                    }
//                }
            }
            .navigationTitle("\(settings.baseCurrency!.flag) \(settings.baseCurrency!.code)")
            .toolbar {
                if nextUpdate < Int(Date().timeIntervalSince1970) && !model.loading {
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
            .refreshable {
//                Task {
//                    await model.refreshData(for: settings.baseCurrency!.code, sortIndex: settings.sortIndex)
//                    SwiftDataManager.saveCurrencies(data: model.currencyArray + model.favoritesArray, to: modelContext)
//                }
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
            .onAppear {
                Task {
                    await loadData()
                }
            }
            .onChange(of: networkMonitor.isConnected) { _, connected in
                if connected {
                    Task {
                        model.shouldDisplayErrorAlert = false
                        await loadData()
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                Task {
                    await loadData()
                }
                
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
    
    private func loadData() async {
        await model.loadData(for: settings.baseCurrency!.code, sortIndex: settings.sortIndex, storageOption: settings.storageOption)
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
