//
//  AnimatedProgressView.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/29/25.
//

import SwiftUI

public struct AnimatedProgressView: View {
    @StateObject private var viewModel = AnimatedProgressViewModel()
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    @Environment(\.presentationMode) var presentationMode

    private var subtitleText: String {
        if viewModel.progress < 33 {
            return "Learning responses"
        } else if viewModel.progress < 66 {
            return "Learning gambling triggers"
        } else {
            return "Building custom plan"
        }
    }

    public init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
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

                // Decorative Leaves
                Group {
                    Image("Lily1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .offset(x: 180, y: -200)
                        .opacity(1)
                        

                    Image("Lily2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .offset(x: 170, y: 200)
                        .opacity(1)
                        

                    Image("Lily3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 110, height: 110)
                        .offset(x: -190, y: 180)
                        .opacity(1)
                        

                    Image("Lily4")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                        .offset(x: -180, y: -180)
                        .opacity(1)
                        

                    Image("Lily5")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .offset(x: -150, y: -440)
                        .opacity(1)
                        
                }

                VStack(spacing: 0) {
                    // No back button - users can't go back during calculation
                    Spacer()
                        .frame(maxHeight: 40)
                    .padding(.top, 10)

                    Spacer()

                    // Ring + Mascot + Text
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 30)
                                .frame(width: 220, height: 220)

                            Circle()
                                .trim(from: 0, to: viewModel.progress / 100)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.progressBar,
                                            Color.button,
                                            Color.button
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    style: StrokeStyle(lineWidth: 30, lineCap: .round)
                                )
                                .frame(width: 220, height: 220)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeOut(duration: 0.3), value: viewModel.progress)
                                .overlay(
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 10, height: 10)
                                        .offset(x: 0, y: -110)
                                        .rotationEffect(.degrees(viewModel.progress * 3.6))
                                        .animation(.easeOut(duration: 0.3), value: viewModel.progress)
                                )

                            // Mascot Image
                            Image("mascot")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 180, height: 180)
                                .offset(y: -15)
                               
                        }

                        // Progress Text
                        VStack(spacing: 7) {
                        
                            Text("\(Int(viewModel.progress))%")
                                .font(.custom("Nunito-Extrabold", size: 42))
                                .foregroundColor(.white)
                                .padding(.top, 15)

                            Text("Calculating")
                                .font(.custom("Montserrat-bold", size: 32))
                                .foregroundColor(.white)

                            Text(subtitleText)
                                .font(.custom("Montserrat-Bold", size: 18))
                                .foregroundColor(.white)
                        }
                    }

                    Spacer()
                }

                // Navigation to Results Page
                NavigationLink("", destination: ResultsPage(viewModel: onboardingViewModel).navigationBarHidden(true), isActive: $viewModel.goToResultsPage)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.startProgressAnimation()
        }
        .onDisappear {
            viewModel.stopAnimation()
        }
    }
}

#Preview {
    AnimatedProgressView(onboardingViewModel: OnboardingViewModel())
}
