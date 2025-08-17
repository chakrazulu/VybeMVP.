#!/usr/bin/env python3
"""
Comprehensive duplicate content detection audit for planet-zodiac combination files.
Extracts all insight text and identifies exact duplicates and near-duplicates.
"""

import json
import os
import re
from collections import defaultdict
from difflib import SequenceMatcher


def normalize_insight(insight_text):
    """Normalize insight text for better duplicate detection."""
    # Remove extra whitespace and convert to lowercase for comparison
    normalized = re.sub(r"\s+", " ", insight_text.strip().lower())
    return normalized


def similarity_ratio(a, b):
    """Calculate similarity ratio between two strings."""
    return SequenceMatcher(None, a, b).ratio()


def extract_insights_from_file(file_path):
    """Extract all insights from a JSON file."""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        insights = []
        if "insights" in data:
            for insight_obj in data["insights"]:
                if "insight" in insight_obj:
                    insight_text = insight_obj["insight"]
                    insights.append(
                        {
                            "text": insight_text,
                            "normalized": normalize_insight(insight_text),
                            "planet": insight_obj.get("planet", ""),
                            "sign": insight_obj.get("sign", ""),
                            "context": insight_obj.get("context", ""),
                            "persona": insight_obj.get("persona", ""),
                            "lunar_phase": insight_obj.get("lunar_phase", ""),
                            "retrograde": insight_obj.get("retrograde", False),
                            "file": os.path.basename(file_path),
                        }
                    )
        return insights
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return []


def find_duplicates_and_near_duplicates(all_insights, similarity_threshold=0.85):
    """Find exact duplicates and near-duplicates in insights."""
    exact_duplicates = defaultdict(list)
    near_duplicates = []

    # Group by normalized text for exact duplicates
    for insight in all_insights:
        exact_duplicates[insight["normalized"]].append(insight)

    # Filter to only duplicated content
    actual_duplicates = {k: v for k, v in exact_duplicates.items() if len(v) > 1}

    # Find near-duplicates using similarity comparison
    insights_list = list(all_insights)
    for i in range(len(insights_list)):
        for j in range(i + 1, len(insights_list)):
            insight1 = insights_list[i]
            insight2 = insights_list[j]

            # Skip if already exact duplicates
            if insight1["normalized"] == insight2["normalized"]:
                continue

            # Check similarity
            similarity = similarity_ratio(insight1["normalized"], insight2["normalized"])
            if similarity >= similarity_threshold:
                near_duplicates.append(
                    {"similarity": similarity, "insight1": insight1, "insight2": insight2}
                )

    return actual_duplicates, near_duplicates


def analyze_common_patterns(all_insights):
    """Analyze common patterns in insights."""
    patterns = {
        "crisis navigation": [],
        "morning awakening": [],
        "evening integration": [],
        "daily rhythm": [],
        "presence is the gift": [],
        "essence becomes most powerful": [],
    }

    for insight in all_insights:
        text_lower = insight["text"].lower()

        for pattern, matches in patterns.items():
            if pattern in text_lower:
                matches.append(insight)

    return patterns


