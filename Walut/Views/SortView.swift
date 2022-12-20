//
//  SortView.swift
//  Walut
//
//  Created by Marcin Bartminski on 20/12/2022.
//

import SwiftUI

struct SortView: View {
    
    @ObservedObject var model = SortViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        model.selectedSort = .byCode
                    } label: {
                        Text(String(localized: "sort_by_code"))
                            .fontWeight(model.selectedSort == .byCode ? .bold : .regular)
                    }
                    
                    Button {
                        model.selectedSort = .byPrice
                    } label: {
                        Text(String(localized: "sort_by_price"))
                            .fontWeight(model.selectedSort == .byPrice ? .bold : .regular)
                    }
                    
                    Button {
                        model.selectedSort = .byChange
                    } label: {
                        Text(String(localized: "sort_by_change"))
                            .fontWeight(model.selectedSort == .byChange ? .bold : .regular)
                    }
                }
                
                Section {
                    Toggle(isOn: $model.sortByFavorite) {
                        Text(String(localized: "sort_by_favorite"))
                    }
                }
            }
            .navigationTitle(String(localized: "sort"))
        }
    }
}

struct SortView_Previews: PreviewProvider {
    static var previews: some View {
        SortView()
    }
}
