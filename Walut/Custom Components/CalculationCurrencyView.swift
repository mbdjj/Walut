//
//  CalculationCurrencyView.swift
//  Walut
//
//  Created by Marcin Bartminski on 14/06/2024.
//

import SwiftUI

struct CalculationCurrencyView: View {
    
    @Namespace var animation
    
    @Binding var currency: Currency
    @Binding var base: Currency
    @Binding var topValue: Double
    @Binding var botValue: Double
    @Binding var isTopOpen: Bool
    let isTop: Bool
    let textFunc: (AmountType) -> String
    
    var isOpen: Bool { isTop ? isTopOpen : !isTopOpen }
    
    var percentColor: Color {
        if currency.percent == 0 {
            return .secondary
        } else if currency.percent > 0 {
            return .green
        } else {
            return .red
        }
    }
    var arrowDirection: String {
        if currency.percent == 0 {
            return "right"
        } else if currency.percent > 0 {
            return "up"
        } else {
            return "down"
        }
    }
    
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
                        Text("\(Image(systemName: "arrow.\(arrowDirection)")) \(shared.percentLocaleStirng(value: abs(currency.percent)))")
                            .foregroundStyle(percentColor)
                            .font(.caption2)
                            .fontWeight(.semibold)
                    } else {
                        Text(textFunc(.passive))
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.primary)
                        .contentTransition(.numericText(value: isTop ? topValue : botValue))
                        .onTapGesture {
                            withAnimation(.spring) {
                                isTopOpen.toggle()
                            }
                        }
                        .matchedGeometryEffect(id: "amount", in: animation)
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
                        Text(textFunc(.active))
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .contentTransition(.numericText(value: isTop ? topValue : botValue))
                        .lineLimit(1)
                        .matchedGeometryEffect(id: "amount", in: animation)
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
        CalculationCurrencyView(currency: .constant(Currency(baseCode: "USD")), base: .constant(Currency(baseCode: "PLN")), topValue: .constant(1.5), botValue: .constant(4), isTopOpen: .constant(true), isTop: true) { type in
            return "0"
        }
        CalculationCurrencyView(currency: .constant(Currency(baseCode: "USD")), base: .constant(Currency(baseCode: "PLN")), topValue: .constant(1), botValue: .constant(4000000000000), isTopOpen: .constant(true), isTop: false) { type in
            return "0"
        }
    }
}
