//
//  GoogleSignInViewModel.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/29/25.
//
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import UIKit

class AuthViewModel: ObservableObject {
    func signInWithGoogle(completion: @escaping (Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("❌ No rootViewController")
            completion(false)
            return
        }

        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("❌ Google sign in error:", error.localizedDescription)
                completion(false)
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("❌ Failed to get user or token")
                completion(false)
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("❌ Firebase sign in error:", error.localizedDescription)
                    completion(false)
                } else {
                    print("✅ Signed in:", authResult?.user.uid ?? "")
                    completion(true)
                }
            }
        }
    }
}
