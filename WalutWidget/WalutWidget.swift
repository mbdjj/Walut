//
//  WalutWidget.swift
//  WalutWidget
//
//  Created by Marcin Bartminski on 17/11/2022.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CurrencyEntry {
        CurrencyEntry(date: Date(), rates: RatesData.placeholderArraySmall)
    }

    func getSnapshot(in context: Context, completion: @escaping (CurrencyEntry) -> ()) {
        let entry = CurrencyEntry(date: Date(), rates: RatesData.placeholderArraySmall)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(3600) // 1 hour
            
            do {
                let rates = try await NetworkManager.shared.getSmallWidgetData(for: "USD", baseCode: "PLN")
                let entry = CurrencyEntry(date: .now, rates: rates)
                
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
}

struct WalutWidgetEntryView : View {
    var entry: CurrencyEntry
    
    var entryCurrency: Currency { Currency(baseCode: entry.rates[0].currencyString) }
    var differencePercent: Double {
        let yesterday = entry.rates[0].value
        let today = entry.rates[1].value
        
        return (today - yesterday) / yesterday * 100
    }
    var percentColor: Color {
        if differencePercent == 0 {
            return .secondary
        } else if differencePercent > 0 {
            return .green
        } else {
            return .red
        }
    }
    var symbol: Image {
        if differencePercent == 0 {
            return Image(systemName: "arrow.right")
        } else if differencePercent > 0 {
            return Image(systemName: "arrow.up.right")
        } else {
            return Image(systemName: "arrow.down.right")
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                
                Text("\(entryCurrency.flag) \(entryCurrency.code)")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("\(String(format: "%.3f", entry.rates.last?.value ?? 1.2)) \(Currency(baseCode: "PLN").symbol)")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundColor(.walut)
                
                Label {
                    Text("\(String(format: "%.2f", differencePercent))%")
                } icon: {
                    symbol
                }
                .fontWeight(.semibold)
                .foregroundColor(percentColor)

                
                Spacer()
                Spacer()
            }
            .padding()
            
            Spacer()
        }
    }
}

struct WalutWidget: Widget {
    let kind: String = "WalutWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WalutWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Currency Tracker")
        .description("A widget to track currency of your choice.")
        .supportedFamilies([.systemSmall])
    }
}

struct WalutWidget_Previews: PreviewProvider {
    static var previews: some View {
        WalutWidgetEntryView(entry: CurrencyEntry(date: Date(), rates: RatesData.placeholderArraySmall))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension Color {
    static let walut = Color(red: 0, green: 0.725, blue: 0.682)
}
