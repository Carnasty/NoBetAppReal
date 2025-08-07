//
//  HomeViewModel.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 8/4/25.
//

import SwiftUI
import Foundation

class HomeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentStreak: Int = 0
    @Published var currentCoin: String = "starter" // Default starter coin
    @Published var timeElapsed: String = "0m - 0s"
    @Published var brainRewiringProgress: Double = 0.0 // 0% default
    @Published var selectedTab: Int = 0
    
    // MARK: - Private Properties
    private var streakStartDate: Date?
    private var lastRelapseDate: Date?
    private var timer: Timer?
    
    // MARK: - Coin Milestones
    private let coinMilestones: [Int: String] = [
        0: "starter",
        3: "bronze",
        7: "silver", 
        10: "gold",
        14: "quartz",
        21: "obsidian",
        30: "platinum",
        45: "ruby",
        60: "sapphire",
        80: "emerald",
        90: "legendary"
    ]
    
    // MARK: - Initialization
    init() {
        loadUserData()
        startTimer()
        updateStreak()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Streak Management
    func startNewStreak() {
        streakStartDate = Date()
        lastRelapseDate = nil
        currentStreak = 0
        currentCoin = "starter"
        brainRewiringProgress = 0.0 // Reset brain rewiring progress to 0
        saveUserData()
        updateStreak()
    }
    
    func handleRelapse() {
        lastRelapseDate = Date()
        currentStreak = 0
        currentCoin = "starter"
        brainRewiringProgress = 0.0 // Reset brain rewiring progress to 0
        saveUserData()
        updateStreak()
    }
    
    func editStreak(to days: Int) {
        currentStreak = days
        updateCoinForStreak()
        updateBrainRewiringProgress()
        saveUserData()
    }
    
    private func updateStreak() {
        let calendar = Calendar.current
        let now = Date()
        
        // If no streak start date, initialize with current date
        if streakStartDate == nil {
            streakStartDate = now
            saveUserData()
        }
        
        guard let startDate = streakStartDate else { return }
        
        // Calculate days since streak started
        let components = calendar.dateComponents([.day], from: startDate, to: now)
        let daysSinceStart = components.day ?? 0
        
        // If there's a relapse date, calculate from relapse
        if let relapseDate = lastRelapseDate {
            let relapseComponents = calendar.dateComponents([.day], from: relapseDate, to: now)
            let daysSinceRelapse = relapseComponents.day ?? 0
            currentStreak = max(0, daysSinceRelapse)
        } else {
            currentStreak = max(0, daysSinceStart)
        }
        
        updateCoinForStreak()
        updateBrainRewiringProgress()
        updateTimeElapsed()
    }
    
    private func updateCoinForStreak() {
        // Find the highest milestone achieved
        var highestMilestone = 0
        for milestone in coinMilestones.keys.sorted() {
            if currentStreak >= milestone {
                highestMilestone = milestone
            } else {
                break
            }
        }
        
        if highestMilestone > 0 {
            currentCoin = coinMilestones[highestMilestone] ?? "starter"
        } else {
            currentCoin = "starter" // Default starter coin
        }
    }
    
    // MARK: - Time Management
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimeElapsed()
        }
    }
    
    private func updateTimeElapsed() {
        let now = Date()
        let calendar = Calendar.current
        
        // Calculate time since start of current day
        let startOfDay = calendar.startOfDay(for: now)
        let timeSinceStartOfDay = now.timeIntervalSince(startOfDay)
        
        let minutes = Int(timeSinceStartOfDay) / 60
        let seconds = Int(timeSinceStartOfDay) % 60
        
        timeElapsed = "\(minutes)m - \(seconds)s"
    }
    
    // MARK: - Navigation Actions
    func navigateToStreakPage() {
        // TODO: Implement navigation to Streak Page
        print("Navigate to Streak Page")
    }
    
    func navigateToAchievementsPage() {
        // TODO: Implement navigation to Achievements Page
        print("Navigate to Achievements Page")
    }
    
    func navigateToEditStreakPage() {
        // TODO: Implement navigation to Edit Streak Page
        print("Navigate to Edit Streak Page")
    }
    
    func navigateToPledgePage() {
        // TODO: Implement navigation to Pledge Page
        print("Navigate to Pledge Page")
    }
    
    func navigateToRecoveryPage() {
        // TODO: Implement navigation to Recovery Page
        print("Navigate to Recovery Page")
    }
    
    func navigateToPanicPage() {
        // TODO: Implement navigation to Panic Page
        print("Navigate to Panic Page")
    }
    
    func navigateToProfilePage() {
        // TODO: Implement navigation to Profile Page
        print("Navigate to Profile Page")
    }
    
    // MARK: - Tab Selection
    func selectTab(_ tabIndex: Int) {
        selectedTab = tabIndex
    }
    
    // MARK: - Data Persistence
    private func saveUserData() {
        let defaults = UserDefaults.standard
        defaults.set(streakStartDate, forKey: "streakStartDate")
        defaults.set(lastRelapseDate, forKey: "lastRelapseDate")
        defaults.set(currentStreak, forKey: "currentStreak")
        defaults.set(currentCoin, forKey: "currentCoin")
    }
    
    private func loadUserData() {
        let defaults = UserDefaults.standard
        streakStartDate = defaults.object(forKey: "streakStartDate") as? Date
        lastRelapseDate = defaults.object(forKey: "lastRelapseDate") as? Date
        currentStreak = defaults.integer(forKey: "currentStreak")
        currentCoin = defaults.string(forKey: "currentCoin") ?? "starter"
    }
    
    // MARK: - Computed Properties
    var isHomeSelected: Bool {
        selectedTab == 0
    }
    
    var isRecoverySelected: Bool {
        selectedTab == 1
    }
    
    var isPledgeSelected: Bool {
        selectedTab == 2
    }
    
    var isUserSelected: Bool {
        selectedTab == 3
    }
    
    // MARK: - Brain Rewiring Progress
    private func updateBrainRewiringProgress() {
        // 90-day program: 100% / 90 days = 1.111...% per day
        let progressPerDay = 1.0 / 90.0
        brainRewiringProgress = Double(currentStreak) * progressPerDay
        brainRewiringProgress = max(0.0, min(1.0, brainRewiringProgress)) // Clamp between 0-100%
    }
    
    func updateBrainRewiringProgress(_ progress: Double) {
        brainRewiringProgress = max(0.0, min(1.0, progress))
    }
} 