//
//  CalculationChartView.swift
//  Walut
//
//  Created by Marcin Bartminski on 16/05/2022.
//

import SwiftUI
import SwiftUICharts

struct CalculationChartView: View {
    
    let currency: Currency
    let data: [Double]
    
    let chartStyle = ChartStyle(backgroundColor: .clear, accentColor: .accentColor, gradientColor: GradientColor(start: .accentColor, end: .accentColor), textColor: .primary, legendTextColor: .gray, dropShadowColor: .clear)
    
    var body: some View {
        LineView(data: data, title: "\(currency.flag) \(currency.code)", legend: currency.fullName, style: chartStyle)
            .padding()
    }
}

struct CalculationChartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CalculationChartView(currency: Currency(baseCode: "USD"), data: [8, 2, 4, 6, 12, 9, 2])
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
