//
//  SettingsViewModel.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 8/4/25.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var twoFactorEnabled = true
    @Published var showingSaveConfirmation = false
    
    init() {
        loadSettings()
    }
    
    // MARK: - Settings Management Functions
    
    func loadSettings() {
        // Load saved settings from UserDefaults
        twoFactorEnabled = UserDefaults.standard.bool(forKey: "two_factor_enabled")
    }
    
    func saveSettings() {
        // Save settings to persistent storage
        UserDefaults.standard.set(twoFactorEnabled, forKey: "two_factor_enabled")
        
        // Show confirmation
        showingSaveConfirmation = true
        
        print("Settings saved: Two-Factor Authentication: \(twoFactorEnabled)")
    }
    
    func toggleTwoFactor() {
        twoFactorEnabled.toggle()
    }
} 