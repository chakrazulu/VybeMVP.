/**
 * Filename: NumberMatchNotificationView.swift
 * 
 * Purpose: Displays detailed information about a number match notification.
 * Shows the matched number, insight title, detailed explanation, and provides
 * actions for the user to take based on the match.
 *
 * Key components:
 * - NumberMatchNotificationView: Main view for displaying match details
 * - MatchHeaderView: Header component showing the matched number and title
 * - MatchActionButtons: Action buttons for user response to the match
 *
 * Dependencies: SwiftUI, Core/Models/NumberMatchInsight
 */

import SwiftUI

/**
 * View for displaying detailed information about a number match notification
 *
 * This view is shown when a user taps on a number match notification or
 * navigates to view details of a previous match. It provides a rich explanation
 * of the significance of the match and offers actions the user can take.
 */
struct NumberMatchNotificationView: View {
    /// The number that matched (focus = realm)
    let matchNumber: Int
    
    /// Optional callback when user dismisses the view
    var onDismiss: (() -> Void)?
    
    /// Access to insights via the manager
    private let insightManager = NumberMatchInsightManager.shared
    
    /// Access to number meanings via the manager
    private let meaningManager = NumberMeaningManager.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with match number and title
                let insight = insightManager.getInsight(for: matchNumber)
                MatchHeaderView(insight: insight)
                
                // Divider with quote style
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.secondary.opacity(0.3))
                    
                    Image(systemName: "quote.opening")
                        .foregroundColor(.secondary)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.secondary.opacity(0.3))
                }
                .padding(.vertical)
                
                // Detailed insight text
                Text(insight.detailedInsight)
                    .font(.body)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                
                // Number meaning section
                if let meaning = meaningManager.getMeaning(for: matchNumber) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About Number \(matchNumber)")
                            .font(.headline)
                            .padding(.top)
                        
                        HStack(alignment: .top) {
                            Text("\(matchNumber)")
                                .font(.system(size: 42, weight: .bold))
                                .foregroundColor(.primary.opacity(0.8))
                                .frame(width: 60)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(meaning.title)
                                    .font(.title3)
                                    .bold()
                                
                                Text(meaning.essence)
                                    .font(.subheadline)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.secondary.opacity(0.1))
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Action buttons
                MatchActionButtons(matchNumber: matchNumber)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Number Match")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    onDismiss?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

/**
 * Header component for the match notification view
 *
 * Displays the match number and insight title prominently at the top of the view.
 */
struct MatchHeaderView: View {
    let insight: NumberMatchInsight
    
    var body: some View {
        VStack(spacing: 16) {
            // Match number display
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.7), .purple.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Text("\(insight.matchNumber)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 8)
            
            // Match title
            Text(insight.title)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            
            // Match summary
            Text(insight.summary)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

/**
 * Action buttons for responding to a number match
 *
 * Provides options for users to respond to a match notification, such as
 * creating a journal entry, sharing the insight, or setting a reminder.
 */
struct MatchActionButtons: View {
    let matchNumber: Int
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Actions")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Journal button
            ActionButton(
                title: "Create Journal Entry",
                icon: "square.and.pencil",
                color: .blue
            ) {
                // TODO: Navigate to journal creation with prefilled match info
                print("Create journal for match \(matchNumber)")
            }
            
            // Share button
            ActionButton(
                title: "Share This Insight",
                icon: "square.and.arrow.up",
                color: .green
            ) {
                // TODO: Implement sharing functionality
                print("Share match \(matchNumber)")
            }
            
            // Reminder button
            ActionButton(
                title: "Set a Reminder",
                icon: "bell",
                color: .orange
            ) {
                // TODO: Implement reminder setting
                print("Set reminder for match \(matchNumber)")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.1))
        )
        .padding(.horizontal)
    }
}

/**
 * Reusable action button component
 *
 * Used for the different actions a user can take from the match notification view.
 */
struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color)
                    )
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.footnote)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.7))
            )
        }
    }
}

#Preview {
    NavigationView {
        NumberMatchNotificationView(matchNumber: 7)
    }
} 