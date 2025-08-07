//
//  StreakViewModel.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 8/4/25.
//

import SwiftUI
import Foundation

class StreakViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentStreak: Int = 0
    @Published var lastLoginDate: Date?
    @Published var streakStartDate: Date?
    
    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Keys for UserDefaults
    private let currentStreakKey = "streakCurrentStreak"
    private let lastLoginDateKey = "streakLastLoginDate"
    private let streakStartDateKey = "streakStartDate"
    
    // MARK: - Initialization
    init() {
        loadStreakData()
        checkAndUpdateStreak()
    }
    
    // MARK: - Public Methods
    
    /// Call this when user logs into the app
    func userLoggedIn() {
        let today = Date()
        let calendar = Calendar.current
        
        // Check if this is the first login
        if lastLoginDate == nil {
            // First time user
            streakStartDate = today
            lastLoginDate = today
            currentStreak = 1
            saveStreakData()
            return
        }
        
        // Check if user already logged in today
        if let lastLogin = lastLoginDate,
           calendar.isDate(lastLogin, inSameDayAs: today) {
            // Already logged in today, don't increment
            return
        }
        
        // Check if user logged in yesterday (consecutive day)
        if let lastLogin = lastLoginDate,
           calendar.isDate(lastLogin, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: today) ?? today) {
            // Consecutive day - increment streak
            currentStreak += 1
        } else {
            // Gap in login - reset streak
            currentStreak = 1
            streakStartDate = today
        }
        
        lastLoginDate = today
        saveStreakData()
    }
    
    /// Call this when user relapses
    func handleRelapse() {
        currentStreak = 0
        lastLoginDate = nil
        streakStartDate = nil
        saveStreakData()
    }
    
    /// Manually set streak (for testing or admin purposes)
    func setStreak(_ days: Int) {
        currentStreak = max(0, days)
        if days > 0 {
            streakStartDate = Date()
            lastLoginDate = Date()
        } else {
            streakStartDate = nil
            lastLoginDate = nil
        }
        saveStreakData()
    }
    
    /// Get streak start date as string
    var streakStartDateString: String {
        guard let startDate = streakStartDate else { return "Not started" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: startDate)
    }
    
    /// Get last login date as string
    var lastLoginDateString: String {
        guard let loginDate = lastLoginDate else { return "Never" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: loginDate)
    }
    
    /// Check if user has logged in today
    var hasLoggedInToday: Bool {
        guard let lastLogin = lastLoginDate else { return false }
        return Calendar.current.isDateInToday(lastLogin)
    }
    
    /// Get days since last login
    var daysSinceLastLogin: Int {
        guard let lastLogin = lastLoginDate else { return 0 }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: lastLogin, to: Date())
        return components.day ?? 0
    }
    
    // MARK: - Private Methods
    
    private func checkAndUpdateStreak() {
        // Check if user should be logged in today
        if !hasLoggedInToday {
            // User hasn't logged in today, check if they should
            // This could trigger a notification or reminder
        }
    }
    
    private func saveStreakData() {
        userDefaults.set(currentStreak, forKey: currentStreakKey)
        userDefaults.set(lastLoginDate, forKey: lastLoginDateKey)
        userDefaults.set(streakStartDate, forKey: streakStartDateKey)
    }
    
    private func loadStreakData() {
        currentStreak = userDefaults.integer(forKey: currentStreakKey)
        lastLoginDate = userDefaults.object(forKey: lastLoginDateKey) as? Date
        streakStartDate = userDefaults.object(forKey: streakStartDateKey) as? Date
    }
    
    // MARK: - Computed Properties
    
    /// Get motivational message based on streak
    var motivationalMessage: String {
        switch currentStreak {
        case 0:
            return "Start your journey today!"
        case 1:
            return "Great start! Keep it going!"
        case 2...6:
            return "You're building momentum!"
        case 7...13:
            return "A week strong! You're doing amazing!"
        case 14...20:
            return "Two weeks! The changes are becoming noticeable."
        case 21...29:
            return "Three weeks! You're not just breaking a habit; you're building a new identity."
        case 30...59:
            return "A month strong! You're transforming your life."
        case 60...89:
            return "Two months! You're an inspiration."
        default:
            return "Incredible! You're a true champion of change."
        }
    }
    
    /// Get streak milestone
    var streakMilestone: String {
        switch currentStreak {
        case 0:
            return "Begin"
        case 1:
            return "First Day"
        case 7:
            return "Week 1"
        case 14:
            return "Week 2"
        case 21:
            return "Week 3"
        case 30:
            return "Month 1"
        case 60:
            return "Month 2"
        case 90:
            return "Month 3"
        case 180:
            return "Month 6"
        case 365:
            return "Year 1"
        default:
            return "Day \(currentStreak)"
        }
    }
} 