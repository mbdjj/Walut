//
//  CalculationView.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import SwiftUI

struct CalculationView: View {
    
    let base: Currency
    let foreign: Currency
    
    @State var foreignAmount: Double = 0.0
    @State var baseAmount: Double = 0.0
    @State var shouldDisableChartButton = true
    
    @FocusState private var foreignTextFieldFocused: Bool
    @FocusState private var baseTextFieldFocused: Bool
    
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        ScrollView {
            
            Spacer(minLength: 80)
            
            HStack {
                
                VStack(alignment: .leading) {
                    
                    Text("\(foreign.flag) \(foreign.fullName)")
                        .padding(.horizontal)
                    
                    TextField("", value: $foreignAmount, format: .currency(code: foreign.code))
                        .keyboardType(.decimalPad)
                        .padding(.horizontal)
                        .textFieldStyle(.roundedBorder)
                        .focused($foreignTextFieldFocused)
                        .onChange(of: foreignAmount) { newValue in
                            if foreignTextFieldFocused {
                                baseAmount = newValue / foreign.rate
                            }
                        }
                        
                    
                }
                
                Text("=")
                    .padding(.top, 30)
                
                VStack(alignment: .leading) {
                    
                    Text("\(base.flag) \(base.fullName)")
                        .padding(.horizontal)
                    
                    TextField("", value: $baseAmount, format: .currency(code: base.code))
                        .keyboardType(.decimalPad)
                        .padding(.horizontal)
                        .textFieldStyle(.roundedBorder)
                        .focused($baseTextFieldFocused)
                        .onChange(of: baseAmount) { newValue in
                            if baseTextFieldFocused {
                                foreignAmount = newValue / foreign.price
                            }
                        }
                    
                }
                
            }
            
            Button {
                
                foreignAmount = 0.0
                baseAmount = 0.0
                
            } label: {
                
                HStack {
                    Spacer()
                    Text(String(localized: "clear"))
                    Spacer()
                }
                
            }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
                .padding(.horizontal)
            
            Spacer()
            
        }
        .navigationTitle("\(foreign.flag) \(foreign.code)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            DispatchQueue.main.async {
                networkManager.getChartData(for: foreign, base: base)
            }
        }
        .toolbar {
            NavigationLink {
                if shouldDisableChartButton {
                    Text("dupa")
                } else {
                    CalculationChartView(currency: foreign, data: networkManager.ratesArray)
                }
            } label: {
                Image(systemName: "chart.xyaxis.line")
            }
            .disabled(shouldDisableChartButton)
        }
        .onChange(of: networkManager.ratesArray.count) { newValue in
            if newValue == 0 {
                shouldDisableChartButton = true
            } else {
                shouldDisableChartButton = false
            }
        }
    }
}

struct CalculationView_Previews: PreviewProvider {
    static var previews: some View {
        CalculationView(base: Currency(baseCode: "PLN"), foreign: Currency(code: "USD", rate: 0.2))
    }
}
