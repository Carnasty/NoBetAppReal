//
//  FinalQuestionView.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/24/25.
//

import SwiftUI

struct FinalQuestionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let title: String
    @Binding var isOptionSelected: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            // Question Text
            Text(title)
                .font(.custom("nunito-semibold", size: 24))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 28)
                .lineLimit(nil)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Single Answer Option
            VStack(spacing: 16) {
                AnswerOptionButton(
                    text: "Yes, I'm ready",
                    isSelected: isOptionSelected
                ) {
                    isOptionSelected.toggle()
                }
            }
            .padding(.horizontal, 24)
        }
    }
} 