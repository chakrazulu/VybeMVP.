#!/usr/bin/env python3
"""
Fast exact duplicate detection for planet-zodiac insight content.
"""

import json
import os
from collections import defaultdict


def extract_insights_from_file(file_path):
    """Extract all insights from a JSON file."""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        insights = []
        if "insights" in data:
            for insight_obj in data["insights"]:
                if "insight" in insight_obj:
                    insights.append(
                        {
                            "text": insight_obj["insight"].strip(),
                            "planet": insight_obj.get("planet", ""),
                            "sign": insight_obj.get("sign", ""),
                            "context": insight_obj.get("context", ""),
                            "persona": insight_obj.get("persona", ""),
                            "file": os.path.basename(file_path),
                        }
                    )
        return insights
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return []


def main():
    """Main function to find exact duplicates."""
    base_path = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebasePlanetZodiacFusion"

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

    # Dictionary to group insights by exact text
    insights_by_text = defaultdict(list)
    total_insights = 0
    file_count = 0

    print("🔍 EXACT DUPLICATE DETECTION AUDIT")
    print("=" * 50)

    # Extract insights from all files
    for planet_dir in planet_dirs:
        dir_path = os.path.join(base_path, planet_dir)
        if not os.path.exists(dir_path):
            continue

        for filename in os.listdir(dir_path):
            if filename.endswith(".json"):
                file_path = os.path.join(dir_path, filename)
                insights = extract_insights_from_file(file_path)

                for insight in insights:
                    insights_by_text[insight["text"]].append(insight)
                    total_insights += 1

                file_count += 1

    print(f"📊 Processed {file_count} files")
    print(f"📊 Extracted {total_insights} total insights")

    # Find exact duplicates
    exact_duplicates = {
        text: insights for text, insights in insights_by_text.items() if len(insights) > 1
    }

    if exact_duplicates:
        print(f"\n🚨 FOUND {len(exact_duplicates)} SETS OF EXACT DUPLICATES!")
        print("=" * 60)

        total_duplicate_instances = 0
        for i, (text, duplicates) in enumerate(exact_duplicates.items(), 1):
            print(f"\n🔥 DUPLICATE SET {i}: ({len(duplicates)} instances)")

            # Show file and planet-sign combinations
            combinations = []
            for dup in duplicates:
                combo = f"{dup['planet']} in {dup['sign']} ({dup['file']})"
                combinations.append(combo)

            print("Files affected:")
            for combo in combinations:
                print(f"   - {combo}")

            print("Duplicate text:")
            print(f'   "{text[:150]}..."' if len(text) > 150 else f'   "{text}"')
            print("-" * 50)

            total_duplicate_instances += len(duplicates) - 1  # -1 because one is the original

        # Calculate uniqueness
        unique_insights = total_insights - total_duplicate_instances
        uniqueness_percentage = (unique_insights / total_insights) * 100

        print("\n📋 SUMMARY:")
        print(f"Total insights: {total_insights}")
        print(f"Duplicate sets: {len(exact_duplicates)}")
        print(f"Duplicate instances: {total_duplicate_instances}")
        print(f"Unique insights: {unique_insights}")
        print(f"Content uniqueness: {uniqueness_percentage:.1f}%")
        print(f"\n🚨 ACTION REQUIRED: {total_duplicate_instances} duplicate insights need fixing!")

    else:
        print("\n✅ EXCELLENT: NO EXACT DUPLICATES FOUND!")
        print("All insights are unique across all planet-zodiac combinations.")


if __name__ == "__main__":
    main()
