// Core/Models/PreparedInsight.swift
//  VybeMVP
//
//  Created by Gemini
//

import Foundation

/**
 * Represents a fully prepared insight ready for display to the user.
 *
 * This object is the result of filtering and selection logic from `InsightFilterService`
 * and includes the insight text along with contextual information like the date it was prepared for,
 * the relevant Life Path Number, and eventually, cosmic data like moon phase.
 */
struct PreparedInsight: Identifiable {
    /// Unique identifier for this instance of a prepared insight.
    let id = UUID()
    
    /// The date for which this insight is relevant (typically the current day).
    let date: Date
    
    /// The Life Path Number of the user for whom this insight was prepared.
    /// This helps in contextualizing or displaying information related to the insight.
    let lifePathNumber: Int
    
    /// The actual text of the insight to be displayed to the user.
    let text: String
    
    /// The current moon phase when this insight was generated (to be integrated later).
    /// Defaults to `.unknown` until `CosmicService` is implemented.
    var moonPhase: MoonPhase = .unknown // Assuming a MoonPhase enum will be created
    
    /// Optional: Information about how this insight was selected (for logging or AI training).
    var source: InsightSource?
}

/**
 * Enum to represent different moon phases.
 * This will be used by `CosmicService` and populated in `PreparedInsight`.
 */
enum MoonPhase: String, Codable {
    case newMoon = "New Moon"
    case waxingCrescent = "Waxing Crescent"
    case firstQuarter = "First Quarter"
    case waxingGibbous = "Waxing Gibbous"
    case fullMoon = "Full Moon"
    case waningGibbous = "Waning Gibbous"
    case lastQuarter = "Last Quarter"
    case waningCrescent = "Waning Crescent"
    case unknown = "Unknown"
}

/**
 * Optional: Structure to log the source and matching criteria for a `PreparedInsight`.
 *
 * This is not for display to the user but can be invaluable for debugging,
 * analytics, and future AI model training to understand why certain insights were chosen.
 */
struct InsightSource: Codable {
    /// The ID of the `InsightTemplate` that was used.
    let templateID: String
    
    /// The user's Life Path Number that was matched.
    let matchedLifePath: Int
    
    /// The user's spiritual mode that was matched.
    let matchedSpiritualMode: String
    
    /// The user's insight tone that was matched.
    let matchedTone: String
    
    /// The specific focus tags from the user's profile that intersected with the template's themes.
    let matchedFocusTags: [String]
    
    /// The calculated match score for this template against the user's profile.
    let score: Int
    
    /// Indicates if this insight was chosen as part of a fallback strategy.
    let isFallback: Bool
} 