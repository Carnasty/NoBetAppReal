//
//  RecoveryViewModel.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 8/4/25.
//

import SwiftUI
import Foundation

class RecoveryViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentProgress: Double = 0.0 // 0.0 to 1.0 (0% to 100%)
    @Published var currentDay: Int = 0
    @Published var chartData: [ChartDataPoint] = []
    
    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    private let totalDays = 90
    private let progressPerDay = 1.0 / 90.0 // 100% / 90 days = 1.111...% per day
    
    // MARK: - Keys for UserDefaults
    private let currentProgressKey = "recoveryCurrentProgress"
    private let currentDayKey = "recoveryCurrentDay"
    private let chartDataKey = "recoveryChartData"
    private let lastUpdateDateKey = "recoveryLastUpdateDate"
    
    // MARK: - Initialization
    init() {
        loadRecoveryData()
        updateProgress()
        generateChartData()
    }
    
    // MARK: - Public Methods
    
    /// Call this when user completes a day without gambling
    func completeDay() {
        let today = Date()
        let calendar = Calendar.current
        
        // Check if we already updated today
        if let lastUpdate = lastUpdateDate {
            if calendar.isDate(lastUpdate, inSameDayAs: today) {
                return // Already updated today
            }
        }
        
        // Increment progress
        currentDay += 1
        currentProgress = Double(currentDay) * progressPerDay
        currentProgress = min(1.0, currentProgress) // Cap at 100%
        
        // Update last update date
        lastUpdateDate = today
        
        // Generate new chart data
        generateChartData()
        
        // Save data
        saveRecoveryData()
    }
    
    /// Reset progress (for relapse)
    func resetProgress() {
        currentDay = 0
        currentProgress = 0.0
        lastUpdateDate = nil
        generateChartData()
        saveRecoveryData()
    }
    
    /// Get progress as percentage string
    var progressPercentage: String {
        return "\(Int(currentProgress * 100))%"
    }
    
    /// Get current day as string
    var currentDayString: String {
        return "Day \(currentDay)"
    }
    
    /// Get remaining days
    var remainingDays: Int {
        return max(0, totalDays - currentDay)
    }
    
    /// Get completion date estimate
    var estimatedCompletionDate: Date? {
        guard currentDay > 0 else { return nil }
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: remainingDays, to: Date())
    }
    
    /// Get motivational message based on progress
    var motivationalMessage: String {
        switch currentProgress {
        case 0.0:
            return "Start your journey today!"
        case 0.0..<0.1:
            return "Great start! Keep going strong."
        case 0.1..<0.25:
            return "You're building momentum!"
        case 0.25..<0.5:
            return "Quarter way there! You're doing amazing."
        case 0.5..<0.75:
            return "Halfway there! The changes are becoming noticeable."
        case 0.75..<1.0:
            return "Almost there! You're transforming your life."
        default:
            return "Incredible! You've completed the program!"
        }
    }
    
    // MARK: - Private Properties
    
    private var lastUpdateDate: Date? {
        get {
            return userDefaults.object(forKey: lastUpdateDateKey) as? Date
        }
        set {
            userDefaults.set(newValue, forKey: lastUpdateDateKey)
        }
    }
    
    // MARK: - Private Methods
    
    private func updateProgress() {
        // Check if we need to update progress based on streak
        // This could be connected to the main streak system
        let calendar = Calendar.current
        let today = Date()
        
        if let lastUpdate = lastUpdateDate {
            let daysSinceLastUpdate = calendar.dateComponents([.day], from: lastUpdate, to: today).day ?? 0
            
            if daysSinceLastUpdate > 0 {
                // User has been away, we could add logic here
                // For now, we'll just use the saved progress
            }
        }
    }
    
    private func generateChartData() {
        chartData = []
        
        // Generate 12 months of data (Jan to Dec)
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                     "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        for (index, month) in months.enumerated() {
            // Calculate progress for each month
            let monthProgress = min(1.0, Double(index + 1) * (currentProgress / 12.0))
            let percentage = Int(monthProgress * 100)
            
            chartData.append(ChartDataPoint(
                month: month,
                percentage: percentage,
                isCurrentMonth: index == Calendar.current.component(.month, from: Date()) - 1
            ))
        }
    }
    
    private func saveRecoveryData() {
        userDefaults.set(currentProgress, forKey: currentProgressKey)
        userDefaults.set(currentDay, forKey: currentDayKey)
        
        // Save chart data as JSON
        if let chartDataJSON = try? JSONEncoder().encode(chartData) {
            userDefaults.set(chartDataJSON, forKey: chartDataKey)
        }
    }
    
    private func loadRecoveryData() {
        currentProgress = userDefaults.double(forKey: currentProgressKey)
        currentDay = userDefaults.integer(forKey: currentDayKey)
        
        // Load chart data from JSON
        if let chartDataJSON = userDefaults.data(forKey: chartDataKey),
           let loadedChartData = try? JSONDecoder().decode([ChartDataPoint].self, from: chartDataJSON) {
            chartData = loadedChartData
        }
    }
}

// MARK: - Chart Data Model
struct ChartDataPoint: Codable, Identifiable {
    let id = UUID()
    let month: String
    let percentage: Int
    let isCurrentMonth: Bool
} 