//
//  QuizQuestionView.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/24/25.
//

import SwiftUI

struct QuizQuestionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let questionIndex: Int
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
            
            // Answer Options
            VStack(spacing: 16) {
                ForEach(0..<viewModel.questions[questionIndex].options.count, id: \.self) { index in
                    AnswerOptionButton(
                        text: viewModel.questions[questionIndex].options[index].text,
                        isSelected: viewModel.questions[questionIndex].options[index].isSelected
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            viewModel.toggleOption(questionIndex: questionIndex, optionIndex: index)
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
} 