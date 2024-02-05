//
//  CurrencyCalcView.swift
//  Walut
//
//  Created by Marcin Bartminski on 23/02/2023.
//

import SwiftUI
import GameController

struct CurrencyCalcView: View {
    
    @StateObject var model: CurrencyCalcViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var chartCurrency: Currency?
    @FocusState var focused: Bool
    
    let keyboardConnected = GCKeyboard.coalesced != nil
    let shared = SharedDataManager.shared
    
    init(currency: Currency, base: Currency = SharedDataManager.shared.base, shouldSwap: Bool = true) {
        let model = CurrencyCalcViewModel(currency: currency, base: base, shouldSwap: shouldSwap)
        _model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        VStack {
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
                        .contentTransition(.numericText(value: model.topAmount))
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
                        .contentTransition(.numericText(value: model.bottomAmount))
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
                
                Button("share_chart") {
                    chartCurrency = model.currency
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
            .padding(.horizontal, 32)
            
            // MARK: - Keypad
            
            if !keyboardConnected {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                    ForEach(1 ..< 10, id: \.self) { num in
                        Button {
                            withAnimation {
                                model.buttonPressed(num)
                            }
                        } label: {
                            Text("\(num)")
                                .font(.system(.title2, design: .rounded, weight: .medium))
                        }
                        .foregroundStyle(.primary)
                        .frame(width: 36, height: 36)
                    }
                    
                    Button {
                        withAnimation {
                            model.buttonPressed(",")
                        }
                    } label: {
                        Text(Locale.current.decimalSeparator ?? ".")
                            .font(.system(.title2, design: .rounded, weight: .medium))
                            .frame(width: 36, height: 36)
                    }
                    .foregroundStyle(.primary)
                    
                    Button {
                        withAnimation {
                            model.buttonPressed("0")
                        }
                    } label: {
                        Text("0")
                            .font(.system(.title2, design: .rounded, weight: .medium))
                            .frame(width: 36, height: 36)
                    }
                    .foregroundStyle(.primary)
                    
                    Button {
                        withAnimation {
                            model.buttonPressed("<")
                        }
                    } label: {
                        Image(systemName: "delete.left")
                            .font(.system(.title2, design: .rounded, weight: .medium))
                            .frame(width: 36, height: 36)
                    }
                    .foregroundStyle(.primary)
                }
                .frame(maxWidth: 400)
                .padding(.horizontal, 32)
            }
            
            // MARK: - Clear button
            
            Button {
                withAnimation {
                    model.clear()
                }
            } label: {
                HStack {
                    Spacer()
                    Text("clear")
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
        .navigationTitle("overview_calculation")
        .toolbar {
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
            }
            .menuStyle(.button)
            .buttonStyle(.bordered)
            .buttonBorderShape(.circle)
            
            
            Button {
                model.handleFavorites()
            } label: {
                Image(systemName: model.showFavorite ? "star.fill" : "star")
                    .foregroundStyle(.yellow)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.circle)
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
        .navigationDestination(item: $chartCurrency) { currency in
            CurrencyChartView(currency: currency, base: model.base)
        }
        .focusable()
        .focused($focused)
        .onAppear {
            focused = true
        }
        .onKeyPress(keys: [.delete, ".", ",", .space]) { press in
            DispatchQueue.main.async {
                switch press.key {
                case .delete:
                    withAnimation {
                        model.buttonPressed("<")
                    }
                case .space:
                    withAnimation {
                        model.clear()
                    }
                case ".", ",":
                    withAnimation {
                        model.buttonPressed(",")
                    }
                default:
                    print("")
                }
            }
            return .handled
        }
        .onNumPressed { num in
            withAnimation {
                if num != 0 {
                    model.buttonPressed(num)
                } else {
                    model.buttonPressed("0")
                }
            }
        }
    }
}

struct CurrencyCalcView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CurrencyCalcView(currency: Currency(baseCode: "PLN"))
        }
    }
}

extension View {
    func onNumPressed(pressed: @escaping (_ num: Int) -> ()) -> some View {
        self
            .onKeyPress(characters: .decimalDigits) { press in
                DispatchQueue.main.async {
                    pressed(Int("\(press.key.character)")!)
                }
                return .handled
            }
    }
}
