// Managers/Services/InsightFilterService.swift
//  VybeMVP
//
//  Created by Gemini
//

import Foundation
import SwiftUI

/**
 * `InsightFilterService` is responsible for selecting the most relevant insight for a user
 * based on their `UserProfile` and a collection of `InsightTemplate`s.
 *
 * It loads insight templates from a JSON file, then filters and scores them
 * against the user's numerology, spiritual preferences, and focus areas.
 */
class InsightFilterService: ObservableObject {
    
    private static let insightTemplatesFilename = "personalized_insight_templates.json"
    
    @Published var templates: [InsightTemplate] = []
    @Published var isLoaded = false
    
    init() {
        Task {
            await loadInsightTemplates()
        }
    }
    
    /**
     * Loads `InsightTemplate` objects from the `personalized_insight_templates.json` file in the main bundle.
     */
    func loadInsightTemplates() async {
        guard let url = Bundle.main.url(forResource: Self.insightTemplatesFilename.replacingOccurrences(of: ".json", with: ""), withExtension: "json") else {
            print("Error: \(Self.insightTemplatesFilename) not found in bundle.")
            await MainActor.run {
                self.isLoaded = true
            }
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let loadedTemplates = try JSONDecoder().decode([InsightTemplate].self, from: data)
            await MainActor.run {
                self.templates = loadedTemplates
                self.isLoaded = true
            }
        } catch {
            print("Error decoding \(Self.insightTemplatesFilename): \(error)")
            await MainActor.run {
                self.templates = []
                self.isLoaded = true
            }
        }
    }
    
    /**
     * Generates today's personalized insight for the given user profile.
     */
    func generateTodaysInsight(for profile: UserProfile?) -> PersonalizedInsight? {
        return generateInsightForDate(Date(), userProfile: profile)
    }
    
    /**
     * Generates a personalized insight for a specific date.
     */
    func generateInsightForDate(_ date: Date, userProfile: UserProfile?) -> PersonalizedInsight? {
        guard let profile = userProfile else { return nil }
        
        if let preparedInsight = Self.getPersonalizedInsight(for: profile) {
            // Convert PreparedInsight to PersonalizedInsight
            let tags = generateTags(for: profile, source: preparedInsight.source ?? InsightSource(
                templateID: "fallback",
                matchedLifePath: profile.lifePathNumber,
                matchedSpiritualMode: profile.spiritualMode,
                matchedTone: profile.insightTone,
                matchedFocusTags: [],
                score: 0,
                isFallback: true
            ))
            let title = generateTitle(for: profile, date: date)
            let preview = String(preparedInsight.text.prefix(120)) + "..."
            
            // Get archetype information from UserArchetypeManager
            let archetype = UserArchetypeManager.shared.storedArchetype
            let archetypeContext = SimpleArchetypeContext(
                zodiacSign: archetype?.zodiacSign.rawValue ?? "Unknown",
                element: archetype?.element.rawValue ?? "Unknown", 
                primaryPlanet: archetype?.primaryPlanet.rawValue ?? "Unknown",
                lifePathNumber: profile.lifePathNumber
            )
            
            return PersonalizedInsight(
                title: title,
                content: preparedInsight.text,
                preview: preview,
                timestamp: date,
                tags: tags,
                focusNumber: profile.lifePathNumber,
                archetypeContext: archetypeContext
            )
        }
        
        return nil
    }
    
    /**
     * Generates appropriate tags for the insight based on the user profile and source.
     */
    private func generateTags(for profile: UserProfile, source: InsightSource) -> [String] {
        var tags: [String] = []
        
        // Add life path number tag
        tags.append("Life Path \(profile.lifePathNumber)")
        
        // Add spiritual mode
        tags.append(profile.spiritualMode)
        
        // Add insight tone
        tags.append(profile.insightTone)
        
        // Add zodiac if available from archetype
        if let archetype = UserArchetypeManager.shared.storedArchetype {
            tags.append(archetype.zodiacSign.rawValue.capitalized)
        }
        
        // Add matched focus tags from source
        tags.append(contentsOf: source.matchedFocusTags)
        
        return Array(Set(tags)).prefix(4).map { $0 } // Remove duplicates and limit to 4
    }
    
    /**
     * Generates an appropriate title for the insight based on the user profile and date.
     */
    private func generateTitle(for profile: UserProfile, date: Date) -> String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        let dayName = dayFormatter.string(from: date)
        
        let isToday = Calendar.current.isDate(date, inSameDayAs: Date())
        
