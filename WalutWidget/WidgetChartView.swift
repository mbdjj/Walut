//
//  WidgetChartView.swift
//  WalutWidgetExtension
//
//  Created by Marcin Bartminski on 29/12/2022.
//

import SwiftUI
import Charts

struct WidgetChartView: View {
    
    var data: [RatesData]
    
    var minValueYAxis: Double
    var maxValueYAxis: Double
    
    init(data: [RatesData]) {
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
        Chart {
            ForEach(data) { rate in
                LineMark(
                    x: .value("Date", rate.date),
                    y: .value("Value", rate.value)
                )
                .foregroundStyle(Color.walut.gradient)
                .interpolationMethod(.catmullRom)
            }
        }
        .chartYScale(domain: minValueYAxis - minValueYAxis * 0.01 ... maxValueYAxis + maxValueYAxis * 0.01)
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .padding()
    }
}
