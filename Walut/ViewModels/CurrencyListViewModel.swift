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
        if shared.favorites.contains(where: { $0 == shared.base.code }) {
            return (shared.favorites.count - 1, shared.allCodesArray.count - shared.favorites.count)
        } else {
            return (shared.favorites.count, shared.allCodesArray.count - shared.favorites.count - 1)
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
        let favoritesArray = array
            .map { $0 }
            .filter { $0.isFavorite }
            .reorder(by: shared.favorites)
        
        let currencyArray = array
            .map { $0 }
            .filter { !$0.isFavorite }
        
        return removeBase(from: (currencyArray, favoritesArray))
    }
    
    private func removeBase(from arrays: ([Currency], [Currency])) -> ([Currency], [Currency]) {
        return (removeBase(from: arrays.0), removeBase(from: arrays.1))
    }
    
    private func removeBase(from array: [Currency]) -> [Currency] {
        return array.filter { $0.code != shared.base.code }
    }
    
    private func sort(array: [Currency]) -> [Currency] {
        switch sortIndex {
        case 0, 1:
            return Sorting.byCode(array, direction: sortDirection)
        case 2, 3:
            return Sorting.byPrice(array, direction: sortDirection)
        case 4, 5:
            return Sorting.byChange(array, direction: sortDirection)
        default:
            return array
        }
    }
    
}
