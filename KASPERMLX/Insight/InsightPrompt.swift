//
//  InsightPrompt.swift
//  VybeMVP
//
//  Created by Claude on 1/24/25.
//  Purpose: Normalized prompt structure for LLM consumption
//  Part of Phase 2B Living Insight Engine
//

import Foundation

/// Normalized, prompt-ready view of InsightContext for LLM consumption
/// Contains only the data needed for insight generation without PII
public struct InsightPrompt: Sendable, Codable {
    // MARK: - Numerology
    public let focusNumber: Int
    public let realmNumber: Int
    public let lifePathNumber: Int
    public let expressionNumber: Int
    public let soulUrgeNumber: Int

    // MARK: - Planetary (from SwiftAAPlanetaryService)
    public let currentTransits: [String]        // e.g., ["Mars sextile Sun", "Moon square Venus"]
    public let rulingPlanet: String             // e.g., "Jupiter"
    public let lunarPhase: String               // e.g., "Waxing Gibbous"
    public let sunSign: String                  // Current sun sign
    public let moonSign: String                 // Current moon sign
    public let retrogrades: [String]            // Planets in retrograde

    // MARK: - User State (privacy-safe)
    public let recentJournalThemes: [String]    // Distilled keywords, no raw text
    public let meditationStreakDays: Int
    public let activeIntentions: [String]       // Sanctum intentions (sanitized)
    public let currentMode: String              // "home", "meditation", "journal"
    public let locale: String                   // "en-US" for stylistic tone
    public let persona: String                  // "Oracle", "Coach", "Psychologist", etc.

    // MARK: - Generation Constraints
    public let maxSentences: Int
    public let temperature: Double              // 0.5-0.7 for consistency
    public let includeAffirmation: Bool
    public let focusArea: FocusArea?

    public enum FocusArea: String, Codable, Sendable {
        case relationships = "relationships"
        case career = "career"
        case spiritual = "spiritual"
        case health = "health"
        case shadow = "shadow"
        case growth = "growth"
    }

    public init(focusNumber: Int, realmNumber: Int, lifePathNumber: Int, expressionNumber: Int, soulUrgeNumber: Int, currentTransits: [String], rulingPlanet: String, lunarPhase: String, sunSign: String, moonSign: String, retrogrades: [String], recentJournalThemes: [String], meditationStreakDays: Int, activeIntentions: [String], currentMode: String, locale: String, persona: String, maxSentences: Int, temperature: Double, includeAffirmation: Bool, focusArea: FocusArea?) {
        self.focusNumber = focusNumber
        self.realmNumber = realmNumber
        self.lifePathNumber = lifePathNumber
        self.expressionNumber = expressionNumber
        self.soulUrgeNumber = soulUrgeNumber
        self.currentTransits = currentTransits
        self.rulingPlanet = rulingPlanet
        self.lunarPhase = lunarPhase
        self.sunSign = sunSign
        self.moonSign = moonSign
        self.retrogrades = retrogrades
        self.recentJournalThemes = recentJournalThemes
        self.meditationStreakDays = meditationStreakDays
        self.activeIntentions = activeIntentions
        self.currentMode = currentMode
        self.locale = locale
        self.persona = persona
        self.maxSentences = maxSentences
        self.temperature = temperature
        self.includeAffirmation = includeAffirmation
        self.focusArea = focusArea
    }
}

// MARK: - Prompt Mapper

/// Maps InsightContext to InsightPrompt, handling privacy and normalization
@MainActor
struct PromptMapper {

    /// Convert full context to prompt-ready format
    func makePrompt(from context: InsightContext,
                   persona: String = "Oracle",
                   maxSentences: Int = 4) -> InsightPrompt {

        // Extract transit descriptions
        let transits = context.aspects.map { aspect in
            "\(aspect.planet1) \(aspect.aspectType) \(aspect.planet2)"
        }

        // Determine ruling planet based on sun sign
        let rulingPlanet = getRulingPlanet(for: context.sunSign)

        // Sanitize recent activity to themes
        let themes = extractThemes(from: context.recentActivity)

        // Extract active intentions (privacy-safe)
        let intentions = extractIntentions(from: context)

        return InsightPrompt(
            focusNumber: context.focus,
            realmNumber: context.realm,
            lifePathNumber: context.lifePath,
            expressionNumber: context.expression,
            soulUrgeNumber: context.soulUrge,
            currentTransits: transits,
            rulingPlanet: rulingPlanet,
            lunarPhase: context.moonPhase,
            sunSign: context.sunSign,
            moonSign: context.moonSign,
            retrogrades: context.retrogrades,
            recentJournalThemes: themes,
            meditationStreakDays: calculateMeditationStreak(context),
            activeIntentions: intentions,
            currentMode: context.mode.rawValue,
            locale: Locale.current.identifier,
            persona: persona,
            maxSentences: maxSentences,
            temperature: 0.7,
            includeAffirmation: shouldIncludeAffirmation(context.mode),
            focusArea: determineFocusArea(from: context)
        )
    }

