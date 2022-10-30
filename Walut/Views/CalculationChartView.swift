//
//  CalculationChartView.swift
//  Walut
//
//  Created by Marcin Bartminski on 10/10/2022.
//

import SwiftUI
import Charts

struct CalculationChartView: View {
    
    let currency: Currency
    @State var data: [RatesData]
    
    var minValueYAxis: Double
    var maxValueYAxis: Double
    
    @State var currentActive: RatesData?
    
    let shared = SharedDataManager.shared
    
    init(currency: Currency, data: [RatesData]) {
        self.currency = currency
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
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                
                Text(currentActive?.dateFormattedString ?? data.last!.dateFormattedString)
                    .padding(.horizontal)
                    .font(.system(.title2, weight: .semibold))
                
                Text("\(String(format: "%.\(shared.decimal)f", currentActive?.value ?? data.last!.value)) \(shared.base.symbol)")
                    .padding(.horizontal)
                    .font(.largeTitle)
                    .bold()
                
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.4)) {
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
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.background.shadow(.drop(radius: 2)))
            }
            
            Spacer()
        }
        .padding()
    }
    
}

struct CalculationChartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CalculationChartView(currency: Currency(baseCode: "USD"), data: [
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
