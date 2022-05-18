//
//  DetailView.swift
//  WatchWalut WatchKit Extension
//
//  Created by Marcin Bartminski on 18/05/2022.
//

import SwiftUI

struct DetailView: View {
    
    let base: Currency
    let foreign: Currency
    
    @State var text = ""
    
    var body: some View {
        ZStack {
            
            VStack {
                HStack {
                    Text("\(foreign.flag) \(foreign.fullName)")
                        .font(.title3)
                        .bold()
                    
                    Spacer()
                }
                
                Spacer()
            }
            
            VStack {
                Text("1 \(base.symbol) = \(String(format: "%.2f", foreign.rate)) \(foreign.symbol)")
                    .bold()
                
                Text("1 \(foreign.symbol) = \(String(format: "%.2f", foreign.price)) \(base.symbol)")
                    .bold()
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(base: .init(baseCode: "PLN"), foreign: .init(baseCode: "USD"))
    }
}
