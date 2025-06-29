/*
 * ========================================
 * ✨ ARCHETYPE DISPLAY VIEW - SPIRITUAL IDENTITY PRESENTATION
 * ========================================
 * 
 * CORE PURPOSE:
 * Elegant presentation view displaying user's complete calculated spiritual archetype
 * including Life Path Number, Zodiac Sign, Element, and Planetary Influences. Final
 * step in onboarding flow before entering main app experience.
 * 
 * UI SPECIFICATIONS:
 * - Header: 100×100pt gradient circle with 40pt sparkles icon
 * - Life Path Display: 60pt bold rounded number in purple
 * - Core Identity Card: 24pt padding, 16pt corner radius, system background with shadow
 * - Detail Cards: 12pt corner radius, secondary background, 16pt padding
 * - Action Button: 50pt height, purple-to-blue gradient, checkmark icon
 * 
 * ARCHETYPE PRESENTATION SYSTEM:
 * - Life Path Number: Primary 60pt display with Master Number badge (11,22,33)
 * - Zodiac Information: Sign name with date range description
 * - Elemental Properties: Element name with qualities description
 * - Planetary Influences: Primary and Shadow planets with archetypal descriptions
 * - Visual Icons: Emoji-based iconography for spiritual concepts
 * 
 * INTEGRATION POINTS:
 * - UserArchetype: Complete archetype data structure from calculation
 * - OnboardingView: Final step before main app access via isCompleted binding
 * - UserArchetypeManager: Source of calculated spiritual profile data
 * - NavigationView: Sheet presentation with toolbar "Done" button
 * 
 * STATE MANAGEMENT:
 * - archetype: UserArchetype data passed from BirthdateInputView
 * - isCompleted: Binding for onboarding completion control
 * - currentPage: State for potential future pagination
 * - showingDetails: State for expandable detail sections
 * 
 * VISUAL DESIGN ELEMENTS:
 * - Purple-Blue Gradient Theme: Consistent mystical color scheme
 * - Card-Based Layout: Clean information hierarchy with rounded rectangles
 * - Icon System: Emoji icons for spiritual concepts (♈🔥🪐🌙)
 * - Typography Hierarchy: Large life path number, structured detail text
 * - Master Number Badge: Special treatment for 11, 22, 33 life paths
 * 
 * ELEMENT-SPECIFIC STYLING:
 * - Fire: Red color, 🔥 icon
 * - Earth: Brown color, 🌍 icon  
 * - Air: Cyan color, 💨 icon
 * - Water: Blue color, 💧 icon
 * - Dynamic color theming based on user's calculated element
 * 
 * ONBOARDING COMPLETION FLOW:
 * - "Begin Your Journey" button triggers completeOnboarding()
 * - Haptic feedback provides tactile confirmation
 * - isCompleted binding set to true for navigation control
 * - dismiss() closes sheet and returns to onboarding coordinator
 * - User proceeds to main ContentView after completion
 * 
 * INFORMATION ARCHITECTURE:
 * 1. Header: Spiritual identity introduction with mystical styling
 * 2. Core Identity: Large life path number with quick summary grid
 * 3. Archetypal Components: Detailed cards for each spiritual element
 * 4. Action: Completion button to enter main app experience
 * 
 * PERFORMANCE NOTES:
 * - Static content display with minimal state management
 * - Efficient card rendering with reusable archetypeDetailCard function
 * - Optimized color and icon helper functions
 * - Clean memory management with proper binding usage
 * 
 * EDUCATIONAL VALUE:
 * - Explains spiritual concepts in accessible language
 * - Provides context for each archetypal component
 * - Builds user understanding of their mystical profile
 * - Prepares user for deeper app exploration
 */

//
//  ArchetypeDisplayView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

import SwiftUI

/**
 * View displaying the user's calculated spiritual archetype.
 *
 * This view presents the complete archetypal profile including life path,
 * zodiac sign, element, and planetary influences in an elegant, educational
 * format that helps the user understand their spiritual identity.
 */
