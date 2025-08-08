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
    // Data passed from the tapped notification
    let matchNumber: Int
    let categoryName: String
    let messageContent: String
    
    /// Optional callback when user dismisses the view
    var onDismiss: (() -> Void)?
    
    // Claude: Updated to use SwiftData SpiritualDataController instead of NumberMeaningManager
    @EnvironmentObject private var spiritualDataController: SpiritualDataController 

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Display the number and category from the notification
                Text("Number \(matchNumber): \(categoryName)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Divider
                Divider().padding(.vertical)
                
                // Display the specific message content from the notification
                Text(messageContent)
                    .font(.body)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                
                // TODO: Implement async NumberMeaning loading with SwiftData
                // Optional: Keep the "About Number" section using spiritualDataController
                // Note: getNumberMeaning is async, need to restructure this section
                /*
                if let meaning = await spiritualDataController.getNumberMeaning(matchNumber) {
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
                */
                
                // Action buttons (These might need context later)
                MatchActionButtons(matchNumber: matchNumber)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Numerology Insight") // Updated title
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
        // Provide sample data for the preview
        NumberMatchNotificationView(
            matchNumber: 7,
            categoryName: "Insight",
            messageContent: "This is a sample insight message for number 7. Embrace introspection and seek deeper truths today. Solitude can be a powerful teacher."
        )
    }
} 