//
//  OnboardingViewModel.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/29/25.
//

import Foundation
import SwiftUI

public class OnboardingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var answers: [Int] = Array(repeating: -1, count: 5)
    @Published var multipleSelections: Set<Int> = []
    
    // MARK: - Slider Data
    @Published var timesGambling: Double = 5
    @Published var totalMoneyBet: Double = 100
    @Published var totalMoneyLost: Double = 100
    
    // MARK: - Error Handling
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    public init() {
        loadQuestions()
    }
    
    private func loadQuestions() {
        questions = [
            Question(
                text: "Why do you want to stop gambling?",
                options: [
                    AnswerOption(text: "I'm losing too much money", weight: 20),
                    AnswerOption(text: "It's affecting my relationships", weight: 20),
                    AnswerOption(text: "I don't feel in control", weight: 20),
                    AnswerOption(text: "It's hurting my mental health", weight: 20),
                    AnswerOption(text: "I just want to take a break", weight: 10)
                ]
            ),
            Question(
                text: "How does gambling make you feel after?",
                options: [
                    AnswerOption(text: "Regretful", weight: 25),
                    AnswerOption(text: "Anxious", weight: 25),
                    AnswerOption(text: "Numb", weight: 20),
                    AnswerOption(text: "Like I want more", weight: 20),
                    AnswerOption(text: "I feel fine afterward", weight: 10)
                ]
            ),
            Question(
                text: "What have you sacrificed because of gambling?",
                options: [
                    AnswerOption(text: "Time with loved ones", weight: 25),
                    AnswerOption(text: "Sleep or energy", weight: 25),
                    AnswerOption(text: "Career progress", weight: 20),
                    AnswerOption(text: "Financial stability", weight: 30)
                ]
            ),
            Question(
                text: "What kind of person do you want to become?",
                options: [
                    AnswerOption(text: "Someone in control", weight: 20),
                    AnswerOption(text: "Someone free from addiction", weight: 30),
                    AnswerOption(text: "Someone who saves and builds", weight: 25),
                    AnswerOption(text: "Someone I can be proud of", weight: 30),
                    AnswerOption(text: "I'm still figuring it out", weight: 15)
                ]
            )
        ]
    }
    
    public func toggleOption(questionIndex: Int, optionIndex: Int) {
        guard questionIndex < questions.count,
              optionIndex < questions[questionIndex].options.count else { return }
        
        // Create a new array to ensure SwiftUI detects the change
        var updatedQuestions = questions
        
        // Toggle the selected option (allow multiple selections)
        updatedQuestions[questionIndex].options[optionIndex].isSelected.toggle()
        
        questions = updatedQuestions
        
        // Update answers array to track selected options
        let selectedOptions = updatedQuestions[questionIndex].options.enumerated()
            .filter { $0.element.isSelected }
            .map { $0.offset }
        
        if selectedOptions.isEmpty {
            answers[questionIndex] = -1
        } else if selectedOptions.count == 1 {
            answers[questionIndex] = selectedOptions.first!
        } else {
            answers[questionIndex] = -2 // Multiple selections
        }
    }
    
    public func calculateScore() -> Double {
        let totalWeight = questions.flatMap { $0.options }
            .filter { $0.isSelected }
            .reduce(0) { $0 + $1.weight }
        
        // Inflate score by 20%
        var inflatedScore = Double(totalWeight) * 1.2
        
        // Apply minimum of 15% and maximum of 92%
        inflatedScore = max(15.0, min(92.0, inflatedScore))
        
        return inflatedScore
    }
    
    public func getProgressPercentage() -> Double {
        guard !questions.isEmpty else { return 0.0 }
        return Double(currentQuestionIndex + 1) / Double(questions.count) * 100.0
    }
    
    public func canProceedToNext() -> Bool {
        guard currentQuestionIndex < questions.count else { return false }
        return questions[currentQuestionIndex].options.contains { $0.isSelected }
    }
    
    public func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        }
    }
    
    public func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
    
    public func selectAnswer(for questionIndex: Int, answer: Int) {
        do {
            guard questionIndex >= 0 && questionIndex < answers.count else {
                throw OnboardingError.invalidQuestionIndex(questionIndex)
            }
            
            guard answer >= 0 && answer <= 4 else {
                throw OnboardingError.invalidAnswerIndex(answer)
            }
            
            // Special handling for question 4 (7th page) - multiple selection
            if questionIndex == 4 {
                handleMultipleSelection(answer: answer)
            } else {
                // Single selection for other questions
                answers[questionIndex] = answer
            }
        } catch {
            handleError(error)
        }
    }
    
    private func handleMultipleSelection(answer: Int) {
        if answer == 4 { // "All of the above" selected
            // If "All of the above" is selected, clear all other selections
            multipleSelections.removeAll()
            multipleSelections.insert(4)
            answers[4] = 4
        } else {
            // If "All of the above" was previously selected, clear it
            if multipleSelections.contains(4) {
                multipleSelections.remove(4)
            }
            
            // Toggle the specific selection
            if multipleSelections.contains(answer) {
                multipleSelections.remove(answer)
            } else {
                multipleSelections.insert(answer)
            }
            
            // Update the answer based on selections
            if multipleSelections.isEmpty {
                answers[4] = -1
            } else if multipleSelections.count == 1 {
                answers[4] = multipleSelections.first!
            } else {
                answers[4] = 4 // Multiple selections = "All of the above"
            }
        }
    }
    
    // MARK: - Slider Computed Properties
    public var timesGamblingDisplay: String {
        let value = Int(timesGambling)
        if value >= 50 {
            return "50+"
        } else {
            return "\(value)+"
        }
    }
    
    public var moneyBetSteps: [Double] {
        // Steps: 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000
        return [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]
    }
    
    public var moneyLostSteps: [Double] {
        // Steps: 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000
        return [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]
    }
    
    public var moneyBetDisplay: String {
        if totalMoneyBet >= 5000 {
            return "$5,000+"
        } else {
            // Find the nearest step and format with +
            let nearestStep = moneyBetSteps.min(by: { abs($0 - totalMoneyBet) < abs($1 - totalMoneyBet) }) ?? totalMoneyBet
            return "$\(Int(nearestStep))+"
        }
    }
    
    public var moneyLostDisplay: String {
        if totalMoneyLost >= 5000 {
            return "$5,000+"
        } else {
            // Find the nearest step and format with +
            let nearestStep = moneyLostSteps.min(by: { abs($0 - totalMoneyLost) < abs($1 - totalMoneyLost) }) ?? totalMoneyLost
            return "$\(Int(nearestStep))+"
        }
    }
    
    // MARK: - Question Data
    public func getSeventhPageQuestionText() -> String {
        return "When are you most tempted to gamble?"
    }
    
    public func getSeventhPageOptionText(for index: Int) -> String {
        switch index {
        case 0: return "When I'm bored"
        case 1: return "After I get paid"
        case 2: return "When I feel stressed"
        case 3: return "When I'm alone"
        case 4: return "All of the above"
        default: return ""
        }
    }
    
    public func saveSliderValues(timesGambling: Double, totalMoneyBet: Double, totalMoneyLost: Double) {
        do {
            guard timesGambling >= 0 else {
                throw OnboardingError.invalidSliderValue("timesGambling", Int(timesGambling))
            }
            
            guard totalMoneyBet >= 0 else {
                throw OnboardingError.invalidSliderValue("totalMoneyBet", Int(totalMoneyBet))
            }
            
            guard totalMoneyLost >= 0 else {
                throw OnboardingError.invalidSliderValue("totalMoneyLost", Int(totalMoneyLost))
            }
            
            self.timesGambling = timesGambling
            self.totalMoneyBet = totalMoneyBet
            self.totalMoneyLost = totalMoneyLost
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Error Handling
    private func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
    
    public func clearError() {
        errorMessage = nil
        showError = false
    }
    
    // MARK: - User Info Validation
    @Published var userName: String = ""
    @Published var userAge: String = ""
    
    public func isUserInfoValid() -> Bool {
        guard !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        
        guard let ageInt = Int(userAge.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return false
        }
        
        return ageInt >= 18
    }
    

}

// MARK: - Custom Errors
public enum OnboardingError: LocalizedError {
    case invalidQuestionIndex(Int)
    case invalidAnswerIndex(Int)
    case invalidSliderValue(String, Int)
    
    public var errorDescription: String? {
        switch self {
        case .invalidQuestionIndex(let index):
            return "Invalid question index: \(index)"
        case .invalidAnswerIndex(let index):
            return "Invalid answer index: \(index)"
        case .invalidSliderValue(let field, let value):
            return "Invalid \(field) value: \(value)"
        }
    }
}
