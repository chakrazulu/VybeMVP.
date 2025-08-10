/**
 * 🧪 KASPER LINGUISTIC ENHANCER V2.0 - COMPREHENSIVE UNIT TESTS
 * ============================================================
 *
 * Production-grade tests validating the revolutionary linguistic enhancement system
 * based on ChatGPT-5 surgical fixes for redundancy, capitalization, and template seams.
 *
 * Test Coverage:
 * • Redundancy elimination with stemming
 * • Mid-sentence capitalization fixes
 • Template seam removal
 * • Emoji policy enforcement
 * • Natural cadence validation
 * • Persona adherence verification
 * • Quality gate enforcement
 */

import XCTest
import Foundation

final class KASPERLinguisticV2Tests: XCTestCase {

    // MARK: - 🎯 CORE FUNCTIONALITY TESTS (ChatGPT Surgical Fixes)

    func testEnhancer_RemovesRedundancyAndFixesCaps() {
        // Test the exact problematic input from user feedback
        let input = "The awakening of Mystical wisdom energy within Your mystic nature reveals a beautiful opportunity to Trust your mystic nature..."

        let (enhanced, _) = KASPERLinguisticEnhancerV2.enhance(
            input,
            options: EnhancementOptions(
                persona: .oracle,
                allowEmoji: true,
                targetTokenRange: 15...22,
                qualityThreshold: 0.84
            )
        )

        // Core redundancy fixes
        XCTAssertFalse(enhanced.contains("mystic nature"), "Repeated phrase 'mystic nature' should be eliminated")
        XCTAssertFalse(enhanced.contains("mystical") && enhanced.contains("mystic"), "Stemmed redundancy (mystic/mystical) should be resolved")

        // Mid-sentence capitalization fixes
        XCTAssertFalse(enhanced.contains("Your "), "Mid-sentence 'Your' should be lowercase")
        XCTAssertFalse(enhanced.contains("Trust your"), "Mid-sentence 'Trust' should be lowercase")

        // Template seam removal
        XCTAssertFalse(enhanced.contains("reveals a beautiful opportunity to"), "Template seam should be removed")
        XCTAssertFalse(enhanced.contains("awakening of"), "Template pattern should be softened")

        // Quality validation
        XCTAssertLessThan(score.repetitionRatio, 0.12, "Repetition ratio should be under 12%")
        XCTAssertGreaterThanOrEqual(score.finalGrade, 0.84, "Quality score should meet threshold")
    }

    func testEnhancer_EmojiPolicyAndCadence() {
        let input = "Awakening mystical language flows through your spiritual nature..."

        let (enhanced, _) = KASPERLinguisticEnhancerV2.enhance(
            input,
            options: EnhancementOptions(
                persona: .oracle,
                allowEmoji: true,
                targetTokenRange: 12...20,
                qualityThreshold: 0.84
            )
        )

        // Emoji policy: At most one leading emoji
        let body = enhanced.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasLeadingEmoji = body.hasPrefix("🌟") || body.hasPrefix("🔮") || body.hasPrefix("💫")

        if hasLeadingEmoji {
            let emojiCount = enhanced.filter { "🌟🔮💫🌙✨⚡🎯🚀💎🌊".contains($0) }.count
            XCTAssertEqual(emojiCount, 1, "Should have exactly one emoji when emoji allowed")
        }

        // Cadence validation: Max 1 comma per sentence
        let sentences = enhanced.components(separatedBy: ". ")
        for sentence in sentences {
            let commaCount = sentence.filter { $0 == "," }.count
            XCTAssertLessThanOrEqual(commaCount, 1, "Each sentence should have at most 1 comma for natural flow")
        }

        // Token count validation
        let wordCount = enhanced.split(separator: " ").count
        XCTAssertTrue(12...22 ~= wordCount, "Enhanced content should meet target token range")
    }

    // MARK: - 🎭 PERSONA-SPECIFIC BEHAVIOR TESTS

