//
//  ChartToShare.swift
//  Walut
//
//  Created by Marcin Bartminski on 29/10/2022.
//

import SwiftUI
import Charts

struct ChartToShare: View {
    
    let base: Currency
    let currency: Currency
    let data: [RatesData]
    
    let shared = SharedDataManager.shared
    var minValueYAxis: Double
    var maxValueYAxis: Double
    
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
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(currency.flag) \(currency.code) - \(base.flag) \(base.code)")
                .font(.largeTitle)
                .bold()
                .padding()
            
            VStack(alignment: .leading) {
                
                Text(data.last!.dateFormattedString)
                    .padding(.horizontal)
                    .font(.system(.title2, weight: .semibold))
                
                Text("\(String(format: "%.\(shared.decimal)f", data.last!.value)) \(shared.base.symbol)")
                    .padding(.horizontal)
                    .font(.largeTitle)
                    .bold()
                
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
                .chartYScale(domain: minValueYAxis*0.99...maxValueYAxis*1.01)
                .frame(width: 360, height: 250)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.background.shadow(.drop(radius: 2)))
            }
        }
        .background(Color.white)
    }
}

extension Color {
    static let walut = Color(red: 0, green: 0.725, blue: 0.682)
}

struct ChartToShare_Previews: PreviewProvider {
    static var previews: some View {
        ChartToShare(currency: Currency(baseCode: "USD"), base: Currency(baseCode: "PLN"), data: [
            RatesData(code: "USD", date: "2022/10/29", value: 2.5),
            RatesData(code: "USD", date: "2022/10/30", value: 3),
            RatesData(code: "USD", date: "2022/10/31", value: 2.16),
            RatesData(code: "USD", date: "2022/11/01", value: 3),
            RatesData(code: "USD", date: "2022/11/02", value: 3),
            RatesData(code: "USD", date: "2022/11/03", value: 3),
            RatesData(code: "USD", date: "2022/11/04", value: 3)
        ])
    }
}
