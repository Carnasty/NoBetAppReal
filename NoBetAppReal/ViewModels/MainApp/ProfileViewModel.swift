//
//  ProfileViewModel.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 8/4/25.
//

import Foundation
import SwiftUI
import PhotosUI

class ProfileViewModel: ObservableObject {
    @Published var name = ""
    @Published var phoneNumber = ""
    @Published var email = ""
    @Published var showingImagePicker = false
    @Published var showingSaveConfirmation = false
    @Published var profileImage: UIImage?
    @Published var selectedPhotoItem: PhotosPickerItem?
    
    init() {
        loadUserProfile()
        loadProfileImage()
    }
    
    // MARK: - Profile Management Functions
    
    func loadUserProfile() {
        // Load user data from Google/Apple sign-in or saved profile
        // This would typically come from UserDefaults, Core Data, or a backend service
        
        // Example: Load from UserDefaults
        name = UserDefaults.standard.string(forKey: "user_name") ?? ""
        phoneNumber = UserDefaults.standard.string(forKey: "user_phone") ?? ""
        email = UserDefaults.standard.string(forKey: "user_email") ?? ""
        
        // If no saved data, these fields will remain empty for user to fill
    }
    
    func saveProfileChanges() {
        // Save user data to persistent storage
        UserDefaults.standard.set(name, forKey: "user_name")
        UserDefaults.standard.set(phoneNumber, forKey: "user_phone")
        UserDefaults.standard.set(email, forKey: "user_email")
        
        // Save profile image if exists
        if let profileImage = profileImage {
            saveProfileImage(profileImage)
        }
        
        // Show confirmation
        showingSaveConfirmation = true
        
        // Here you could also sync with backend services
        print("Profile saved: \(name), \(phoneNumber), \(email)")
    }
    
    func updateProfileImage() {
        // Handle profile image update logic
        showingImagePicker = true
    }
    
    // MARK: - Profile Image Management
    
    func loadProfileImage() {
        // Load saved profile image from UserDefaults
        if let imageData = UserDefaults.standard.data(forKey: "profile_image"),
           let image = UIImage(data: imageData) {
            profileImage = image
        }
    }
    
    func saveProfileImage(_ image: UIImage) {
        // Convert image to data and save to UserDefaults
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: "profile_image")
        }
    }
    
    func handleSelectedPhoto(_ item: PhotosPickerItem) {
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                await MainActor.run {
                    profileImage = image
                    saveProfileImage(image)
                }
            }
        }
    }
    
    func removeProfileImage() {
        profileImage = nil
        UserDefaults.standard.removeObject(forKey: "profile_image")
    }
} 