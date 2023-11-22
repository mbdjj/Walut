//
//  CurrencyCalcView.swift
//  Walut
//
//  Created by Marcin Bartminski on 23/02/2023.
//

import SwiftUI

struct CurrencyCalcView: View {
    
    @StateObject var model: CurrencyCalcViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var chartCurrency: Currency?
    @State private var numberPressed: String? = nil
    
    let shared = SharedDataManager.shared
    
    init(currency: Currency, base: Currency = SharedDataManager.shared.base, shouldSwap: Bool = true) {
        let model = CurrencyCalcViewModel(currency: currency, base: base, shouldSwap: shouldSwap)
        _model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        // MARK: - Top bar
        
        VStack {
            HStack(spacing: 16) {
                Text("overview_calculation")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                
                Spacer()
                
                Menu {
                    ShareLink(item: model.valueToShare()) {
                        Label("share_value", systemImage: "equal.circle")
                    }
                    .disabled(model.topAmount == 0)
                    
                    ShareLink(item: model.textToShare) {
                        Label("share_text", systemImage: "text.bubble")
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.body)
                        .foregroundColor(.primary)
                }
                
                Button {
                    model.handleFavorites()
                } label: {
                    Image(systemName: "star.fill")
                        .font(.title3)
                        .foregroundColor(model.currency.isFavorite ? .yellow : Color(uiColor: .systemGray5))
                }
                
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3.weight(.bold))
                        .foregroundColor(.primary)
                        
                }
            }
            .padding()
            
            // MARK: - From and To currency
            
