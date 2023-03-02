//
//  FeatureRoadmapView.swift
//  Walut
//
//  Created by Marcin Bartminski on 02/03/2023.
//

import SwiftUI
import Roadmap

struct FeatureRoadmapView: View {
    
    var configuration: RoadmapConfiguration {
        RoadmapConfiguration(
            roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/jfhtmgzfiwq")!,
            style: style,
            shuffledOrder: false,
            allowVotes: true
        )
    }
    
    let style = RoadmapStyle(
        icon: Image(systemName: "heart.fill"),
        titleFont: .system(.title2, design: .rounded, weight: .medium),
        numberFont: .system(.body, design: .rounded),
        statusFont: .system(.caption, design: .rounded),
        cornerRadius: 8,
        cellColor: .init(uiColor: .secondarySystemBackground),
        selectedColor: .white,
        tint: .walut
    )
    
    var body: some View {
        RoadmapView(configuration: configuration)
            .navigationTitle("features")
            .toolbar {
                Button {
                    sendEmail()
                } label: {
                    Image(systemName: "questionmark.square.fill")
                        .overlay(alignment: .topTrailing) {
                            Image(systemName: "plus.circle.fill")
                                .symbolRenderingMode(.multicolor)
                                .imageScale(.small)
                                .background(.background)
                                .clipShape(Circle())
                                .offset(x: 6, y: -6)
                        }
                }
            }
    }
    
    func sendEmail() {
        let subject = "Walut - Feature request"
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let url = URL(string: "mailto:marcin@bartminski.ga?subject=\(subjectEncoded)")
        
        if let url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("D:")
        }
    }
}

struct FeatureRoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FeatureRoadmapView()
        }
    }
}
