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
                    Picker("", selection: $model.selectedSort) {
                        Text("sort_by_code").tag(SortType.byCode)
                        Text("sort_by_price").tag(SortType.byPrice)
                        Text("sort_by_change").tag(SortType.byChange)
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
                
                Section {
                    Picker("", selection: $model.selectedDirection) {
                        Text("sort_ascending").tag(SortDirection.ascending)
                        Text("sort_descending").tag(SortDirection.descending)
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
                
                Section {
                    Toggle(isOn: $model.sortByFavorite) {
                        Text("sort_by_favorite")
                    }
                }
            }
            .navigationTitle("sort")
            .onChange(of: model.selectedSort) { _, _ in
                model.saveSortAsIndex()
            }
            .onChange(of: model.selectedDirection) { _, _ in
                model.saveSortAsIndex()
            }
            .onChange(of: model.sortByFavorite) { _, _ in
                model.saveByFavorite()
            }
        }
    }
}

struct SortView_Previews: PreviewProvider {
    static var previews: some View {
        SortView()
    }
}