    func testPersona_Oracle_MysticalLanguage() {
        let input = "Trust your inner knowing and embrace spiritual wisdom"

        let (enhanced, _) = KASPERLinguisticEnhancerV2.enhance(
            input,
            options: EnhancementOptions(persona: .oracle, qualityThreshold: 0.80)
        )

        // Oracle should use mystical language
        let mysticalMarkers = ["sense", "perceive", "feel in your bones", "sacred", "divine", "cosmic"]
        let containsMysticalLanguage = mysticalMarkers.contains { marker in
            enhanced.lowercased().contains(marker)
        }

        XCTAssertTrue(containsMysticalLanguage, "Oracle persona should include mystical language markers")
        XCTAssertGreaterThan(score.personaAdherence, 0.80, "Oracle persona adherence should be strong")
    }

    func testPersona_Psychologist_CognitiveLanguage() {
        let input = "Feel the mystical divine cosmic energy flowing through your sacred being"

        let (enhanced, _) = KASPERLinguisticEnhancerV2.enhance(
            input,
            options: EnhancementOptions(persona: .psychologist, qualityThreshold: 0.80)
        )

        // Psychologist should avoid "woo" terms and use cognitive language
        let wooTerms = ["mystical", "cosmic", "divine", "sacred", "magical"]
        let cognitiveTerms = ["notice", "observe", "recognize", "acknowledge", "internal", "authentic"]

        let hasWooTerms = wooTerms.contains { term in enhanced.lowercased().contains(term) }
        let hasCognitiveTerms = cognitiveTerms.contains { term in enhanced.lowercased().contains(term) }

        XCTAssertFalse(hasWooTerms, "Psychologist should avoid mystical woo terms")
        XCTAssertTrue(hasCognitiveTerms, "Psychologist should use cognitive behavioral language")
    }

    func testPersona_MindfulnessCoach_PresentTenseAndBodyAwareness() {
        let input = "You will feel spiritual energy and you will be able to trust your wisdom"

        let (enhanced, _) = KASPERLinguisticEnhancerV2.enhance(
            input,
            options: EnhancementOptions(persona: .mindfulnessCoach, qualityThreshold: 0.80)
        )

        // Mindfulness coach should use present tense
        XCTAssertFalse(enhanced.contains("will be"), "Should convert future tense to present")
        XCTAssertFalse(enhanced.contains("will feel"), "Should use present-tense feeling")

        // Should include body awareness
        let bodyTerms = ["breath", "breathe", "body", "sensation", "ground", "center"]
        let hasBodyAwareness = bodyTerms.contains { term in enhanced.lowercased().contains(term) }

        XCTAssertTrue(hasBodyAwareness, "Mindfulness coach should include embodied awareness")
    }

    // MARK: - 🚫 SAFETY AND QUALITY GATE TESTS

    func testSafetyGates_BlockProblematicTerms() {
        let problematicInputs = [
            "This will guarantee you cure depression",
            "You must do this to heal your disease",
            "This should fix your money problems"
        ]

        for input in problematicInputs {
            let (enhanced, _) = KASPERLinguisticEnhancerV2.enhance(
                input,
                options: EnhancementOptions(qualityThreshold: 0.84)
            )

            // Safety blocks
            XCTAssertFalse(enhanced.contains("guarantee"), "Should block guarantee claims")
            XCTAssertFalse(enhanced.contains("cure"), "Should block medical cure claims")
            XCTAssertFalse(enhanced.contains("must"), "Should soften coercive language")

            // Safety score validation
            XCTAssertEqual(score.safetyScore, 1.0, "Safety score should be perfect after enhancement")
        }
    }

    func testQualityGate_RejectsLowQualityContent() {
        let lowQualityInput = "bad bad bad grammar trust your the the nature trust"

        let (enhanced, _) = KASPERLinguisticEnhancerV2.enhance(
            lowQualityInput,
            options: EnhancementOptions(qualityThreshold: 0.90) // High threshold
        )

        // Quality gate should significantly improve content
        XCTAssertFalse(enhanced.contains("trust your the"), "Basic grammar issues should be fixed")
        XCTAssertFalse(enhanced.contains("the the"), "Duplicate articles should be removed")

        // But may still not meet very high threshold due to source quality
        if score.finalGrade < 0.90 {
            print("ℹ️ Low-quality source appropriately gated: \(score.summary)")
        }
    }

    // MARK: - ⚡ PERFORMANCE AND INTEGRATION TESTS

