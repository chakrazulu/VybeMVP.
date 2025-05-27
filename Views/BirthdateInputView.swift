//
//  BirthdateInputView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

import SwiftUI

/**
 * Onboarding view for collecting user's birthdate to calculate spiritual archetype.
 *
 * This view is part of the onboarding flow and appears before the user
 * sees their first insight. It collects the birthdate and triggers the
 * UserArchetypeManager to generate the complete spiritual profile.
 */
struct BirthdateInputView: View {
    // MARK: - Properties
    @StateObject private var archetypeManager = UserArchetypeManager.shared
    @State private var selectedDate = Date()
    @State private var isProcessing = false
    @State private var showingArchetype = false
    @State private var calculatedArchetype: UserArchetype?
    
    // Binding for navigation control
    @Binding var isCompleted: Bool
    
    // Date range constraints (reasonable birth year range)
    private let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 1900, month: 1, day: 1)) ?? Date()
        let endDate = Date()
        return startDate...endDate
    }()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                headerSection
                
                // Date Picker
                datePickerSection
                
                // Explanation
                explanationSection
                
                // Continue Button
                continueButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(Color(UIColor.systemBackground))
        .navigationTitle("Your Spiritual Identity")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingArchetype) {
            if let archetype = calculatedArchetype {
                ArchetypeDisplayView(archetype: archetype, isCompleted: $isCompleted)
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Mystical icon
            Image(systemName: "sparkles")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(.purple)
            
            Text("When were you born?")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text("Your birthdate holds the key to your spiritual archetype—a unique combination of numerology, astrology, and elemental wisdom.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
        .padding(.top, 20)
    }
    
    private var datePickerSection: some View {
        VStack(spacing: 20) {
            // Show selected date clearly
            VStack(spacing: 8) {
                Text("Selected Date")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(1)
                
                Text(selectedDate, style: .date)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.purple.opacity(0.1))
                            .overlay(
                                Capsule()
                                    .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
            
            DatePicker(
                "Birth Date",
                selection: $selectedDate,
                in: dateRange,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
            .onChange(of: selectedDate) { oldValue, newValue in
                // Provide haptic feedback when date changes
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                
                // Debug: Log the selected date
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                print("📅 User selected new date: \(formatter.string(from: newValue))")
            }
        }
    }
    
    private var explanationSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                Text("What we'll calculate:")
                    .font(.headline)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                archetypeElement("📊", "Life Path Number", "Your core numerological identity")
                archetypeElement("♈", "Zodiac Sign", "Your astrological archetype")
                archetypeElement("🔥", "Element", "Fire, Earth, Air, or Water alignment")
                archetypeElement("🪐", "Planetary Influences", "Conscious and subconscious guides")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private func archetypeElement(_ icon: String, _ title: String, _ description: String) -> some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.title3)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
    
    private var continueButton: some View {
        Button(action: calculateArchetype) {
            HStack {
                if isProcessing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "sparkles")
                }
                
                Text(isProcessing ? "Calculating..." : "Reveal My Archetype")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .disabled(isProcessing)
        .scaleEffect(isProcessing ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isProcessing)
        .padding(.top, 20)
        .onAppear {
            print("🔵 Reveal My Archetype button is rendered and visible")
        }
    }
    
    // MARK: - Actions
    
    private func calculateArchetype() {
        isProcessing = true
        
        // Debug: Show what date we're calculating
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        print("🎂 Calculating archetype for birthdate: \(formatter.string(from: selectedDate))")
        
        // Also show what was previously stored (if anything)
        if let previousArchetype = archetypeManager.storedArchetype {
            print("📦 Previous stored archetype: Life Path \(previousArchetype.lifePath), calculated on \(previousArchetype.calculatedDate)")
        } else {
            print("📦 No previous archetype stored")
        }
        
        // Add a small delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Calculate archetype
            let archetype = archetypeManager.calculateArchetype(from: selectedDate)
            
            // Debug: Show what was calculated and stored
            print("✅ New archetype calculated and stored:")
            print("   Life Path: \(archetype.lifePath)")
            print("   Zodiac: \(archetype.zodiacSign.rawValue)")
            print("   Element: \(archetype.element.rawValue)")
            print("   Calculated Date: \(archetype.calculatedDate)")
            
            // Store for display
            calculatedArchetype = archetype
            
            // Hide processing and show archetype
            isProcessing = false
            showingArchetype = true
            
            // Post notification for onboarding flow (if we're in onboarding)
            NotificationCenter.default.post(
                name: .archetypeCalculated,
                object: archetype
            )
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }
}

// MARK: - Preview

struct BirthdateInputView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdateInputView(isCompleted: .constant(false))
    }
} 