    // MARK: - Private Helpers

    private func getRulingPlanet(for sign: String) -> String {
        switch sign.lowercased() {
        case "aries": return "Mars"
        case "taurus": return "Venus"
        case "gemini": return "Mercury"
        case "cancer": return "Moon"
        case "leo": return "Sun"
        case "virgo": return "Mercury"
        case "libra": return "Venus"
        case "scorpio": return "Pluto"
        case "sagittarius": return "Jupiter"
        case "capricorn": return "Saturn"
        case "aquarius": return "Uranus"
        case "pisces": return "Neptune"
        default: return "Sun"
        }
    }

    private func extractThemes(from activities: [String]) -> [String] {
        // Extract themes without exposing actual journal content
        var themes: Set<String> = []

        for activity in activities {
            if activity.contains("journal") {
                themes.insert("reflection")
            }
            if activity.contains("meditation") {
                themes.insert("mindfulness")
            }
            if activity.contains("social") {
                themes.insert("connection")
            }
            if activity.contains("chakra") {
                themes.insert("energy")
            }
        }

        return Array(themes).prefix(5).map { $0 }
    }

    private func extractIntentions(from context: InsightContext) -> [String] {
        // Return generic intentions based on numerology
        // Never expose actual user-written intentions
        var intentions: [String] = []

        if context.lifePath == 1 {
            intentions.append("Leadership and independence")
        }
        if context.soulUrge == 2 {
            intentions.append("Harmony and partnership")
        }
        if context.expression == 3 {
            intentions.append("Creative expression")
        }

        return intentions.prefix(3).map { $0 }
    }

    private func calculateMeditationStreak(_ context: InsightContext) -> Int {
        // Calculate based on recent activity
        let meditationCount = context.recentActivity.filter {
            $0.contains("meditation")
        }.count
        return min(meditationCount, 30) // Cap at 30 for privacy
    }

    private func shouldIncludeAffirmation(_ mode: UserMode) -> Bool {
        switch mode {
        case .meditate, .journal, .reflect:
            return true
        default:
            return false
        }
    }

    private func determineFocusArea(from context: InsightContext) -> InsightPrompt.FocusArea? {
        // Determine based on recent activity patterns
        let activities = context.recentActivity.joined(separator: " ").lowercased()

        if activities.contains("relationship") || activities.contains("friend") {
            return .relationships
        }
        if activities.contains("work") || activities.contains("career") {
            return .career
        }
        if activities.contains("meditation") || activities.contains("chakra") {
            return .spiritual
        }
        if activities.contains("health") || activities.contains("wellness") {
            return .health
        }

        return nil
    }
}

// MARK: - Privacy Extensions

extension InsightPrompt {
    /// Redact any potentially identifying information before cloud transmission
    func redacted() -> InsightPrompt {
        return InsightPrompt(
            focusNumber: focusNumber,
            realmNumber: realmNumber,
            lifePathNumber: lifePathNumber,
            expressionNumber: expressionNumber,
            soulUrgeNumber: soulUrgeNumber,
            currentTransits: currentTransits,
            rulingPlanet: rulingPlanet,
            lunarPhase: lunarPhase,
            sunSign: sunSign,
            moonSign: moonSign,
            retrogrades: retrogrades,
            recentJournalThemes: recentJournalThemes.map { _ in "theme" },
            meditationStreakDays: meditationStreakDays,
            activeIntentions: activeIntentions.map { _ in "intention" },
            currentMode: currentMode,
            locale: Locale.current.language.languageCode?.identifier ?? "en",
            persona: persona,
            maxSentences: maxSentences,
            temperature: temperature,
            includeAffirmation: includeAffirmation,
            focusArea: focusArea
        )
    }

    /// Check if prompt contains any PII
    var containsPII: Bool {
        // Check for patterns that might indicate PII
        let allText = (recentJournalThemes + activeIntentions).joined()

        // Simple PII detection patterns
        let patterns = [
            #"\b[A-Z][a-z]+ [A-Z][a-z]+\b"#,  // Names
            #"\b\d{3}-\d{3}-\d{4}\b"#,         // Phone numbers
            #"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b"# // Emails
        ]

        for pattern in patterns {
            if allText.range(of: pattern, options: .regularExpression) != nil {
                return true
            }
        }

        return false
    }
}
