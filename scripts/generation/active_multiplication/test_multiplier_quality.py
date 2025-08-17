#!/usr/bin/env python3

"""
🧪 Multiplier Quality Canary Test
Validates the A+ archetypal multiplier against ChatGPT's quality checklist
"""

import os
import sys

sys.path.append(os.path.dirname(__file__))

import json
import random

from archetypal_firebase_multiplier import ArchetypalFirebaseMultiplier


def run_canary_test():
    """Run canary checklist for multiplier quality"""
    print("🧪 MULTIPLIER QUALITY CANARY TEST")
    print("=" * 50)

    # Initialize multiplier with test seed for deterministic results
    multiplier = ArchetypalFirebaseMultiplier()

    # Test with reduced sample for quick validation
    print("📊 Generating 20 test insights per number (200 total)...")

    # Temporarily reduce target for testing
    original_target = 100
    multiplier.target_total = 20  # Quick test

    # Generate insights with test seed
    multiplier.multiply_firebase_insights(testing_mode=True, seed=42)

    # Load and analyze one generated file
    test_file = "NumerologyData/FirebaseNumberMeanings/NumberMessages_Complete_0_archetypal.json"
    if not os.path.exists(test_file):
        print("❌ Test file not found")
        return

    with open(test_file, "r") as f:
        data = json.load(f)

    insights = []
    for category, category_insights in data["0"].items():
        if isinstance(category_insights, list):
            insights.extend([insight["insight"] for insight in category_insights])

    print(f"\n🔍 CANARY ANALYSIS ({len(insights)} insights):")
    print("-" * 40)

    # Metric 1: Word count analysis
    word_counts = [len(insight.split()) for insight in insights]
    median_words = sorted(word_counts)[len(word_counts) // 2]
    print(f"📝 Median words: {median_words} (target: 18-28)")

    # Metric 2: Human action percentage (aligned with multiplier's expanded ACTION_WORDS)
    action_keywords = [
        "pause",
        "breathe",
        "choose",
        "release",
        "forgive",
        "trust",
        "embrace",
        "honor",
        "listen",
        "write",
        "feel",
        "create",
        "express",
        "align",
        "connect",
        "focus",
        "commit",
        "dedicate",
        "act",
        "step",
        "speak",
        "explore",
        "discover",
        "welcome",
        "recognize",
        "acknowledge",
        "practice",
        "celebrate",
        "allow",
        "respond",
        "begin",
        "follow",
        "invite",
        "guide",
        "encourage",
        "remind",
        "lead",
        "support",
        "help",
        "inspire",
        "activate",
        "transform",
        "manifest",
        "channel",
        "flow",
        "awaken",
        "reveal",
    ]
    insights_with_action = sum(
        1 for insight in insights if any(action in insight.lower() for action in action_keywords)
    )
    action_percentage = (insights_with_action / len(insights)) * 100
    print(f"⚡ % with human action: {action_percentage:.1f}% (target: ~95-100%)")

    # Metric 3: Archetypal anchor percentage
    archetypal_keywords = ["sacred", "divine", "archetypal", "essence", "cosmic", "infinite"]
    insights_with_archetype = sum(
        1
        for insight in insights
        if any(keyword in insight.lower() for keyword in archetypal_keywords)
    )
    archetype_percentage = (insights_with_archetype / len(insights)) * 100
    print(f"🎭 % with archetypal anchor: {archetype_percentage:.1f}% (target: ~95-100%)")

    # Metric 4: First-person percentage
    first_person_count = sum(1 for insight in insights if insight.lower().startswith("i am"))
    first_person_percentage = (first_person_count / len(insights)) * 100
    print(f"👤 % first-person: {first_person_percentage:.1f}% (target: 25-33%)")

    # Metric 5: Duplicate check
    unique_insights = len(set(insight.lower().strip() for insight in insights))
    duplicate_count = len(insights) - unique_insights
    print(f"🔄 Duplicates: {duplicate_count} (target: 0)")

    # Metric 6: Length compliance
    length_compliant = sum(1 for count in word_counts if 15 <= count <= 30)
    length_percentage = (length_compliant / len(insights)) * 100
    print(f"📏 Length compliance (15-30 words): {length_percentage:.1f}%")

    print("\n" + "=" * 50)

    # Overall assessment
    issues = []
    if not (18 <= median_words <= 28):
        issues.append(f"Median words out of range: {median_words}")
    if action_percentage < 95:
        issues.append(f"Low human action percentage: {action_percentage:.1f}%")
    if archetype_percentage < 95:
        issues.append(f"Low archetypal anchor percentage: {archetype_percentage:.1f}%")
    if not (25 <= first_person_percentage <= 33):
        issues.append(f"First-person percentage out of range: {first_person_percentage:.1f}%")
    if duplicate_count > 0:
        issues.append(f"Found {duplicate_count} duplicates")
    if length_percentage < 90:
        issues.append(f"Length compliance too low: {length_percentage:.1f}%")

    if issues:
        print("⚠️  ISSUES FOUND:")
        for issue in issues:
            print(f"   • {issue}")
    else:
        print("✅ ALL CANARY CHECKS PASSED!")
        print("🎉 Multiplier producing A+ quality content")

    # Sample a few insights for manual review
    print("\n📝 SAMPLE INSIGHTS FOR MANUAL REVIEW:")
    print("-" * 40)
    sample_insights = random.sample(insights, min(3, len(insights)))
    for i, insight in enumerate(sample_insights, 1):
        words = len(insight.split())
        first_person = "✓" if insight.lower().startswith("i am") else "✗"
        print(f"{i}. ({words} words, 1st person: {first_person})")
        print(f"   {insight}")
        print()


if __name__ == "__main__":
    run_canary_test()
