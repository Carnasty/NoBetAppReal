//
//  SliderView.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/24/25.
//

import SwiftUI

struct SliderView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let title: String
    
    var body: some View {
        VStack(spacing: 30) {
            // Question Text
            Text(title)
                .font(.custom("nunito-semibold", size: 24))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 28)
                .lineLimit(nil)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Slider Sections
            VStack(spacing: 32) {
                // Number of times gambling
                SliderSection(
                    title: "Number of times gambling?",
                    value: $viewModel.timesGambling,
                    range: 5...50,
                    step: 5,
                    displayValue: viewModel.timesGamblingDisplay
                )
                
                // Total money bet
                SliderSection(
                    title: "Total money bet?",
                    value: $viewModel.totalMoneyBet,
                    range: 0...5000,
                    step: 1,
                    displayValue: viewModel.moneyBetDisplay,
                    customSteps: viewModel.moneyBetSteps
                )
                
                // Total money lost
                SliderSection(
                    title: "Total money lost?",
                    value: $viewModel.totalMoneyLost,
                    range: 0...5000,
                    step: 1,
                    displayValue: viewModel.moneyLostDisplay,
                    customSteps: viewModel.moneyLostSteps
                )
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Slider Section
struct SliderSection: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let displayValue: String
    let customSteps: [Double]?
    
    init(title: String, value: Binding<Double>, range: ClosedRange<Double>, step: Double, displayValue: String, customSteps: [Double]? = nil) {
        self.title = title
        self._value = value
        self.range = range
        self.step = step
        self.displayValue = displayValue
        self.customSteps = customSteps
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.custom("montserrat-regular", size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("Per week") {
                    // Time period button
                }
                .font(.custom("montserrat-regular", size: 14))
                .foregroundColor(Color("progressBar"))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("progressBar"), lineWidth: 1)
                )
            }
            
            HStack {
                Text(displayValue)
                    .font(.custom("montserrat-semibold", size: 18))
                    .foregroundColor(.white)
                    .frame(width: 80, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.3))
                    )
                
                Spacer()
            }
            
            if let customSteps = customSteps {
                // Custom slider with specific steps
                Slider(value: $value, in: range, step: 1)
                    .accentColor(Color("progressBar"))
                    .onChange(of: value) { _, newValue in
                        // Snap to nearest custom step
                        let nearestStep = customSteps.min(by: { abs($0 - newValue) < abs($1 - newValue) }) ?? newValue
                        // Always snap to the nearest step
                        value = nearestStep
                    }
            } else {
                // Standard slider
                Slider(value: $value, in: range, step: step)
                    .accentColor(Color("progressBar"))
            }
        }
    }
} 