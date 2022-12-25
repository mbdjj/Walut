//
//  OnboardingView.swift
//  Walut
//
//  Created by Marcin Bartminski on 27/10/2022.
//

import SwiftUI

struct OnboardingView: View {
    
    let model = OnboardingViewModel()
    let shared = SharedDataManager.shared
    
    @State var selection = 0
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.accentColor
                    .ignoresSafeArea()
                
                TabView (selection: $selection) {
                    OnboardingPage(model.onboardingData[0])
                        .tag(0)
                    OnboardingPage(model.onboardingData[1])
                        .tag(1)
                    OnboardingPage(model.onboardingData[2])
                        .tag(2)
                    OnboardingPage(model.onboardingData[3])
                        .tag(3)
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            .toolbar {
                if selection != 0 {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            if selection > 0 {
                                withAnimation {
                                    selection -= 1
                                }
                            }
                        } label: {
                            Text(String(localized: "back"))
                        }
                        .foregroundColor(.white)
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        if selection < 3 {
                            withAnimation {
                                selection += 1
                            }
                        } else {
                            withAnimation {
                                shared.onboardingDone = true
                            }
                        }
                    } label: {
                        if selection == 3 {
                            Text(String(localized: "continue"))
                            .bold()
                        } else {
                            Text(String(localized: "next"))
                        }
                    }
                    .foregroundColor(.white)
                    .bold()
                }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
