//
//  NavigationViewModel.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 8/4/25.
//

import SwiftUI

class NavigationViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    
    // MARK: - Tab Selection
    func selectTab(_ tabIndex: Int) {
        selectedTab = tabIndex
    }
    
    // MARK: - Tab States
    var isHomeSelected: Bool {
        selectedTab == 0
    }
    
    var isRecoverySelected: Bool {
        selectedTab == 1
    }
    
    var isPledgeSelected: Bool {
        selectedTab == 2
    }
    
    var isUserSelected: Bool {
        selectedTab == 3
    }
    
    // MARK: - Tab Data
    var tabs: [NavigationTabData] {
        [
            NavigationTabData(id: 0, icon: "Home", title: "Home", isSelected: isHomeSelected),
            NavigationTabData(id: 1, icon: "Recovery", title: "Recovery", isSelected: isRecoverySelected),
            NavigationTabData(id: 2, icon: "Pledge", title: "Pledge", isSelected: isPledgeSelected),
            NavigationTabData(id: 3, icon: "User", title: "User", isSelected: isUserSelected)
        ]
    }
    
    // MARK: - Icon Logic
    func getIconName(for tab: NavigationTabData) -> String {
        return tab.isSelected ? "\(tab.icon.lowercased())fill" : tab.icon
    }
}

// MARK: - Navigation Tab Model
struct NavigationTabData: Identifiable {
    let id: Int
    let icon: String
    let title: String
    let isSelected: Bool
} 