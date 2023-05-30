//
//  SortView.swift
//  Walut
//
//  Created by Marcin Bartminski on 20/12/2022.
//

import SwiftUI

struct SortView: View {
    
    @State var isSheet: Bool
    
    @ObservedObject var model = SortViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        model.selectedSort = .byCode
                    } label: {
                        Text("sort_by_code")
                            .fontWeight(model.selectedSort == .byCode ? .bold : .regular)
                    }
                    
                    Button {
                        model.selectedSort = .byPrice
                    } label: {
                        Text("sort_by_price")
                            .fontWeight(model.selectedSort == .byPrice ? .bold : .regular)
                    }
                    
                    Button {
                        model.selectedSort = .byChange
                    } label: {
                        Text("sort_by_change")
                            .fontWeight(model.selectedSort == .byChange ? .bold : .regular)
                    }
                }
                
                Section {
                    Button {
                        model.selectedDirection = .ascending
                    } label: {
                        Text("sort_ascending")
                            .fontWeight(model.selectedDirection == .ascending ? .bold : .regular)
                    }
                    
                    Button {
                        model.selectedDirection = .descending
                    } label: {
                        Text("sort_descending")
                            .fontWeight(model.selectedDirection == .descending ? .bold : .regular)
                    }
                }
                
                Section {
                    Toggle(isOn: $model.sortByFavorite) {
                        Text("sort_by_favorite")
                    }
                }
            }
            .navigationTitle("sort")
            .toolbar {
                #if !os(watchOS)
                if isSheet {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss.callAsFunction()
                        } label: {
                            Text("cancel")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        model.saveSortAsIndex()
                        model.saveByFavorite()
                    } label: {
                        Text("save")
                            .bold()
                    }
                }
                #endif
            }
            #if os(watchOS)
            .onChange(of: model.selectedSort) { _ in
                model.saveSortAsIndex()
            }
            .onChange(of: model.selectedDirection) { _ in
                model.saveSortAsIndex()
            }
            .onChange(of: model.sortByFavorite) { _ in
                model.saveByFavorite()
            }
            #endif
        }
        .interactiveDismissDisabled(model.changed)
    }
}

struct SortView_Previews: PreviewProvider {
    static var previews: some View {
        SortView(isSheet: true)
    }
}
