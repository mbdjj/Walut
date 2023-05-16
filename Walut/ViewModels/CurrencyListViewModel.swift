//
//  CurrencyListViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 21/11/2022.
//

import SwiftUI

class CurrencyListViewModel: ObservableObject {
    
    @Published var favoritesArray = [Currency]()
    @Published var currencyArray = [Currency]()
    
    @Published var selectedCurrency: Currency?
    
    @Published var loading: Bool = false
    
    @Published var errorMessage = ""
    @Published var shouldDisplayErrorAlert = false
    
    @Published var shouldShowSortView = false
    @Published var shouldShowDatePickView = false
    
    var sortIndex: Int { shared.sortIndex }
    var sortDirection: SortDirection { shared.sortIndex % 2 == 0 ? .ascending : .descending }
    var byFavorite: Bool { shared.sortByFavorite }
    var isCustomDate: Bool { shared.isCustomDate }
    var customDate: Date { shared.customDate }
    
    let shared = SharedDataManager.shared
    let networkManager = NetworkManager.shared
    
    init() {
        DispatchQueue.main.async {
            self.loading = true
        }
        
        Task {
            await refreshData()
        }
    }
    
    
    func numbersForPlaceholders() -> (Int, Int) {
        var favorites = shared.favorites
        let baseCode = shared.base.code
        
        if let index = favorites.firstIndex(of: baseCode) {
            favorites.remove(at: index)
            
            return (favorites.count, shared.allCodesArray.count - favorites.count)
        } else {
            return (favorites.count, shared.allCodesArray.count - favorites.count - 1)
        }
    }
    
    func refreshData() async {
        do {
            if isCustomDate {
                let data = try await networkManager.getCurrencyData(for: shared.base, date: customDate)
                present(data: data)
            } else {
                let data = try await networkManager.getCurrencyData(for: shared.base)
                present(data: data)
            }
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
        if byFavorite {
            var (currencyArray, favoritesArray) = splitFavorites(from: data)
            
            currencyArray = sort(array: currencyArray)
            
            DispatchQueue.main.async {
                self.favoritesArray = favoritesArray
                self.currencyArray = currencyArray
            }
        } else {
            var currencyArray = removeBase(from: data)
            
            currencyArray = sort(array: currencyArray)
            
            DispatchQueue.main.async {
                self.currencyArray = currencyArray
            }
        }
        
        DispatchQueue.main.async {
            withAnimation {
                self.loading = false
            }
        }
    }
    
    private func splitFavorites(from array: [Currency]) -> ([Currency], [Currency]) {
        
        var favoritesArray = [Currency]()
        var currencyArray = [Currency]()
        
        for currency in array {
            if currency.isFavorite {
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
            }
        }
        
        return (currencyArray, favoritesArray)
    }
    
    private func removeBase(from array: [Currency]) -> [Currency] {
        var currencyArray = array
        
        if let index = currencyArray.firstIndex(of: Currency(baseCode: shared.base.code)) {
            currencyArray.remove(at: index)
        }
        
        return currencyArray
    }
    
    private func sort(array: [Currency]) -> [Currency] {
        if sortIndex == 0 || sortIndex == 1 {
            return Sorting.byCode(array, direction: sortDirection)
        } else if sortIndex == 2 || sortIndex == 3 {
            return Sorting.byPrice(array, direction: sortDirection)
        } else if sortIndex == 4 || sortIndex == 5 {
            return Sorting.byChange(array, direction: sortDirection)
        } else {
            return array
        }
    }
    
}
