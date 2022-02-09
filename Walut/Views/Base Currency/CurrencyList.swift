//
//  CurrencyList.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/02/2022.
//

import SwiftUI

struct CurrencyList: View {
    
    @ObservedObject var shared = NetworkManager.shared
    
    var body: some View {
        
        NavigationView {
            List (shared.currencies) { currency in
                NavigationLink(destination: CalculationView(base: shared.base, foreign: currency)) {
                    
                    CurrencyCell(base: shared.base, currency: currency)
                }
            }
            .refreshable {
                shared.fetchData(forCode: shared.base.code)
            }
            
            .navigationTitle("\(shared.base.flag) \(shared.base.code)")
        }
        
        .onAppear {
            shared.fetchData(forCode: shared.base.code)
        }
        .onChange(of: shared.tappedTwice) { tapped in
            if tapped {
                
            }
        }
    }
}

struct CurrencyListPreviews: PreviewProvider {
    static var previews: some View {
        CurrencyList()
    }
}
