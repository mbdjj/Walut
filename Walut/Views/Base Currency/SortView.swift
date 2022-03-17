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
    
    init(selectedSort: Int) {
        
        self.selectedSort = selectedSort
        self.byFavorite = NetworkManager.shared.byFavorite
        
        switch selectedSort {
        case 1:
            ztoa = true
            fromLowest = true
        case 2:
            ztoa = false
            fromLowest = true
        case 3:
            ztoa = true
            fromLowest = true
        case 4:
            ztoa = true
            fromLowest = false
        default:
            ztoa = true
            fromLowest = true
        }
    }
    
    var body: some View {
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
                    Text("By code \(selectedSort == 1 || selectedSort == 2 ? ztoa ? "(Z to A)" : "(A to Z)" : "")")
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
                    Text("By price \(selectedSort == 3 || selectedSort == 4 ? !fromLowest ? "(from highest)" : "(from lowest)" : "")")
                        .fontWeight(selectedSort == 3 || selectedSort == 4 ? .bold : .regular)
                }
                
                
                
                Button {
                    byFavorite = false
                    selectedSort = 5
                    
                    saveSort()
                } label: {
                    Text("Custom")
                        .fontWeight(selectedSort == 5 ? .bold : .regular)
                }

            }
            
            Section {
                Toggle(isOn: $byFavorite) {
                    Text("By favorite")
                }
                .disabled(selectedSort == 5 ? true : false)
            }
            
        }
        .navigationTitle("Sort currencies")
        
        .onChange(of: byFavorite) { newValue in
            defaults.set(newValue, forKey: "byFavorite")
            shared.byFavorite = newValue
            shared.decodeAndSort()
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
        NavigationView {
            SortView(selectedSort: 1)
        }
    }
}
