//
//  LoadingCell.swift
//  Walut
//
//  Created by Marcin Bartminski on 30/12/2022.
//

import SwiftUI

struct LoadingCell: View {
    
    var randomName: String {
        let randomCode = SharedDataManager.shared.allCodesArray.randomElement()
        return Currency(baseCode: randomCode!).fullName
    }
    
    var body: some View {
        HStack {
            
            Text("AA")
                .font(.system(size: 50))
            
            VStack(alignment: .leading) {
                
                Text(randomName)
                    .font(.system(size: 19))
                    .fontWeight(.medium)
                
                Text("ABCD")
                    .font(.system(size: 17))
                
                Spacer()
                
            }
            
            Spacer()
            
            HStack {
                VStack(alignment: .trailing) {
                    Text("1.001 zł")
                        .font(.system(size: 17))
                    
                    if SharedDataManager.shared.showPercent {
                        Text("0.01%")
                            .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(Bool.random() ? .green : .red)
                    }
                }
                
                Text("a")
            }
            
        }
        .redacted(reason: .placeholder)
    }
}

struct LoadingCell_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            List {
                NavigationLink {
                    Text("dupa")
                } label: {
                    CurrencyCell(for: Currency(baseCode: "PLN"), mode: .normal, value: 1)
                }
                LoadingCell()
            }
        }
    }
}
