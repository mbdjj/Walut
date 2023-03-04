//
//  CurrencyOverviewView.swift
//  Walut
//
//  Created by Marcin Bartminski on 12/02/2023.
//

import SwiftUI
import Charts

struct CurrencyChartView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var minValueYAxis: Double {
        let data = model.currency.chartData ?? []
        return data.min { $0.value < $1.value }?.value ?? 0.0
    }
    var maxValueYAxis: Double {
        let data = model.currency.chartData ?? []
        return data.max { $0.value < $1.value }?.value ?? 0.0
    }
    
    @State var currentActive: RatesData?
    var percent: Double {
        if let data = model.currency.chartData {
            if let active = currentActive {
                let price = active.value
                let start = data.first!.value
                
                return (price - start) / start
            } else {
                let price = data.last!.value
                let start = data.first!.value
                
                return (price - start) / start
            }
        } else {
            return 0.0
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
    
    @ObservedObject var model: CurrencyChartViewModel
    
    @FocusState private var foreignTextFieldFocused: Bool
    @FocusState private var baseTextFieldFocused: Bool
    
    init(currency: Currency) {
        let base = SharedDataManager.shared.base
        
        self.model = CurrencyChartViewModel(currency: currency, base: base)
    }
    
    init(currency: Currency, base: Currency) {
        self.model = CurrencyChartViewModel(currency: currency, base: base)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            // MARK: - Top bar
            
            HStack(alignment: .top, spacing: 8) {
                Text(model.currency.flag)
                    .frame(width: 50, height: 50)
                    .font(.largeTitle)
                    .background {
                        Color.walut
                            .clipShape(Circle())
                    }
                    .shadow(color: .walut, radius: 5, x: 0, y: 4)
                
                if model.base.code != SharedDataManager.shared.base.code {
                    Text(model.base.flag)
                        .frame(width: 50, height: 50)
                        .font(.largeTitle)
                        .background {
                            Color.walut
                                .clipShape(Circle())
                        }
                        .shadow(color: .walut, radius: 5, x: 0, y: 4)
                }
                
                Spacer()
                
                Button {
                    
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
            
            // MARK: - Chart info
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text(SharedDataManager.shared.currencyLocaleString(value: currentActive?.value ?? model.currency.price, currencyCode: model.base.code))
                        .font(.system(.title, design: .rounded, weight: .bold))
                    
                    Text(model.currency.fullName)
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .foregroundColor(.walut)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: "arrow.up")
                            .rotationEffect(Angle(degrees: percentArrowDeg))
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundColor(percentColor)
                            .animation(.easeInOut(duration: 0.3), value: percentArrowDeg)
                        Text(SharedDataManager.shared.percentLocaleStirng(value: abs(percent)))
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundColor(percentColor)
                            
                    }
                    
                    Text(currentActive == nil ? String(localized: "overview_past_month") : currentActive!.dateFormattedString)
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .foregroundColor(percentColor)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal)
            
            // MARK: - Chart
            
            if let data = model.currency.chartData {
                Chart {
                    ForEach(data) { rate in
                        LineMark(
                            x: .value("Date", rate.date),
                            y: .value("Value", rate.value)
                        )
                        .foregroundStyle(Color.walut.gradient.opacity(currentActive == nil ? 1 : 0.6))
                        .interpolationMethod(.catmullRom)
                        
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
                //.chartXAxis(.hidden)
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let location = value.location
                                        
                                        if let date: Date = proxy.value(atX: location.x) {
                                            let formatter = DateFormatter()
                                            formatter.calendar = Calendar.current
                                            formatter.dateFormat = "rrrr-MM-dd"
                                            let dateString = formatter.string(from: date)
                                            if let currentItem = data.first(where: { item in
                                                dateString == item.dateString
                                            }) {
                                                self.currentActive = currentItem
                                            }
                                        }
                                    }
                                    .onEnded({ _ in
                                        self.currentActive = nil
                                    })
                            )
                    }
                }
                .onChange(of: currentActive) { newValue in
                    if newValue != nil {
                        let impact = UIImpactFeedbackGenerator(style: .soft)
                        impact.impactOccurred()
                    }
                }
                .onChange(of: currentActive == nil) { _ in
                    let impact = UIImpactFeedbackGenerator(style: .heavy)
                    impact.impactOccurred()
                }
            } else {
                ZStack {
                    Rectangle()
                        .frame(height: 250)
                        .foregroundColor(Color(uiColor: .systemBackground))
                    
                    ProgressView()
                }
            }
            
            // MARK: - todo chart length changing buttons
            
        }
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
