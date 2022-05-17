//
//  CalculationView.swift
//  Walut
//
//  Created by Marcin Bartminski on 09/02/2022.
//

import SwiftUI

struct CalculationView: View {
    
    let base: Currency
    let foreign: Currency
    
    @State var foreignText: String = ""
    @State var baseText: String = ""
    
    @FocusState private var foreignTextFieldFocused: Bool
    @FocusState private var baseTextFieldFocused: Bool
    
    @ObservedObject var networkManager = NetworkManager.shared
    
    
    var body: some View {
        
        ScrollView {
            
            Spacer(minLength: 80)
            
            HStack {
                
                VStack(alignment: .leading) {
                    
                    Text("\(foreign.flag) \(foreign.fullName)")
                        .padding(.horizontal)
                    
                    TextField("", text: $foreignText)
                        .keyboardType(.decimalPad)
                        .padding(.horizontal)
                        .textFieldStyle(.roundedBorder)
                        .focused($foreignTextFieldFocused)
                        .onChange(of: foreignText) { newValue in
                            if foreignTextFieldFocused {
                                if let number = Double(newValue) {
                                    let math = number / foreign.rate
                                    
                                    baseText = String(format: "%.2f", math)
                                } else {
                                    baseText = String(format: "%.2f", 0)
                                }
                            }
                        }
                        
                    
                }
                
                Text("=")
                    .padding(.top, 30)
                
                VStack(alignment: .leading) {
                    
                    Text("\(base.flag) \(base.fullName)")
                        .padding(.horizontal)
                    
                    TextField("", text: $baseText)
                        .keyboardType(.decimalPad)
                        .padding(.horizontal)
                        .textFieldStyle(.roundedBorder)
                        .focused($baseTextFieldFocused)
                        .onChange(of: baseText) { newValue in
                            if baseTextFieldFocused {
                                if let number = Double(newValue) {
                                    let math = number / foreign.price
                                    
                                    foreignText = String(format: "%.2f", math)
                                } else {
                                    foreignText = String(format: "%.2f", 0)
                                }
                            }
                        }
                    
                }
                
            }
            
            Button {
                
                foreignText = ""
                baseText = ""
                
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
            networkManager.getChartData(for: foreign)
        }
        .toolbar {
            NavigationLink {
                CalculationChartView(currency: foreign, data: networkManager.chosenCurrencyTimeSeries)
            } label: {
                Image(systemName: "chart.xyaxis.line")
            }
        }
    }
}
