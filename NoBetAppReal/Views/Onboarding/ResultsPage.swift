//
//  ResultsPage.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/24/25.
//

import SwiftUI

struct ResultsPage: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var goToPlanPage = false
    @Environment(\.presentationMode) var presentationMode
    
    // Animation states for professional entrance
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = 30
    @State private var checkmarkScale: CGFloat = 0
    @State private var subtitleOpacity: Double = 0
    @State private var chartOpacity: Double = 0
    @State private var chartOffset: CGFloat = 50
    @State private var resultMessageOpacity: Double = 0
    @State private var buttonOpacity: Double = 0
    @State private var buttonScale: CGFloat = 0.8
    
    // Chart animation states
    @State private var yourScoreHeight: CGFloat = 0
    @State private var averageHeight: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient - exact match to other pages
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
                    // Header with Back Button
                    HStack {
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
                    
                    Spacer()
                        .frame(maxHeight: 20)
                    
                    // Analysis Complete Section
                    VStack(spacing: 16) {
                        // Title with Checkmark
                        HStack(spacing: 12) {
                            Text("Analysis Complete")
                                .font(.custom("nunito-semibold", size: 28))
                                .foregroundColor(.white)
                                .opacity(titleOpacity)
                                .offset(y: titleOffset)
                            
                            // Checkmark Icon
                            ZStack {
                                Circle()
                                    .fill(Color("progressBar"))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .scaleEffect(checkmarkScale)
                        }
                        
                        // Subtitle
                        Text("We've got some news to break to you.")
                            .font(.custom("montserrat-regular", size: 16))
                            .foregroundColor(.white.opacity(0.8))
                            .opacity(subtitleOpacity)
                    }
                    
                    Spacer()
                        .frame(maxHeight: 40)
                    
                    // Bar Chart Container
                    VStack(spacing: 0) {
                        // Chart Container
                        VStack(spacing: 24) {
                            // Y-axis and Chart Area
                            HStack(alignment: .bottom, spacing: 16) {
                                // Y-axis labels
                                VStack(alignment: .trailing, spacing: 0) {
                                    ForEach([100, 80, 60, 40, 20, 0], id: \.self) { percentage in
                                        Text("\(percentage)%")
                                            .font(.custom("montserrat-regular", size: 12))
                                            .foregroundColor(.gray)
                                            .frame(height: 30)
                                    }
                                }
                                .frame(width: 40)
                                
                                // Chart bars
                                HStack(alignment: .bottom, spacing: 40) {
                                    // Your Score Bar
                                    VStack(spacing: 8) {
                                        // Bar with gradient
                                        ZStack(alignment: .bottom) {
                                            // Background track
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 60, height: 180)
                                            
                                            // Your Score Bar with gradient
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            Color.green,
                                                            Color.blue
                                                        ]),
                                                        startPoint: .top,
                                                        endPoint: .bottom
                                                    )
                                                )
                                                .frame(width: 60, height: yourScoreHeight)
                                        }
                                        
                                        Text("Your score")
                                            .font(.custom("montserrat-regular", size: 14))
                                            .foregroundColor(.white)
                                    }
                                    
                                    // Average Bar
                                    VStack(spacing: 8) {
                                        // Bar with gradient
                                        ZStack(alignment: .bottom) {
                                            // Background track
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 60, height: 180)
                                            
                                            // Average Bar with gradient
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            Color.green,
                                                            Color.blue
                                                        ]),
                                                        startPoint: .top,
                                                        endPoint: .bottom
                                                    )
                                                )
                                                .frame(width: 60, height: averageHeight)
                                        }
                                        
                                        Text("Average")
                                            .font(.custom("montserrat-regular", size: 14))
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.1))
                        )
                        .opacity(chartOpacity)
                        .offset(y: chartOffset)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                        .frame(maxHeight: 32)
                    
                    // Result Message
                    HStack(spacing: 4) {
                        Text("\(Int(viewModel.calculateScore()))%")
                            .font(.custom("nunito-semibold", size: 24))
                            .foregroundColor(Color.orange)
                        
                        Text("higher dependance on gambling")
                            .font(.custom("montserrat-regular", size: 16))
                            .foregroundColor(.white)
                    }
                    .opacity(resultMessageOpacity)
                    
                    Spacer()
                    
                    // Call to Action Button
                    VStack(spacing: 16) {
                        Button(action: {
                            goToPlanPage = true
                        }) {
                            Text("Check out your plan")
                                .font(.custom("montserrat-semibold", size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color("progressBar"))
                                .cornerRadius(25)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .opacity(buttonOpacity)
                        .scaleEffect(buttonScale)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                }
                
                // Navigation to Plan Page
                NavigationLink(destination: Text("Plan Page - Coming Soon").navigationBarHidden(true), isActive: $goToPlanPage) {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Animate title and checkmark
        withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
            titleOpacity = 1
            titleOffset = 0
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4)) {
            checkmarkScale = 1.0
        }
        
        // Animate subtitle
        withAnimation(.easeOut(duration: 0.6).delay(0.6)) {
            subtitleOpacity = 1
        }
        
        // Animate chart container
        withAnimation(.easeOut(duration: 0.8).delay(0.8)) {
            chartOpacity = 1
            chartOffset = 0
        }
        
        // Animate chart bars
        withAnimation(.easeOut(duration: 1.2).delay(1.0)) {
            yourScoreHeight = CGFloat(viewModel.calculateScore() / 100.0 * 180) // Dynamic based on actual score
        }
        
        withAnimation(.easeOut(duration: 1.2).delay(1.2)) {
            averageHeight = 36 // 20% of 180 (average baseline)
        }
        
        // Animate result message
        withAnimation(.easeOut(duration: 0.6).delay(1.4)) {
            resultMessageOpacity = 1
        }
        
        // Animate button
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.6)) {
            buttonOpacity = 1
            buttonScale = 1.0
        }
    }
}

#Preview {
    ResultsPage(viewModel: OnboardingViewModel())
} 