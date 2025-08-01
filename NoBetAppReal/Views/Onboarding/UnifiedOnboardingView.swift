//
//  UnifiedOnboardingView.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/29/25.
//

import SwiftUI

public struct UnifiedOnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var currentStep: Int = 0
    @State private var isGoingForward: Bool = true
    @State private var showUserInfo = false
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var showAgeError = false
    @State private var isOptionSelected = false
    @State private var timesGambling: Double = 10
    @State private var totalMoneyBet: Double = 100
    @State private var totalMoneyLost: Double = 100
    @Environment(\.presentationMode) var presentationMode
    @State private var goToResultsPage = false
    
    public init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && 
        !age.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        isValidAge
    }
    
    private var isValidAge: Bool {
        guard let ageInt = Int(age.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return false
        }
        return ageInt >= 18
    }
    
    private var moneyBetDisplay: String {
        if totalMoneyBet >= 5000 {
            return "$5,000+"
        } else {
            return "$\(Int(totalMoneyBet))"
        }
    }
    
    private var moneyLostDisplay: String {
        if totalMoneyLost >= 5000 {
            return "$5,000+"
        } else {
            return "$\(Int(totalMoneyLost))"
        }
    }
    
    private var progressPercentage: Double {
        switch currentStep {
        case 0: return 0.125  // ThirdPage
        case 1: return 0.25   // FourthPage
        case 2: return 0.375  // FifthPage
        case 3: return 0.5    // SixthPage
        case 4: return 0.625  // SeventhPage
        case 5: return 0.75   // EighthPage
        case 6: return 0.8    // NinthPage
        case 7: return 0.85   // UserInfoPage
        default: return 0.125
        }
    }
    
    public var body: some View {
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
                                if currentStep > 0 {
                                    isGoingForward = false
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentStep -= 1
                                    }
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
                                    .frame(width: (UIScreen.main.bounds.width - 48) * progressPercentage, height: 8)
                            }
                            .frame(maxWidth: UIScreen.main.bounds.width - 48)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer()
                        .frame(maxHeight: 20)
                    
                    // Content Area with Smooth Transitions
                    VStack(spacing: 40) {
                        // Question Text with Transition
                        Group {
                            switch currentStep {
                            case 0...4:
                                if currentStep < viewModel.questions.count {
                                    Text(viewModel.questions[currentStep].text)
                                        .font(.custom("nunito-semibold", size: 24))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 28)
                                        .lineLimit(nil)
                                        .minimumScaleFactor(0.8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .transition(.asymmetric(
                                            insertion: isGoingForward ? .move(edge: .trailing).combined(with: .opacity) : .move(edge: .leading).combined(with: .opacity),
                                            removal: isGoingForward ? .move(edge: .leading).combined(with: .opacity) : .move(edge: .trailing).combined(with: .opacity)
                                        ))
                                }
                                
                            case 5:
                                // Slider content for EighthPage
                                VStack(spacing: 32) {
                                    Text("What does a typical week look like for you?")
                                        .font(.custom("nunito-semibold", size: 24))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 28)
                                        .lineLimit(nil)
                                        .minimumScaleFactor(0.8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
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
                                                Text("\(Int(timesGambling))")
                                                    .font(.custom("montserrat-semibold", size: 18))
                                                    .foregroundColor(.white)
                                                    .frame(width: 60, height: 40)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .fill(Color.gray.opacity(0.3))
                                                    )
                                                
                                                Spacer()
                                            }
                                            
                                            Slider(value: $timesGambling, in: 0...50, step: 1)
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
                                                Text(moneyBetDisplay)
                                                    .font(.custom("montserrat-semibold", size: 18))
                                                    .foregroundColor(.white)
                                                    .frame(width: 80, height: 40)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .fill(Color.gray.opacity(0.3))
                                                    )
                                                
                                                Spacer()
                                            }
                                            
                                            Slider(value: $totalMoneyBet, in: 0...5000, step: 100)
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
                                                Text(moneyLostDisplay)
                                                    .font(.custom("montserrat-semibold", size: 18))
                                                    .foregroundColor(.white)
                                                    .frame(width: 80, height: 40)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .fill(Color.gray.opacity(0.3))
                                                    )
                                                
                                                Spacer()
                                            }
                                            
                                            Slider(value: $totalMoneyLost, in: 0...5000, step: 100)
                                                .accentColor(Color("progressBar"))
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                }
                                .transition(.asymmetric(
                                    insertion: isGoingForward ? .move(edge: .trailing).combined(with: .opacity) : .move(edge: .leading).combined(with: .opacity),
                                    removal: isGoingForward ? .move(edge: .leading).combined(with: .opacity) : .move(edge: .trailing).combined(with: .opacity)
                                ))
                                
                            case 6:
                                Text("Do you want a clear, personalized plan to quit gambling and take back control?")
                                    .font(.custom("nunito-semibold", size: 24))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 28)
                                    .lineLimit(nil)
                                    .minimumScaleFactor(0.8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .transition(.asymmetric(
                                        insertion: isGoingForward ? .move(edge: .trailing).combined(with: .opacity) : .move(edge: .leading).combined(with: .opacity),
                                        removal: isGoingForward ? .move(edge: .leading).combined(with: .opacity) : .move(edge: .trailing).combined(with: .opacity)
                                    ))
                                
                            case 7:
                                Text("Let's get to know you")
                                    .font(.custom("nunito-semibold", size: 24))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 28)
                                    .transition(.asymmetric(
                                        insertion: isGoingForward ? .move(edge: .trailing).combined(with: .opacity) : .move(edge: .leading).combined(with: .opacity),
                                        removal: isGoingForward ? .move(edge: .leading).combined(with: .opacity) : .move(edge: .trailing).combined(with: .opacity)
                                    ))
                                
                            default:
                                EmptyView()
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                        
                        // Answer Options with Transition
                        Group {
                            switch currentStep {
                            case 0...4:
                                // Multiple choice options from ViewModel
                                if currentStep < viewModel.questions.count {
                                    VStack(spacing: 16) {
                                        ForEach(Array(viewModel.questions[currentStep].options.enumerated()), id: \.element.id) { index, option in
                                            AnswerOptionButton(
                                                text: option.text,
                                                isSelected: option.isSelected,
                                                action: {
                                                    viewModel.toggleOption(questionIndex: currentStep, optionIndex: index)
                                                }
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                    .transition(.asymmetric(
                                        insertion: isGoingForward ? .move(edge: .trailing).combined(with: .opacity) : .move(edge: .leading).combined(with: .opacity),
                                        removal: isGoingForward ? .move(edge: .leading).combined(with: .opacity) : .move(edge: .trailing).combined(with: .opacity)
                                    ))
                                }
                                
                            case 6:
                                // Single option for commitment question
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
                                .transition(.asymmetric(
                                    insertion: isGoingForward ? .move(edge: .trailing).combined(with: .opacity) : .move(edge: .leading).combined(with: .opacity),
                                    removal: isGoingForward ? .move(edge: .leading).combined(with: .opacity) : .move(edge: .trailing).combined(with: .opacity)
                                ))
                                
                            case 7:
                                // User info form
                                VStack(spacing: 24) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Name")
                                            .font(.custom("montserrat-regular", size: 16))
                                            .foregroundColor(.white)
                                        
                                        TextField("Enter name", text: $name)
                                            .font(.custom("montserrat-regular", size: 16))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.gray.opacity(0.3))
                                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                            )
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .autocorrectionDisabled()
                                            .textInputAutocapitalization(.words)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Age")
                                            .font(.custom("montserrat-regular", size: 16))
                                            .foregroundColor(.white)
                                        
                                        TextField("Enter age", text: $age)
                                            .font(.custom("montserrat-regular", size: 16))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.gray.opacity(0.3))
                                                    .stroke(showAgeError ? Color.red : Color.white.opacity(0.3), lineWidth: 1)
                                            )
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .keyboardType(.numberPad)
                                            .autocorrectionDisabled()
                                            .onChange(of: age) { newValue in
                                                let filtered = newValue.filter { "0123456789".contains($0) }
                                                if filtered != newValue {
                                                    age = filtered
                                                }
                                                
                                                if !age.isEmpty {
                                                    if let ageInt = Int(age), ageInt < 18 {
                                                        showAgeError = true
                                                    } else {
                                                        showAgeError = false
                                                    }
                                                } else {
                                                    showAgeError = false
                                                }
                                            }
                                        
                                        if showAgeError {
                                            Text("You must be 18 or older to use this app")
                                                .font(.custom("montserrat-regular", size: 12))
                                                .foregroundColor(.red)
                                                .padding(.top, 4)
                                        }
                                    }
                                }
                                .padding(.horizontal, 24)
                                .transition(.asymmetric(
                                    insertion: isGoingForward ? .move(edge: .trailing).combined(with: .opacity) : .move(edge: .leading).combined(with: .opacity),
                                    removal: isGoingForward ? .move(edge: .leading).combined(with: .opacity) : .move(edge: .trailing).combined(with: .opacity)
                                ))
                                
                            default:
                                EmptyView()
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                    }
                    
                    Spacer()
                    
                    // Next Button
                    VStack(spacing: 16) {
                        Button(action: {
                            if currentStep < 7 {
                                isGoingForward = true
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentStep += 1
                                }
                            } else {
                                // Complete quiz and navigate to loading page
                                goToResultsPage = true
                            }
                        }) {
                            Text(currentStep == 7 ? "Complete Quiz" : "Next")
                                .font(.custom("montserrat-semibold", size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(getButtonColor())
                                .cornerRadius(25)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(!canProceed())
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                }
                
                // Navigation to AnimatedProgressView
                NavigationLink(destination: AnimatedProgressView(onboardingViewModel: viewModel).navigationBarHidden(true), isActive: $goToResultsPage) {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private func getButtonColor() -> Color {
        if currentStep == 6 {
            return isOptionSelected ? Color("progressBar") : Color.gray
        } else if currentStep == 7 {
            return isFormValid ? Color("progressBar") : Color.gray
        } else {
            return Color("progressBar")
        }
    }
    
    private func canProceed() -> Bool {
        if currentStep < 5 {
            // Check if any option is selected for multiple choice questions
            if currentStep < viewModel.questions.count {
                return viewModel.questions[currentStep].options.contains { $0.isSelected }
            }
            return false
        } else if currentStep == 6 {
            return isOptionSelected
        } else if currentStep == 7 {
            return isFormValid
        } else {
            return true
        }
    }
}

#Preview {
    UnifiedOnboardingView(viewModel: OnboardingViewModel())
} 