struct ArchetypeDisplayView: View {
    // MARK: - Properties
    let archetype: UserArchetype
    @Binding var isCompleted: Bool
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentPage = 0
    @State private var showingDetails = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.1),
                        Color.blue.opacity(0.1),
                        Color.clear
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        headerSection
                        
                        // Core Identity Card
                        coreIdentityCard
                        
                        // Detailed Components
                        detailsSection
                        
                        // Action Button
                        actionButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Your Archetype")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        completeOnboarding()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Mystical icon with sparkle effect
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple.opacity(0.3), .blue.opacity(0.3)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(.purple)
            }
            
            Text("Your Spiritual Identity")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("A unique combination of ancient wisdom systems")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var coreIdentityCard: some View {
        VStack(spacing: 20) {
            // Life Path Number - Primary Identity
            VStack(spacing: 8) {
                Text("Life Path")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(1)
                
                Text("\(archetype.lifePath)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(.purple)
                
                if archetype.lifePath == 11 || archetype.lifePath == 22 || archetype.lifePath == 33 {
                    Text("Master Number")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.purple)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.purple.opacity(0.1))
                        )
                }
            }
            
            Divider()
            
            // Quick Summary
            VStack(spacing: 12) {
                quickInfoRow("♈", "Sign", archetype.zodiacSign.rawValue)
                quickInfoRow("🔥", "Element", archetype.element.rawValue.capitalized)
                quickInfoRow("🪐", "Primary Planet", archetype.primaryPlanet.rawValue.capitalized)
                quickInfoRow("🌙", "Shadow Planet", archetype.subconsciousPlanet.rawValue.capitalized)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private func quickInfoRow(_ icon: String, _ label: String, _ value: String) -> some View {
        HStack {
            Text(icon)
                .font(.title3)
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
    
    private var detailsSection: some View {
        VStack(spacing: 16) {
            Text("Archetypal Components")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                // Zodiac Detail
                archetypeDetailCard(
                    icon: "♈",
                    title: "Zodiac Sign",
                    subtitle: archetype.zodiacSign.rawValue,
                    description: archetype.zodiacSign.dateRange,
                    color: .orange
                )
                
                // Element Detail
                archetypeDetailCard(
                    icon: elementIcon(archetype.element),
                    title: "Element",
                    subtitle: archetype.element.rawValue.capitalized,
                    description: archetype.element.qualities,
                    color: elementColor(archetype.element)
                )
                
                // Primary Planet Detail
                archetypeDetailCard(
                    icon: "🪐",
                    title: "Primary Planet",
                    subtitle: archetype.primaryPlanet.rawValue.capitalized,
                    description: archetype.primaryPlanet.archetype,
                    color: .purple
                )
                
                // Subconscious Planet Detail
                archetypeDetailCard(
                    icon: "🌙",
                    title: "Shadow Planet",
                    subtitle: archetype.subconsciousPlanet.rawValue.capitalized,
                    description: archetype.subconsciousPlanet.archetype,
                    color: .indigo
                )
            }
        }
    }
    
    private func archetypeDetailCard(icon: String, title: String, subtitle: String, description: String, color: Color) -> some View {
        HStack(spacing: 16) {
            // Icon
            Text(icon)
                .font(.title2)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                )
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
                
                Text(subtitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
    
    private var actionButton: some View {
        Button(action: completeOnboarding) {
            HStack {
                Image(systemName: "checkmark")
                Text("Begin Your Journey")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: Color.purple.opacity(0.3), radius: 4, x: 0, y: 2)
        }
    }
    
    // MARK: - Helper Methods
    
    private func elementIcon(_ element: Element) -> String {
        switch element {
        case .fire: return "🔥"
        case .earth: return "🌍"
        case .air: return "💨"
        case .water: return "💧"
        }
    }
    
    private func elementColor(_ element: Element) -> Color {
        switch element {
        case .fire: return .red
        case .earth: return .brown
        case .air: return .cyan
        case .water: return .blue
        }
    }
    
    // MARK: - Actions
    
    private func completeOnboarding() {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Complete onboarding
        isCompleted = true
        dismiss()
    }
}

// MARK: - Preview

struct ArchetypeDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        let testArchetype = UserArchetype(
            lifePath: 7,
            zodiacSign: .gemini,
            element: .air,
            primaryPlanet: .neptune,
            subconsciousPlanet: .jupiter,
            calculatedDate: Date()
        )
        
        ArchetypeDisplayView(archetype: testArchetype, isCompleted: .constant(false))
    }
} 