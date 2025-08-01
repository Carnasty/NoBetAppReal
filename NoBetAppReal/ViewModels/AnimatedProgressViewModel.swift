//
//  AnimatedProgressViewModel.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/29/25.
//

import Foundation
import SwiftUI
import Combine

public class AnimatedProgressViewModel: ObservableObject {
    @Published var progress: Double = 2.0
    @Published var isAnimating = false
    @Published var goToResultsPage = false
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    public func startProgressAnimation() {
        isAnimating = true
        
        // Start at 2% and animate to 100% over 12 seconds
        let totalDuration: TimeInterval = 12.0
        let startProgress: Double = 2.0
        let endProgress: Double = 100.0
        let progressRange = endProgress - startProgress
        
        // Update every 0.05 seconds for ultra-smooth animation
        let updateInterval: TimeInterval = 0.05
        let totalUpdates = totalDuration / updateInterval
        let progressIncrement = progressRange / totalUpdates
        
        var currentUpdate = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            currentUpdate += 1
            
            if currentUpdate <= Int(totalUpdates) {
                DispatchQueue.main.async {
                    self.progress = startProgress + (Double(currentUpdate) * progressIncrement)
                }
            } else {
                // Animation complete
                self.timer?.invalidate()
                self.timer = nil
                
                // Navigate to results after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.goToResultsPage = true
                }
            }
        }
    }
    
    public func stopAnimation() {
        timer?.invalidate()
        timer = nil
        isAnimating = false
    }
    
    deinit {
        stopAnimation()
    }
} 