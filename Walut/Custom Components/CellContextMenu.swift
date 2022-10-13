//
//  CellContextMenu.swift
//  Walut
//
//  Created by Marcin Bartminski on 13/10/2022.
//

import SwiftUI

struct CellContextMenu: View {
    
    let base: Currency
    let currency: Currency
    
    var shared = SharedDataManager.shared
    
    init(for currency: Currency) {
        self.base = SharedDataManager.shared.base
        self.currency = currency
    }
    
    var body: some View {
        Group {
            
            Button {
                withAnimation {
                    //currency.isFavorite ? unfavoriteCurrency(currency) : favoriteCurrency(currency)
                }
            } label: {
                Label(currency.isFavorite ? String(localized: "menu_unfavorite") : String(localized: "menu_favorite"), systemImage: currency.isFavorite ? "star.slash" : "star")
            }

            
            Button {
                presentShareSheet()
            } label: {
                Label(String(localized: "share"), systemImage: "square.and.arrow.up")
            }

        }
    }
    
//    func favoriteCurrency(_ currency: Currency) {
//        let code = currency.code
//        shared.favoriteCodes.append(code)
//
//        if let index = shared.sortedCurrencies.firstIndex(of: currency) {
//            shared.sortedCurrencies[index].isFavorite = true
//        }
//
//        if let index = shared.currencies.firstIndex(of: currency) {
//            shared.currencies[index].isFavorite = true
//        }
//
//        defaults.set(shared.favoriteCodes, forKey: "favorites")
//        shared.decodeAndSort()
//    }
//
//    func unfavoriteCurrency(_ currency: Currency) {
//        let code = currency.code
//        guard let i = shared.favoriteCodes.firstIndex(of: code) else { return }
//        shared.favoriteCodes.remove(at: i)
//
//        if let index = shared.sortedCurrencies.firstIndex(of: currency) {
//            shared.sortedCurrencies[index].isFavorite = false
//        }
//
//        if let index = shared.currencies.firstIndex(of: currency) {
//            shared.currencies[index].isFavorite = false
//        }
//
//        defaults.set(shared.favoriteCodes, forKey: "favorites")
//        shared.decodeAndSort()
//    }
    
    func presentShareSheet() {
        let text = "\(currency.fullName)\(String(localized: "textToShare0"))(\(currency.code))\(String(localized: "textToShare1"))\(String(format: "%.\(shared.decimal)f", currency.price)) \(base.symbol)"

        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

struct CellContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        CellContextMenu(for: Currency(baseCode: "PLN"))
    }
}
