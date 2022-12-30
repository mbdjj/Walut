//
//  LoadingCell.swift
//  Walut
//
//  Created by Marcin Bartminski on 30/12/2022.
//

import SwiftUI

struct LoadingCell: View {
    var body: some View {
        HStack {
            
            Text("🇵🇱")
                .font(.system(size: 50))
            
            VStack(alignment: .leading) {
                
                Text("Polish Złoty")
                    .font(.system(size: 19))
                    .fontWeight(.medium)
                
                Text("PLN")
                    .font(.system(size: 17))
                
                Spacer()
                
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(String(format: "%.\(SharedDataManager.shared.decimal)f", 1.001)) zł")
                    .font(.system(size: 17))
                
                if SharedDataManager.shared.showPercent {
                    Text("\(String(format: "%.2f", 0.01))%")
                        .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(Bool.random() ? .green : .red)
                }
            }
            
        }
        .redacted(reason: .placeholder)
    }
}

struct LoadingCell_Previews: PreviewProvider {
    static var previews: some View {
        LoadingCell()
            .previewLayout(.fixed(width: 450, height: 90))
    }
}
