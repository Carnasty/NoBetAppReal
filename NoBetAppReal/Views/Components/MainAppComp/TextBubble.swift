//
//  TextBubble.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 8/4/25.
//

import SwiftUI

struct TextBubble: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                // Icon in circle
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(
                        Circle()
                            .fill(Color.niceGreen.opacity(0.2))
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .offset(x: -2, y: 0)
                
                Text(title)
                    .font(.custom("montserrat-medium", size: 12.2))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .offset(x: 8, y: 0)
                    
                
                Spacer()
            }
            .frame(height: 32)
            .padding(.horizontal, 3)
            .background(Color("BubbleColor"))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1.5)
            )
            .cornerRadius(16)
        }
    }
}

#Preview {
    ZStack {
        Color.black
        HStack(spacing: 6) {
            TextBubble(title: "Pledge", icon: "doc.text.fill") {
                print("Pledge tapped")
            }
            
            TextBubble(title: "Edit streak", icon: "pencil") {
                print("Edit streak tapped")
            }
            
            TextBubble(title: "Reset", icon: "clock.arrow.circlepath") {
                print("Reset tapped")
            }
        }
        .padding()
    }
} 
