//
//  UserInfoView.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/24/25.
//

import SwiftUI

struct UserInfoView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let title: String
    @State private var showAgeError = false
    
    private var isValidAge: Bool {
        guard let ageInt = Int(viewModel.userAge.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return false
        }
        return ageInt >= 18
    }
    
    var body: some View {
        VStack(spacing: 32) {
            // Title
            Text(title)
                .font(.custom("nunito-semibold", size: 24))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 28)
                .lineLimit(nil)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Input Fields
            VStack(spacing: 24) {
                // Name Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .font(.custom("montserrat-regular", size: 16))
                        .foregroundColor(.white)
                    
                    TextField("Enter name", text: $viewModel.userName)
                        .font(.custom("montserrat-regular", size: 16))
                        .foregroundColor(.white)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                        )
                }
                
                // Age Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Age")
                        .font(.custom("montserrat-regular", size: 16))
                        .foregroundColor(.white)
                    
                    TextField("Enter age", text: $viewModel.userAge)
                        .font(.custom("montserrat-regular", size: 16))
                        .foregroundColor(.white)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                        )
                        .onChange(of: viewModel.userAge) { _, newValue in
                            if !newValue.isEmpty {
                                if let ageInt = Int(newValue), ageInt < 18 {
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
        }
    }
} 