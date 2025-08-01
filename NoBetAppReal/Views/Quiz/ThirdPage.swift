//
//  ThirdPage.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/24/25.
//

import SwiftUI

struct ThirdPage: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var goToFourthPage = false
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
                                    .frame(width: (UIScreen.main.bounds.width - 48) * 0.125, height: 8) // 12.5% of available width
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer()
                        .frame(maxHeight: 32)
                    
                    // Question Content
                    if !viewModel.questions.isEmpty && viewModel.currentQuestionIndex < viewModel.questions.count {
                        let currentQuestion = viewModel.questions[viewModel.currentQuestionIndex]
                        
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
                                            questionIndex: viewModel.currentQuestionIndex,
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
                            goToFourthPage = true
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
                
                // Navigation to FourthPage
                NavigationLink(destination: FourthPage(viewModel: viewModel).navigationBarHidden(true), isActive: $goToFourthPage) {
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

// MARK: - Answer Option Button
struct AnswerOptionButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(Color("progressBar"))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                
                Text(text)
                    .font(.custom("montserrat-regular", size: 16))
                    .foregroundColor(.white)
                    .opacity(isSelected ? 1 : 0.6)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.white.opacity(0.3) : Color.white.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? Color("progressBar").opacity(0.8) : Color.white.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    ThirdPage(viewModel: OnboardingViewModel())
}
