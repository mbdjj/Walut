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
    
    @ObservedObject var model: CurrencyOverviewViewModel
    
    @FocusState private var foreignTextFieldFocused: Bool
    @FocusState private var baseTextFieldFocused: Bool
    
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
                    Text("\(String(format: "%.\(model.decimal)f", currentActive?.value ?? model.currency.price)) \(model.base.symbol)")
                        .font(.system(.title, design: .rounded, weight: .bold))
                    
                    Text(model.currency.fullName)
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .foregroundColor(.walut)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: "arrow.up")
                            .rotationEffect(Angle(degrees: percentArrowDeg))
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundColor(percentColor)
                            .animation(.easeInOut(duration: 0.3), value: percentArrowDeg)
                        Text("\(String(format: "%.2f", abs(percent)))%")
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundColor(percentColor)
                            
                    }
                    
                    Text(currentActive == nil ? String(localized: "overview_past_month") : currentActive!.dateFormattedString)
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .foregroundColor(percentColor)
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
                .frame(height: 250)
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
                .onChange(of: currentActive) { newValue in
                    if newValue != nil {
                        let impact = UIImpactFeedbackGenerator(style: .soft)
                        impact.impactOccurred()
                    }
                }
                .onChange(of: currentActive == nil) { _ in
                    let impact = UIImpactFeedbackGenerator(style: .heavy)
                    impact.impactOccurred()
                }
            } else {
                ZStack {
                    Rectangle()
                        .frame(height: 300)
                        .foregroundColor(Color(uiColor: .secondarySystemBackground))
                    
                    ProgressView()
                }
            }
            
            // MARK: - todo chart length changing buttons
            
            // MARK: - CalculationView replacement
            
            Spacer(minLength: 60)
            
            HStack(spacing: 0) {
                TextField("", value: $model.foreignAmount, format: .currency(code: model.currency.code))
                    .frame(height: 50)
                    .font(.system(.title3, design: .rounded, weight: .medium))
                    .padding(.horizontal)
                    .background {
                        Color.white
                    }
                    .cornerRadius(25)
                    .shadow(color: .walut, radius: 5, x: 0, y: 4)
                    .keyboardType(.decimalPad)
                    .padding(.horizontal, 16)
                    .focused($foreignTextFieldFocused)
                    .onChange(of: model.foreignAmount) { newValue in
                        if foreignTextFieldFocused {
                            model.baseAmount = newValue / model.currency.rate
                        }
                    }
                
                TextField("", value: $model.baseAmount, format: .currency(code: model.base.code))
                    .frame(height: 50)
                    .font(.system(.title3, design: .rounded, weight: .medium))
                    .padding(.horizontal)
                    .background {
                        Color.white
                    }
                    .cornerRadius(25)
                    .shadow(color: .walut, radius: 4, x: 0, y: 4)
                    .keyboardType(.decimalPad)
                    .padding(.trailing, 16)
                    .focused($baseTextFieldFocused)
                    .onChange(of: model.baseAmount) { newValue in
                        if baseTextFieldFocused {
                            model.foreignAmount = newValue / model.currency.price
                        }
                    }
            }
            .padding(.vertical)
            
            Button {
                foreignTextFieldFocused = false
                baseTextFieldFocused = false
                
                model.foreignAmount = 0.0
                model.baseAmount = 0.0
            } label: {
                HStack {
                    Spacer()
                    Text("clear")
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .frame(height: 40)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .background {
                    Color(uiColor: .secondarySystemBackground)
                }
                .cornerRadius(20)
                .padding(.horizontal)
            }
            
            // MARK: - Currency info
            
            Spacer(minLength: 60)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("About \(model.currency.code)")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                
                Text("""
                     Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam dictum mauris metus, rutrum lobortis magna pretium quis. Maecenas a nulla elementum, consectetur quam ut, fringilla nisi. Phasellus pulvinar sodales ipsum a finibus. Vestibulum interdum nulla id magna cursus elementum. Etiam venenatis blandit augue, nec consectetur enim ullamcorper consectetur. Nunc ut enim sed justo luctus rhoncus quis quis arcu. Maecenas a placerat sem. Proin laoreet luctus sapien, non vulputate nulla egestas ut. Maecenas varius mauris nisl, non mollis massa hendrerit eu. Proin elementum, enim nec aliquet tempus, magna magna tincidunt leo, sed vestibulum metus dui in tortor. Praesent sit amet finibus nibh, sed molestie sem. Suspendisse pellentesque, felis sit amet semper fermentum, dui quam consectetur ligula, at tristique quam nibh ac lacus. Suspendisse potenti. Duis iaculis lorem enim, ut finibus est varius ac.
                     
                     Curabitur posuere pellentesque tellus, eu pulvinar urna hendrerit nec. In sed ipsum vel lorem varius varius. Integer ultricies malesuada leo. Etiam finibus et elit eget imperdiet. Donec gravida non nisi ac vestibulum. Nulla facilisi. Aliquam a mattis turpis, eget rutrum risus. Sed eu orci vitae leo convallis pharetra. Praesent eget efficitur diam.

                     Morbi dignissim diam a dapibus egestas. Aenean pellentesque molestie tempor. Mauris suscipit nec justo ut rutrum. Donec id mi tempor, lobortis urna ac, porttitor enim. In posuere vitae diam id fermentum. Suspendisse convallis quis massa at ultrices. Integer elementum lorem eget odio bibendum, eu consequat erat dictum. Aenean eleifend varius metus, eu molestie augue hendrerit vel. Sed cursus auctor odio, non porta nibh aliquet ornare. Cras est sem, placerat nec libero eget, laoreet congue lectus. In at feugiat mi. Morbi vel neque quam.
                     """)
                .lineLimit(model.infoLineLimit)
                .foregroundColor(.gray)
                .font(.system(.body, design: .rounded))
                
                Button {
                    if model.infoLineLimit == 8 {
                        model.infoLineLimit = nil
                    } else {
                        model.infoLineLimit = 8
                    }
                } label: {
                    Text("Read more \(Image(systemName: "arrow.right.circle"))")
                        .font(.system(.body, design: .rounded, weight: .medium))
                }
            }
            .padding()
            
        }
        .scrollDismissesKeyboard(.interactively)
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
