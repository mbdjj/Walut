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
        VStack {
            // MARK: - Number views
            
            Spacer()
            
            // MARK: - Keypad
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 0) {
                ForEach(0 ... 2, id: \.self) { row in
                    GridRow {
                        ForEach(1 ... 3, id: \.self) { col in
                            let num = row * 3 + col
                            Button {
                                
                            } label: {
                                Text("\(num)")
                                    .frame(width: 60, height: 60)
                            }
                            .foregroundStyle(.primary)
                            .font(.system(.title2, design: .rounded, weight: .medium))
                        }
                    }
                    .padding(.bottom, 4)
                }
                GridRow {
                    Button {
                        
                    } label: {
                        Text(Locale.current.decimalSeparator ?? ".")
                            .frame(width: 60, height: 60)
                    }
                    .foregroundStyle(.primary)
                    .font(.system(.title2, design: .rounded, weight: .medium))
                    
                    Button {
                        
                    } label: {
                        Text("0")
                            .frame(width: 60, height: 60)
                    }
                    .foregroundStyle(.primary)
                    .font(.system(.title2, design: .rounded, weight: .medium))
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "delete.left")
                            .frame(width: 60, height: 60)
                    }
                    .foregroundStyle(.primary)
                    .font(.system(.title2, design: .rounded, weight: .medium))
                }
            }
            .padding(.bottom)
            
            Button {
                withAnimation {
                    model.clear()
                }
            } label: {
                HStack {
                    Spacer()
                    Text("share_chart")
                        .foregroundColor(.walut)
                        .font(.system(.title3, design: .rounded, weight: .medium))
                    Spacer()
                }
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .padding(.horizontal, 32)
            .padding(.bottom)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Label("share", systemImage: "square.and.arrow.up")
                }
                
                Button {
                    
                } label: {
                    Label("favorite", systemImage: "star.circle")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CalculationView(currency: Currency(baseCode: "USD"))
    }
}