        if isToday {
            return "Today's Spiritual Guidance"
        } else {
            return "\(dayName)'s Insight"
        }
    }

    // MARK: - Static Methods (Legacy Support)
    
    /**
     * Loads `InsightTemplate` objects from the `personalized_insight_templates.json` file in the main bundle.
     *
     * - Returns: An array of `InsightTemplate` objects, or `nil` if the file cannot be found or parsed.
     */
    private static func loadInsightTemplatesStatic() -> [InsightTemplate]? {
        guard let url = Bundle.main.url(forResource: insightTemplatesFilename.replacingOccurrences(of: ".json", with: ""), withExtension: "json") else {
            print("Error: \(insightTemplatesFilename) not found in bundle.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let templates = try JSONDecoder().decode([InsightTemplate].self, from: data)
            return templates
        } catch {
            print("Error decoding \(insightTemplatesFilename): \(error)")
            return nil
        }
    }
    
    /**
     * Calculates a match score for a given `InsightTemplate` against a `UserProfile`.
     *
     * - Parameters:
     *   - template: The `InsightTemplate` to score.
     *   - profile: The `UserProfile` to match against.
     * - Returns: A tuple containing the calculated score and an array of matched focus tags.
     */
    private static func calculateMatchScore(for template: InsightTemplate, profile: UserProfile) -> (score: Int, matchedTags: [String]) {
        var score = 0
        var matchedTags: [String] = []
        
        // Life Path Match (highest priority)
        if template.lifePath == profile.lifePathNumber {
            score += 5
        } else if profile.isMasterNumber {
            // For master numbers, check if the template's life path matches the sum of the digits of the master number.
            let reducedMasterNumber = String(profile.lifePathNumber).compactMap { Int(String($0)) }.reduce(0, +)
            if template.lifePath == reducedMasterNumber {
                 score += 3 // Lower score for reduced master number match
            }
        }
        
        // Spiritual Mode Match
        if template.spiritualMode.lowercased() == profile.spiritualMode.lowercased() {
            score += 3
        }
        
        // Insight Tone Match
        if template.tone.lowercased() == profile.insightTone.lowercased() {
            score += 2
        }
        
        // Focus Tags Match (match at least one)
        let userFocusTagsLowercased = Set(profile.focusTags.map { $0.lowercased() })
        let templateThemesLowercased = Set(template.themes.map { $0.lowercased() })
        
        let intersection = userFocusTagsLowercased.intersection(templateThemesLowercased)
        if !intersection.isEmpty {
            score += 2 * intersection.count // More points for more matching tags
            matchedTags.append(contentsOf: Array(intersection).map { $0.capitalized })
        }
        
        return (score, matchedTags)
    }
    
    /**
     * Selects the best `PreparedInsight` for the given `UserProfile` using a scoring system.
     * Implements a fallback strategy if no perfect match is found.
     *
     * - Parameter profile: The `UserProfile` for whom to generate the insight.
     * - Returns: An optional `PreparedInsight`. Returns `nil` if no templates are loaded or no suitable insight can be found even with fallbacks.
     */
    static func getPersonalizedInsight(for profile: UserProfile) -> PreparedInsight? {
        guard let templates = loadInsightTemplatesStatic(), !templates.isEmpty else {
            print("Error: Insight templates could not be loaded or are empty.")
            return nil
        }
        
        var bestMatch: (template: InsightTemplate, score: Int, matchedTags: [String])? = nil
        
        // Primary Matching: Score all templates
        for template in templates {
            let (currentScore, currentMatchedTags) = calculateMatchScore(for: template, profile: profile)
            
            if currentScore > 0 { // Only consider templates with some level of match
                if bestMatch == nil || currentScore > bestMatch!.score {
                    bestMatch = (template, currentScore, currentMatchedTags)
                } else if currentScore == bestMatch!.score {
                    // If scores are equal, prefer more matched tags or a random choice
                    if currentMatchedTags.count > bestMatch!.matchedTags.count {
                        bestMatch = (template, currentScore, currentMatchedTags)
                    } else if currentMatchedTags.count == bestMatch!.matchedTags.count && Bool.random() { // Random tie-breaker
                         bestMatch = (template, currentScore, currentMatchedTags)
                    }
                }
            }
        }
        
        if let chosenMatch = bestMatch, chosenMatch.score > 0 { // Ensure there's at least some positive score
            let source = InsightSource(
                templateID: chosenMatch.template.id,
                matchedLifePath: profile.lifePathNumber, // Log actual user LP
                matchedSpiritualMode: profile.spiritualMode,
                matchedTone: profile.insightTone,
                matchedFocusTags: chosenMatch.matchedTags,
                score: chosenMatch.score,
                isFallback: false
            )
            return PreparedInsight(date: Date(),
                                   lifePathNumber: profile.lifePathNumber,
                                   text: chosenMatch.template.text,
                                   source: source)
        } else {
            print("Warning: No suitable insight found for the user profile after scoring. Attempting fallback...")
            // Fallback: Try to find a template matching at least the Life Path Number
            if let fallbackTemplate = templates.first(where: { $0.lifePath == profile.lifePathNumber }) ?? templates.randomElement() {
                 let source = InsightSource(
                    templateID: fallbackTemplate.id,
                    matchedLifePath: profile.lifePathNumber,
                    matchedSpiritualMode: "N/A (Fallback)",
                    matchedTone: "N/A (Fallback)",
                    matchedFocusTags: [],
                    score: 0,
                    isFallback: true
                )
                print("   Fallback insight selected: Template ID '\(fallbackTemplate.id)' for Life Path \(profile.lifePathNumber)")
                return PreparedInsight(date: Date(), lifePathNumber: profile.lifePathNumber, text: fallbackTemplate.text, source: source)
            } else {
                print("Error: Fallback failed. No insight templates available at all.")
            }
            return nil
        }
    }
} 
