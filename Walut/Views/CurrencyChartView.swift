//
//  CurrencyOverviewView.swift
//  Walut
//
//  Created by Marcin Bartminski on 12/02/2023.
//

import SwiftUI
import Charts
import SwiftData

struct CurrencyChartView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.displayScale) var displayScale
    @Environment(\.modelContext) var modelContext
    @Query var savedCurrencies: [SavedCurrency]
    
    @State var data: [RatesData] = []
    
    var minValueYAxis: Double {
        return data.min { $0.value < $1.value }?.value ?? 0.0
    }
    var maxValueYAxis: Double {
        return data.max { $0.value < $1.value }?.value ?? 0.0
    }
    
    @State var currentActive: RatesData?
    var percent: Double {
        if let active = currentActive {
            let price = active.value
            let start = data.first!.value
            
            return (price - start) / start
        } else {
            let price = data.last?.value ?? 1
            let start = data.first?.value ?? 1
            
            return (price - start) / start
        }
    }
    var percentArrowDeg: Double {
        if percent > 0 {
            return 0
        } else if percent < 0 {
            return 180
        } else {
            return 90
        }
    }
    var percentColor: Color {
        if percent > 0 {
            return .green
        } else if percent < 0 {
            return .red
        } else {
            return .gray
        }
    }
    
    @StateObject var model: CurrencyChartViewModel
    
    init(currency: Currency, base: Currency = SharedDataManager.shared.base) {
        _model = StateObject(wrappedValue: CurrencyChartViewModel(currency: currency, base: base))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            // MARK: - Top bar
            
            HStack(alignment: .top, spacing: 16) {
                Text(model.currency.flag)
                    .frame(width: 60, height: 60)
                    .font(.system(size: 44))
                    .background {
                        Color.walut
                            .clipShape(Circle())
                    }
                
                if model.base.code != SharedDataManager.shared.base.code {
                    Text(model.base.flag)
                        .frame(width: 60, height: 60)
                        .font(.system(size: 44))
                        .background {
                            Color.walut
                                .clipShape(Circle())
                        }
                }
                
                Spacer()
                
//                if let image = renderView() {
//                    ShareLink(item: image, preview: SharePreview("share_chart", image: image)) {
//                        Image(systemName: "square.and.arrow.up")
//                            .font(.body)
//                            .foregroundColor(.primary)
//                            .padding(.top, 4)
//                    }
//                }
                
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3.weight(.bold))
                        .foregroundColor(.primary)
                        .padding(.top, 4)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // MARK: - Chart info
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(model.currency.fullName)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .minimumScaleFactor(0.6)
                    
                    Text(SharedDataManager.shared.currencyLocaleString(value: currentActive?.value ?? model.currency.price, currencyCode: model.base.code))
                        .font(.system(.title2, design: .rounded, weight: .bold))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    if let currentActive {
                        Text(currentActive.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.system(.title3, design: .rounded, weight: .bold))
                    }
                    
                    HStack {
                        Image(systemName: "arrow.up")
                            .rotationEffect(Angle(degrees: percentArrowDeg))
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .foregroundColor(percentColor)
                            .animation(.easeInOut(duration: 0.3), value: percentArrowDeg)
                        Text(SharedDataManager.shared.percentLocaleStirng(value: abs(percent)))
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundColor(percentColor)
                            
                    }
                }
            }
            .padding(.horizontal)
            
            // MARK: - Chart
            
            Chart {
                ForEach(data) { rate in
                    LineMark(
                        x: .value("Date", rate.date),
                        y: .value("Value", rate.value)
                    )
                    .foregroundStyle(Color.walut.gradient.opacity(currentActive == nil ? 1 : 0.6))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    
                    if let currentActive, currentActive.id == rate.id {
                        RuleMark(x: .value("Date", currentActive.date))
                            .foregroundStyle(Color.accentColor.gradient)
                            .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                    }
                }
            }
            .frame(height: 250)
            .chartYScale(domain: minValueYAxis - minValueYAxis * 0.01 ... maxValueYAxis + maxValueYAxis * 0.01)
            .chartYAxis(.hidden)
            .chartXAxis(.hidden)
            .chartOverlay { proxy in
                GeometryReader { _ in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let location = value.location
                                    
                                    if let date: Date = proxy.value(atX: location.x) {
                                        var index = calculateClosestIndex(of: date)
                                        if index == data.count {
                                            index -= 1
                                        }
                                        self.currentActive = self.data[index]
                                    }
                                }
                                .onEnded({ _ in
                                    self.currentActive = nil
                                })
                        )
                }
            }
            .onAppear {
                data = savedCurrencies
                    .filter { $0.code == model.currency.code && $0.base == model.base.code }
                    .sorted { $0.nextRefresh < $1.nextRefresh }
                    .map { RatesData(from: $0) }
                    .uniqued()
                print(data)
            }
            .onChange(of: currentActive) { _, newValue in
                if newValue != nil {
                    let impact = UIImpactFeedbackGenerator(style: .soft)
                    impact.impactOccurred()
                }
            }
            .onChange(of: currentActive == nil) { _, _ in
                let impact = UIImpactFeedbackGenerator(style: .heavy)
                impact.impactOccurred()
            }
            
            // MARK: - chart length changing buttons
            
//            ChartButtons(selected: $model.selectedRange)
//                .onChange(of: model.selectedRange) { _, _ in
//                    Task {
//                        //await model.checkLoadData()
//                    }
//                }
            
        }
    }
    
//    @MainActor func renderView() -> Image? {
//        let renderer = ImageRenderer(content: ChartToShare(currency: model.currency, base: model.base, range: model.selectedRange))
//        
//        renderer.scale = displayScale
//        
//        guard let image = renderer.uiImage else { return nil }
//        return Image(uiImage: image)
//    }
    
    private func calculateClosestIndex(of date: Date) -> Int {
        let firstInterval = data.first!.date.timeIntervalSince1970
        let lastInterval = data.last!.date.timeIntervalSince1970
        let chosenInterval = date.timeIntervalSince1970
        
        let approximate = (chosenInterval - firstInterval) / (lastInterval - firstInterval)
        let index = round(approximate * Double(data.count - 1))
        
        print("\(approximate) - \(index)")
        
        return Int(index)
    }
}

struct CurrencyOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        Text("dupa")
            .sheet(isPresented: .constant(true)) {
                CurrencyChartView(currency: Currency.placeholder)
            }
    }
}

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
