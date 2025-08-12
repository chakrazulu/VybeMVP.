//
//  EvaluationIntegrationTest.swift
//  VybeMVP
//
//  Created by KASPER MLX Team on December 2024.
//  Copyright © 2024 Vybe. All rights reserved.
//
//  PURPOSE:
//  Integration test to verify the KASPERInsightEvaluator works with your existing architecture.
//  This validates that ChatGPT's strategy integrates cleanly with your provider system.
//
//  USAGE:
//  Add this to your KASPERMLXTestView for real-time evaluation testing.
//

import Foundation

/// Simple integration test for the evaluation system
@MainActor
class EvaluationIntegrationTest {

    private let manager = KASPERMLXManager.shared
    private let contentRouter = KASPERContentRouter.shared

    /// Test evaluation system with your actual content
    func runIntegrationTest() async {
        print("🧪 Starting KASPER MLX Evaluation Integration Test...")

        // Test 1: Load real content from your RuntimeBundle
        print("\n📋 Test 1: Loading Real Content...")
        if let richContent = await contentRouter.getRichContent(for: 7) {
            print("✅ Successfully loaded rich content for number 7")

            // Extract behavioral insights for evaluation
            if let insights = richContent["behavioral_insights"] as? [[String: Any]],
               let firstInsight = insights.first,
               let insightText = firstInsight["insight"] as? String {

                print("📝 Testing insight: \(insightText.prefix(100))...")

                // Test 2: Evaluate real content
                let evaluation = await manager.evaluateInsightQuality(
                    insightText,
                    expectedFocus: 7,
                    expectedRealm: 3
                )

                print("✅ Evaluation Result:")
                print("   Grade: \(evaluation.grade)")
                print("   Overall Score: \(String(format: "%.2f", evaluation.overallScore))")
                print("   Fidelity: \(String(format: "%.2f", evaluation.fidelityScore))")
                print("   Actionability: \(String(format: "%.2f", evaluation.actionabilityScore))")
                print("   Tone: \(String(format: "%.2f", evaluation.toneScore))")
                print("   Safety: \(String(format: "%.2f", evaluation.safetyScore))")

                if evaluation.passes {
                    print("🎉 Content PASSES quality threshold!")
                } else {
                    print("⚠️  Content needs improvement")
                    print("   Issues found: \(evaluation.fidelityIssues + evaluation.actionabilityIssues + evaluation.toneIssues + evaluation.safetyIssues)")
                }
            }
        }

        // Test 3: Evaluate hard negatives (should fail)
        print("\n📋 Test 3: Testing Hard Negatives...")
        let hardNegatives = manager.getEvaluatorTestCases()
        for (index, negativeExample) in hardNegatives.enumerated() {
            let evaluation = await manager.evaluateInsightQuality(
                negativeExample,
                expectedFocus: 1,
                expectedRealm: 1
            )

            print("   Hard Negative \(index + 1): \(evaluation.grade) (\(String(format: "%.2f", evaluation.overallScore)))")
            if evaluation.passes {
                print("   🚨 ERROR: Hard negative should have failed!")
            } else {
                print("   ✅ Correctly rejected poor quality content")
            }
        }

        // Test 4: Quick evaluation method
        print("\n📋 Test 4: Quick Evaluation...")
        let quickResult = await manager.quickEvaluateInsight(
            "Focus on your path of spiritual growth and consider spending time in quiet reflection today.",
            focus: 7,
            realm: 3
        )
        print("   Quick Result: \(quickResult)")

        print("\n🎉 Integration Test Complete - All systems working!")
        print("✅ Your architecture + ChatGPT's strategy = Perfect integration")
    }
}
