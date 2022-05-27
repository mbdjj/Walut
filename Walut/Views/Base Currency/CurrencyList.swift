//
//  CurrencyList.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/02/2022.
//

import SwiftUI

struct CurrencyList: View {
    
    @ObservedObject var shared = NetworkManager.shared
    
    @State var shouldPresentSortPopover: Bool = false
    
    let defaults = UserDefaults.standard
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(shared.sortedCurrencies) { currency in
                    NavigationLink(destination: CalculationView(base: shared.base, foreign: currency)) {
                        
                        CurrencyCell(base: shared.base, currency: currency, decimal: defaults.integer(forKey: "decimal") )
                            .contextMenu {
                                CellContextMenu(for: currency)
                            }
                        
                    }
                }
                .onMove(perform: move)
            }
            .refreshable {
                shared.fetchData(forCode: shared.base.code)
            }
            
            .navigationTitle("\(shared.base.flag) \(shared.base.code)")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    Button {
                        shouldPresentSortPopover = true
                    } label: {
                        Text(String(localized: "sort"))
                    }
                    
                    EditButton()
                    
                }
            }
        }
        
        .popover(isPresented: $shouldPresentSortPopover, content: {
            NavigationView {
                SortView(selectedSort: shared.currentSort)
            }
        })
        .onChange(of: shared.tappedTwice) { tapped in
            if tapped {
                
            }
        }
    }
    
    func move(from: IndexSet, to: Int) {
        shared.sortedCurrencies.move(fromOffsets: from, toOffset: to)
        
        if shared.byFavorite {
            let index = from[from.startIndex]
            print(to)
            
            if index < shared.favoriteCodes.count {
                if to <= shared.favoriteCodes.count {
                    shared.favoriteCodes.move(fromOffsets: from, toOffset: to)
                    defaults.set(shared.favoriteCodes, forKey: "favorites")
                }
            }
        }
        
        if shared.currentSort == 5 {
            shared.customSortCodes.move(fromOffsets: from, toOffset: to)
            print(shared.customSortCodes)
            defaults.set(shared.customSortCodes, forKey: "customSort")
        }
    }
}

struct CurrencyListPreviews: PreviewProvider {
    static var previews: some View {
        CurrencyList()
    }
}
