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
            print(error.localizedDescription)
        }
    }
    
    private func present(data: [Currency]) {
        
        let currencyArray = removeBase(from: data)
        
        DispatchQueue.main.async {
            withAnimation {
                self.currencyArray = currencyArray
                self.loading = false
            }
        }
    }
    
    private func removeBase(from array: [Currency]) -> [Currency] {
        return array.filter { $0.code != shared.base.code }
    }
    
}
