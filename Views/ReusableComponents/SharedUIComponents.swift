//
//  SharedUIComponents.swift
//  VybeMVP
//
//  Shared reusable UI components to avoid duplication across the app
//

import SwiftUI

// MARK: - Text Field Styles

/**
 * CosmicTextFieldStyle provides a consistent cosmic-themed text field appearance.
 * Used throughout the app for form inputs with a space/mystical aesthetic.
 */
struct CosmicTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .foregroundColor(.white)
    }
}

// MARK: - Button Components

/**
 * NumberButton provides a reusable selectable number button for various features.
 * Used in focus number selection, sightings creation, and other numeric inputs.
 * 
 * 🎯 PIXEL-PERFECT SPECIFICATIONS:
 * • Button size: 80×80pt circle
 * • Selected scale: 1.1x (88×88pt)
 * • Number font: Title2 (~22pt), bold, white
 * • Shadow: Black 30% opacity, 3pt blur, 1pt Y offset
 * • Selection animation: 0.2s ease-in-out
 * • Selected border: 2pt width, sacred color
 * • Unselected border: 1pt width, white 30% opacity
 * • Selected shadow: Sacred color 40%, 10pt blur, 5pt Y offset
 */
struct NumberButton: View {
    let number: Int
    let isSelected: Bool
    let action: () -> Void
    
    private var sacredColor: Color {
        switch number {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0)
        case 9: return .white
        default: return .gray
        }
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                isSelected ? sacredColor.opacity(0.8) : Color.white.opacity(0.1),
                                isSelected ? sacredColor.opacity(0.4) : Color.white.opacity(0.05),
                                Color.black.opacity(0.2)
                            ]),
                            center: .center,
                            startRadius: 10,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle()
                            .stroke(
                                isSelected ? sacredColor : Color.white.opacity(0.3),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
                
                Text("\(number)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
            }
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .shadow(
            color: isSelected ? sacredColor.opacity(0.4) : .clear,
            radius: isSelected ? 10 : 0,
            x: 0,
            y: isSelected ? 5 : 0
        )
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .accessibilityLabel("Number \(number)")
        .accessibilityHint(isSelected ? "Selected" : "Tap to select")
    }
}

// MARK: - Card Components

/**
 * StatCard provides a consistent card layout for displaying statistics.
 * Used in analytics views and dashboard components throughout the app.
 */
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30, height: 30)
            
            // Value
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            // Title
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview Providers

struct SharedUIComponents_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            HStack {
                NumberButton(number: 1, isSelected: true) {}
                NumberButton(number: 2, isSelected: false) {}
                NumberButton(number: 3, isSelected: false) {}
            }
            
            HStack {
                StatCard(title: "Today", value: "5", icon: "calendar", color: .blue)
                StatCard(title: "This Week", value: "23", icon: "chart.bar", color: .green)
            }
        }
        .padding()
        .background(Color.black)
        .previewLayout(.sizeThatFits)
    }
} 