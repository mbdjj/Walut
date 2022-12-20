//
//  CurrencyListViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 21/11/2022.
//

import Foundation

class CurrencyListViewModel: ObservableObject {
    
    @Published var favoritesArray = [Currency]()
    @Published var currencyArray = [Currency]()
    
    @Published var errorMessage = ""
    @Published var shouldDisplayErrorAlert = false
    
    @Published var shouldShowSortView = false
    
    let shared = SharedDataManager.shared
    let networkManager = NetworkManager.shared
    
    init() {
        Task {
            await refreshData()
        }
    }
    
    
    func refreshData() async {
        do {
            let data = try await networkManager.getCurrencyData(for: shared.base)
            present(data: data)
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.shouldDisplayErrorAlert = true
            }
        }
    }
    
    func checkRefreshData() async {
        let shouldRefresh = networkManager.shouldRefresh()
        
        if shouldRefresh {
            await self.refreshData()
        } else {
            return
        }
    }
    
    private func present(data: [Currency]) {
        let (currencyArray, favoritesArray) = splitFavorites(from: data)
        
        DispatchQueue.main.async {
            self.favoritesArray = favoritesArray
            self.currencyArray = currencyArray
        }
    }
    
    private func splitFavorites(from array: [Currency]) -> ([Currency], [Currency]) {
        
        var favoritesArray = [Currency]()
        var currencyArray = [Currency]()
        
        for currency in array {
            if shared.favorites.firstIndex(of: currency.code) != nil {
                favoritesArray.append(currency)
            } else {
                currencyArray.append(currency)
            }
        }
        
        for code in shared.favorites {
            let indexFrom = favoritesArray.firstIndex { $0.code == code }!
            let indexTo = shared.favorites.firstIndex(of: code)!
            
            let currency = favoritesArray.remove(at: indexFrom)
            favoritesArray.insert(currency, at: indexTo)
        }
        
        return removeBase(from: (currencyArray, favoritesArray))
    }
    
    private func removeBase(from arrays: ([Currency], [Currency])) -> ([Currency], [Currency]) {
        var currencyArray = arrays.0
        var favoritesArray = arrays.1
        
        if let index = currencyArray.firstIndex(of: Currency(baseCode: shared.base.code)) {
            currencyArray.remove(at: index)
        } else {
            if let index = favoritesArray.firstIndex(of: Currency(baseCode: shared.base.code)) {
                favoritesArray.remove(at: index)
            } else {
                return ([], [])
            }
        }
        
        return (currencyArray, favoritesArray)
    }
    
}
