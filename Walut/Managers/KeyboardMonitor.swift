//
//  KeyboardMonitor.swift
//  Walut
//
//  Created by Marcin Bartminski on 13/03/2026.
//

import SwiftUI
import GameController

@Observable class KeyboardMonitor {
    var isConnected = false
    
    init() {
        checkKeyboard()
        
        NotificationCenter.default.addObserver(
            forName: .GCKeyboardDidConnect,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.isConnected = true
        }
        NotificationCenter.default.addObserver(
            forName: .GCKeyboardDidDisconnect,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.isConnected = false
        }
    }
    
    private func checkKeyboard() {
        self.isConnected = GCKeyboard.coalesced != nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
