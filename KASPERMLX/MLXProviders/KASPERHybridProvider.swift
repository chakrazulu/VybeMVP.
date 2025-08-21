//
//  KASPERHybridProvider.swift
//  VybeMVP
//
//  🔀 HYBRID KASPER PROVIDER - BEST OF BOTH WORLDS
//  Created: August 18, 2025
//
//  Combines the sophisticated template system with 9,483 authentic NumerologyData insights
//  for diverse, natural-feeling spiritual guidance that doesn't feel template-heavy.
//

import Foundation
import os.log

/**
 * 🔀 KASPER HYBRID PROVIDER - Enhanced Diversity & Authenticity
 *
 * REVOLUTIONARY APPROACH:
 * Instead of choosing templates OR real content, this provider intelligently blends both:
 *
 * 1. **Base Insight**: Uses real content from 9,483 NumerologyData insights
 * 2. **Context Enhancement**: Adds light KASPER template structure when beneficial
 * 3. **Natural Flow**: Avoids obvious "Focus X + Realm Y" patterns
 * 4. **Intelligent Selection**: 70% real insights, 30% enhanced templates
 *
 * RESULT:
 * Natural-feeling insights with authentic spiritual depth + structural coherence
 */
public actor KASPERHybridProvider: KASPERInferenceProvider {

    // MARK: - Properties

    public let name = "HybridKASPER"
    public let description = "Authentic insights enhanced with KASPER wisdom"
    public let averageConfidence = 0.75  // Higher than templates, lower than pure NumerologyData

    private let logger = Logger(subsystem: "com.vybe.kasper", category: "HybridProvider")

    // Blend both systems
    private let numerologyProvider = NumerologyDataTemplateProvider()
    private let templateProvider = KASPERTemplateProvider()

    // MARK: - Naturalization Config

    private enum Nat {
        static let minWords = 15
        static let maxWords = 25
        static let deepeningChance: Double = 0.35   // how often we add a short tail
    }

    // Small, portable RNG
    private func chance(_ p: Double) -> Bool { Double.random(in: 0...1) < p }

    // MARK: - Word Frequency Balancer

    /// Tracks recently used words/phrases to reduce repetition.
    private final class WordBalancer {
        private var recent = [String]()
        private let cap: Int
        init(cap: Int = 60) { self.cap = cap }
        func pick(_ options: [String]) -> String {
            let filtered = options.filter { o in !recent.contains(o.lowercased()) }
            let choice = (filtered.isEmpty ? options : filtered).randomElement()!
            recent.append(choice.lowercased())
            if recent.count > cap { recent.removeFirst(recent.count - cap) }
            return choice
        }
    }

    // one balancer shared by the provider instance
    private let wordBalancer = WordBalancer()

    // MARK: - Length & Cleanup

    private func trimToWordLimit(_ text: String,
                                 min: Int = Nat.minWords,
                                 max: Int = Nat.maxWords) -> String {
        let tokens = text.split(whereSeparator: \.isWhitespace)
        if tokens.count <= max { return text }
        // keep punctuation if the last kept token ends mid-sentence
        let kept = tokens.prefix(max).joined(separator: " ")
        return kept.hasSuffix(".") ? kept : kept + "."
    }

    /// aggressively removes stacked modifiers & filler
    private func compactSyntax(_ text: String) -> String {
        var t = text
        // redundant linkers
        t = t.replacingOccurrences(of: #"(?i)\b(in order to|so that|that you may|that you can)\b"#,
                                   with: "to", options: .regularExpression)
        // double adjectives (e.g., "deep mystical", "divine cosmic")
        t = t.replacingOccurrences(of: #"(?i)\b(deep|profound|divine|mystical|cosmic)\s+(mystical|cosmic|divine|spiritual)\b"#,
                                   with: "$2", options: .regularExpression)
        // tidy spaces
        t = t.replacingOccurrences(of: #"\s{2,}"#, with: " ", options: .regularExpression)
        return t.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Initialization

    public init() {
        logger.info("🔀 Hybrid Provider initialized - blending 9,483 insights with KASPER templates")
    }

    // MARK: - De-buzz & Natural Word Banks

    // Handle common two-word phrases first (before single words)
    private let phraseMap: [String: String] = [
        "divine timing": "right timing",
        "sacred space": "quiet space",
        "spiritual growth": "real growth",
        "mystical wisdom": "inner knowing",
        "cosmic energy": "life force",
        "universal love": "deep love"
    ]

    private let bannedMap: [String: String] = [
        // buzz → everyday
        "mystical": "subtle",
        "divine": "true",
        "sacred": "steady",
        "resonates": "lands",
        "resonance": "connection",
        "vibration": "signal",
        "vibrations": "signals",
        "self-expression": "your voice",
        "transformation": "change",
        "transcendence": "perspective",
        "activation": "start",
        "attunement": "attention",
        "manifestation": "creating",
        "embodiment": "living",
        "awakening": "opening",
        "consciousness": "awareness",
        "enlightenment": "clarity",
        "spiritual": "inner",
        "cosmic": "bigger",
        "universal": "shared"
    ]

    private func debuzz(_ text: String) -> String {
        var t = text
        // Handle phrases first (better idiom preservation)
        for (k, v) in phraseMap {
            t = t.replacingOccurrences(of: "\\b\(k)\\b", with: v, options: [.regularExpression, .caseInsensitive])
        }
        // Then handle single words
        for (k, v) in bannedMap {
            t = t.replacingOccurrences(of: "\\b\(k)\\b", with: v, options: [.regularExpression, .caseInsensitive])
        }
        // collapse "your true true …"
        t = t.replacingOccurrences(of: #"(?i)\b(\w+)\s+\1\b"#, with: "$1", options: .regularExpression)
        return t
    }

    private func isClean(_ text: String) -> Bool {
        let wordCount = text.split(whereSeparator: \.isWhitespace).count
        guard wordCount <= Nat.maxWords else { return false }

        // Check for buzz phrases first
        for phrase in phraseMap.keys {
            if text.range(of: "\\b\(phrase)\\b", options: [.regularExpression, .caseInsensitive]) != nil {
                return false
            }
        }
        // Then check for buzz words
        for word in bannedMap.keys {
            if text.range(of: "\\b\(word)\\b", options: [.regularExpression, .caseInsensitive]) != nil {
                return false
            }
        }
        return true
    }

    private func chooseFitVerb() -> String {
        wordBalancer.pick(["fits", "works with", "sits well with", "pairs with"])
    }

    // Variation banks (no incense words) - Expanded for extreme diversity
    private var actionVerbs: [String] {
        ["notice", "trust", "try", "practice", "choose", "simplify", "focus", "pause", "listen", "begin", "continue", "check in", "explore", "embrace", "release", "allow", "accept", "honor", "follow", "create", "build", "discover", "recognize", "appreciate", "celebrate", "integrate", "balance", "ground", "expand", "deepen", "clarify", "strengthen", "soften", "open", "flow", "shine", "grow", "heal", "learn", "remember", "forgive", "serve", "share", "give", "receive", "offer", "invite", "welcome", "return", "rest"]
    }

    private var growthNouns: [String] {
        ["clarity", "patience", "balance", "courage", "next step", "a steady pace", "support", "new options", "room to breathe", "fresh perspective", "quiet confidence", "gentle strength", "inner knowing", "creative spark", "sense of purpose", "natural rhythm", "deeper connection", "honest communication", "authentic expression", "meaningful progress", "sustainable growth", "genuine peace", "lasting change", "real understanding", "true acceptance", "heartfelt gratitude", "sincere effort", "thoughtful action", "careful attention", "loving kindness", "wise discernment", "peaceful resolution", "joyful discovery", "harmonious flow", "graceful movement", "mindful presence", "conscious choice", "intentional living", "purposeful direction", "meaningful engagement"]
    }

    private var timeContexts: [String] {
        ["today", "this morning", "this afternoon", "tonight", "this week", "right now", "in this season", "lately", "recently", "soon", "in the coming days", "as things unfold", "in due time", "when you're ready", "step by step", "moment by moment", "day by day", "little by little", "gradually", "naturally", "in the flow", "as life allows", "when it feels right", "in your own time", "at your own pace"]
    }

    private var lifeAreas: [String] {
        ["in your work", "in relationships", "with your body", "with money", "at home", "in your practice", "with family", "with friends", "in your community", "in your creativity", "with your health", "in your learning", "in your service", "with your dreams", "in your daily life", "with your challenges", "in your growth", "with your gifts", "in your healing", "with your purpose", "in your joy", "with your peace", "in your freedom", "with your truth", "in your love", "with your power", "in your wisdom", "with your courage"]
    }

    // MARK: - KASPERInferenceProvider

    public var isAvailable: Bool {
        true // Always available - has fallbacks
    }


    // MARK: - Natural References (Improved)

    private func chooseNaturalReference(_ number: Int) -> String {
        // numbered but ordinary, avoids "soul blueprint"
        let opts = [
            "your core drive", "what matters most", "your way of deciding",
            "how you move forward", "what steadies you", "your inner compass",
            "what guides you", "your natural instinct", "what feels right",
            "your genuine self", "what rings true", "your authentic voice",
            "what you value", "your deeper knowing", "what motivates you"
        ]
        return wordBalancer.pick(opts)
    }

    private func chooseCosmicReference(_ number: Int) -> String {
        let opts = [
            "timing", "the bigger picture", "what's shifting", "the current tone", "what's opening",
            "what's emerging", "the flow", "what's available", "what's possible",
            "what's calling", "what's ready", "what's next", "what's needed",
            "the right moment", "what's unfolding", "what's in motion"
        ]
        return wordBalancer.pick(opts)
    }

    // MARK: - Enhanced Naturalization

    private func naturalizeTemplateInsight(_ insight: String, focus: Int, realm: Int) -> String {
        var t = insight

        // remove obvious placeholders
        t = t.replacingOccurrences(of: #"Focus\s*\(\s*focus\s*\)"#, with: chooseNaturalReference(focus), options: .regularExpression)
        t = t.replacingOccurrences(of: #"Realm\s*\(\s*realm\s*\)"#,  with: chooseCosmicReference(realm), options: .regularExpression)

        // deflate spiritual boilerplate → ordinary language with variety
        t = t.replacingOccurrences(of: #"(?i)\bresonates with\b"#, with: wordBalancer.pick(["fits", "lands with"]))
         .replacingOccurrences(of: #"(?i)\bvibrates at\b"#,   with: wordBalancer.pick(["runs at", "moves at"]))
         .replacingOccurrences(of: #"(?i)\baligns with\b"#,   with: chooseFitVerb())

        // de-buzz + compact + trim
        t = debuzz(t)
        t = compactSyntax(t)
        t = trimToWordLimit(t)

        // hard cap clauses: at most 2 sentences, favoring shorter ones
        let parts = t.split(separator: ".").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        if parts.count <= 2 {
            let limited = parts.joined(separator: ". ")
            return limited.hasSuffix(".") ? limited : limited + "."
        }
        // Choose shortest two for maximum punch
        let bestTwo = parts.sorted { $0.count < $1.count }.prefix(2).joined(separator: ". ")
        return bestTwo.hasSuffix(".") ? bestTwo : bestTwo + "."
    }

    private func addSpiritualDepth(_ insight: String, context: String) -> String {
        guard chance(Nat.deepeningChance) else { return insight }
        let tails = [
            "Trust the small signal.",
            "Keep it simple.",
            "One honest step is enough.",
            "Let quiet lead you.",
            "Stay with what's real.",
            "Follow what feels true.",
            "Notice what opens.",
            "Trust your instinct.",
            "Stay present.",
            "Be patient with the process.",
            "Honor your pace.",
            "Listen to your body.",
            "Follow your curiosity.",
            "Stay grounded.",
            "Keep your heart open."
        ]
        let tail = wordBalancer.pick(tails)
        // keep under hard cap
        let joined = insight.hasSuffix(".") ? "\(insight) \(tail)" : "\(insight). \(tail)"
        return trimToWordLimit(joined)
    }

    private func addLightContextualDepth(_ insight: String, context: String) -> String {
        // only when very short; keep casual
        guard insight.split(whereSeparator: \.isWhitespace).count < Nat.minWords else { return insight }
        let frames: [String: String] = [
            "daily": "\(wordBalancer.pick(timeContexts)). \(insight)",
            "sanctum": "In quiet moments: \(insight)",
            "lifepath": "For the long run: \(insight)",
            "cosmictiming": "Right now: \(insight)"
        ]
        return frames[context.lowercased()] ?? insight
    }

    // MARK: - Enhancement Logic (Improved)

    private enum EnhancementLevel {
        case minimal    // Real content - just light polish
        case moderate   // Template content - remove obvious patterns
        case natural    // Enhanced template - make it feel authentic
    }

    private func enhanceInsightNaturally(
        baseInsight: String,
        context: String,
        focus: Int,
        realm: Int,
        level: EnhancementLevel
    ) -> String {

        switch level {
        case .minimal:
            // real content: preserve authentic voice, only clean if needed
            if isClean(baseInsight) { return baseInsight }
            let tidy = trimToWordLimit(compactSyntax(baseInsight))
            return addLightContextualDepth(tidy, context: context)

        case .moderate:
            // templated: naturalize aggressively, keep to 1–2 short clauses
            return naturalizeTemplateInsight(baseInsight, focus: focus, realm: realm)

        case .natural:
            // enhanced template: naturalize + (maybe) short tail
            let nat = naturalizeTemplateInsight(baseInsight, focus: focus, realm: realm)
            return addSpiritualDepth(nat, context: context)
        }
    }

    // MARK: - Ultra-Short Mode (for HUD/Widgets)

    public func generateInsight(
        context: String,
        focus: Int,
        realm: Int,
        extras: [String: Any]
    ) async throws -> String {
        // Check for ultra-short mode
        let ultraShort = (extras["ultraShort"] as? Bool) == true

        // Generate normally first
        let result = try await generateInsightInternal(context: context, focus: focus, realm: realm, extras: extras)

        // Apply ultra-short mode if requested (bypass tails)
        if ultraShort {
            return trimToWordLimit(result, min: 8, max: 18)
        }

        return result
    }

    private func generateInsightInternal(
        context: String,
        focus: Int,
        realm: Int,
        extras: [String: Any]
    ) async throws -> String {
        // Original generateInsight logic here...
        logger.info("🔀 Generating hybrid insight - Context: \(context), Focus: \(focus), Realm: \(realm)")

        // Use timestamp + focus + realm for selection variety
        let selectionSeed = Int(Date().timeIntervalSince1970) + focus + realm
        let useRealContent = (selectionSeed % 10) < 7  // 70% real content, 30% enhanced templates

        let baseInsight: String
        let enhancementLevel: EnhancementLevel

        if useRealContent {
            // Get authentic insight from NumerologyData (primary approach)
            do {
                baseInsight = try await numerologyProvider.generateInsight(
                    context: context,
                    focus: focus,
                    realm: realm,
                    extras: extras
                )
                enhancementLevel = .minimal  // Real content needs minimal enhancement
                logger.info("🔮 Using authentic NumerologyData insight")
            } catch {
                // Fallback to template
                baseInsight = try await templateProvider.generateInsight(
                    context: context,
                    focus: focus,
                    realm: realm,
                    extras: extras
                )
                enhancementLevel = .moderate
                logger.info("📝 Fallback to template insight")
            }
        } else {
            // Use enhanced template approach (30% of time)
            baseInsight = try await templateProvider.generateInsight(
                context: context,
                focus: focus,
                realm: realm,
                extras: extras
            )
            enhancementLevel = .natural
            logger.info("🎭 Using enhanced template")
        }

        // Enhance the insight to feel more natural
        let finalInsight = enhanceInsightNaturally(
            baseInsight: baseInsight,
            context: context,
            focus: focus,
            realm: realm,
            level: enhancementLevel
        )

        logger.info("🔀 Hybrid insight generated: \(finalInsight.prefix(50))...")
        return finalInsight
    }
}
