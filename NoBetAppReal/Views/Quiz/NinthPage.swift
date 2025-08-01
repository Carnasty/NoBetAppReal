//
//  NinthPage.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/29/25.
//

import SwiftUI

struct NinthPage: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var goToResultsPage = false
    @State private var isOptionSelected = false
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
                                    .frame(width: (UIScreen.main.bounds.width - 48) * 0.8, height: 8) // 80% of available width
                            }
                            .frame(maxWidth: UIScreen.main.bounds.width - 48) // Fixed container width
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer()
                        .frame(maxHeight: 32)
                    
                    // Question Content
                    VStack(spacing: 30) {
                        // Question Text
                        Text("Do you want a clear, personalized plan to quit gambling and take back control?")
                            .font(.custom("nunito-semibold", size: 24))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28)
                            .lineLimit(nil)
                            .minimumScaleFactor(0.8)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Single Answer Option
                        VStack(spacing: 16) {
                            AnswerOptionButton(
                                text: "Yes, I'm ready",
                                isSelected: isOptionSelected,
                                action: {
                                    isOptionSelected.toggle()
                                }
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer()
                    
                    // Next Button
                    VStack(spacing: 16) {
                        Button(action: {
                            // Calculate final score and navigate to results
                            let finalScore = viewModel.calculateScore()
                            print("🎯 Final Score: \(finalScore)%")
                            goToResultsPage = true
                        }) {
                            Text("Next")
                                .font(.custom("montserrat-semibold", size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(isOptionSelected ? Color("progressBar") : Color.gray)
                                .cornerRadius(25)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(!isOptionSelected)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                }
                
                // Navigation to UserInfoPage
                NavigationLink(destination: UserInfoPage(viewModel: viewModel).navigationBarHidden(true), isActive: $goToResultsPage) {
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
    NinthPage(viewModel: OnboardingViewModel())
} 
