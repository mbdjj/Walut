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
    let changeCurrency: (Currency, AmountType) -> ()
    
    @State var showCurrencyPicker: Bool = false
    let pickerData: [Currency] = {
        StaticData.currencyCodes.map { Currency(baseCode: $0) }
    }()
    
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
    
    var body: some View {
        VStack(spacing: 8) {
            // MARK: - Top bar
            HStack {
                Text(isTop ? currency.flag : base.flag)
                    .font(.system(size: 52))
                
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
                        Text(Formatter.currency(
                            value: isTop ? currency.price : currency.rate,
                            currencyCode: isTop ? base.code : currency.code,
                            decimal: Defaults.decimal()
                        ))
                        .foregroundColor(.primary)
                        
                        if isTop && isOpen && currency.percent != 0 {
                            Text("\(Image(systemName: "arrow.\(arrowDirection)")) \(Formatter.percent(value: abs(currency.percent)))")
                                .foregroundStyle(percentColor)
                                .font(.caption2)
                                .fontWeight(.semibold)
                        }
                    } else {
                        Text(textFunc(.passive))
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.primary)
                        .contentTransition(.numericText(value: isTop ? topValue : botValue))
                        .matchedGeometryEffect(id: "amount", in: animation)
                    }
                }
            }
            .background(Color(uiColor: .secondarySystemBackground))
            .padding(.top, 8)
            .padding(.horizontal, isOpen ? 8 : 16)
            .padding(.bottom, isOpen ? 0 : 8)
            .onTapGesture {
                if isOpen {
                    showCurrencyPicker = true
                } else {
                    withAnimation(.spring) {
                        isTopOpen.toggle()
                    }
                }
            }
            
            // MARK: - Bottom bar
            
            if isOpen {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                
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
                .padding(.horizontal, 8)
                .frame(maxHeight: 200)
            }
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .popover(isPresented: $showCurrencyPicker) {
            NavigationStack {
                List {
                    ForEach(pickerData) { currency in
                        Button {
                            changeCurrency(currency, isOpen ? .active : .passive)
                            showCurrencyPicker = false
                        } label: {
                            CurrencyCell(for: currency, mode: .picker, value: 1)
                        }
                    }
                }
                .navigationTitle("Change")
            }
        }
    }
}

#Preview {
    VStack {
        CalculationCurrencyView(currency: .constant(Currency(baseCode: "USD")), base: .constant(Currency(baseCode: "PLN")), topValue: .constant(1.5), botValue: .constant(4), isTopOpen: .constant(false), isTop: true) { type in
            return "0"
        } changeCurrency: { _, _ in }
        CalculationCurrencyView(currency: .constant(Currency(baseCode: "USD")), base: .constant(Currency(baseCode: "PLN")), topValue: .constant(1), botValue: .constant(4), isTopOpen: .constant(false), isTop: false) { type in
            return "0"
        } changeCurrency: { _, _ in }
    }
}
