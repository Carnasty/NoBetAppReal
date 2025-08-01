//
//  CustomPlanView.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/24/25.
//

import SwiftUI

struct CustomPlanView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // Animation states
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = 30
    @State private var dateOpacity: Double = 0
    @State private var benefitsOpacity: Double = 0
    @State private var tagsOpacity: Double = 0
    @State private var buttonOpacity: Double = 0
    @State private var buttonScale: CGFloat = 0.8
    
    // Calculate target date (90 days from now)
    private var targetDate: String {
        let calendar = Calendar.current
        let currentDate = Date()
        if let futureDate = calendar.date(byAdding: .day, value: 90, to: currentDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d"
            let dateString = formatter.string(from: futureDate)
            
            // Add proper suffix (st, nd, rd, th)
            let day = calendar.component(.day, from: futureDate)
            let suffix: String
            switch day {
            case 1, 21, 31: suffix = "st"
            case 2, 22: suffix = "nd"
            case 3, 23: suffix = "rd"
            default: suffix = "th"
            }
            
            return dateString + suffix
        }
        return "July 1st"
    }
    
    // Get user name from viewModel
    private var userName: String {
        return viewModel.userName.isEmpty ? "You" : viewModel.userName.uppercased()
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
                    // No back button - users can't go back after completing quiz
                    Spacer()
                        .frame(maxHeight: 40)
                    
                    // Main Content
                    VStack(spacing: 32) {
                        // Title Section
                        VStack(spacing: 8) {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text(userName)
                                        .font(.custom("nunito-semibold", size: 28))
                                        .foregroundColor(Color("niceGreen"))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    
                                    Text(", We Built You A")
                                        .font(.custom("nunito-semibold", size: 28))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                
                                Text("Custom Plan")
                                    .font(.custom("nunito-semibold", size: 28))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .opacity(titleOpacity)
                            .offset(y: titleOffset)
                            
                            VStack(spacing: 4) {
                                Text("You will become gambling free by")
                                    .font(.custom("montserrat-regular", size: 16))
                                    .foregroundColor(.white)
                                    .opacity(dateOpacity)
                                
                                Text(targetDate)
                                    .font(.custom("nunito-semibold", size: 24))
                                    .foregroundColor(Color("niceGreen"))
                                    .opacity(dateOpacity)
                            }
                        }
                        
                        // Benefits Section
                        VStack(spacing: 20) {
                            Text("Become the best version of yourself with no bet")
                                .font(.custom("nunito-semibold", size: 20))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .opacity(benefitsOpacity)
                            
                            // Stars with custom objects
                            HStack(spacing: 4) {
                                Image("object1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 54, height: 54)
                                
                                ForEach(0..<5, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.yellow)
                                }
                                
                                Image("object2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 54, height: 54)
                            }
                            .opacity(benefitsOpacity)
                            
                            // Three main benefits
                            HStack(spacing: 24) {
                                BenefitItem(emoji: "❤️", text: "Healthier")
                                BenefitItem(emoji: "😊", text: "Happier")
                                BenefitItem(emoji: "💰", text: "Richer")
                            }
                            .opacity(benefitsOpacity)
                        }
                        
                        // Benefit Tags
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                BenefitTag(text: "More money", color: .green)
                                BenefitTag(text: "Better sleep", color: .yellow)
                            }
                            
                            HStack(spacing: 12) {
                                BenefitTag(text: "Sense of control", color: .purple)
                                BenefitTag(text: "Increased Relationships", color: .red)
                            }
                            
                            HStack(spacing: 12) {
                                BenefitTag(text: "Less stress", color: .blue, isSmaller: true)
                                BenefitTag(text: "Increased confidence", color: .orange)
                            }
                        }
                        .opacity(tagsOpacity)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    
                    // Bottom Section
                    VStack(spacing: 16) {
                        // Main CTA Button
                        Button(action: {
                            // Handle "Become a no bet ally" action
                        }) {
                            Text("Become a no bet ally")
                                .font(.custom("Montserrat-SemiBold", size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color("progressBar"))
                                .cornerRadius(25)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .opacity(buttonOpacity)
                        .scaleEffect(buttonScale)
                        
                        // Bottom info
                        HStack(spacing: 24) {
                            HStack(spacing: 8) {
                                Text("Cancel Anytime")
                                    .font(.custom("montserrat-regular", size: 12))
                                    .foregroundColor(.white)
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 16, height: 16)
                                    .background(Color.green)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                            
                            HStack(spacing: 8) {
                                Text("Finally Quit Gambling")
                                    .font(.custom("montserrat-regular", size: 12))
                                    .foregroundColor(.white)
                                
                                Image("shield")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                            }
                        }
                        .opacity(buttonOpacity)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
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
        // Animate title
        withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
            titleOpacity = 1
            titleOffset = 0
        }
        
        // Animate date
        withAnimation(.easeOut(duration: 0.6).delay(0.6)) {
            dateOpacity = 1
        }
        
        // Animate benefits
        withAnimation(.easeOut(duration: 0.6).delay(0.8)) {
            benefitsOpacity = 1
        }
        
        // Animate tags
        withAnimation(.easeOut(duration: 0.6).delay(1.0)) {
            tagsOpacity = 1
        }
        
        // Animate button
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.2)) {
            buttonOpacity = 1
            buttonScale = 1.0
        }
    }
}

// MARK: - Benefit Item Component
struct BenefitItem: View {
    let emoji: String
    let text: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(emoji)
                .font(.system(size: 24))
            
            Text(text)
                .font(.custom("montserrat-regular", size: 14))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Benefit Tag Component
struct BenefitTag: View {
    let text: String
    let color: Color
    let isSmaller: Bool
    
    init(text: String, color: Color, isSmaller: Bool = false) {
        self.text = text
        self.color = color
        self.isSmaller = isSmaller
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(text)
                .font(.custom("montserrat-regular", size: 14))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, isSmaller ? 4 : 6)
        .background(Color.white.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color, lineWidth: 1)
        )
        .cornerRadius(20)
    }
}

#Preview {
    CustomPlanView(viewModel: OnboardingViewModel())
} 
