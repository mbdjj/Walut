//
//  WalutApp.swift
//  WatchWalut WatchKit Extension
//
//  Created by Marcin Bartminski on 17/05/2022.
//

import SwiftUI

@main
struct WalutApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView()
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
