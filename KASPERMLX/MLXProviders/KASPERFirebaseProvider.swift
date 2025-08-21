//
//  KASPERFirebaseProvider.swift
//  VybeMVP
//
//  🔥 KASPER FIREBASE PROVIDER - Live Insights Integration
//  Created: August 19, 2025
//
//  Integrates 9,900+ Firebase insights (6,600 original + 300 enhanced) with KASPER AI.
//  Provides authentic spiritual content for diverse, natural-feeling guidance.
//  Bridges Firebase insights with KASPER orchestrator for comprehensive spiritual experiences.
//

import Foundation
import os.log

/**
 * 🔥 KASPER FIREBASE PROVIDER - Live Spiritual Content
 *
 * Provides KASPER with access to 9,900+ Firebase insights for authentic spiritual guidance.
 * Replaces template-heavy responses with real, enhanced spiritual content.
 *
 * ARCHITECTURE:
 * • Async integration with FirebaseInsightRepository
 * • Context-aware insight selection based on user's spiritual state
 * • Planetary aspect integration for cosmic snapshots
 * • Smart fallback system when Firebase insights unavailable
 * • High confidence scoring due to A+ quality content
 *
 * INTEGRATION BENEFITS:
 * • Eliminates template-heavy KASPER responses
 * • Provides diverse, authentic spiritual guidance
 * • Enhances match notification insights
 * • Supports cosmic timing and astrological context
 * • Enables sophisticated spiritual AI experiences
 */
@MainActor
public class KASPERFirebaseProvider: KASPERInferenceProvider {

    // MARK: - Properties

    public let name = "FirebaseKASPER"
    public let description = "Live Firebase insights with spiritual authenticity"
    public let averageConfidence = 0.90  // High confidence due to A+ quality content

    private let logger = Logger(subsystem: "com.vybe.kasper", category: "FirebaseProvider")

    // Firebase integration
    private let firebaseRepository = FirebaseInsightRepository()

    // Context mapping for Firebase requests
    private let contextMapping: [String: FirebaseInsightContext] = [
        "lifepath": .daily,
        "expression": .daily,
        "soulurge": .daily,
        "dailycard": .daily,
        "sanctum": .evening,
        "cosmictiming": .daily,
        "crisis": .crisis,
        "celebration": .celebration,
        "morning": .morning,
        "evening": .evening
    ]

    // MARK: - Initialization

    public init() {
        logger.info("🔥 Firebase KASPER Provider initialized")
    }

    // MARK: - KASPERInferenceProvider

    public var isAvailable: Bool {
        // Always available due to Firebase reliability
        true
    }

    public func generateInsight(
        context: String,
        focus: Int,
        realm: Int,
        extras: [String: Any]
    ) async throws -> String {

        logger.info("🔥 Generating Firebase insight - Context: \\(context), Focus: \\(focus), Realm: \\(realm)")

        // Determine which number to use for Firebase query
        let primaryNumber = selectPrimaryNumber(focus: focus, realm: realm, context: context)

        // Map context to Firebase context
        let firebaseContext = contextMapping[context.lowercased()] ?? .daily

        do {
            // Try to get insight from Firebase
            let insight = try await fetchFirebaseInsight(
                number: primaryNumber,
                context: firebaseContext,
                originalContext: context
            )

            if let insight = insight {
                // Enhance with planetary aspects if applicable
                let enhancedInsight = await enhanceWithPlanetaryAspects(
                    baseInsight: insight,
                    focus: focus,
                    realm: realm,
                    extras: extras
                )

                logger.info("🔥 Firebase insight delivered: \\(enhancedInsight.prefix(50))...")
                return enhancedInsight
            }

        } catch {
            logger.error("❌ Firebase insight fetch failed: \\(error.localizedDescription)")
        }

        // Fallback to contextual template
        logger.info("🔄 Using contextual fallback for \\(context)")
        return generateContextualFallback(context: context, focus: focus, realm: realm)
    }

    // MARK: - Firebase Integration

    /**
     * Fetch insight from Firebase based on context and number
     */
    private func fetchFirebaseInsight(
        number: Int,
        context: FirebaseInsightContext,
        originalContext: String
    ) async throws -> String? {

        // Determine appropriate Firebase request type based on context
        let requestType: FirebaseInsightType
        let category: FirebaseInsightCategory

        switch originalContext.lowercased() {
        case "dailycard":
            requestType = .dailyCard
            category = .insight
        case "sanctum":
            requestType = .sanctum
            category = .reflection
        case "cosmictiming":
            requestType = .cosmicHUD
            category = .astrological
        case "crisis":
            requestType = .general
            category = .challenge
        case "celebration":
            requestType = .general
            category = .manifestation
        default:
            requestType = .general
            category = .insight
        }

        // Fetch from Firebase
        let request = FirebaseInsightRequest(
            type: requestType,
            number: number,
            category: category,
            context: context,
            limit: 5  // Get multiple options for variety
        )

        let insights = try await firebaseRepository.fetchInsights(for: request)
        return insights.randomElement()?.text
    }

