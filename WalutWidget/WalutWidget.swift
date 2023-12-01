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
    private let defaults = UserDefaults(suiteName: "group.dev.bartminski.Walut")!
    
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
            
            if NetworkManager.shared.shouldRefresh() {
                do {
                    let currencies = try await NetworkManager.shared.getCurrencyData(for: Currency(baseCode: baseCode))
                    
                    await saveCurrency(data: currencies, base: baseCode)
                    
                    let currency = currencies.filter { $0.code == foreignCode }.first!
                    
                    let entry = CurrencyEntry(date: .now, currency: currency, baseCode: baseCode, chartData: nil)
                    
                    let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                    completion(timeline)
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                if let currency = await getSavedData(for: foreignCode, base: baseCode) {
                    let entry = CurrencyEntry(date: .now, currency: currency, baseCode: baseCode, chartData: nil)
                    
                    let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                    completion(timeline)
                } else {
                    do {
                        let currency = try await NetworkManager.shared.getSmallWidgetData(for: foreignCode, baseCode: baseCode)
                        
                        let entry = CurrencyEntry(date: .now, currency: currency, baseCode: baseCode, chartData: nil)
                        
                        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                        completion(timeline)
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func getCodes(from configuration: ChangeCurrenciesIntent) -> (String, String) {
        let allCodesArray = ["AUD", "BGN", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "RUB", "SEK", "SGD", "THB", "TRY", "UAH", "USD", "ZAR"]
        
        let foreignCode = allCodesArray[configuration.foreignCurrency.rawValue]
        let baseCode = allCodesArray[configuration.baseCurrency.rawValue]
        
        return (foreignCode, baseCode)
    }
    
    @MainActor
    private func getSavedData(for code: String, base: String) -> Currency? {
        let descriptor = FetchDescriptor<SavedCurrency>()
        let saved = try? modelContainer.mainContext.fetch(descriptor)
        let nextUpdate = defaults.integer(forKey: "nextUpdate")
        let currency = saved?
            .filter {
                $0.nextRefresh == nextUpdate && $0.base == base
            }
            .map {
                Currency(code: $0.code, rate: $0.rate)
            }
            .filter { $0.code == code }
            .first
        
        return currency
    }
    
    @MainActor
    private func saveCurrency(data: [Currency], base: String) {
        let nextUpdate = defaults.integer(forKey: "nextUpdate")
        let descriptor = FetchDescriptor<SavedCurrency>()
        let savedCurrencies = try? modelContainer.mainContext.fetch(descriptor)
        data.forEach { item in
            if !(savedCurrencies?.contains(where: { $0.code == item.code && $0.base == base && $0.nextRefresh == nextUpdate }) ?? true) {
                let newSaved = SavedCurrency(code: item.code, base: base, rate: item.rate, nextRefresh: nextUpdate)
                modelContainer.mainContext.insert(newSaved)
                print("Saved \(item.code) to SwiftData")
            }
        }
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
