//
//  CurrencyCalcView.swift
//  Walut
//
//  Created by Marcin Bartminski on 23/02/2023.
//

import SwiftUI

struct CurrencyCalcView: View {
    
    @ObservedObject var model: CurrencyCalcViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var chartCurrency: Currency?
    
    let shared = SharedDataManager.shared
    
    init(currency: Currency, base: Currency = SharedDataManager.shared.base, shouldSwap: Bool = true) {
        model = CurrencyCalcViewModel(currency: currency, base: base, shouldSwap: shouldSwap)
    }
    
    var body: some View {
        // MARK: - Top bar
        
        VStack {
            HStack {
                Text("overview_calculation")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                
                Spacer()
                
                Button {
                    model.handleFavorites()
                } label: {
                    Image(systemName: "star\(model.currency.isFavorite ? ".fill" : "")")
                        .font(.body)
                        .frame(width: 30, height: 30)
                        .foregroundColor(model.currency.isFavorite ? .yellow : .gray)
                        .background {
                            Color(uiColor: .secondarySystemBackground)
                                .clipShape(Circle())
                        }
                }
                
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
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                        .background {
                            Color(uiColor: .secondarySystemBackground)
                                .clipShape(Circle())
                        }
                }
                
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.weight(.bold))
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                        .background {
                            Color(uiColor: .secondarySystemBackground)
                                .clipShape(Circle())
                        }
                }
            }
            .padding()
            
            // MARK: - From and To currency
            
            HStack {
                Text("calc_from")
                    .font(.system(.body, design: .rounded, weight: .medium))
                
                Button {
                    
                } label: {
                    let top = model.topCurrency
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
                
                Button {
                    
                } label: {
                    let bot = model.bottomCurrency
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
                        .foregroundColor(.gray)
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
                    Button {
                        model.buttonPressed(num)
                    } label: {
                        Text("\(num)")
                            .foregroundColor(.primary)
                            .font(.system(.title2, design: .rounded, weight: .medium))
                            .frame(width: 60, height: 60)
                    }
                }
            }
            .padding(.horizontal, 32)
            
            HStack {
                Spacer()
                Button {
                    model.buttonPressed(",")
                } label: {
                    Text(Locale.current.decimalSeparator ?? ".")
                        .foregroundColor(.primary)
                        .font(.system(.title2, design: .rounded, weight: .medium))
                        .frame(width: 60, height: 60)
                }
                Spacer()
                Spacer()
                Button {
                    model.buttonPressed("0")
                } label: {
                    Text("0")
                        .foregroundColor(.primary)
                        .font(.system(.title2, design: .rounded, weight: .medium))
                        .frame(width: 60, height: 60)
                }
                Spacer()
                Spacer()
                Button {
                    model.buttonPressed("<")
                } label: {
                    Image(systemName: "delete.left")
                        .foregroundColor(.primary)
                        .font(.system(.title2, design: .rounded, weight: .medium))
                        .frame(width: 60, height: 60)
                }
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
                        .foregroundColor(.gray)
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
        .onChange(of: model.topAmount) { top in
            if model.topCurrency == model.base {
                model.bottomAmount = top / model.currency.price
            } else {
                model.bottomAmount = top / model.currency.rate
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
