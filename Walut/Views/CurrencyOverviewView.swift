//
//  CurrencyOverviewView.swift
//  Walut
//
//  Created by Marcin Bartminski on 12/02/2023.
//

import SwiftUI
import Charts

struct CurrencyOverviewView: View {
    
    var minValueYAxis: Double {
        let data = model.currency.chartData ?? []
        return data.min { $0.value < $1.value }?.value ?? 0.0
    }
    var maxValueYAxis: Double {
        let data = model.currency.chartData ?? []
        return data.max { $0.value < $1.value }?.value ?? 0.0
    }
    
    @State var currentActive: RatesData?
    var percent: Double {
        if let data = model.currency.chartData {
            if let active = currentActive {
                let price = active.value
                let start = data.first!.value
                
                return (price - start) / start * 100
            } else {
                let price = data.last!.value
                let start = data.first!.value
                
                return (price - start) / start * 100
            }
        } else {
            return 0.0
        }
    }
    var percentPositive: Bool { percent >= 0 }
    
    @ObservedObject var model: CurrencyOverviewViewModel
    
    init(currency: Currency) {
        let base = SharedDataManager.shared.base
        let currency = currency
        
        self.model = CurrencyOverviewViewModel(currency: currency, base: base)
    }
    
    var body: some View {
        ScrollView {
            
            // MARK: - Top bar
            
            HStack(alignment: .top, spacing: 8) {
                Text(model.currency.flag)
                    .frame(width: 50, height: 50)
                    .font(.largeTitle)
                    .background {
                        Color.walut
                            .clipShape(Circle())
                    }
                    .shadow(color: .walut, radius: 5, x: 0, y: 4)
                
                Spacer()
                
                Button {
                    model.handleFavorites()
                } label: {
                    Image(systemName: "star\(model.currency.isFavorite ? ".fill" : "")")
                        .font(.title2)
                        .frame(width: 40, height: 40)
                        .foregroundColor(model.currency.isFavorite ? .yellow : .gray)
                        .background {
                            Color(uiColor: .secondarySystemBackground)
                                .clipShape(Circle())
                        }
                }
                
                Menu {
                    Button {
                        
                    } label: {
                        Label("share_value", systemImage: "equal.circle")
                    }
                    
                    Button {
                        
                    } label: {
                        Label("share_text", systemImage: "text.bubble")
                    }
                    
                    Button {
                        
                    } label: {
                        Label("share_chart", systemImage: "chart.xyaxis.line")
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                        .background {
                            Color(uiColor: .secondarySystemBackground)
                                .clipShape(Circle())
                        }
                }
            }
            .padding()
            
            // MARK: - Chart info
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text("\(String(format: "%.3f", currentActive?.value ?? model.currency.price)) \(model.base.symbol)")
                        .font(.system(.title, design: .rounded, weight: .bold))
                    
                    Text(model.currency.fullName)
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .foregroundColor(.walut)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(Image(systemName: "arrow.\(percentPositive ? "up" : "down")")) \(String(format: "%.2f", abs(percent)))%")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundColor(percentPositive ? .green : .red)
                    
                    Text(currentActive == nil ? String(localized: "overview_past_month") : currentActive!.dateFormattedString)
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .foregroundColor(percentPositive ? .green : .red)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal)
            
            // MARK: - Chart
            
            if let data = model.currency.chartData {
                Chart {
                    ForEach(data) { rate in
                        LineMark(
                            x: .value("Date", rate.date),
                            y: .value("Value", rate.value)
                        )
                        .foregroundStyle(Color.walut.gradient.opacity(currentActive == nil ? 1 : 0.6))
                        .interpolationMethod(.catmullRom)
                        
                        if let currentActive, currentActive.id == rate.id {
                            RuleMark(x: .value("Date", currentActive.date))
                                .foregroundStyle(Color.accentColor.gradient)
                                .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                        }
                    }
                }
                .frame(height: 300)
                .chartYScale(domain: minValueYAxis - minValueYAxis * 0.01 ... maxValueYAxis + maxValueYAxis * 0.01)
                .chartYAxis(.hidden)
                //.chartXAxis(.hidden)
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
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
            } else {
                ZStack {
                    Rectangle()
                        .frame(height: 300)
                        .foregroundColor(Color(uiColor: .secondarySystemBackground))
                    
                    ProgressView()
                }
            }
        }
    }
}

struct CurrencyOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        Text("dupa")
            .sheet(isPresented: .constant(true)) {
                CurrencyOverviewView(currency: Currency.placeholder)
            }
    }
}
