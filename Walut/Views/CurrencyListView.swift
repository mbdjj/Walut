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
    
    @ObservedObject var model = CurrencyListViewModel()
    @StateObject var shared = SharedDataManager.shared
    
    @State var quickConvertValue = 1.0
    
    @State var queryString: String = ""
    
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @AppStorage("openCount") var openCount = 0
    @AppStorage("nextUpdate", store: UserDefaults(suiteName: "group.dev.bartminski.Walut")) var nextUpdate = 0
    
    @Environment(\.modelContext) var modelContext
    @Query var savedCurrencies: [SavedCurrency]
    
    var body: some View {
        NavigationStack {
            List {
                
                if shared.quickConvert {
                    Section {
                        TextField("Value", value: $quickConvertValue, format: .currency(code: shared.base.code))
                            .keyboardType(.decimalPad)
                    } header: {
                        Text("quick_convert")
                    }
                }
                
                if !model.loading {
                    if !model.favoritesArray.isEmpty {
                        Section {
                            ForEach(results.0) { currency in
                                Button {
                                    model.selectedCurrency = currency
                                } label: {
                                    CurrencyCell(for: currency, mode: shared.quickConvert ? .quickConvert : .normal, value: quickConvertValue)
                                        .onDrag {
                                            let textToShare = "\(currency.fullName)\(String(localized: "text_to_share0"))(\(currency.code))\(String(localized: "text_to_share1"))\(String(format: "%.\(shared.decimal)f", currency.price)) \(shared.base.symbol)"
                                            return NSItemProvider(object: textToShare as NSString)
                                        }
                                }

                            }
                        }
                    }
                    
                    Section {
                        ForEach(results.1) { currency in
                            Button {
                                model.selectedCurrency = currency
                            } label: {
                                CurrencyCell(for: currency, mode: shared.quickConvert ? .quickConvert : .normal, value: quickConvertValue)
                                    .onDrag {
                                        let textToShare = "\(currency.fullName)\(String(localized: "text_to_share0"))(\(currency.code))\(String(localized: "text_to_share1"))\(String(format: "%.\(shared.decimal)f", currency.price)) \(shared.base.symbol)"
                                        return NSItemProvider(object: textToShare as NSString)
                                    }
                            }
                        }
                    }
                } else {  // placeholder cells while loading
                    if shared.sortByFavorite {
                        Section {
                            ForEach(0 ..< model.numbersForPlaceholders().0, id: \.self) { _ in
                                LoadingCell()
                            }
                        }
                    }
                    
                    Section {
                        ForEach(shared.sortByFavorite ? 0 ..< model.numbersForPlaceholders().1 : 0 ..< shared.allCodesArray.count - 1, id: \.self) { _ in
                            LoadingCell()
                        }
                    }
                }
            }
            .navigationTitle("\(shared.base.flag) \(shared.base.code)")
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
                        SortView()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.circle)
                }
            }
            .refreshable {
                Task {
                    await model.refreshData()
                    saveCurrencies(data: model.currencyArray + model.favoritesArray)
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
            .onAppear {
                Task {
                    await refreshData()
                }
            }
            .onChange(of: networkMonitor.isConnected) { _, connected in
                if connected {
                    Task {
                        await model.refreshData()
                        model.shouldDisplayErrorAlert = false
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                Task {
                    await refreshData()
                }
                
                if openCount < 6 {
                    openCount += 1
                    print(openCount)
                }
                
                if openCount == 5 {
                    requestReview()
                }
            }
            .searchable(text: $queryString) {}
            .sheet(item: $model.selectedCurrency) { currency in
                CurrencyCalcView(currency: currency)
            }
        }
    }
    
    var results: ([Currency], [Currency]) {
        if queryString.isEmpty {
            return (model.favoritesArray, model.currencyArray)
        } else {
            let filteredFav = model.favoritesArray.filter { $0.code.lowercased().contains(queryString.lowercased()) || $0.fullName.lowercased().contains(queryString.lowercased()) }
            let filteredCur = model.currencyArray.filter { $0.code.lowercased().contains(queryString.lowercased()) || $0.fullName.lowercased().contains(queryString.lowercased()) }
            
            return (filteredFav, filteredCur)
        }
    }
    
    private func refreshData() async {
        await model.checkRefreshData()
        
        if !savedCurrencies.contains(where: { $0.base == shared.base.code && $0.nextRefresh == nextUpdate }) {
            print("Couldn't populate data from storage. Refreshing...")
            await model.refreshData()
            saveCurrencies(data: model.currencyArray + model.favoritesArray)
        }
        
        cleanDataFromStorage()
        populateCurrenciesFromMemory()
    }
    
    private func saveCurrencies(data: [Currency]) {
        data.forEach { item in
            if !savedCurrencies.contains(where: { $0.code == item.code && $0.base == shared.base.code && $0.nextRefresh == nextUpdate }) {
                let newSaved = SavedCurrency(code: item.code, base: shared.base.code, rate: item.rate, nextRefresh: nextUpdate)
                modelContext.insert(newSaved)
                print("Saved \(item.code) to SwiftData")
            }
        }
    }
    
    private func populateCurrenciesFromMemory() {
        let currencies = savedCurrencies
            .filter { $0.nextRefresh == nextUpdate && $0.base == shared.base.code }
            .map { Currency(from: $0) }
            .map { currency in
                let lastRate = savedCurrencies
                    .filter { $0.code == currency.code && $0.base == shared.base.code }
                    .sorted { $0.nextRefresh > $1.nextRefresh }
                    .dropFirst()
                    .first?
                    .rate
                
                if let lastRate {
                    var newCurrency = currency
                    newCurrency.lastRate = lastRate
                    return newCurrency
                } else {
                    return currency
                }
            }
        
        withAnimation {
            model.present(data: currencies)
        }
        print("Populated data from memory")
    }
    
    private func cleanDataFromStorage() {
        do {
            let minInterval = model.decodeStorageOptionInterval()
            try modelContext.delete(model: SavedCurrency.self, where: #Predicate {
                $0.nextRefresh < minInterval || $0.nextRefresh > nextUpdate - (12 * 3600) && $0.nextRefresh < nextUpdate
            })
            
            print("Old data successfully deleted")
        } catch {
            print("Couldn't delete old data")
        }
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
