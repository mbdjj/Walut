//
//  SortView.swift
//  Walut
//
//  Created by Marcin Bartminski on 10/02/2022.
//

import SwiftUI

struct SortView: View {
    
    @ObservedObject var shared = NetworkManager.shared
    
    @State var selectedSort: Int
    
    @State var ztoa: Bool
    @State var fromLowest: Bool
    
    @State var byFavorite: Bool
    
    let defaults = UserDefaults.standard
    
    @Environment(\.dismiss) var dismiss
    
    init(selectedSort: Int) {
        
        _selectedSort = State(initialValue: selectedSort)
        _byFavorite = State(initialValue: NetworkManager.shared.byFavorite)
        
        switch selectedSort {
        case 1:
            _ztoa = State(initialValue: true)
            _fromLowest = State(initialValue: true)
        case 2:
            _ztoa = State(initialValue: false)
            _fromLowest = State(initialValue: true)
        case 3:
            _ztoa = State(initialValue: true)
            _fromLowest = State(initialValue: true)
        case 4:
            _ztoa = State(initialValue: true)
            _fromLowest = State(initialValue: false)
        default:
            _ztoa = State(initialValue: true)
            _fromLowest = State(initialValue: true)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    Button {
                        ztoa.toggle()
                        if ztoa {
                            selectedSort = 1
                        } else {
                            selectedSort = 2
                        }
                        
                        saveSort()
                    } label: {
                        Text("\(String(localized: "sort_by_code")) \(selectedSort == 1 || selectedSort == 2 ? ztoa ? String(localized: "sort_by_code_ztoa") : String(localized: "sort_by_code_atoz") : "")")
                            .fontWeight(selectedSort == 1 || selectedSort == 2 ? .bold : .regular)
                    }
                    
                    
                    
                    Button {
                        fromLowest.toggle()
                        if fromLowest {
                            selectedSort = 3
                        } else {
                            selectedSort = 4
                        }
                        
                        saveSort()
                    } label: {
                        Text("\(String(localized: "sort_by_price")) \(selectedSort == 3 || selectedSort == 4 ? !fromLowest ? String(localized: "sort_by_price_highest") : String(localized: "sort_by_price_lowest") : "")")
                            .fontWeight(selectedSort == 3 || selectedSort == 4 ? .bold : .regular)
                    }
                    
                    
                    
                    Button {
                        byFavorite = false
                        selectedSort = 5
                        
                        saveSort()
                    } label: {
                        Text(String(localized: "sort_custom"))
                            .fontWeight(selectedSort == 5 ? .bold : .regular)
                    }

                }
                
                Section {
                    Toggle(isOn: $byFavorite) {
                        Text(String(localized: "sort_by_favorite"))
                    }
                    .disabled(selectedSort == 5 ? true : false)
                }
                
            }
            .navigationTitle(String(localized: "sort_nav_title"))
        }
        .onChange(of: byFavorite) { newValue in
            defaults.set(newValue, forKey: "byFavorite")
            shared.byFavorite = newValue
            shared.decodeAndSort()
        }
        .toolbar {
            Button {
                dismiss()
            } label: {
                Text(String(localized: "done"))
                    .bold()
            }

        }
    }
    
    func saveSort() {
        defaults.set(selectedSort, forKey: "sort")
        shared.currentSort = selectedSort
        shared.decodeAndSort()
    }
}

struct SortView_Previews: PreviewProvider {
    static var previews: some View {
        SortView(selectedSort: 1)
    }
}