    /**
     * Select which number to use as primary for Firebase query
     */
    private func selectPrimaryNumber(focus: Int, realm: Int, context: String) -> Int {
        switch context.lowercased() {
        case "lifepath", "expression", "soulurge":
            // Life path contexts prefer focus number
            return focus
        case "cosmictiming", "sanctum":
            // Cosmic contexts prefer realm number
            return realm
        case "dailycard":
            // Daily cards can use either - prefer focus for personalization
            return focus
        default:
            // For match notifications, use the matching number
            if focus == realm {
                return focus
            }
            // Otherwise prefer focus for personalization
            return focus
        }
    }

    /**
     * Enhance base insight with planetary aspects for cosmic context
     */
    private func enhanceWithPlanetaryAspects(
        baseInsight: String,
        focus: Int,
        realm: Int,
        extras: [String: Any]
    ) async -> String {

        // Check if cosmic enhancement is requested
        guard let cosmicEnhancement = extras["cosmic_enhancement"] as? Bool,
              cosmicEnhancement else {
            return baseInsight
        }

        // Get current planetary aspects if available
        await CosmicService.shared.fetchTodaysCosmicData()

        guard let cosmic = CosmicService.shared.todaysCosmic,
              let keyAspect = cosmic.getTodaysKeyAspect() else {
            return baseInsight
        }

        // Add planetary context to the insight
        let planetaryAddition = "The \\(keyAspect.aspectType.rawValue) between \\(keyAspect.planet1.name) and \\(keyAspect.planet2.name) amplifies this energy today."

        return "\\(baseInsight) \\(planetaryAddition)"
    }

    /**
     * Generate contextual fallback when Firebase unavailable
     */
    private func generateContextualFallback(context: String, focus: Int, realm: Int) -> String {
        switch context.lowercased() {
        case "lifepath":
            return "Your spiritual path resonates with number \\(focus), guiding you through profound transformation today."
        case "expression":
            return "Express your authentic \\(focus) energy while embracing the wisdom of \\(realm) for balanced growth."
        case "soulurge":
            return "Your soul's deepest calling aligns with \\(focus) energy, creating sacred opportunities for spiritual evolution."
        case "dailycard":
            return "Today's spiritual focus on \\(focus) brings clarity and purpose to your journey."
        case "sanctum":
            return "In your sacred space, reflect on how \\(focus) and \\(realm) energies create inner harmony."
        case "cosmictiming":
            return "The cosmic timing aligns \\(focus) with \\(realm) for optimal spiritual growth and manifestation."
        default:
            return "Your spiritual journey with \\(focus) energy opens new pathways for authentic growth and wisdom."
        }
    }
}

// MARK: - Supporting Types

/**
 * Enhanced Firebase integration for cosmic snapshots
 */
extension KASPERFirebaseProvider {

    /**
     * Generate cosmic snapshot insight with planetary aspects
     */
    public func generateCosmicSnapshot(
        focus: Int,
        realm: Int,
        planetaryAspects: [String] = []
    ) async throws -> String {

        // Fetch cosmic-themed insight from Firebase
        let insight = try await fetchFirebaseInsight(
            number: realm,  // Use realm for cosmic context
            context: .daily,
            originalContext: "cosmictiming"
        )

        if let baseInsight = insight {
            // Add planetary aspect context
            if !planetaryAspects.isEmpty {
                let aspectText = planetaryAspects.joined(separator: ", ")
                return "\\(baseInsight) Today's planetary influences (\\(aspectText)) support this cosmic alignment."
            }
            return baseInsight
        }

        // Fallback cosmic insight
        return "The cosmic energies of \\(realm) align with your \\(focus) essence, creating a powerful portal for spiritual growth and manifestation."
    }

    /**
     * Generate match notification insight (when focus == realm)
     */
    public func generateMatchNotificationInsight(
        matchingNumber: Int
    ) async throws -> String {

        let insight = try await firebaseRepository.fetchMatchNotificationInsight(
            matchingNumber: matchingNumber,
            context: .daily
        )

        return insight?.text ?? "Sacred alignment achieved! Number \\(matchingNumber) resonates through all dimensions of your spiritual experience today."
    }
}
