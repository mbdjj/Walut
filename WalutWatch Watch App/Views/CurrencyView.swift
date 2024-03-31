//
//  CurrencyView.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 22/03/2024.
//

import SwiftUI

struct CurrencyView: View {
    
    @State var model: CurrencyCalcViewModel
    let shared = SharedDataManager.shared
    
    init(currency: Currency, base: Currency = SharedDataManager.shared.base, shouldSwap: Bool = true) {
        let model = CurrencyCalcViewModel(currency: currency, base: base, shouldSwap: shouldSwap)
        _model = State(initialValue: model)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(shared.currencyLocaleString(value: model.topAmount, currencyCode: model.topCurrency.code, decimal: 2))
                .font(.system(.title2, design: .rounded, weight: .bold))
            
            Text(shared.currencyLocaleString(value: model.bottomAmount, currencyCode: model.bottomCurrency.code, decimal: 2))
                .font(.system(.title3, design: .rounded, weight: .bold))
            
            Spacer()
            
            HStack {
                Text(model.topCurrency.flag)
                    .font(.title)
                Spacer()
                Image(systemName: "arrow.right")
                    .bold()
                Spacer()
                Text(model.bottomCurrency.flag)
                    .font(.title)
            }
            .padding(.horizontal)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .focusable(true)
        .digitalCrownRotation($model.topAmount, from: 1, through: 1000, by: 1, sensitivity: .low)
        .containerBackground(Color.walut.gradient, for: .navigation)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        model.swapCurrencies()
                    }
                } label: {
                    Image(systemName: "rectangle.2.swap")
                }
            }
        }
        .onChange(of: model.topAmount) { _, top in
            withAnimation {
                model.calcBottom()
            }
        }
    }
}

#Preview {
    NavigationStack {
        CurrencyView(currency: Currency(baseCode: "USD"))
    }
}
