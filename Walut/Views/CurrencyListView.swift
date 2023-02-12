//
//  CurrencyList.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI

struct CurrencyListView: View {
    
    @ObservedObject var model = CurrencyListViewModel()
    @ObservedObject var shared = SharedDataManager.shared
    
    @State var quickConvertValue = 1.0
    
    @State var queryString: String = ""
    
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
                                    //CalculationView(base: shared.base, foreign: currency, decimal: shared.decimal)
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
                                //CalculationView(base: shared.base, foreign: currency, decimal: shared.decimal)
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
                if shared.isCustomDate {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text(shared.customDateString())
                            .foregroundColor(.gray)
                            .fontWeight(.medium)
                    }
                }
                
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
                    await model.checkRefreshData()
                }
            }
            .sheet(isPresented: $model.shouldShowSortView) {
                SortView(isSheet: true)
            }
            .sheet(isPresented: $model.shouldShowDatePickView) {
                DatePickView()
            }
            .searchable(text: $queryString) {
                
            }
            .sheet(item: $model.selectedCurrency) { currency in
                CurrencyOverviewView(currency: currency)
                    .presentationDetents([.fraction(0.9), .large])
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
}

//struct CurrencyListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrencyListView()
//    }
//}
