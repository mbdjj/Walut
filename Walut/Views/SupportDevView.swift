//
//  SupportDevView.swift
//  Walut
//
//  Created by Marcin Bartminski on 03/11/2022.
//

import SwiftUI

struct SupportDevView: View {
    var body: some View {
        List {
            HStack {
                Text(String(localized: "support"))
                    .fontWeight(.medium)
                
                Spacer()
                
                VStack {
                    Text("☕️")
                        .font(.title)
                    Text("5,99 zł")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .navigationTitle(String(localized: "support"))
    }
}

struct SupportDevView_Previews: PreviewProvider {
    static var previews: some View {
        SupportDevView()
    }
}
