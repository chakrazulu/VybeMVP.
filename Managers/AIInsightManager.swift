// Managers/AIInsightManager.swift
// VybeMVP
//
// Created by Gemini
//

import Foundation
import Combine

/**
 * `AIInsightManager` is an ObservableObject responsible for orchestrating the generation
 * and provision of personalized insights for the user.
 *
 * It uses the user's `UserProfile` and the `InsightFilterService` to select
 * an appropriate daily insight. Views can observe this manager to display
 * the latest insight.
 */
class AIInsightManager: ObservableObject {
    
    /// Shared singleton instance for easy access throughout the app.
    static let shared = AIInsightManager()
    
    /// The currently prepared personalized insight for the user.
    /// Views should observe this property to display the insight.
    @Published var personalizedDailyInsight: PreparedInsight?
    
    /// A boolean flag indicating whether a personalized insight is ready to be displayed.
    @Published var isInsightReady: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    /// Private initializer to enforce singleton pattern.
    private init() {
        // Potential future use: Load last known insight from cache, etc.
    }
    
    /**
     * Configures the manager with the user's profile and attempts to generate a personalized insight.
     *
     * This method should be called after the user's profile is available (e.g., after login or onboarding).
     * It uses the `InsightFilterService` to find the best matching insight.
     *
     * - Parameter profile: The `UserProfile` object for the current user.
     */
    func configureAndRefreshInsight(for profile: UserProfile) {
        print("AIInsightManager: Configuring and refreshing insight for user ID \(profile.id)...")
        
        if let insight = InsightFilterService.getPersonalizedInsight(for: profile) {
            self.personalizedDailyInsight = insight
            self.isInsightReady = true
            print("✨ Personalized insight prepared: \"\(insight.text.prefix(70))...\"")
            if let source = insight.source {
                print("   Source Details - Template ID: '\(source.templateID)', Score: \(source.score), Matched Tags: \(source.matchedFocusTags.joined(separator: ", ")), Fallback: \(source.isFallback)")
            }
        } else {
            self.personalizedDailyInsight = nil // Clear any old insight
            self.isInsightReady = false
            print("😔 AIInsightManager: Could not prepare a personalized insight for the current profile.")
        }
    }
    
    /**
     * Clears the current personalized insight.
     * Call this on user logout, for example.
     */
    func clearInsight() {
        self.personalizedDailyInsight = nil
        self.isInsightReady = false
        print("AIInsightManager: Cleared personalized insight.")
    }
} 