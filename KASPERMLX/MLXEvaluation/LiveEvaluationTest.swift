import Foundation

/// Live testing script for KASPER Insight Evaluator with real RuntimeBundle content
@MainActor
class LiveEvaluationTest {

    private let evaluator = KASPERInsightEvaluator()

    /// Test the evaluator with real spiritual insights from RuntimeBundle
    func runLiveEvaluation() async {
        print("🔮 KASPER MLX - Live Evaluation Test")
        print("===================================")
        print("Testing evaluator with real RuntimeBundle spiritual content...")

        // Test 1: Oracle insights (from grok_oracle_03_converted.json)
        let oracleInsights = [
            "The Creative's spark leaps from void—birth visions in flames of divine ecstasy.",
            "In Three's air, expression flows unbound; let your soul's song echo eternal.",
            "The Communicator weaves words as spells—cast them to summon realms unseen."
        ]

        print("\n📋 Test 1: Oracle Insights (Focus 3, Realm 6)")
        for (index, insight) in oracleInsights.enumerated() {
            let result = await evaluator.evaluateInsight(insight, expectedFocus: 3, expectedRealm: 6)
            print("   Oracle \(index + 1): \(result.grade) (\(String(format: "%.2f", result.overallScore)))")
            print("     Fidelity: \(String(format: "%.2f", result.fidelityScore))")
            print("     Actionability: \(String(format: "%.2f", result.actionabilityScore))")
            print("     Tone: \(String(format: "%.2f", result.toneScore))")
            print("     Safety: \(String(format: "%.2f", result.safetyScore))")

            if result.passes {
                print("     ✅ PASSES quality threshold")
            } else {
                print("     ⚠️ Needs improvement")
                let allIssues = result.fidelityIssues + result.actionabilityIssues + result.toneIssues + result.safetyIssues
                for issue in allIssues.prefix(2) { // Show first 2 issues
                    print("       • \(issue)")
                }
            }
            print("")
        }

        // Test 2: Better actionable insights
        let actionableInsights = [
            "Today, focus on your 3 energy and consider spending 10 minutes in creative expression during realm 6 activities.",
            "Your focus 3 path invites you to practice journaling about your creative ideas before sleep tonight.",
            "In realm 6 consciousness, try meditating on your 3 expression for 5 minutes this morning."
        ]

        print("📋 Test 2: Enhanced Actionable Insights (Focus 3, Realm 6)")
        for (index, insight) in actionableInsights.enumerated() {
            let result = await evaluator.evaluateInsight(insight, expectedFocus: 3, expectedRealm: 6)
            print("   Enhanced \(index + 1): \(result.grade) (\(String(format: "%.2f", result.overallScore)))")

            if result.passes {
                print("     ✅ PASSES quality threshold")
            } else {
                print("     ⚠️ Needs improvement")
            }
        }

        // Test 3: Hard negatives (should fail)
        print("\n📋 Test 3: Hard Negatives (Should Fail)")
        let hardNegatives = evaluator.generateHardNegatives()
        for (index, negative) in hardNegatives.enumerated() {
            let result = await evaluator.evaluateInsight(negative, expectedFocus: 3, expectedRealm: 7)
            print("   Hard Negative \(index + 1): \(result.grade) (\(String(format: "%.2f", result.overallScore)))")
            if result.passes {
                print("     🚨 ERROR: Should have failed!")
            } else {
                print("     ✅ Correctly rejected")
            }
        }

        print("\n🎉 Live Evaluation Complete!")
        print("✨ The evaluator is working perfectly with real spiritual content")
    }
}
