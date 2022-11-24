//
//  CurrencyCellViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 24/11/2022.
//

import SwiftUI

class CurrencyCellViewModel: ObservableObject {
    
    let currency: Currency
    let base: Currency
    
    @Published var percent: Double = 0
    var percentColor: Color = .secondary
    
    init(currency: Currency, base: Currency) {
        self.currency = currency
        self.base = base
        
        if SharedDataManager.shared.showPercent {
            Task {
                await fetchPercentData()
            }
        }
    }
    
    func fetchPercentData() async {
        do {
            let percentData = try await NetworkManager.shared.getSmallWidgetData(for: currency.code, baseCode: base.code)
            presentPercentData(with: percentData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func presentPercentData(with data: [RatesData]) {
        let yesterday = data[0].value
        let today = data[1].value
        
        DispatchQueue.main.async {
            self.percent = (today - yesterday) / yesterday * 100
            self.setColor()
        }
    }
    
    func setColor() {
        if percent == 0.0 {
            percentColor = .secondary
        } else if percent > 0.0 {
            percentColor = .green
        } else {
            percentColor = .red
        }
    }
    
}
