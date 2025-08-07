//
//  BottomNavigationBar.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 8/4/25.
//

import SwiftUI

struct BottomNavigationBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            NavigationTabView(
                icon: "Home",
                title: "Home",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
            }
            
            NavigationTabView(
                icon: "Recovery",
                title: "Recovery",
                isSelected: selectedTab == 1
            ) {
                selectedTab = 1
            }
            
            NavigationTabView(
                icon: "Pledge",
                title: "Pledge",
                isSelected: selectedTab == 2
            ) {
                selectedTab = 2
            }
            
            NavigationTabView(
                icon: "User",
                title: "User",
                isSelected: selectedTab == 3
            ) {
                selectedTab = 3
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(Color("navBar").opacity(0.9))
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }
}

struct NavigationTabView: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                let iconName = isSelected ? "\(icon.lowercased())fill" : icon
                Image(iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? .green : .white.opacity(0.6))
                
                if isSelected {
                    Text(title)
                        .font(.custom("montserrat-medium", size: 10))
                        .foregroundColor(.green)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .overlay(
                Image("union")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 6)
                    .opacity(isSelected ? 1.0 : 0.0)
                    .offset(y: 20)
            )
        }
    }
}

#Preview {
    BottomNavigationBar(selectedTab: .constant(0))
} 
