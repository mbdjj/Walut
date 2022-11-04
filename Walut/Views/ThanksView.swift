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
                
                Text("Thank you for your support.")
                    .foregroundColor(.white)
                    .font(.system(.title, design: .rounded))
                    .bold()
                
                Text("❤️")
                    .font(.system(size: 50))
                
                Spacer()
                
                Text("Enjoy your new \(title) title. \nYou can equip it in your profile.")
                    .foregroundColor(.white)
                    .padding(.bottom)
                
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
