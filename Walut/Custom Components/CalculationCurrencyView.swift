//
//  CalculationCurrencyView.swift
//  Walut
//
//  Created by Marcin Bartminski on 14/06/2024.
//

import SwiftUI

struct CalculationCurrencyView: View {
    
    @Binding var currency: Currency
    @Binding var base: Currency
    @Binding var topValue: Double
    @Binding var botValue: Double
    @Binding var isTopOpen: Bool
    let isTop: Bool
    var isOpen: Bool { isTop ? isTopOpen : !isTopOpen }
    
    let shared = SharedDataManager.shared
    
    var body: some View {
        VStack(spacing: 8) {
            // MARK: - Top bar
            HStack {
                Text(isTop ? currency.flag : base.flag)
                    .font(.system(size: 50))
                
                VStack(alignment: .leading) {
                    Text(isTop ? currency.fullName : base.fullName)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    Text(isTop ? currency.code : base.code)
                        .foregroundColor(.primary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    if isOpen {
                        Text(shared.currencyLocaleString(value: currency.price, currencyCode: base.code))
                            .foregroundColor(.primary)
                        Text("\(Image(systemName: "arrow.right")) 0%")
                            .foregroundStyle(.secondary)
                    } else {
                        Text(shared.currencyLocaleString(
                            value: isTop ? topValue : botValue,
                            currencyCode: isTop ? currency.code : base.code,
                            decimal: 2)
                        )
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding()
            
            // MARK: - Bottom bar
            
            if isOpen {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                
                VStack {
                    Spacer()
                    
                    HStack(alignment: .top, spacing: 0) {
                        Text(shared.currencyLocaleString(
                            value: isTop ? topValue : botValue,
                            currencyCode: isTop ? currency.code : base.code,
                            decimal: 2)
                        )
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .contentTransition(.numericText(value: 0))
                            .lineLimit(1)
                    }
                    .minimumScaleFactor(0.15)
                    
                    Spacer()
                }
                .padding()
                .frame(maxHeight: 200)
            }
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

#Preview {
    VStack {
        CalculationCurrencyView(currency: .constant(Currency(baseCode: "USD")), base: .constant(Currency(baseCode: "PLN")), topValue: .constant(1.5), botValue: .constant(4), isTopOpen: .constant(true), isTop: true)
        CalculationCurrencyView(currency: .constant(Currency(baseCode: "USD")), base: .constant(Currency(baseCode: "PLN")), topValue: .constant(1), botValue: .constant(4), isTopOpen: .constant(true), isTop: false)
    }
}
