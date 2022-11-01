//
//  FavoritesView.swift
//  Walut
//
//  Created by Marcin Bartminski on 30/10/2022.
//

import SwiftUI

struct FavoritesView: View {
    
    @ObservedObject var model = FavoritesViewModel()
    
    var body: some View {
        List {
            ForEach(model.favorites) { favorite in
                HStack {
                    Text(favorite.flag)
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading) {
                        
                        Text(favorite.fullName)
                            .font(.system(size: 19))
                            .fontWeight(.medium)
                        
                        Text(favorite.code)
                            .font(.system(size: 17))
                        
                    }
                }
            }
            .onDelete(perform: model.delete)
            .onMove(perform: model.move)
        }
        .navigationTitle(String(localized: "favorites"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Menu {
                ForEach(model.pickerData) { currency in
                    Button {
                        model.addToFavorites(currency: currency)
                    } label: {
                        Text("\(currency.flag) \(currency.code)")
                    }
                }
            } label: {
                Image(systemName: "plus")
            }
            
            EditButton()
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FavoritesView()
        }
    }
}