def main():
    """Main function to run the duplicate detection audit."""
    base_path = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebasePlanetZodiacFusion"

    # Get all planet directories
    planet_dirs = [
        "Mars_Combinations",
        "Venus_Combinations",
        "Sun_Combinations",
        "Moon_Combinations",
        "Mercury_Combinations",
        "Jupiter_Combinations",
        "Saturn_Combinations",
        "Uranus_Combinations",
        "Neptune_Combinations",
        "Pluto_Combinations",
    ]

    all_insights = []
    file_count = 0

    print("🔍 COMPREHENSIVE DUPLICATE CONTENT DETECTION AUDIT")
    print("=" * 60)

    # Extract insights from all files
    for planet_dir in planet_dirs:
        dir_path = os.path.join(base_path, planet_dir)
        if not os.path.exists(dir_path):
            print(f"⚠️  Directory not found: {planet_dir}")
            continue

        for filename in os.listdir(dir_path):
            if filename.endswith(".json"):
                file_path = os.path.join(dir_path, filename)
                insights = extract_insights_from_file(file_path)
                all_insights.extend(insights)
                file_count += 1

    print(f"📊 Processed {file_count} files")
    print(f"📊 Extracted {len(all_insights)} total insights")
    print()

    # Find duplicates
    print("🔍 DETECTING EXACT DUPLICATES...")
    exact_duplicates, near_duplicates = find_duplicates_and_near_duplicates(all_insights)

    if exact_duplicates:
        print(f"🚨 FOUND {len(exact_duplicates)} SETS OF EXACT DUPLICATES:")
        print("=" * 50)

        for i, (normalized_text, duplicates) in enumerate(exact_duplicates.items(), 1):
            print(f"\n🔥 DUPLICATE SET {i}: ({len(duplicates)} instances)")
            print(f"Files affected: {[d['file'] for d in duplicates]}")
            print(f"Planet-Sign combinations: {[(d['planet'], d['sign']) for d in duplicates]}")
            print(f"Text preview: {duplicates[0]['text'][:100]}...")
            print("-" * 40)
    else:
        print("✅ NO EXACT DUPLICATES FOUND!")

    print("\n🔍 DETECTING NEAR-DUPLICATES (>85% similarity)...")

    if near_duplicates:
        print(f"⚠️  FOUND {len(near_duplicates)} NEAR-DUPLICATE PAIRS:")
        print("=" * 50)

        for i, near_dup in enumerate(near_duplicates[:10], 1):  # Show first 10
            print(f"\n⚠️  NEAR-DUPLICATE PAIR {i}: ({near_dup['similarity']:.2%} similar)")
            print(
                f"File 1: {near_dup['insight1']['file']} ({near_dup['insight1']['planet']} in {near_dup['insight1']['sign']})"
            )
            print(
                f"File 2: {near_dup['insight2']['file']} ({near_dup['insight2']['planet']} in {near_dup['insight2']['sign']})"
            )
            print(f"Text 1: {near_dup['insight1']['text'][:80]}...")
            print(f"Text 2: {near_dup['insight2']['text'][:80]}...")
            print("-" * 40)

        if len(near_duplicates) > 10:
            print(f"... and {len(near_duplicates) - 10} more near-duplicates")
    else:
        print("✅ NO NEAR-DUPLICATES FOUND!")

    # Analyze common patterns
    print("\n🔍 ANALYZING COMMON PATTERNS...")
    patterns = analyze_common_patterns(all_insights)

    for pattern, matches in patterns.items():
        if matches:
            print(f"\n🔍 Pattern '{pattern}': {len(matches)} instances")
            files_with_pattern = set(match["file"] for match in matches)
            if len(files_with_pattern) > 1:
                print(f"   🚨 Found across {len(files_with_pattern)} different files!")
                print(f"   Files: {list(files_with_pattern)[:5]}...")  # Show first 5

    # Summary
    print("\n📋 AUDIT SUMMARY:")
    print(f"Total files processed: {file_count}")
    print(f"Total insights extracted: {len(all_insights)}")
    print(f"Exact duplicate sets: {len(exact_duplicates)}")
    print(f"Near-duplicate pairs: {len(near_duplicates)}")

    # Calculate uniqueness percentage
    unique_insights = len(all_insights) - sum(len(dups) - 1 for dups in exact_duplicates.values())
    uniqueness_percentage = (unique_insights / len(all_insights)) * 100 if all_insights else 0
    print(f"Content uniqueness: {uniqueness_percentage:.1f}%")

    if exact_duplicates or near_duplicates:
        print("\n🚨 ACTION REQUIRED: Duplicate content found that needs immediate fixing!")
    else:
        print("\n✅ EXCELLENT: All insights are unique!")


if __name__ == "__main__":
    main()
