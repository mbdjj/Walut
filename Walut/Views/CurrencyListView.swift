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
                            ForEach(model.favoritesArray) { currency in
                                NavigationLink {
                                    CalculationView(base: shared.base, foreign: currency, decimal: shared.decimal)
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
                        ForEach(model.currencyArray) { currency in
                            NavigationLink {
                                CalculationView(base: shared.base, foreign: currency, decimal: shared.decimal)
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
                Button {
                    model.shouldShowDatePickView = true
                } label: {
                    Image(systemName: "calendar")
                }
                
                Button {
                    model.shouldShowSortView = true
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
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
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $model.shouldShowDatePickView) {
                DatePickView()
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

//struct CurrencyListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrencyListView()
//    }
//}
