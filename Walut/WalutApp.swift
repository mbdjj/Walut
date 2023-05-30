//
//  WalutApp.swift
//  Walut
//
//  Created by Marcin Bartminski on 07/10/2022.
//

import SwiftUI

@main
struct WalutApp: App {
    @StateObject var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            ViewManagingView()
                .environmentObject(networkMonitor)
        }
    }
}