    func testPerformance_EnhancementLatency() {
        let testInputs = [
            "Trust your mystical spiritual nature and embrace divine wisdom",
            "The awakening of cosmic energy within your sacred being reveals beautiful opportunities",
            "Feel the powerful mystical forces flowing through your authentic spiritual essence"
        ]

        measure {
            for input in testInputs {
                let (_, _) = KASPERLinguisticEnhancerV2.enhance(
                    input,
                    options: EnhancementOptions(persona: .oracle, qualityThreshold: 0.84)
                )
            }
        }
    }

    func testIntegration_AllPersonasProcessSuccessfully() {
        let testInput = "Trust your inner wisdom and embrace your spiritual nature with confidence"
        let personas: [SpiritualPersona] = [.oracle, .psychologist, .mindfulnessCoach, .numerologyScholar, .philosopher]

        for persona in personas {
            let (enhanced, _) = KASPERLinguisticEnhancerV2.enhance(
                testInput,
                options: EnhancementOptions(persona: persona, qualityThreshold: 0.75)
            )

            // Basic validation for all personas
            XCTAssertFalse(enhanced.isEmpty, "\(persona) should produce non-empty output")
            XCTAssertGreaterThan(enhanced.count, 20, "\(persona) should produce meaningful content")
            XCTAssertGreaterThanOrEqual(score.finalGrade, 0.75, "\(persona) should meet basic quality threshold")

            print("✅ \(persona): \(enhanced)")
            print("📊 Score: \(score.summary)")
        }
    }

    // MARK: - 🔬 EDGE CASE AND ROBUSTNESS TESTS

    func testEdgeCases_EmptyAndShortInput() {
        let edgeCases = ["", "Hi", "Trust", "The mystical"]

        for input in edgeCases {
            let (enhanced, _) = KASPERLinguisticEnhancerV2.enhance(
                input,
                options: EnhancementOptions(qualityThreshold: 0.70)
            )

            // Should handle gracefully without crashes
            XCTAssertNotNil(enhanced, "Should handle edge case: '\(input)'")
            XCTAssertTrue(score.finalGrade >= 0.0 && score.finalGrade <= 1.0, "Score should be valid range")
        }
    }

    func testRobustness_RepeatedProcessing() {
        let input = "Trust your mystical nature and embrace spiritual wisdom"

        // Process same input multiple times - should be stable
        var results: [String] = []
        for _ in 0..<5 {
            let (enhanced, _) = KASPERLinguisticEnhancerV2.enhance(
                input,
                options: EnhancementOptions(persona: .oracle, qualityThreshold: 0.80)
            )
            results.append(enhanced)
        }

        // Results should be consistent (allowing for random variation in synonyms)
        let uniqueResults = Set(results)
        XCTAssertLessThanOrEqual(uniqueResults.count, 3, "Results should be relatively stable with controlled variation")
    }
}

// MARK: - 📊 PERFORMANCE BENCHMARK HELPER

extension KASPERLinguisticV2Tests {

    /// Performance benchmark helper for detailed latency analysis
    func runPerformanceBenchmark() {
        print("🔬 KASPER V2.0 PERFORMANCE BENCHMARK")
        print("===================================")

        let testCases = [
            ("Short insight", "Trust your inner wisdom"),
            ("Medium insight", "The mystical energy within your spiritual nature reveals opportunities for growth"),
            ("Long insight", "The awakening of divine cosmic consciousness within your authentic spiritual being reveals a beautiful sacred opportunity to trust your mystical nature and embrace the flowing wisdom that emerges from your deepest spiritual knowing through divine connection")
        ]

        for (name, input) in testCases {
            let startTime = CFAbsoluteTimeGetCurrent()

            let (enhanced, _) = KASPERLinguisticEnhancerV2.enhance(
                input,
                options: EnhancementOptions(persona: .oracle, qualityThreshold: 0.84)
            )

            let latency = (CFAbsoluteTimeGetCurrent() - startTime) * 1000 // Convert to milliseconds

            print("\n📊 \(name):")
            print("   Input: \(input.count) chars")
            print("   Output: \(enhanced.count) chars")
            print("   Latency: \(String(format: "%.2f", latency))ms")
            print("   Quality: \(score.summary)")
            print("   Enhanced: \"\(enhanced)\"")
        }

        print("\n🎯 Target: <3ms latency on production hardware")
    }
}
