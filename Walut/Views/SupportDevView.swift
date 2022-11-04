//
//  SupportDevView.swift
//  Walut
//
//  Created by Marcin Bartminski on 03/11/2022.
//

import SwiftUI

struct SupportDevView: View {
    
    @ObservedObject var model = SupportDevViewModel()
    
    var body: some View {
        List {
            ForEach(model.products) { product in
                Button {
                    Task.init {
                        try await model.purchase(product)
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(product.displayName)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Text(product.description)
                                .font(.system(.caption))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text(product.id == "ga.bartminski.WalutApp.SupportSmall" ? "☕️" : "🌯")
                                .font(.title)
                            Text(product.displayPrice)
                                .foregroundColor(.accentColor)
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .navigationTitle(String(localized: "support_title"))
        .sheet(isPresented: $model.shouldShowThanks) {
            ThanksView(title: model.titleToPresent, arrayToSave: model.arrayToSave)
        }
        
    }
}

struct SupportDevView_Previews: PreviewProvider {
    static var previews: some View {
        SupportDevView()
    }
}
