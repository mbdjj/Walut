//
//  NetworkManager.swift
//  WatchWalut WatchKit Extension
//
//  Created by Marcin Bartminski on 17/05/2022.
//

import Foundation
import SwiftUI

class NetworkManager: ObservableObject {
    
    @Published var base: Currency = Currency(baseCode: "PLN")
    @Published var sortedCurrencies = [Currency]()
    @Published var currencies = [Currency]()
    @Published var favoriteCodes = [String]()
    
    @Published var allCurrencies = [Currency]()
    
    @Published var byFavorite: Bool
    
    @Published var isBaseSelected: Bool
    
    let defaults = UserDefaults.standard
    let sortManager = SortManager()
    
    static let shared = NetworkManager()
    
    let allCodesArray = ["AUD", "BRL", "BGN", "CAD", "CNY", "HRK", "CZK", "DKK", "EUR", "HKD", "HUF", "INR", "IDR", "ILS", "JPY", "MYR", "MXN", "RON", "NZD", "NOK", "PHP", "PLN", "GBP", "RUB", "SGD", "ZAR", "KRW", "SEK", "CHF", "THB", "TRY", "USD"]
    
    init() {
        base = Currency(baseCode: defaults.string(forKey: "base") ?? "AUD")
        isBaseSelected = defaults.bool(forKey: "isBaseSelected")
        
        byFavorite = defaults.bool(forKey: "byFavorite")
        
        if let array = defaults.array(forKey: "favorites") as? [String] {
            favoriteCodes = array
        }
        
        for code in allCodesArray {
            allCurrencies.append(Currency(baseCode: code))
        }
        
        if isBaseSelected {
            fetchData(forCode: base.code)
        }
    }
    
    
    func fetchData(forCode baseCurrency: String) {
        
        currencies = []
        
        if let url = URL(string: "https://api.exchangerate.host/latest?base=\(baseCurrency)") {
            let session = URLSession(configuration: .default)
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
            let task = session.dataTask(with: request) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(CurrencyData.self, from: safeData)
                            
                            var currencyArray = [Currency]()
                            
                            for code in self.allCodesArray {
                                var currency = Currency(code: code, rate: results.rates.getRate(of: code))
                                if self.favoriteCodes.firstIndex(of: code) != nil {
                                    currency.isFavorite = true
                                }
                                currencyArray.append(currency)
                            }
                            
                            guard let index = currencyArray.firstIndex(of: Currency(baseCode: self.base.code)) else { return }
                            currencyArray.remove(at: index)
                            
                            DispatchQueue.main.async {
                                self.currencies = currencyArray
                                self.decodeAndSort()
                            }
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
            
            task.resume()
        }
    }
    
    func decodeAndSort() {
        withAnimation {
            if byFavorite {
                sortedCurrencies = sortManager.favoritesFirst(array: currencies, favorites: favoriteCodes)
            } else {
                sortedCurrencies = currencies
            }
        }
    }
    
}
