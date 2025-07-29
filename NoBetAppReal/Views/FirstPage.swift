//
//  FirstPage.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/23/25.
//

import SwiftUI

struct FirstPage: View {
    
    @StateObject private var viewModel = FirstPageViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
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

                GeometryReader { geo in
                    ZStack {
                        Image("leaf1")
                            .frame(width:100, height: 90)
                            .position(x: geo.size.width * 0.08, y: geo.size.height * 0.1)

                        Image("leaf2")
                            .frame(width: 80, height: 60)
                            .position(x: geo.size.width * 0.5)

                        Image("leaf3")
                            .frame(width: 80, height: 60)
                            .position(x: geo.size.width * 0.92, y: geo.size.height * 0.1)

                        VStack {
                            Image("icon1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 270, height: 450)

                            Text("Welcome!")
                                .font(.custom("nunito-semibold", size: 30))
                                .foregroundColor(.white)

                            Text("Let’s start by seeing if gambling is becoming a problem for you.")
                                .font(.custom("montserrat-regular", size: 15))
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)

                            HStack(spacing: 4) {
                                Image("object1").foregroundColor(.white)
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill").foregroundColor(.yellow)
                                }
                                Image("object2").foregroundColor(.white)
                            }

                            Spacer()

                            // 🟢 NavigationLink-wrapped Button
                            NavigationLink(
                                destination: SecondPage(),
                                isActive: $viewModel.goToSecondPage
                            ) {
                                Button(action: {
                                    viewModel.startQuizTapped()
                                }) {
                                    Text("Start Quiz")
                                        .font(.custom("montserrat-regular", size: 15))
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color("buttonColor"))
                                        .foregroundColor(.black)
                                        .cornerRadius(25)
                                        .padding(.horizontal)
                                }
                            }

                            Spacer(minLength: 30)
                        }
                    }
                }
            }
            .navigationBarHidden(true) // ← ✅ this was missing
        }
    }
}

#Preview {
    FirstPage()
}
