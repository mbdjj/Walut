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
            .navigationTitle("settings_roadmap")
    }
}

struct FeatureRoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FeatureRoadmapView()
        }
    }
}
