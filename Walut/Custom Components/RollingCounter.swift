//
//  RollingCounter.swift
//  Walut
//
//  Created by Marcin Bartminski on 07/01/2023.
//

import SwiftUI

struct RollingCounter: View {
    
    var font: Font = .system(size: 16)
    var weight: Font.Weight = .regular
    var color: Color = .primary
    
    @Binding var value: String
    
    @State var animationRange: [String] = []
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< animationRange.count, id: \.self) { index in
                Text("0")
                    .font(font)
                    .fontWeight(weight)
                    .foregroundColor(color)
                    .opacity(0)
                    .overlay {
                        GeometryReader { proxy in
                            let size = proxy.size
                            
                            VStack(spacing: 0) {
                                ForEach(0 ... 9, id: \.self) { num in
                                    Text("\(num)")
                                        .font(font)
                                        .fontWeight(weight)
                                        .foregroundColor(color)
                                        .frame(width: size.width, height: size.height, alignment: .center)
                                }
                            }
                            .offset(y: -CGFloat(Int(animationRange[index]) ?? 0) * size.height)
                        }
                        .clipped()
                    }
            }
        }
        .onAppear {
            animationRange = Array(repeating: "0", count: "\(value)".count)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                updateText(atStart: true)
            }
        }
        .onChange(of: value) { newValue in
            let extra = "\(value)".count - animationRange.count
            if extra > 0 {
                for _ in 0 ..< extra {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        animationRange.append("0")
                    }
                }
            } else {
                for _ in 0 ..< (-extra) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        animationRange.removeLast()
                    }
                }
            }
            
            updateText()
        }
    }
    
    func updateText(atStart: Bool = false) {
        let stringValue = "\(value)"
        for (index, value) in zip(0 ..< stringValue.count, stringValue) {
            withAnimation(.easeInOut(duration: atStart ? 0.5 : 0.1)) {
                animationRange[index] = String(value)
            }
        }
    }
}
