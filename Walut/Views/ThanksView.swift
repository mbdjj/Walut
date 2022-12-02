//
//  ThanksView.swift
//  Walut
//
//  Created by Marcin Bartminski on 04/11/2022.
//

import SwiftUI

struct ThanksView: View {
    
    let title: String
    let arrayToSave: [Int]
    
    var shared = SharedDataManager.shared
    
    var body: some View {
        ZStack {
            Color.accentColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Spacer()
                
                Text(String(localized: "support_thanks"))
                    .foregroundColor(.white)
                    .font(.system(.title, design: .rounded))
                    .bold()
                
                Text("❤️")
                    .font(.system(size: 50))
                
                Spacer()
                
                Text("\(String(localized: "support_enjoy_1"))\(title)\(String(localized: "support_enjoy_2"))")
                    .foregroundColor(.white)
                    .padding(.bottom)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Button {
                    shared.titleIDArray = arrayToSave
                } label: {
                    ZStack {
                        Color.white
                        
                        Text("OK")
                    }
                    .frame(maxHeight: 45)
                    .cornerRadius(10)
                }
                .padding(.bottom, 40)
                .padding(.horizontal)
            }
        }
        .interactiveDismissDisabled()
    }
}

struct ThanksView_Previews: PreviewProvider {
    static var previews: some View {
        ThanksView(title: "Supporter", arrayToSave: [0])
    }
}
