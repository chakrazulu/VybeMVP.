// Core/Models/InsightTemplate.swift
//  VybeMVP
//
//  Created by Gemini
//

import Foundation

/**
 * Represents a single template for a personalized insight, decoded from `personalized_insight_templates.json`.
 *
 * This structure holds all the necessary metadata to filter and select insights
 * based on the user's profile.
 */
struct InsightTemplate: Codable, Identifiable {
    /// A unique identifier for the insight template (e.g., "lp7-reflection-poetic-creativity-001").
    let id: String

    /// The Life Path Number this insight is primarily associated with.
    /// Can be a regular number (1-9) or a Master Number (11, 22, 33).
    let lifePath: Int

    /// The spiritual mode this insight aligns with (e.g., "Reflection", "Manifestation").
    /// This should match one of the `spiritualModeOptions` from `OnboardingViewModel`.
    let spiritualMode: String

    /// The preferred communication tone for this insight (e.g., "Poetic", "Direct").
    /// This should match one of the `insightToneOptions` from `OnboardingViewModel`.
    let tone: String

    /// An array of themes or focus tags associated with this insight (e.g., ["Creativity", "Purpose"]).
    /// These are matched against the user's `focusTags` from `UserProfile`.
    let themes: [String]

    /// The actual textual content of the insight.
    let text: String
}
