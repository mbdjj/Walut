//
//  CurrencyListViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI

class CurrencyListViewModel: ObservableObject {
    
    @Published var currencyArray = [Currency]()
    
    @ObservedObject var shared = SharedDataManager.shared
    
}
