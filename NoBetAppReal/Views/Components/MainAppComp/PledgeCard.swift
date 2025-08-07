//
//  PledgeCard.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 8/4/25.
//

import SwiftUI

struct PledgeCard: View {
    let iconName: String
    let title: String
    let description: String
    let isCustomIcon: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon
            if isCustomIcon {
                Image(iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            } else {
                Image(systemName: iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.yellow)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 35/255, green: 105/255, blue: 82/255).opacity(0.3))
        )
        .clipped()
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        PledgeCard(
            iconName: "goldRibben",
            title: "Achievable Goal",
            description: "When pledging, you agree to stay gamble-free for the day only. One day at a time builds lasting change.",
            isCustomIcon: true
        )
        .padding()
    }
} 