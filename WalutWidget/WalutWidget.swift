//
//  WalutWidget.swift
//  WalutWidget
//
//  Created by Marcin Bartminski on 17/11/2022.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: IntentTimelineProvider {
    
    private let modelContainer: ModelContainer
    private let defaults = UserDefaults(suiteName: "group.dev.bartminski.Walut")
    
    init() {
        do {
            modelContainer = try ModelContainer(for: SavedCurrency.self)
        } catch {
            fatalError("Failed to create the model container: \(error)")
        }
    }
    
    func placeholder(in context: Context) -> CurrencyEntry {
        CurrencyEntry(date: Date(), currency: Currency.placeholder, baseCode: "USD", chartData: MockData.chartData)
    }
    
    func getSnapshot(for configuration: ChangeCurrenciesIntent, in context: Context, completion: @escaping (CurrencyEntry) -> Void) {
        let entry = CurrencyEntry(date: Date(), currency: Currency.placeholder, baseCode: "USD", chartData: MockData.chartData)
        completion(entry)
    }
    
    func getTimeline(for configuration: ChangeCurrenciesIntent, in context: Context, completion: @escaping (Timeline<CurrencyEntry>) -> Void) {
        Task {
            let nextUpdate = Date().addingTimeInterval(3600) // 1 hour
            
            let (foreignCode, baseCode) = getCodes(from: configuration)
            
            do {
                let currency = try await NetworkManager.shared.getSmallWidgetData(for: foreignCode, baseCode: baseCode)
                
                //var chartData: [RatesData]?
//                if context.family == .systemMedium {
//                    chartData = try await NetworkManager.shared.getChartData(forCode: foreignCode, baseCode: baseCode)
//                }
                
                let entry = CurrencyEntry(date: .now, currency: currency, baseCode: baseCode, chartData: nil)
                
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getCodes(from configuration: ChangeCurrenciesIntent) -> (String, String) {
        let allCodesArray = ["AUD", "BGN", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "RUB", "SEK", "SGD", "THB", "TRY", "UAH", "USD", "ZAR"]
        
        let foreignCode = allCodesArray[configuration.foreignCurrency.rawValue]
        let baseCode = allCodesArray[configuration.baseCurrency.rawValue]
        
        return (foreignCode, baseCode)
    }
}

struct CurrencyEntry: TimelineEntry {
    let date: Date
    let currency: Currency
    
    let baseCode: String
    
    let chartData: [RatesData]?
}

struct WalutWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: CurrencyEntry

    var body: some View {
        switch family {
        case .systemSmall:
            PercentView(currency: entry.currency, baseCode: entry.baseCode)
                .containerBackground(.background, for: .widget)
//        case .systemMedium:
//            HStack {
//                PercentView(rates: entry.rates, baseCode: entry.baseCode)
//                
//                if let chartData = entry.chartData {
//                    WidgetChartView(data: chartData)
//                }
//            }
        case .accessoryRectangular:
            RectangularView(baseCode: entry.baseCode, currency: entry.currency)
                .containerBackground(.clear, for: .widget)
        default:
            EmptyView()
        }
    }
}

struct WalutWidget: Widget {
    let kind: String = "WalutWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ChangeCurrenciesIntent.self, provider: Provider()) { entry in
            WalutWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(String(localized: "widget_title"))
        .description(String(localized: "widget_description"))
        .supportedFamilies([.systemSmall, .accessoryRectangular])
    }
}

struct WalutWidget_Previews: PreviewProvider {
    static var previews: some View {
        WalutWidgetEntryView(entry: CurrencyEntry(date: Date(), currency: Currency.placeholder, baseCode: "USD", chartData: MockData.chartData))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
