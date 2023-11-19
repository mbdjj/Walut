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
    @ObservedObject var shared = SharedDataManager.shared
    
    @State var quickConvertValue = 1.0
    
    @State var queryString: String = ""
    
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @AppStorage("openCount") var openCount = 0
    @AppStorage("nextUpdate") var nextUpdate = 0
    
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
                        Text(String(localized: "quick_convert"))
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
//                if shared.isCustomDate {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Text(shared.customDateString())
//                            .foregroundColor(.gray)
//                            .fontWeight(.medium)
//                    }
//                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        model.shouldShowDatePickView = true
                    } label: {
                        if shared.isCustomDate {
                            Image(systemName: "calendar")
                                .foregroundColor(Color(uiColor: .systemBackground))
                                .frame(width: 35, height: 35)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .foregroundColor(.walut)
                                }
                        } else {
                            Image(systemName: "calendar")
                        }
                    }
                    .disabled(true)
                    
                    Button {
                        model.shouldShowSortView = true
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
            .refreshable {
                Task {
                    await model.refreshData()
                }
            }
            .alert(String(localized: "error"), isPresented: $model.shouldDisplayErrorAlert) {
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
            .sheet(isPresented: $model.shouldShowSortView) {
                SortView(isSheet: true)
            }
            .sheet(isPresented: $model.shouldShowDatePickView) {
                DatePickView()
            }
            .searchable(text: $queryString) {}
            .sheet(item: $model.selectedCurrency) { currency in
                CurrencyCalcView(currency: currency)
            }
            .sheet(isPresented: $model.shouldShowNotWorkingView) {
                NotWorkingView()
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
        var str = ""
        savedCurrencies.forEach {
            str += "\($0.base)+\($0.code)+\($0.nextRefresh) "
        }
        print("SwiftData storage")
        print(str)
        await model.checkRefreshData()
        saveCurrencies(data: model.currencyArray)
        if savedCurrencies.contains(where: { $0.base == shared.base.code && $0.nextRefresh == nextUpdate }) {
            populateCurrenciesFromMemory()
        } else {
            print("Couldn't populate data from storage. Refreshing...")
            await model.refreshData()
        }
        cleanDataFromStorage()
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
            .filter {
                $0.nextRefresh == nextUpdate && $0.base == shared.base.code
            }
            .map {
                Currency(code: $0.code, rate: $0.rate)
            }
        
        model.present(data: currencies)
        print("Populated data from memory")
    }
    
    private func cleanDataFromStorage() {
        do {
            let minInterval = model.decodeStorageOptionInterval()
            try modelContext.delete(model: SavedCurrency.self, where: #Predicate {
                $0.nextRefresh < minInterval
            })
            
            print("Old data successfully deleted")
//            var str = ""
//            savedCurrencies.forEach {
//                str += "\($0.base)+\($0.code)+\($0.nextRefresh) "
//            }
//            print("SwiftData storage")
//            print(str)
        } catch {
            print("Couldn't delete old data")
        }
    }
}

//struct CurrencyListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrencyListView()
//    }
//}
