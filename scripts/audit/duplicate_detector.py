#!/usr/bin/env python3
"""
DUPLICATE ELIMINATION AGENT - Pattern Detection System
Identifies all duplicate and near-duplicate content across archetypal files
"""

import glob
import json
import os
import re
from collections import defaultdict
from difflib import SequenceMatcher


def similarity(a, b):
    """Calculate similarity between two strings"""
    return SequenceMatcher(None, a.lower(), b.lower()).ratio()


def extract_insights(file_path):
    """Extract all insights from a file"""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        insights = []
        for key, category in data.items():
            if isinstance(category, dict) and "insight" in category:
                # Handle the new structure where insights are in an array under 'insight'
                insight_array = category["insight"]
                if isinstance(insight_array, list):
                    for insight_data in insight_array:
                        if isinstance(insight_data, dict) and "insight" in insight_data:
                            insights.append(
                                {
                                    "text": insight_data["insight"],
                                    "file": os.path.basename(file_path),
                                    "category": insight_data.get("archetypal_fusion", key),
                                    "persona": insight_data.get("persona", "unknown"),
                                    "context": insight_data.get("context", "unknown"),
                                    "uniqueness_score": insight_data.get("uniqueness_score", 0.0),
                                }
                            )
        return insights
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return []


def find_duplicates_and_patterns():
    """Find all duplicates and repetitive patterns across files"""

    # Get all archetypal files
    base_dir = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP"
    archetypal_files = glob.glob(f"{base_dir}/**/*_archetypal.json", recursive=True)

    print(f"🔍 SCANNING {len(archetypal_files)} archetypal files for duplicates...")

    # Collect all insights
    all_insights = []
    for file_path in archetypal_files:
        insights = extract_insights(file_path)
        all_insights.extend(insights)

    print(f"📊 ANALYZING {len(all_insights)} total insights...")

    # Find exact duplicates
    exact_duplicates = defaultdict(list)
    for i, insight in enumerate(all_insights):
        exact_duplicates[insight["text"]].append((i, insight))

    # Find near duplicates (similarity > 0.8)
    near_duplicates = []
    similarity_threshold = 0.8

    for i in range(len(all_insights)):
        for j in range(i + 1, len(all_insights)):
            sim = similarity(all_insights[i]["text"], all_insights[j]["text"])
            if sim > similarity_threshold:
                near_duplicates.append(
                    {"similarity": sim, "insight1": all_insights[i], "insight2": all_insights[j]}
                )

    # Find repetitive patterns
    pattern_phrases = defaultdict(list)
    common_patterns = [
        r"challenge becomes opportunity",
        r"storms reveal the strength",
        r"joy shared multiplies",
        r"morning clarity dissolves",
        r"authentic presence",
        r"expanded consciousness",
        r"hidden pathways",
        r"sacred wisdom",
        r"divine essence",
        r"spiritual journey",
        r"inner wisdom",
        r"cosmic intelligence",
        r"universal truth",
        r"sacred understanding",
    ]

    for pattern in common_patterns:
        for insight in all_insights:
            if re.search(pattern, insight["text"], re.IGNORECASE):
                pattern_phrases[pattern].append(insight)

    # Generate report
    print("\n" + "=" * 80)
    print("🚨 DUPLICATE ELIMINATION REPORT")
    print("=" * 80)

    # Report exact duplicates
    exact_count = sum(1 for duplicates in exact_duplicates.values() if len(duplicates) > 1)
    print(f"\n📋 EXACT DUPLICATES FOUND: {exact_count}")

    for text, duplicates in exact_duplicates.items():
        if len(duplicates) > 1:
            print(f"\n❌ EXACT DUPLICATE ({len(duplicates)} instances):")
            print(f"   Text: '{text[:100]}...'")
            for idx, insight in duplicates:
                print(f"   File: {insight['file']} | Archetype: {insight['category']}")

    # Report near duplicates
    print(f"\n📋 NEAR DUPLICATES (similarity > {similarity_threshold}): {len(near_duplicates)}")

    for dup in near_duplicates[:10]:  # Show top 10
        print(f"\n⚠️  SIMILARITY: {dup['similarity']:.3f}")
        print(f"   Text 1: '{dup['insight1']['text'][:80]}...'")
        print(f"   File 1: {dup['insight1']['file']}")
        print(f"   Text 2: '{dup['insight2']['text'][:80]}...'")
        print(f"   File 2: {dup['insight2']['file']}")

    # Report pattern overuse
    print("\n📋 REPETITIVE PATTERN ANALYSIS:")

    for pattern, insights in pattern_phrases.items():
        if len(insights) > 3:  # Pattern appears more than 3 times
            print(f"\n🔄 OVERUSED PATTERN: '{pattern}' ({len(insights)} instances)")
            files_affected = set(insight["file"] for insight in insights)
            print(f"   Files affected: {len(files_affected)}")
            for file in list(files_affected)[:5]:  # Show first 5 files
                print(f"   - {file}")

    # Calculate uniqueness score
    total_insights = len(all_insights)
    unique_insights = len(set(insight["text"] for insight in all_insights))
    uniqueness_score = unique_insights / total_insights if total_insights > 0 else 0

    print("\n📊 UNIQUENESS ANALYSIS:")
    print(f"   Total insights: {total_insights}")
    print(f"   Unique insights: {unique_insights}")
    print(
        f"   Uniqueness score: {uniqueness_score:.3f} ({'PASS' if uniqueness_score >= 0.98 else 'FAIL'})"
    )
    print("   Target: 0.980+ (98% uniqueness)")

    # Generate action items
    print("\n🎯 ACTION ITEMS FOR DUPLICATE ELIMINATION:")
    print(f"   1. Eliminate {exact_count} exact duplicates")
    print(f"   2. Transform {len(near_duplicates)} near-duplicates")
    print(
        f"   3. Diversify {len([p for p, insights in pattern_phrases.items() if len(insights) > 3])} overused patterns"
    )
    print(f"   4. Target uniqueness improvement: {(0.98 - uniqueness_score):.3f}")

    return {
        "exact_duplicates": exact_duplicates,
        "near_duplicates": near_duplicates,
        "pattern_phrases": pattern_phrases,
        "uniqueness_score": uniqueness_score,
        "total_insights": total_insights,
    }


if __name__ == "__main__":
    results = find_duplicates_and_patterns()
