//
//  CalculationView.swift
//  Walut
//
//  Created by Marcin Bartminski on 14/06/2024.
//

import SwiftUI

struct CalculationView: View {
    @State var model: CurrencyCalcViewModel
    
    init(currency: Currency, base: Currency = SharedDataManager.shared.base, shouldSwap: Bool = true) {
        let model = CurrencyCalcViewModel(currency: currency, base: base, shouldSwap: shouldSwap)
        _model = State(initialValue: model)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CalculationView(currency: Currency(baseCode: "USD"))
}
