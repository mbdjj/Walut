//
//  HelloiPadView.swift
//  Walut
//
//  Created by Marcin Bartminski on 04/02/2024.
//

import SwiftUI

struct HelloiPadView: View {
    @Namespace var animation
    
    @State var animateStart = false
    @State var changeToOnboarding = false
    @State var animateNext = false
    
    let model = HelloViewModel()
    
    var body: some View {
        if !changeToOnboarding {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Image("WalutIcon")
                            .resizable()
                            .frame(width: 128, height: 128)
                            .cornerRadius(32)
                            .padding(.bottom, 32)
                        
                        Text("onboarding_welcome")
                            .font(.system(size: 64, weight: .heavy, design: .rounded))
                            .matchedGeometryEffect(id: "welcomeText", in: animation)
                        Text("Walut")
                            .font(.system(size: 64, weight: .heavy, design: .rounded))
                            .foregroundColor(.walut)
                            .matchedGeometryEffect(id: "walutText", in: animation)
                    }
                    
                    Spacer()
                }
                .padding(128)
                .opacity(animateStart ? 1.0 : 0.0)
                .scaleEffect(animateStart ? 1.0 : 0.8)
                
                Spacer()
                Spacer()
                
                ProgressView()
                    .padding(.bottom)
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.6)) {
                    animateStart = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.6)) {
                        changeToOnboarding = true
                    }
                }
            }
        } else {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("onboarding_welcome")
                            .font(.system(size: 64, weight: .heavy, design: .rounded))
                            .matchedGeometryEffect(id: "welcomeText", in: animation)
                        Text("Walut")
                            .font(.system(size: 64, weight: .heavy, design: .rounded))
                            .foregroundColor(.walut)
                            .matchedGeometryEffect(id: "walutText", in: animation)
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    ForEach(model.onboardingData) { data in
                        OnboardingCell(data)
                            .padding(.bottom, 48)
                    }
                }
                .padding(.top)
                
                Spacer()
                
                Button {
                    withAnimation {
                        SharedDataManager.shared.appState = .onboarded
                    }
                } label: {
                    Text("next")
                        .font(.title2)
                        .bold()
                        .frame(width: 400, height: 32)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle)
                .padding(.bottom, 30)
                .offset(y: animateNext ? 0 : 40)
            }
            .padding(.horizontal, 128)
            .padding(.top, 128)
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.6)) {
                    animateNext = true
                }
            }
        }
    }
}

#Preview {
    HelloiPadView()
}
