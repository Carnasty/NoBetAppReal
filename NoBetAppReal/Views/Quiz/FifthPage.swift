//
//  FifthPage.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/29/25.
//

import SwiftUI

struct FifthPage: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var goToSixthPage = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color("mainGradiant"), location: 0.0),
                        .init(color: Color("mainGradiant"), location: 0.4),
                        .init(color: Color("secondaryGradiant"), location: 0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with Back Button and Progress Bar
                    VStack(spacing: 30) {
                        // Back Button and Progress Bar Row
                        HStack {
                            // Back Button
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                        
                        // Progress Bar (separate row for better control)
                        HStack {
                            ZStack(alignment: .leading) {
                                // Background track
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 8)
                                
                                // Progress fill
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("progressBar"))
                                    .frame(width: (UIScreen.main.bounds.width - 48) * 0.375, height: 8) // 37.5% of available width
                            }
                            .frame(maxWidth: UIScreen.main.bounds.width - 48) // Fixed container width
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer()
                        .frame(maxHeight: 32)
                    
                    // Question Content
                    if !viewModel.questions.isEmpty && viewModel.currentQuestionIndex < viewModel.questions.count {
                        let currentQuestion = viewModel.questions[2] // Use third question
                        
                        VStack(spacing: 30) {
                            // Question Text
                            Text(currentQuestion.text)
                                .font(.custom("nunito-semibold", size: 24))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 28)
                                .lineLimit(nil)
                                .minimumScaleFactor(0.8)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            // Answer Options
                            VStack(spacing: 16) {
                                ForEach(Array(currentQuestion.options.enumerated()), id: \.element.id) { index, option in
                                    AnswerOptionButton(
                                        text: option.text,
                                        isSelected: option.isSelected
                                    ) {
                                        viewModel.toggleOption(
                                            questionIndex: 2,
                                            optionIndex: index
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    
                    Spacer()
                    
                    // Next Button
                    VStack(spacing: 16) {
                        Button(action: {
                            // Calculate final score and navigate to results
                            let finalScore = viewModel.calculateScore()
                            print("🎯 Final Score: \(finalScore)%")
                            goToSixthPage = true
                        }) {
                            Text("Next")
                                .font(.custom("montserrat-semibold", size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(viewModel.canProceedToNext() ? Color("progressBar") : Color("progressBar").opacity(0.5))
                                .cornerRadius(25)
                        }
                        .disabled(!viewModel.canProceedToNext())
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                }
                
                // Navigation to SixthPage
                NavigationLink(destination: SixthPage(viewModel: viewModel).navigationBarHidden(true), isActive: $goToSixthPage) {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred")
        }
    }
}

#Preview {
    FifthPage(viewModel: OnboardingViewModel())
} 