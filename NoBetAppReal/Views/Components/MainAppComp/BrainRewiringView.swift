//
//  BrainRewiringView.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 8/4/25.
//

import SwiftUI

struct BrainRewiringView: View {
    let progress: Double
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Background bubble with gradient
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color("BubbleColor"),
                                Color("BubbleColor").opacity(0.4)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                    )
                
                // Content inside the bubble
                HStack(spacing: 12) {
                    Text("Brain Rewiring")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white)
                    
                    // Progress bar with fill inside
                    ZStack(alignment: .leading) {
                        // Background bar
                        RoundedRectangle(cornerRadius: 7)
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 10)
                        
                        // Progress fill inside the background bar
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.green)
                            .frame(width: UIScreen.main.bounds.width * 0.08 * progress, height: 10)
                    }
                    
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 4)
    }
}

#Preview {
    BrainRewiringView(progress: 0.2) {
        print("Brain rewiring tapped")
    }
} 
