//
//  EighthPage.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/24/25.
//

import SwiftUI

struct EighthPage: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var goToNinthPage = false
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
                                
                                // Progress fill (75% for step 5)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("progressBar"))
                                    .frame(width: (UIScreen.main.bounds.width - 48) * 0.75, height: 8)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer()
                        .frame(maxHeight: 32)
                    
                    // Content Area
                    ScrollView {
                        VStack(spacing: 32) {
                            // Question Text
                            Text("What does a typical week look like for you?")
                                .font(.custom("nunito-semibold", size: 24))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 28)
                                .lineLimit(nil)
                                .minimumScaleFactor(0.8)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            // Slider Sections
                            VStack(spacing: 32) {
                                // Number of times gambling
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Number of times gambling?")
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
                                            Text(viewModel.timesGamblingDisplay)
                                                .font(.custom("montserrat-semibold", size: 18))
                                                .foregroundColor(.white)
                                                .frame(width: 60, height: 40)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(Color.gray.opacity(0.3))
                                                )
                                            
                                            Spacer()
                                        }
                                        
                                        Slider(value: $viewModel.timesGambling, in: 5...50, step: 5)
                                            .accentColor(Color("progressBar"))
                                }
                                
                                // Total money bet
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Total money bet?")
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
                                                Text(viewModel.moneyBetDisplay)
                                                    .font(.custom("montserrat-semibold", size: 18))
                                                    .foregroundColor(.white)
                                                    .frame(width: 80, height: 40)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .fill(Color.gray.opacity(0.3))
                                                    )
                                                
                                                Spacer()
                                            }
                                            
                                            Slider(value: $viewModel.totalMoneyBet, in: 0...5000, step: 100)
                                                .accentColor(Color("progressBar"))
                                }
                                
                                // Total money lost
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Total money lost?")
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
                                                Text(viewModel.moneyLostDisplay)
                                                    .font(.custom("montserrat-semibold", size: 18))
                                                    .foregroundColor(.white)
                                                    .frame(width: 80, height: 40)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .fill(Color.gray.opacity(0.3))
                                                    )
                                                
                                                Spacer()
                                            }
                                            
                                            Slider(value: $viewModel.totalMoneyLost, in: 0...5000, step: 100)
                                                .accentColor(Color("progressBar"))
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.vertical, 20)
                    }
                    
                    // Continue Button
                    VStack(spacing: 16) {
                        Button(action: {
                            goToNinthPage = true
                        }) {
                            Text("Continue")
                                .font(.custom("montserrat-semibold", size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color("progressBar"))
                                .cornerRadius(25)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                }
                
                // Navigation to NinthPage
                NavigationLink(destination: NinthPage(viewModel: viewModel).navigationBarHidden(true), isActive: $goToNinthPage) {
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
    EighthPage(viewModel: OnboardingViewModel())
} 
