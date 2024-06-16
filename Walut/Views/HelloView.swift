//
//  HelloView.swift
//  Walut
//
//  Created by Marcin Bartminski on 03/03/2023.
//

import SwiftUI

struct HelloView: View {
    
    @Namespace var animation
    
    @Environment(AppSettings.self) var settings
    
    @State var animateStart = false
    @State var changeToOnboarding = false
    @State var animateNext = false
    
    let model = HelloViewModel()
    
    var body: some View {
        if !changeToOnboarding {
            VStack {
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Image("WalutIcon")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .cornerRadius(16)
                            .padding(.bottom, 10)
                        
                        Text("onboarding_welcome")
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .matchedGeometryEffect(id: "welcomeText", in: animation)
                        Text("Walut")
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .foregroundColor(.walut)
                            .matchedGeometryEffect(id: "walutText", in: animation)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 48)
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
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .matchedGeometryEffect(id: "welcomeText", in: animation)
                        Text("Walut")
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .foregroundColor(.walut)
                            .matchedGeometryEffect(id: "walutText", in: animation)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
                .padding(.top, 48)
                
                VStack(alignment: .leading) {
                    ForEach(model.onboardingData) { data in
                        OnboardingCell(data)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top)
                
                Spacer()
                
                Button {
                    withAnimation {
                        settings.appstate = .onboarded
                    }
                } label: {
                    Text("next")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background {
                            Color.walut
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
                .offset(y: animateNext ? 0 : 40)
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.6)) {
                    animateNext = true
                }
            }
        }
    }
}

struct HelloView_Previews: PreviewProvider {
    static var previews: some View {
        HelloView()
            .environment(AppSettings())
    }
}
