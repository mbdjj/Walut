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
    
    @FocusState private var foreignTextFieldFocused: Bool
    @FocusState private var baseTextFieldFocused: Bool
    
    @ObservedObject var model: CalculationViewModel
    
    init(base: Currency, foreign: Currency, decimal: Int) {
        self.base = base
        self.foreign = foreign
        self.decimal = decimal
        self.model = CalculationViewModel(base: base, foreign: foreign, decimal: decimal)
    }
    
    var body: some View {
        ScrollView {
            
            Spacer(minLength: 80)
            
            HStack(alignment: .bottom) {
                
                VStack(alignment: .leading) {
                    
                    Text("\(foreign.flag) \(foreign.fullName)")
                        .padding(.horizontal)
                    
                    TextField("", value: $model.foreignAmount, format: .currency(code: foreign.code))
                        .keyboardType(.decimalPad)
                        .padding(.horizontal)
                        .textFieldStyle(.roundedBorder)
                        .focused($foreignTextFieldFocused)
                        .onChange(of: model.foreignAmount) { newValue in
                            if foreignTextFieldFocused {
                                model.baseAmount = newValue / foreign.rate
                            }
                        }
                        .onDrag {
                            let text = "\(model.foreignAmount.formatted(.currency(code: model.foreign.code))) = \(model.baseAmount.formatted(.currency(code: model.base.code)))"
                            
                            return NSItemProvider(object: text as NSString)
                        } preview: {
                            Text("\(model.foreignAmount.formatted(.currency(code: model.foreign.code))) = \(model.baseAmount.formatted(.currency(code: model.base.code)))")
                        }

                }
                
                Text("=")
                    .padding(.bottom, 8)
                
                VStack(alignment: .leading) {
                    
                    Text("\(base.flag) \(base.fullName)")
                        .padding(.horizontal)
                    
                    TextField("", value: $model.baseAmount, format: .currency(code: base.code))
                        .keyboardType(.decimalPad)
                        .padding(.horizontal)
                        .textFieldStyle(.roundedBorder)
                        .focused($baseTextFieldFocused)
                        .onChange(of: model.baseAmount) { newValue in
                            if baseTextFieldFocused {
                                model.foreignAmount = newValue / foreign.price
                            }
                        }
                        .onDrag {
                            let text = "\(model.baseAmount.formatted(.currency(code: model.base.code))) = \(model.foreignAmount.formatted(.currency(code: model.foreign.code)))"
                            
                            return NSItemProvider(object: text as NSString)
                        } preview: {
                            Text("\(model.baseAmount.formatted(.currency(code: model.base.code))) = \(model.foreignAmount.formatted(.currency(code: model.foreign.code)))")
                        }
                }
                
            }
            
            Button {
                
                foreignTextFieldFocused = false
                baseTextFieldFocused = false
                
                model.foreignAmount = 0.0
                model.baseAmount = 0.0
                
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
        .toolbar {
            
            Menu {
                Button {
                    let textToShare = "\(foreign.fullName)\(String(localized: "text_to_share0"))(\(foreign.code))\(String(localized: "text_to_share1"))\(String(format: "%.\(decimal)f", foreign.price)) \(base.symbol)"
                    
                    shareSheet(for: textToShare)
                } label: {
                    Label(String(localized: "share_text"), systemImage: "text.bubble")
                }
                
                Button {
                    shareSheet(for: generateSnapshot())
                } label: {
                    Label(String(localized: "share_chart"), systemImage: "chart.xyaxis.line")
                }
                .disabled(model.shouldDisableChartButton)
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            
            NavigationLink {
                if model.shouldDisableChartButton {
                    Text("You shouldn't be here")
                } else {
                    CalculationChartView(currency: foreign, data: model.shareChartData)
                }
            } label: {
                Image(systemName: "chart.xyaxis.line")
            }
            .disabled(model.shouldDisableChartButton)
        }
        .scrollDismissesKeyboard(.immediately)
    }
    
    //MARK: - Share function
    
    var chartToShare: some View {
        ChartToShare(currency: foreign, data: model.shareChartData)
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
        CalculationView(base: Currency(baseCode: "PLN"), foreign: Currency(code: "USD", rate: 0.2, yesterday: 0.3), decimal: 3)
    }
}
