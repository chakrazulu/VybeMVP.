#!/usr/bin/env python3
"""
Analyze duplicate content by planet to identify which systems are most affected.
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
                            "file": os.path.basename(file_path),
                        }
                    )
        return insights
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return []


def main():
    """Analyze duplicates by planet."""
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

    planet_stats = {}
    insights_by_text = defaultdict(list)

    print("🔍 DUPLICATE ANALYSIS BY PLANET")
    print("=" * 50)

    # Extract insights by planet
    for planet_dir in planet_dirs:
        planet_name = planet_dir.replace("_Combinations", "")
        planet_stats[planet_name] = {"total_insights": 0, "files_processed": 0}

        dir_path = os.path.join(base_path, planet_dir)
        if not os.path.exists(dir_path):
            continue

        for filename in os.listdir(dir_path):
            if filename.endswith(".json"):
                file_path = os.path.join(dir_path, filename)
                insights = extract_insights_from_file(file_path)

                planet_stats[planet_name]["total_insights"] += len(insights)
                planet_stats[planet_name]["files_processed"] += 1

                for insight in insights:
                    insights_by_text[insight["text"]].append(insight)

    # Find exact duplicates by planet
    exact_duplicates = {
        text: insights for text, insights in insights_by_text.items() if len(insights) > 1
    }

    # Analyze duplicates by planet
    planet_duplicate_counts = defaultdict(int)
    for text, duplicates in exact_duplicates.items():
        planets_affected = set()
        for dup in duplicates:
            planets_affected.add(dup["planet"])

        # Count duplicates per planet
        for planet in planets_affected:
            planet_duplicate_count = sum(1 for dup in duplicates if dup["planet"] == planet)
            if (
                planet_duplicate_count > 1
            ):  # Only count if there are actual duplicates within the planet
                planet_duplicate_counts[planet] += 1

    # Display results
    print("📊 PLANET DUPLICATE SUMMARY:")
    print("-" * 40)

    for planet in sorted(planet_stats.keys()):
        total = planet_stats[planet]["total_insights"]
        files = planet_stats[planet]["files_processed"]
        duplicates = planet_duplicate_counts.get(planet, 0)

        if duplicates > 0:
            print(f"🚨 {planet}: {duplicates} duplicate sets, {total} total insights, {files} files")
        else:
            print(f"✅ {planet}: NO duplicates, {total} total insights, {files} files")

    print("\n📋 OVERALL SUMMARY:")
    total_duplicate_sets = len(exact_duplicates)
    total_planets_affected = len(
        [p for p in planet_duplicate_counts.keys() if planet_duplicate_counts[p] > 0]
    )

    print(f"Total duplicate text sets: {total_duplicate_sets}")
    print(f"Planets with duplicates: {total_planets_affected}/10")

    print("\n🎯 MOST AFFECTED PLANETS:")
    sorted_planets = sorted(planet_duplicate_counts.items(), key=lambda x: x[1], reverse=True)
    for planet, count in sorted_planets[:5]:
        print(f"   {planet}: {count} duplicate sets")


if __name__ == "__main__":
    main()
