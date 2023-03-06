//
//  ChartToShare.swift
//  Walut
//
//  Created by Marcin Bartminski on 29/10/2022.
//

import SwiftUI
import Charts

struct ChartToShare: View {
    
    let currency: Currency
    let base: Currency
    
    var minValueYAxis: Double {
        let data = currency.chartData ?? []
        return data.min { $0.value < $1.value }?.value ?? 0.0
    }
    var maxValueYAxis: Double {
        let data = currency.chartData ?? []
        return data.max { $0.value < $1.value }?.value ?? 0.0
    }
    
    var percent: Double {
        if let data = currency.chartData {
            let price = data.last!.value
            let start = data.first!.value
            
            return (price - start) / start
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
    
    var body: some View {
        VStack {
            
            // MARK: - Top bar
            
            HStack(alignment: .top, spacing: 8) {
                Text(currency.flag)
                    .frame(width: 50, height: 50)
                    .font(.largeTitle)
                    .background {
                        Color.walut
                            .clipShape(Circle())
                    }
                    .shadow(color: .walut, radius: 5, x: 0, y: 4)
                
                Text(base.flag)
                    .frame(width: 50, height: 50)
                    .font(.largeTitle)
                    .background {
                        Color.walut
                            .clipShape(Circle())
                    }
                    .shadow(color: .walut, radius: 5, x: 0, y: 4)
                
                Spacer()
            }
            .padding()
            
            // MARK: - Chart info
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text(SharedDataManager.shared.currencyLocaleString(value: currency.price, currencyCode: base.code))
                        .font(.system(.title, design: .rounded, weight: .bold))
                    
                    Text(currency.fullName)
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .foregroundColor(.walut)
                }
                
                Spacer(minLength: 80)
                
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
                    
                    Text("overview_past_month")
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .foregroundColor(percentColor)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal)
            
            // MARK: - Chart
            
            Chart {
                ForEach(currency.chartData ?? [RatesData]()) { rate in
                    LineMark(
                        x: .value("Date", rate.date),
                        y: .value("Value", rate.value)
                    )
                    .foregroundStyle(Color.walut.gradient.opacity(1.0))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 300)
            .chartYScale(domain: minValueYAxis - minValueYAxis * 0.01 ... maxValueYAxis + maxValueYAxis * 0.01)
            .chartXAxis(.hidden)
            
        }
        .background(.background)
    }
}

extension Color {
    static let walut = Color(red: 0, green: 0.725, blue: 0.682)
}

struct ChartToShare_Previews: PreviewProvider {
    static var previews: some View {
        ChartToShare(currency: Currency.placeholder, base: Currency(baseCode: "PLN"))
    }
}
