//
//  CurrencyCellContextMenu.swift
//  Walut
//
//  Created by Marcin Bartminski on 10/02/2022.
//

import SwiftUI

struct CellContextMenu: View {
    
    let base: Currency
    let currency: Currency
    //let favoriteArray: [String]
    
    @ObservedObject var shared = NetworkManager.shared
    
    let defaults = UserDefaults.standard
    
    init(for currency: Currency) {
        base = NetworkManager.shared.base
        self.currency = currency
    }
    
    var body: some View {
        Group {
            
            Button {
                withAnimation {
                    currency.isFavorite ? unfavoriteCurrency(currency) : favoriteCurrency(currency)
                }
            } label: {
                Label(currency.isFavorite ? "Unfavorite" : "Favorite", systemImage: currency.isFavorite ? "star.slash" : "star")
            }

            
            Button {
                presentShareSheet()
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }

            
        }
    }
    
    func favoriteCurrency(_ currency: Currency) {
        let code = currency.code
        shared.favoriteCodes.append(code)
        
        if let index = shared.sortedCurrencies.firstIndex(of: currency) {
            shared.sortedCurrencies[index].isFavorite = true
        }
        
        if let index = shared.currencies.firstIndex(of: currency) {
            shared.currencies[index].isFavorite = true
        }
        
        defaults.set(shared.favoriteCodes, forKey: "favorites")
        shared.decodeAndSort()
    }
    
    func unfavoriteCurrency(_ currency: Currency) {
        let code = currency.code
        guard let i = shared.favoriteCodes.firstIndex(of: code) else { return }
        shared.favoriteCodes.remove(at: i)
        
        if let index = shared.sortedCurrencies.firstIndex(of: currency) {
            shared.sortedCurrencies[index].isFavorite = false
        }
        
        if let index = shared.currencies.firstIndex(of: currency) {
            shared.currencies[index].isFavorite = false
        }
        
        defaults.set(shared.favoriteCodes, forKey: "favorites")
        shared.decodeAndSort()
    }
    
    func presentShareSheet() {
        let text = "\(currency.fullName)'s (\(currency.code)) price is now at \(String(format: "%.3f", currency.price)) \(base.symbol)"

        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}
