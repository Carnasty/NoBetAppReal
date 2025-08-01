//
//  QuizContainerView.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/24/25.
//

import SwiftUI

struct QuizContainerView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var goToAnimatedProgress = false
    
    // Navigation state
    @State private var currentPage: QuizPage = .third
    @State private var isGoingForward: Bool = true
    
    // Animation states
    @State private var pageOpacity: Double = 1
    @State private var progressBarWidth: CGFloat = 0
    
    enum QuizPage: Int, CaseIterable {
        case third = 0
        case fourth = 1
        case fifth = 2
        case sixth = 3
        case seventh = 4
        case eighth = 5
        case ninth = 6
        case userInfo = 7
        
        var title: String {
            switch self {
            case .third: return "Why do you want to stop\ngambling?"
            case .fourth: return "How does gambling make you feel after?"
            case .fifth: return "What have you sacrificed because of gambling?"
            case .sixth: return "What kind of person do you want to become?"
            case .seventh: return "When are you most tempted to gamble?"
            case .eighth: return "What does a typical week look like for you?"
            case .ninth: return "Do you want a clear, personalized plan to quit gambling and take back control?"
            case .userInfo: return "Let's get to know you"
            }
        }
        
        var progressPercentage: Double {
            switch self {
            case .third: return 0.125
            case .fourth: return 0.25
            case .fifth: return 0.375
            case .sixth: return 0.5
            case .seventh: return 0.625
            case .eighth: return 0.75
            case .ninth: return 0.8
            case .userInfo: return 0.85
            }
        }
        
        var questionIndex: Int {
            switch self {
            case .third: return 0
            case .fourth: return 1
            case .fifth: return 2
            case .sixth: return 3
            case .seventh: return 4
            case .eighth: return 5
            case .ninth: return 6
            case .userInfo: return 7
            }
        }
        
        var hasQuestion: Bool {
            switch self {
            case .third, .fourth, .fifth, .sixth:
                return questionIndex < 4 // Only 4 questions in the array
            case .seventh, .eighth, .ninth, .userInfo:
                return false // These are special pages, not standard questions
            }
        }
    }
    
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
                                if currentPage.rawValue > 0 {
                                    navigateToPreviousPage()
                                } else {
                                    presentationMode.wrappedValue.dismiss()
                                }
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
                                
                                // Progress fill
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("progressBar"))
                                    .frame(width: progressBarWidth, height: 8)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer()
                        .frame(maxHeight: 32)
                    
                    // Dynamic Content Area
                    ZStack {
                        // Quiz Pages
                        Group {
                            switch currentPage {
                            case .third, .fourth, .fifth, .sixth:
                                QuizQuestionView(
                                    viewModel: viewModel,
                                    questionIndex: currentPage.questionIndex,
                                    title: currentPage.title
                                )
                            case .seventh:
                                MultipleSelectionView(
                                    viewModel: viewModel,
                                    title: currentPage.title
                                )
                            case .eighth:
                                SliderView(
                                    viewModel: viewModel,
                                    title: currentPage.title
                                )
                            case .ninth:
                                FinalQuestionView(
                                    viewModel: viewModel,
                                    title: currentPage.title,
                                    isOptionSelected: $isNinthPageOptionSelected
                                )
                            case .userInfo:
                                UserInfoView(
                                    viewModel: viewModel,
                                    title: currentPage.title
                                )
                            }
                        }
                        .opacity(pageOpacity)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    }
                    
                    Spacer()
                    
                    // Next Button
                    VStack(spacing: 16) {
                        Button(action: {
                            // Modern iOS-style button press
                            withAnimation(.spring(response: 0.15, dampingFraction: 0.7)) {
                                // Subtle button press effect
                            }
                            navigateToNextPage()
                        }) {
                            Text(getButtonText())
                                .font(.custom("montserrat-semibold", size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(getButtonColor())
                                .cornerRadius(25)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(!canProceed())
                        .scaleEffect(currentPage == .userInfo && canProceed() ? 1.02 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage == .userInfo && canProceed())
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Enhanced initial progress bar animation
            withAnimation(.easeOut(duration: 1.5).delay(0.3)) {
                progressBarWidth = (UIScreen.main.bounds.width - 48) * currentPage.progressPercentage
            }
        }
        
        // Navigation to AnimatedProgressView
        NavigationLink(destination: AnimatedProgressView(onboardingViewModel: viewModel).navigationBarHidden(true), isActive: $goToAnimatedProgress) {
            EmptyView()
        }
    }
    
    // MARK: - Navigation Methods
    private func navigateToNextPage() {
        guard canProceed() else { return }
        
        isGoingForward = true
        
        // Special handling for UserInfo page completion
        if currentPage == .userInfo {
            // Modern iOS-style transition to completion
            withAnimation(.easeInOut(duration: 0.5)) {
                pageOpacity = 0
            }
            
            // Animate progress bar to completion
            withAnimation(.easeOut(duration: 0.8).delay(0.1)) {
                progressBarWidth = UIScreen.main.bounds.width - 48
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                goToAnimatedProgress = true
            }
        } else {
            // Standard page transition for other pages
            animatePageTransition {
                if currentPage.rawValue < QuizPage.allCases.count - 1 {
                    currentPage = QuizPage.allCases[currentPage.rawValue + 1]
                }
            }
        }
    }
    
    private func navigateToPreviousPage() {
        isGoingForward = false
        animatePageTransition {
            if currentPage.rawValue > 0 {
                currentPage = QuizPage.allCases[currentPage.rawValue - 1]
            }
        }
    }
    
    private func animatePageTransition(completion: @escaping () -> Void) {
        // Modern iOS-style transition
        withAnimation(.easeInOut(duration: 0.4)) {
            pageOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            completion()
            
            withAnimation(.easeInOut(duration: 0.4)) {
                pageOpacity = 1
            }
            
            // Animate progress bar forward smoothly
            withAnimation(.easeOut(duration: 0.8).delay(0.1)) {
                progressBarWidth = (UIScreen.main.bounds.width - 48) * currentPage.progressPercentage
            }
        }
    }
    
    // MARK: - Helper Methods
    private func getButtonText() -> String {
        switch currentPage {
        case .userInfo:
            return "Complete Quiz"
        default:
            return "Next"
        }
    }
    
    private func getButtonColor() -> Color {
        if canProceed() {
            return Color("progressBar")
        } else {
            return Color("progressBar").opacity(0.5)
        }
    }
    
    private func canProceed() -> Bool {
        switch currentPage {
        case .third, .fourth, .fifth, .sixth:
            return currentPage.hasQuestion &&
                   viewModel.questions.indices.contains(currentPage.questionIndex) &&
                   viewModel.questions[currentPage.questionIndex].options.contains { $0.isSelected }
        case .seventh:
            return !viewModel.multipleSelections.isEmpty
        case .eighth:
            return true // Sliders always have values
        case .ninth:
            return isNinthPageOptionSelected // Check if "Yes, I'm ready" is selected
        case .userInfo:
            return viewModel.isUserInfoValid()
        }
    }
    
    @State private var isNinthPageOptionSelected = false
}

#Preview {
    QuizContainerView(viewModel: OnboardingViewModel())
} 