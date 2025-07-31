//
//  GoogleButtonUI.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/29/25.
//

import SwiftUI

struct GoogleButtonUI: View {
    @ObservedObject var authVM: AuthViewModel
    @Binding var goToNextPage: Bool

    var body: some View {
        Button(action: {
            authVM.signInWithGoogle { success in
                if success {
                    goToNextPage = true
                }
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "globe") // Replace with your "Google" asset if needed
                    .font(.system(size: 18))
                Text("Continue with Google")
                    .font(.custom("montserrat-regular", size: 16))
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, maxHeight: 54)
            .background(Color.white)
            .cornerRadius(27)
        }
    }
}

#Preview {
    GoogleButtonUI(authVM: AuthViewModel(), goToNextPage: .constant(false))
}
