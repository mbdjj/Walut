//
//  NotWorkingView.swift
//  Walut
//
//  Created by Marcin Bartminski on 30/09/2023.
//

import SwiftUI

struct NotWorkingView: View {
    
    @AppStorage("whyNotWorkingShown") var whyNotWorkingShown: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("😰")
                .font(.largeTitle)
            Text("walut_not_working_title")
                .font(.title)
                .bold()
                .padding(.bottom)
            Text("walut_not_working_desc")
                .padding(.horizontal)
            
            Spacer()
            
            Button {
                dismiss.callAsFunction()
            } label: {
                HStack {
                    Spacer()
                    Text("OK")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .padding(.bottom)
            
            Button {
                whyNotWorkingShown = true
                dismiss.callAsFunction()
            } label: {
                HStack {
                    Spacer()
                    Text("dont_show_again")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
        .padding()
    }
}

#Preview {
    NotWorkingView()
}
