/**
 * Filename: RealmNumberView.swift
 * 
 * Purpose: Displays the current realm number and provides context about what it represents.
 * The realm number is a cosmic/universal numerical value that changes based on time, date,
 * location, and heart rate factors.
 *
 * Design pattern: Declarative SwiftUI view
 * Dependencies: RealmNumberManager for data access
 */

import SwiftUI

/**
 * View that displays and explains the current realm number.
 *
 * The realm number is a central concept in the application, representing a
 * universal numerical value that users can match with their focus number.
 * This view visually presents that number along with explanatory information.
 *
 * Key features:
 * 1. Prominently displays the current realm number in a visually appealing format
 * 2. Provides a thematic description for the current realm number
 * 3. Explains the factors that contribute to realm number calculation
 */
struct RealmNumberView: View {
    /// Access to the realm number manager for the current realm number value
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Realm Number")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            ZStack {
                // Background circle with gradient
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.8),
                                Color.blue.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                // Number display
                Text("\(realmNumberManager.currentRealmNumber)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 2)
            }
            
            // Realm description
            Text(getRealmDescription())
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Additional info card
            VStack(alignment: .leading, spacing: 12) {
                Text("About Realm Numbers")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Your Realm Number is calculated using:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 20) {
                    VStack {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        Text("Time")
                            .font(.caption)
                    }
                    
                    VStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.purple)
                        Text("Date")
                            .font(.caption)
                    }
                    
                    VStack {
                        Image(systemName: "location")
                            .foregroundColor(.green)
                        Text("Location")
                            .font(.caption)
                    }
                    
                    VStack {
                        Image(systemName: "heart")
                            .foregroundColor(.red)
                        Text("BPM")
                            .font(.caption)
                    }
                }
                .padding(.top, 4)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 40)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
    
    /**
     * Returns a descriptive name for the current realm number.
     *
     * Each realm number (1-9) corresponds to a thematic concept:
     * 1: Creation - 2: Partnership - 3: Expression - 4: Foundation
     * 5: Freedom - 6: Harmony - 7: Spirituality - 8: Abundance - 9: Completion
     *
     * - Returns: A string description of the current realm number
     */
    private func getRealmDescription() -> String {
        let descriptions = [
            "Realm of Creation",
            "Realm of Partnership",
            "Realm of Expression",
            "Realm of Foundation",
            "Realm of Freedom",
            "Realm of Harmony",
            "Realm of Spirituality",
            "Realm of Abundance",
            "Realm of Completion"
        ]
        
        let index = max(0, min(realmNumberManager.currentRealmNumber - 1, descriptions.count - 1))
        return descriptions[index]
    }
}

#Preview {
    RealmNumberView()
        .environmentObject(RealmNumberManager())
} 
