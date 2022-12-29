//
//  WalutWidget.swift
//  WalutWidget
//
//  Created by Marcin Bartminski on 17/11/2022.
//

import WidgetKit
import SwiftUI
import Charts

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CurrencyEntry {
        CurrencyEntry(date: Date(), rates: MockData.rates, chartData: MockData.chartData)
    }

    func getSnapshot(in context: Context, completion: @escaping (CurrencyEntry) -> ()) {
        let entry = CurrencyEntry(date: Date(), rates: MockData.rates, chartData: MockData.chartData)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(3600) // 1 hour
            
            do {
                let rates = try await NetworkManager.shared.getSmallWidgetData(for: "USD", baseCode: "PLN")
                
                var chartData: [RatesData]?
                if context.family == .systemMedium {
                    chartData = try await NetworkManager.shared.getChartData(forCode: "USD", baseCode: "PLN")
                }
                
                let entry = CurrencyEntry(date: .now, rates: rates, chartData: chartData)
                
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                
            }
        }
    }
}

struct CurrencyEntry: TimelineEntry {
    let date: Date
    let rates: [RatesData]
    
    let chartData: [RatesData]?
    
    init(date: Date, rates: [RatesData]) {
        self.date = date
        self.rates = rates
        self.chartData = nil
    }
    
    init(date: Date, rates: [RatesData], chartData: [RatesData]?) {
        self.date = date
        self.rates = rates
        self.chartData = chartData
    }
}

struct WalutWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: CurrencyEntry

    var body: some View {
        switch family {
        case .systemSmall:
            PercentView(rates: entry.rates)
        case .systemMedium:
            HStack {
                PercentView(rates: entry.rates)
                
                if let chartData = entry.chartData {
                    WidgetChartView(data: chartData)
                }
            }
        default:
            Text(entry.date.formatted(.dateTime))
        }
    }
}

struct WalutWidget: Widget {
    let kind: String = "WalutWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WalutWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(String(localized: "widget_title"))
        .description(String(localized: "widget_description"))
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct WalutWidget_Previews: PreviewProvider {
    static var previews: some View {
        WalutWidgetEntryView(entry: CurrencyEntry(date: Date(), rates: MockData.rates, chartData: MockData.chartData))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

extension Color {
    static let walut = Color(red: 0, green: 0.725, blue: 0.682)
}
