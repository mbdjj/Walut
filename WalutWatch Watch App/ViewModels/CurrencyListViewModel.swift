//
//  CurrencyListViewModel.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 11/03/2023.
//

import SwiftUI

class CurrencyListViewModel: ObservableObject {
    
    @Published var currencyArray = [Currency]()
    
    @Published var loading: Bool = false
    
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
    
    func refreshData() async {
        do {
            let data = try await networkManager.getCurrencyData(for: shared.base)
            present(data: data)
        } catch {
//            DispatchQueue.main.async {
//                self.errorMessage = error.localizedDescription
//                self.shouldDisplayErrorAlert = true
//            }
        }
    }
    
    private func present(data: [Currency]) {
        
        let currencyArray = removeBase(from: data)
        
//        currencyArray = sort(array: currencyArray)
        
        DispatchQueue.main.async {
            self.currencyArray = currencyArray
        }
        
        DispatchQueue.main.async {
            withAnimation {
                self.loading = false
            }
        }
    }
    
    private func removeBase(from array: [Currency]) -> [Currency] {
        var currencyArray = array
        
        if let index = currencyArray.firstIndex(of: Currency(baseCode: shared.base.code)) {
            currencyArray.remove(at: index)
        }
        
        return currencyArray
    }
    
}
