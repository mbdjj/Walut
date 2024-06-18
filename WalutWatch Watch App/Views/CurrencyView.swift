//
//  CurrencyView.swift
//  WalutWatch Watch App
//
//  Created by Marcin Bartminski on 22/03/2024.
//

import SwiftUI

struct CurrencyView: View {
    
    @State var model: CurrencyCalcViewModel
    
    init(currency: Currency, base: Currency, shouldSwap: Bool = true) {
        model = CurrencyCalcViewModel(currency: currency, base: base, shouldSwap: shouldSwap)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(Formatter.price(value: model.topAmount, currencyCode: model.currency.code))
                .font(.system(model.isTopOpen ? .title2 : .title3, design: .rounded, weight: .bold))
            
            Text(Formatter.price(value: model.bottomAmount, currencyCode: model.base.code))
                .font(.system(!model.isTopOpen ? .title2 : .title3, design: .rounded, weight: .bold))
            
            Spacer()
            
            HStack {
                Text(model.currency.flag)
                    .font(.title)
                Spacer()
                Image(systemName: "arrow.right")
                    .bold()
                    .rotationEffect(model.isTopOpen ? .zero : .degrees(-180))
                Spacer()
                Text(model.base.flag)
                    .font(.title)
            }
            .padding(.horizontal)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .focusable(true)
        .digitalCrownRotation(model.isTopOpen ? $model.topAmount : $model.bottomAmount, from: 1, through: 1000, by: 1, sensitivity: .low)
        .containerBackground(Color.walut.gradient, for: .navigation)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        model.isTopOpen.toggle()
                    }
                } label: {
                    Image(systemName: "rectangle.2.swap")
                }
            }
        }
        .onChange(of: model.topAmount) { _, _ in
            if model.isTopOpen {
                withAnimation {
                    model.calcPassive()
                }
            }
        }
        .onChange(of: model.bottomAmount) { _, _ in
            if !model.isTopOpen {
                withAnimation {
                    model.calcPassive()
                }
            }
        }
        .onChange(of: model.isTopOpen) { _, _ in
            model.swapActive()
        }
        
    }
}

#Preview {
    NavigationStack {
        CurrencyView(currency: Currency(baseCode: "USD"), base: Currency(baseCode: "PLN"))
    }
    .environment(AppSettings.preview)
}
