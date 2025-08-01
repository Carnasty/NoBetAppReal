//
//  OnboardingModels.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/29/25.
//

import Foundation

public struct AnswerOption: Identifiable {
    public let id: UUID
    public let text: String
    public let weight: Int
    public var isSelected: Bool
    
    public init(text: String, weight: Int, isSelected: Bool = false) {
        self.id = UUID()
        self.text = text
        self.weight = weight
        self.isSelected = isSelected
    }
}

public struct Question: Identifiable {
    public let id: UUID
    public let text: String
    public var options: [AnswerOption]
    
    public init(text: String, options: [AnswerOption]) {
        self.id = UUID()
        self.text = text
        self.options = options
    }
} 