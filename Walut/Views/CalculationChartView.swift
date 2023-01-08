//
//  CalculationChartView.swift
//  Walut
//
//  Created by Marcin Bartminski on 10/10/2022.
//

import SwiftUI
import Charts

struct CalculationChartView: View {
    
    let base: Currency
    let currency: Currency
    @State var data: [RatesData]
    
    var minValueYAxis: Double
    var maxValueYAxis: Double
    
    @State var currentActive: RatesData?
    
    @State var currentNum: String = "0"
    @State var currentDecimal: String = "0"
    
    let shared = SharedDataManager.shared
    
    init(currency: Currency, base: Currency, data: [RatesData]) {
        self.currency = currency
        self.base = base
        self.data = data
        
        if !data.isEmpty {
            self.minValueYAxis = data[0].value
            self.maxValueYAxis = data[0].value
        } else {
            self.minValueYAxis = 0
            self.maxValueYAxis = 0
        }
        
        for item in data {
            if self.minValueYAxis > item.value {
                self.minValueYAxis = item.value
            }
            
            if self.maxValueYAxis < item.value {
                self.maxValueYAxis = item.value
            }
        }
        
        let values = splitDouble(data.last!.value)
        _currentNum = State(initialValue: values.0)
        _currentDecimal = State(initialValue: values.1)
    }
    
    var body: some View {
        List {
            VStack(alignment: .leading) {
                
                Text(currentActive?.dateFormattedString ?? data.last!.dateFormattedString)
                    .font(.system(.title2, weight: .semibold))
                
                HStack {
                    HStack(spacing: 0) {
                        RollingCounter(font: .largeTitle, weight: .bold, value: $currentNum)
                        Text(".")
                            .font(.largeTitle)
                            .bold()
                        RollingCounter(font: .largeTitle, weight: .bold, value: $currentDecimal)
                        Text(" \(base.symbol)")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Spacer()
                    
//                    HStack(spacing: 0) {
//                        RollingCounter(color: .gray, value: $currentPercent)
//                        Text("%")
//                            .foregroundColor(.gray)
//                    }
                }
                
                Chart {
                    ForEach(data) { rate in
                        LineMark(
                            x: .value("Date", rate.date),
                            y: .value("Value", rate.animate ? rate.value : minValueYAxis)
                        )
                        .foregroundStyle(Color.accentColor.gradient)
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
                .onAppear {
                    for (index, _) in data.enumerated() {
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                data[index].animate = true
                            }
                        }
                    }
                }
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture()
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
            }
            .onChange(of: currentActive) { newValue in
                (currentNum, currentDecimal) = splitDouble(newValue?.value ?? data
                    .last!.value)
            }
        }
    }
    
    func splitDouble(_ value: Double) -> (String, String) {
        let stringValue = "\(value)"
        let nums = stringValue.split(separator: ".")
        let num1 = "\(nums[0])"
        let num2 = "\(nums[1].prefix(shared.decimal))"
        
        return (num1, num2)
    }
    
}

struct CalculationChartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CalculationChartView(currency: Currency(baseCode: "USD"), base: Currency(baseCode: "PLN"), data: [
                RatesData(code: "USD", date: "2022/10/29", value: 2.5),
                RatesData(code: "USD", date: "2022/10/30", value: 3),
                RatesData(code: "USD", date: "2022/10/31", value: 2.16),
                RatesData(code: "USD", date: "2022/11/01", value: 3),
                RatesData(code: "USD", date: "2022/11/02", value: 3),
                RatesData(code: "USD", date: "2022/11/03", value: 3),
                RatesData(code: "USD", date: "2022/11/04", value: 3)
            ])
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
