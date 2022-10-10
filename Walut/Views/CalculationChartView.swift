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
    let data: [RatesData]
    
    var minValueYAxis: Double
    var maxValueYAxis: Double
    
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
            Chart {
                ForEach(data) { rate in
                    LineMark(x: .value("Time", rate.date),
                             y: .value("Value", rate.value))
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .chartYScale(domain: minValueYAxis...maxValueYAxis)
            
            Spacer()
        }
    }
    
}

struct CalculationChartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CalculationChartView(currency: Currency(baseCode: "USD"), data: [RatesData(date: "test", value: 0.5), RatesData(date: "dzisiaj", value: 3), RatesData(date: "jutro", value: 2.16)])
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
