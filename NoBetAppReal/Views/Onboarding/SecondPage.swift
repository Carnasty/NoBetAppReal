//
//  SecondPage.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/24/25.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct SecondPage: View {
    @StateObject private var authVM = AuthViewModel()
    @State private var goToThirdPage = false

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
                    // Title
                    Text("BETFREE")
                        .font(.custom("nunito-bold", size: 30))
                        .foregroundColor(.betFree)
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    // Mascot
                    Image("icon1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    
                    Spacer()
                    
                    // Headline
                    VStack(spacing: 4) {
                        HStack(spacing: 0) {
                            Text("No more ")
                                .font(.custom("nunito-bold", size: 24))
                                .foregroundColor(.white)
                            Text("BETS")
                                .font(.custom("nunito-bold", size: 30))
                                .foregroundColor(Color("niceGreen"))
                        }
                        
                        HStack(spacing: 0) {
                            Text("No more ")
                                .font(.custom("nunito-bold", size: 24))
                                .foregroundColor(.white)
                            Text("REGRETS")
                                .font(.custom("nunito-bold", size: 30))
                                .foregroundColor(Color("niceGreen"))
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Subtitle
                    Text("Join over 400,000 people to become bet free and regain control of their lives")
                        .font(.custom("montserrat-regular", size: 16))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .lineLimit(nil)
                    
                    Spacer()
                    
                    // Buttons
                    VStack(spacing: 12) {
                        googleSignInButton
                        appleSignInButton
                        
                        HStack {
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 1)
                            Text("OR")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.custom("montserrat-regular", size: 14))
                                .padding(.horizontal, 16)
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 8)
                        
                        // Continue Button
                        Button(action: {
                            goToThirdPage = true
                        }) {
                            Text("Skip For Now")
                                .font(.custom("montserrat-semibold", size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color("buttonColor"))
                                .cornerRadius(25)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Sign up text
                   
                    .padding(.top, 16)
                    .padding(.bottom, 50)
                }

                // Navigation to QuizContainerView
                NavigationLink("", destination: QuizContainerView(viewModel: OnboardingViewModel()).navigationBarHidden(true), isActive: $goToThirdPage)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private var googleSignInButton: some View {
        Button(action: {
            authVM.signInWithGoogle { success in
                if success {
                    goToThirdPage = true
                }
            }
        }) {
            HStack(spacing: 12) {
                Image("Google")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                
                Text("Continue with Google")
                    .font(.custom("montserrat-regular", size: 16))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, maxHeight: 54)
            .background(Color.white)
            .cornerRadius(27)
        }
    }
    
    private var appleSignInButton: some View {
        Button(action: {
            authVM.signInWithApple { success in
                if success {
                    goToThirdPage = true
                }
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "applelogo")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                
                Text("Continue with Apple")
                    .font(.custom("montserrat-regular", size: 16))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: 54)
            .background(Color.black)
            .cornerRadius(27)
        }
    }
}

#Preview {
    SecondPage()
}
