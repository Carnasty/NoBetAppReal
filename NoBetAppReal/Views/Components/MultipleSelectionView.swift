//
//  MultipleSelectionView.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/24/25.
//

import SwiftUI

struct MultipleSelectionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let title: String
    
    private var options: [String] {
        return ["When I'm bored", "After I get paid", "When I feel stressed", "When I'm alone", "All of the above"]
    }
    
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
                ForEach(0..<5, id: \.self) { index in
                    AnswerOptionButton(
                        text: options[index],
                        isSelected: viewModel.multipleSelections.contains(index)
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            viewModel.selectAnswer(for: 4, answer: index)
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
} 