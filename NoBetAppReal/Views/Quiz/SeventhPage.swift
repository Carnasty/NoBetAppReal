//
//  SeventhPage.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/24/25.
//

import SwiftUI

struct SeventhPage: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var goToEighthPage = false
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
                        
                        // Progress Bar
                        HStack {
                            ZStack(alignment: .leading) {
                                // Background track
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 8)
                                
                                // Progress fill (62.5% for step 4)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("progressBar"))
                                    .frame(width: (UIScreen.main.bounds.width - 48) * 0.625, height: 8)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer()
                        .frame(maxHeight: 32)
                    
                    // Question Content
                    VStack(spacing: 30) {
                        // Question Text
                        Text(viewModel.getSeventhPageQuestionText())
                            .font(.custom("nunito-semibold", size: 24))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28)
                            .lineLimit(nil)
                            .minimumScaleFactor(0.8)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Answer Options
                        VStack(spacing: 16) {
                            ForEach(0..<5, id: \.self) { index in
                                AnswerOptionButton(
                                    text: viewModel.getSeventhPageOptionText(for: index),
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
                    
                    Spacer()
                    
                    // Next Button
                    VStack(spacing: 16) {
                        Button(action: {
                            goToEighthPage = true
                        }) {
                            Text("Next")
                                .font(.custom("montserrat-semibold", size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(!viewModel.multipleSelections.isEmpty ? Color("progressBar") : Color("progressBar").opacity(0.5))
                                .cornerRadius(25)
                        }
                        .disabled(viewModel.multipleSelections.isEmpty)
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                }
                
                // Navigation to EighthPage
                NavigationLink(destination: EighthPage(viewModel: viewModel).navigationBarHidden(true), isActive: $goToEighthPage) {
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
    SeventhPage(viewModel: OnboardingViewModel())
} 