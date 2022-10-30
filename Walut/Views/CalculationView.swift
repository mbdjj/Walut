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
    
    let decimal: Int
    
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
                
                foreignTextFieldFocused = false
                baseTextFieldFocused = false
                
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
            
            Menu {
                Button {
                    let textToShare = "\(foreign.fullName)\(String(localized: "text_to_share0"))(\(foreign.code))\(String(localized: "text_to_share1"))\(String(format: "%.\(decimal)f", foreign.price)) \(base.symbol)"
                    
                    shareSheet(for: textToShare)
                } label: {
                    Label("Text", systemImage: "text.bubble")
                }
                
                Button {
                    shareSheet(for: generateSnapshot())
                } label: {
                    Label("Chart", systemImage: "chart.xyaxis.line")
                }
                .disabled(shouldDisableChartButton)
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            
            NavigationLink {
                if shouldDisableChartButton {
                    Text("You shouldn't be here")
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
        .scrollDismissesKeyboard(.immediately)
    }
    
    //MARK: - Share function
    
    var chartToShare: some View {
        ChartToShare(currency: foreign, data: networkManager.ratesArray)
    }
    
    @MainActor private func generateSnapshot() -> UIImage {
        let renderer = ImageRenderer(content: chartToShare)
        renderer.scale = 3.0
     
        return renderer.uiImage ?? UIImage()
    }
    
    func shareSheet(for image: UIImage) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    func shareSheet(for text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

struct CalculationView_Previews: PreviewProvider {
    static var previews: some View {
        CalculationView(base: Currency(baseCode: "PLN"), foreign: Currency(code: "USD", rate: 0.2), decimal: 3)
    }
}
