//
//  CalculationView.swift
//  Walut
//
//  Created by Marcin Bartminski on 14/06/2024.
//

import SwiftUI

struct CalculationView: View {
    @Environment(AppSettings.self) var settings
    
    @State var model: CurrencyCalcViewModel
    @State var chartCurrency: Currency?
    @State var keyboardMonitor = KeyboardMonitor()
    
    init(currency: Currency, base: Currency, shouldSwap: Bool = true) {
        let model = CurrencyCalcViewModel(currency: currency, base: base, shouldSwap: shouldSwap)
        _model = State(initialValue: model)
    }
    
    var body: some View {
        VStack {
            // MARK: - Number views
            
            VStack {
                CalculationCurrencyView(currency: $model.currency, base: $model.base, topValue: $model.topAmount, botValue: $model.bottomAmount, isTopOpen: $model.isTopOpen, isTop: true) { type in
                    model.amountString(type)
                } changeCurrency: { currency, type in
                    model.changeCurrency(type, to: currency.code)
                }
                
                CalculationCurrencyView(currency: $model.currency, base: $model.base, topValue: $model.topAmount, botValue: $model.bottomAmount, isTopOpen: $model.isTopOpen, isTop: false) { type in
                    model.amountString(type)
                } changeCurrency: { currency, type in
                    model.changeCurrency(type, to: currency.code)
                }
            }
            .padding()
            
            // MARK: - Keypad
            if !keyboardMonitor.isConnected {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 0) {
                    ForEach(0 ... 2, id: \.self) { row in
                        GridRow {
                            ForEach(1 ... 3, id: \.self) { col in
                                let num = row * 3 + col
                                Button {
                                    withAnimation {
                                        model.buttonPressed(num)
                                    }
                                } label: {
                                    Text("\(num)")
                                        .frame(width: 60, height: 60)
                                }
                                .foregroundStyle(.primary)
                                .font(.system(.title2, design: .rounded, weight: .medium))
                                .id("\(row)\(col)")
                            }
                        }
                        .padding(.bottom, 4)
                    }
                    GridRow {
                        Button {
                            withAnimation {
                                model.buttonPressed(",")
                            }
                        } label: {
                            Text(Locale.current.decimalSeparator ?? ".")
                                .frame(width: 60, height: 60)
                        }
                        .foregroundStyle(.primary)
                        .font(.system(.title2, design: .rounded, weight: .medium))
                        
                        Button {
                            withAnimation {
                                model.buttonPressed("0")
                            }
                        } label: {
                            Text("0")
                                .frame(width: 60, height: 60)
                        }
                        .foregroundStyle(.primary)
                        .font(.system(.title2, design: .rounded, weight: .medium))
                        
                        Button {} label: {
                            Image(systemName: "delete.left")
                                .frame(width: 60, height: 60)
                                .onTapGesture {
                                    withAnimation {
                                        model.buttonPressed("<")
                                    }
                                }
                                .onLongPressGesture {
                                    withAnimation {
                                        model.clear()
                                    }
                                }
                        }
                        .foregroundStyle(.primary)
                        .font(.system(.title2, design: .rounded, weight: .medium))
                    }
                }
                .padding(.bottom)
            } else {
                Spacer()
                    .background {
                        // Keyboard support 
                        
                        ZStack {
                            Color(uiColor: .systemBackground)
                            
                            Button("1") { withAnimation { model.buttonPressed(1) } }.keyboardShortcut("1", modifiers: [])
                            Button("2") { withAnimation { model.buttonPressed(2) } }.keyboardShortcut("2", modifiers: [])
                            Button("3") { withAnimation { model.buttonPressed(3) } }.keyboardShortcut("3", modifiers: [])
                            Button("4") { withAnimation { model.buttonPressed(4) } }.keyboardShortcut("4", modifiers: [])
                            Button("5") { withAnimation { model.buttonPressed(5) } }.keyboardShortcut("5", modifiers: [])
                            Button("6") { withAnimation { model.buttonPressed(6) } }.keyboardShortcut("6", modifiers: [])
                            Button("7") { withAnimation { model.buttonPressed(7) } }.keyboardShortcut("7", modifiers: [])
                            Button("8") { withAnimation { model.buttonPressed(8) } }.keyboardShortcut("8", modifiers: [])
                            Button("9") { withAnimation { model.buttonPressed(9) } }.keyboardShortcut("9", modifiers: [])
                            Button("0") { withAnimation { model.buttonPressed("0") } }.keyboardShortcut("0", modifiers: [])
                            Button(".") { withAnimation { model.buttonPressed(",") } }.keyboardShortcut(".", modifiers: [])
                            Button(",") { withAnimation { model.buttonPressed(",") } }.keyboardShortcut(",", modifiers: [])
                            Button("delete") { withAnimation { model.buttonPressed("<") } }.keyboardShortcut(.delete, modifiers: [])
                        }
                    }
            }
            
            Button {
                chartCurrency = model.currency
            } label: {
                HStack {
                    Spacer()
                    Text("share_chart")
                        .font(.system(.title3, design: .rounded, weight: .medium))
                    Spacer()
                }
            }
            .buttonStyle(.glassProminent)
            .padding(.horizontal, 32)
            .padding(.bottom)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu {
                    ShareLink(item: model.valueToShare()) {
                        Label("share_value", systemImage: "equal.circle")
                    }
                    .disabled(model.topAmount == 0)
                    
                    ShareLink(item: Sharing.descText(currency: model.currency, base: model.base)) {
                        Label("share_text", systemImage: "text.bubble")
                    }
                } label: {
                    Label("share", systemImage: "square.and.arrow.up")
                }
                
                Button {
                    withAnimation {
                        settings.handleFavoriteFlip(of: model.currency)
                    }
                } label: {
                    Label("favorite", systemImage: model.currency.isFavorite ? "star.slash" : "star")
                        .contentTransition(.symbolEffect(.replace))
                }
                .tint(model.currency.isFavorite ? .yellow : .primary)
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
        .onChange(of: "\(model.currency.rate)\(model.base.rate)") { _, _ in
            withAnimation {
                model.calcPassive()
            }
        }
        .navigationDestination(item: $chartCurrency) { currency in
            CurrencyChartView(currency: currency, base: model.base)
        }
        .animation(.easeInOut, value: keyboardMonitor.isConnected)
    }
}

#Preview {
    NavigationStack {
        CalculationView(currency: Currency(baseCode: "USD"), base: Currency(baseCode: "PLN"))
            .environment(AppSettings.preview)
    }
}
