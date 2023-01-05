//
//  AnyCurrencyViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 05/01/2023.
//

import SwiftUI

class AnyCurrencyViewModel: ObservableObject {
    
    @Published var selectedFromCurrency: String
    @Published var selectedToCurrency: String
    
    @Published var dataLoaded: Bool
    
    @Published var toCurrency: Currency
    var fromCurrency: Currency { Currency(baseCode: selectedFromCurrency) }
    
    @Published var pickerData = [Currency]()
    
    let networkManager = NetworkManager.shared
    
    
    init() {
        selectedFromCurrency = "AUD"
        selectedToCurrency = "AUD"
        toCurrency = Currency(baseCode: "AUD")
        
        dataLoaded = false
        
        for code in SharedDataManager.shared.allCodesArray {
            pickerData.append(Currency(baseCode: code))
        }
        
        Task {
            await loadData()
        }
    }
    
    func loadData() async {
        DispatchQueue.main.async {
            withAnimation {
                self.dataLoaded = false
            }
        }
        do {
            let currency = try await networkManager.getData(for: Currency(baseCode: selectedToCurrency), base: fromCurrency)
            present(data: currency)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func present(data: Currency) {
        DispatchQueue.main.async {
            self.toCurrency = data
            withAnimation {
                self.dataLoaded = true
            }
        }
    }
    
}
