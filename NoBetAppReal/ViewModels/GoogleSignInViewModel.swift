//
//  GoogleSignInViewModel.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/29/25.
//
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
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
    
    func signInWithApple(completion: @escaping (Bool) -> Void) {
        // TODO: Implement Apple Sign-In after Apple Developer Portal setup
        print("🍎 Apple Sign-In: Requires Apple Developer Portal configuration")
        print("📋 To enable Apple Sign-In:")
        print("   1. Go to Apple Developer Portal")
        print("   2. Add 'Sign in with Apple' capability to your app")
        print("   3. Configure the service in your app's capabilities")
        
        // For now, just simulate success to allow navigation
        // Remove this when implementing real Apple Sign-In
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(true)
        }
    }
}

// MARK: - Apple Sign In Delegate
// TODO: Uncomment and implement when Apple Developer Portal is configured
/*
class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate {
    private let completion: (Bool) -> Void
    
    init(completion: @escaping (Bool) -> Void) {
        self.completion = completion
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("❌ Failed to get Apple ID token")
                self.completion(false)
                return
            }
            
            // Create Firebase credential using Apple ID token
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nil
            )
            
            // Sign in to Firebase with Apple credential
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("❌ Firebase Apple sign in error:", error.localizedDescription)
                    self.completion(false)
                } else {
                    print("✅ Apple signed in successfully with Firebase:", authResult?.user.uid ?? "")
                    
                    // Update user profile with Apple user info if available
                    if let fullName = appleIDCredential.fullName {
                        let displayName = "\(fullName.givenName ?? "") \(fullName.familyName ?? "")".trimmingCharacters(in: .whitespaces)
                        let changeRequest = authResult?.user.createProfileChangeRequest()
                        changeRequest?.displayName = displayName
                        changeRequest?.commitChanges { error in
                            if let error = error {
                                print("❌ Failed to update display name:", error.localizedDescription)
                            } else {
                                print("✅ Updated display name to:", displayName)
                            }
                        }
                    }
                    
                    self.completion(true)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Apple sign in error:", error.localizedDescription)
        self.completion(false)
    }
}

// MARK: - Apple Sign In Presentation Context Provider
class AppleSignInPresentationContextProvider: NSObject, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window found")
        }
        return window
    }
}
*/

