//
//  SupportDevView.swift
//  Walut
//
//  Created by Marcin Bartminski on 03/11/2022.
//

import SwiftUI

struct SupportDevView: View {
    
    @State var model: SupportDevViewModel
    
    init(user: User) {
        model = SupportDevViewModel(userUnlockedTitles: user.unlockedTitlesArray)
    }
    
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
                .disabled(model.shouldDisableButtons)
            }
        }
        .navigationTitle(String(localized: "support_title"))
        .sheet(isPresented: $model.shouldShowThanks) {
            ThanksView(title: model.titleToPresent, arrayToSave: model.arrayToSave)
                .presentationDetents([.medium, .large])
        }
        
    }
}

struct SupportDevView_Previews: PreviewProvider {
    static var previews: some View {
        SupportDevView(user: User(name: "User", selectedTitleIndex: 0, unlockedTitlesArray: [0, 1], selectedTitleLocalized: "Essa"))
    }
}