            HStack {
                Text("calc_from")
                    .font(.system(.body, design: .rounded, weight: .medium))
                
                let top = model.topCurrency
                Menu {
                    ForEach(shared.allCodesArray, id: \.self) { code in
                        let currency = Currency(baseCode: code)
                        Button {
                            model.changeCurrency(.top, to: code)
                        } label: {
                            HStack {
                                Text("\(currency.flag) \(code)")
                                Spacer()
                                if top.code == code {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Text("\(top.flag) \(top.code)")
                        .foregroundColor(.gray)
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .frame(width: 70, height: 30)
                        .background {
                            Color(uiColor: .secondarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                }
                
                Text("calc_to")
                    .font(.system(.body, design: .rounded, weight: .medium))
                
                let bot = model.bottomCurrency
                Menu {
                    ForEach(shared.allCodesArray, id: \.self) { code in
                        let currency = Currency(baseCode: code)
                        Button {
                            model.changeCurrency(.bottom, to: code)
                        } label: {
                            HStack {
                                Text("\(currency.flag) \(code)")
                                Spacer()
                                if bot.code == code {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Text("\(bot.flag) \(bot.code)")
                        .foregroundColor(.gray)
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .frame(width: 70, height: 30)
                        .background {
                            Color(uiColor: .secondarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // MARK: - Calculation numbers
            
            Spacer()
            
            VStack {
                let top = model.topCurrency
                HStack(alignment: .top, spacing: 0) {
                    Text("\(top.code)")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .offset(y: 16)
                    Text(model.amountString(.top))
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .lineLimit(1)
                        .contentTransition(.numericText())
                    Text("\(top.code)")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .offset(y: 16)
                        .opacity(0)
                }
                .minimumScaleFactor(0.6)
                .onDrag {
                    return NSItemProvider(object: model.valueToShare() as NSString)
                } preview: {
                    Text(model.valueToShare())
                        .font(.system(.body, design: .rounded, weight: .bold))
                }
                
                let bot = model.bottomCurrency
                HStack {
                    Text("\(bot.code)")
                        .font(.system(.body, design: .rounded, weight: .bold))
                    Text(model.amountString(.bottom))
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .lineLimit(1)
                        .contentTransition(.numericText())
                    Button {
                        model.swapCurrencies()
                    } label: {
                        Image(systemName: "rectangle.2.swap")
                            .foregroundColor(.primary)
                            .bold()
                    }
                }
                .minimumScaleFactor(0.6)
                .onDrag {
                    return NSItemProvider(object: model.valueToShare(.bottom) as NSString)
                } preview: {
                    Text(model.valueToShare(.bottom))
                        .font(.system(.body, design: .rounded, weight: .bold))
                }
            }
            
            Spacer()
            
            // MARK: - Chart button + rate
            
            HStack {
                Text(model.currency.flag)
                    .frame(width: 45, height: 45)
                    .font(.largeTitle)
                    .background {
                        Color.walut
                            .clipShape(Circle())
                    }
                
                VStack(alignment: .leading) {
                    Text(model.currency.fullName)
                        .font(.system(.title3, design: .rounded, weight: .medium))
                    Text(shared.currencyLocaleString(value: model.currency.price, currencyCode: model.base.code))
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button {
                    chartCurrency = model.currency
                } label: {
                    Text("share_chart")
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .foregroundColor(.walut)
                        .background {
                            Color(uiColor: .secondarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                }
            }
            .padding(.horizontal, 32)
            
            // MARK: - Keypad
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                ForEach(1 ..< 10, id: \.self) { num in
                    Text("\(num)")
                        .foregroundColor(.primary)
                        .font(.system(.title2, design: .rounded, weight: .medium))
                        .frame(width: 60, height: 60)
                        .scaleEffect(numberPressed == "\(num)" ? 2.0 : 1.0)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    withAnimation(.spring(duration: 0.07)) {
                                        numberPressed = "\(num)"
                                    }
                                }
                                .onEnded({ _ in
                                    withAnimation {
                                        numberPressed = nil
                                        model.buttonPressed(num)
                                    }
                                })
                        )
                }
            }
            .padding(.horizontal, 32)
            
            HStack {
                Spacer()
                Text(Locale.current.decimalSeparator ?? ".")
                    .foregroundColor(.primary)
                    .font(.system(.title2, design: .rounded, weight: .medium))
                    .frame(width: 60, height: 60)
                    .scaleEffect(numberPressed == "," ? 2.0 : 1.0)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                withAnimation(.spring(duration: 0.07)) {
                                    numberPressed = ","
                                }
                            }
                            .onEnded({ _ in
                                withAnimation {
                                    numberPressed = nil
                                    model.buttonPressed(",")
                                }
                            })
                    )
                Spacer()
                Spacer()
                Text("0")
                    .foregroundColor(.primary)
                    .font(.system(.title2, design: .rounded, weight: .medium))
                    .frame(width: 60, height: 60)
                    .scaleEffect(numberPressed == "0" ? 2.0 : 1.0)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                withAnimation(.spring(duration: 0.07)) {
                                    numberPressed = "0"
                                }
                            }
                            .onEnded({ _ in
                                withAnimation {
                                    numberPressed = nil
                                    model.buttonPressed("0")
                                }
                            })
                    )
                Spacer()
                Spacer()
                Image(systemName: "delete.left")
                    .foregroundColor(.primary)
                    .font(.system(.title2, design: .rounded, weight: .medium))
                    .frame(width: 60, height: 60)
                    .scaleEffect(numberPressed == "<" ? 2.0 : 1.0)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                withAnimation(.easeInOut(duration: 0.07)) {
                                    numberPressed = "<"
                                }
                            }
                            .onEnded({ _ in
                                withAnimation {
                                    numberPressed = nil
                                    model.buttonPressed("<")
                                }
                            })
                    )
                Spacer()
            }
            .padding(.horizontal, 32)
            
            // MARK: - Clear button
            
            Button {
                model.clear()
            } label: {
                HStack {
                    Spacer()
                    Text("clear")
                        .foregroundColor(.walut)
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .padding(.vertical, 8)
                    Spacer()
                }
                .background {
                    Color(uiColor: .secondarySystemBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom)
        }
        .onChange(of: model.topAmount) { _, top in
            withAnimation {
                model.calcBottom()
            }
        }
        .onChange(of: model.currency) { _, _ in
            withAnimation {
                model.calcBottom()
            }
        }
        .sheet(item: $chartCurrency) { currency in
            CurrencyChartView(currency: currency, base: model.base)
        }
    }
}

struct CurrencyCalcView_Previews: PreviewProvider {
    static var previews: some View {
        Text("dupa")
            .sheet(isPresented: .constant(true)) {
                CurrencyCalcView(currency: Currency(baseCode: "PLN"))
            }
    }
}
