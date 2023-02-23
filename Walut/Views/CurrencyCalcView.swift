//
//  CurrencyCalcView.swift
//  Walut
//
//  Created by Marcin Bartminski on 23/02/2023.
//

import SwiftUI

struct CurrencyCalcView: View {
    var body: some View {
        // MARK: - Top bar
        
        VStack {
            HStack {
                Text("overview_calculation")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2.weight(.bold))
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                        .background {
                            Color(uiColor: .secondarySystemBackground)
                                .clipShape(Circle())
                        }
                }
            }
            .padding()
            
            // MARK: - From and To currency
            
            HStack {
                Text("From: ")
                    .font(.system(.body, design: .rounded, weight: .medium))
                
                Button {
                    
                } label: {
                    Text("🇵🇱 PLN")
                        .foregroundColor(.gray)
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .frame(width: 70, height: 30)
                        .background {
                            Color(uiColor: .secondarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                }
                
                Text("To: ")
                    .font(.system(.body, design: .rounded, weight: .medium))
                
                Button {
                    
                } label: {
                    Text("🇺🇸 USD")
                        .foregroundColor(.gray)
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .frame(width: 70, height: 30)
                        .background {
                            Color(uiColor: .secondarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // MARK: - Calculation numbers
            
            Spacer()
            
            VStack {
                HStack(alignment: .top, spacing: 0) {
                    Text("\("PLN")")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .offset(y: 16)
                    Text("0")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                    Text("\("PLN")")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .offset(y: 16)
                        .opacity(0)
                }
                
                HStack {
                    Text("\("USD")")
                        .font(.system(.body, design: .rounded, weight: .bold))
                    Text("0")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    Button {
                        
                    } label: {
                        Image(systemName: "rectangle.2.swap")
                            .foregroundColor(.primary)
                            .bold()
                    }
                }
            }
            
            Spacer()
            
            // MARK: - Chart button + rate
            
            HStack {
                Text("🇺🇸")
                    .frame(width: 45, height: 45)
                    .font(.largeTitle)
                    .background {
                        Color.walut
                            .clipShape(Circle())
                    }
                
                VStack(alignment: .leading) {
                    Text("USD")
                        .font(.system(.title3, design: .rounded, weight: .medium))
                    Text("4.469 zł")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("share_chart")
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .foregroundColor(.gray)
                        .background {
                            Color(uiColor: .secondarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                }
            }
            .padding(.horizontal, 32)
            
            // MARK: - Keypad
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                ForEach(1 ..< 10, id: \.self) { num in
                    Button {
                        
                    } label: {
                        Text("\(num)")
                            .foregroundColor(.primary)
                            .font(.system(.title2, design: .rounded, weight: .medium))
                            .frame(width: 60, height: 60)
                    }
                }
            }
            .padding(.horizontal, 32)
            
            HStack {
                Spacer()
                Button {
                    
                } label: {
                    Text(".")
                        .foregroundColor(.primary)
                        .font(.system(.title2, design: .rounded, weight: .medium))
                        .frame(width: 60, height: 60)
                }
                Spacer()
                Spacer()
                Button {
                    
                } label: {
                    Text("0")
                        .foregroundColor(.primary)
                        .font(.system(.title2, design: .rounded, weight: .medium))
                        .frame(width: 60, height: 60)
                }
                Spacer()
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "delete.left")
                        .foregroundColor(.primary)
                        .font(.system(.title2, design: .rounded, weight: .medium))
                        .frame(width: 60, height: 60)
                }
                Spacer()
            }
            .padding(.horizontal, 32)
            
            // MARK: - Clear button
            
            Button {
                
            } label: {
                HStack {
                    Spacer()
                    Text("clear")
                        .foregroundColor(.gray)
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .padding(.vertical, 8)
                    Spacer()
                }
                .background {
                    Color(uiColor: .secondarySystemBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom)
        }
    }
}

struct CurrencyCalcView_Previews: PreviewProvider {
    static var previews: some View {
        Text("dupa")
            .sheet(isPresented: .constant(true)) {
                CurrencyCalcView()
            }
    }
}
