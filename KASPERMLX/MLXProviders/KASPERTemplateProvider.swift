//
//  KASPERTemplateProvider.swift
//  VybeMVP
//
//  Created by KASPER MLX Team on August 2025.
//  Copyright © 2025 Vybe. All rights reserved.
//
//  PURPOSE:
//  Template-based fallback provider for spiritual insights.
//  Uses deterministic templates with number-based variations.
//  This is the most basic provider, always available as last resort.
//

import Foundation
import os.log

/// Template-based fallback provider
public actor KASPERTemplateProvider: KASPERInferenceProvider {

    // MARK: - Properties

    public let name = "Template"
    public let description = "Basic template-based spiritual insights"
    public let averageConfidence = 0.45

    private let logger = Logger(subsystem: "com.vybe.kasper", category: "TemplateProvider")

    // MARK: - Initialization

    public init() {
        logger.info("📝 Template Provider initialized")
    }

    // MARK: - KASPERInferenceProvider

    public var isAvailable: Bool {
        true // Templates are always available
    }

    public func generateInsight(
        context: String,
        focus: Int,
        realm: Int,
        extras: [String: Any]
    ) async throws -> String {

        logger.info("📝 Generating template insight - Context: \(context), Focus: \(focus), Realm: \(realm)")

        // Generate based on context
        let insight: String

        switch context.lowercased() {
        case "lifepath":
            insight = generateLifePathInsight(focus: focus, realm: realm)
        case "expression":
            insight = generateExpressionInsight(focus: focus, realm: realm)
        case "soulurge":
            insight = generateSoulUrgeInsight(focus: focus, realm: realm)
        case "dailycard":
            insight = generateDailyCardInsight(focus: focus, realm: realm)
        case "sanctum":
            insight = generateSanctumInsight(focus: focus, realm: realm)
        case "cosmictiming":
            insight = generateCosmicTimingInsight(focus: focus, realm: realm)
        default:
            insight = generateGenericInsight(focus: focus, realm: realm, context: context)
        }

        logger.info("📝 Template insight generated: \(insight.prefix(50))...")
        return insight
    }

    // MARK: - Template Generators

    private func generateLifePathInsight(focus: Int, realm: Int) -> String {
        let templates = [
            "Your Life Path resonates with Focus \(focus) energy, guiding you through Realm \(realm)'s transformative vibrations.",
            "The universe aligns your Focus \(focus) essence with Realm \(realm)'s cosmic wisdom, illuminating your spiritual journey.",
            "As Focus \(focus) meets Realm \(realm), your Life Path reveals profound opportunities for spiritual growth.",
            "Your spiritual DNA vibrates at Focus \(focus) frequency, harmonizing beautifully with Realm \(realm)'s current energy.",
            "The sacred geometry of Focus \(focus) and Realm \(realm) creates a powerful portal for your Life Path evolution."
        ]

        let index = (focus + realm) % templates.count
        return templates[index]
    }

    private func generateExpressionInsight(focus: Int, realm: Int) -> String {
        let templates = [
            "Express your Focus \(focus) gifts freely as Realm \(realm) amplifies your creative potential.",
            "Your Expression Number \(focus) finds perfect resonance in Realm \(realm)'s supportive frequencies.",
            "Channel Focus \(focus)'s unique voice through Realm \(realm)'s transformative gateway.",
            "The cosmos invites your Focus \(focus) expression to dance with Realm \(realm)'s rhythms.",
            "Your authentic Focus \(focus) nature shines brilliantly in Realm \(realm)'s sacred space."
        ]

        let index = (focus * 2 + realm) % templates.count
        return templates[index]
    }

    private func generateSoulUrgeInsight(focus: Int, realm: Int) -> String {
        let templates = [
            "Your Soul Urge \(focus) whispers ancient truths through Realm \(realm)'s mystical veil.",
            "Deep within, Focus \(focus)'s desires align with Realm \(realm)'s transformative power.",
            "Listen to your Soul Urge \(focus) as it harmonizes with Realm \(realm)'s sacred frequency.",
            "Focus \(focus)'s inner calling finds fulfillment in Realm \(realm)'s nurturing embrace.",
            "Your deepest Focus \(focus) yearnings manifest through Realm \(realm)'s spiritual gateway."
        ]

        let index = (focus * 3 + realm * 2) % templates.count
        return templates[index]
    }

    private func generateDailyCardInsight(focus: Int, realm: Int) -> String {
        let templates = [
            "Today, Focus \(focus) and Realm \(realm) converge to bring unexpected blessings.",
            "The daily energies of Focus \(focus) in Realm \(realm) promise spiritual breakthroughs.",
            "Embrace Focus \(focus)'s wisdom as Realm \(realm) opens new doorways today.",
            "Your Focus \(focus) vibration attracts Realm \(realm)'s most beneficial energies today.",
            "This sacred day brings Focus \(focus) and Realm \(realm) into perfect spiritual alignment."
        ]

        let hour = Calendar.current.component(.hour, from: Date())
        let index = (focus + realm + hour) % templates.count
        return templates[index]
    }

    private func generateSanctumInsight(focus: Int, realm: Int) -> String {
        let templates = [
            "In your sacred sanctuary, Focus \(focus) merges with Realm \(realm)'s divine essence.",
            "Your spiritual sanctum resonates with Focus \(focus) while channeling Realm \(realm)'s peace.",
            "Within this holy space, Focus \(focus) and Realm \(realm) create profound transformation.",
            "Your sanctum pulses with Focus \(focus) energy, blessed by Realm \(realm)'s protection.",
            "Sacred Focus \(focus) wisdom flows through your sanctum via Realm \(realm)'s gateway."
        ]

        let index = (focus + realm * 3) % templates.count
        return templates[index]
    }

    private func generateCosmicTimingInsight(focus: Int, realm: Int) -> String {
        let templates = [
            "The cosmic clock aligns Focus \(focus) with Realm \(realm) for perfect divine timing.",
            "Universal synchronicity brings Focus \(focus) and Realm \(realm) into harmonic convergence.",
            "This cosmic moment activates Focus \(focus)'s potential through Realm \(realm)'s portal.",
            "Celestial timing unites Focus \(focus) with Realm \(realm) for spiritual acceleration.",
            "The stars align to merge Focus \(focus) energy with Realm \(realm)'s cosmic purpose."
        ]

        let minute = Calendar.current.component(.minute, from: Date())
        let index = (focus + realm + minute) % templates.count
        return templates[index]
    }

    private func generateGenericInsight(focus: Int, realm: Int, context: String) -> String {
        "Your Focus \(focus) energy harmonizes with Realm \(realm) to guide your \(context) journey toward spiritual enlightenment."
    }
}
