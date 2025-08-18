#!/usr/bin/env python3
"""
📊 Quick Insight Counter - See total before importing
"""

import json
import os

NUMEROLOGY_DATA_PATH = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData"


def count_insights():
    """Count insights in each category"""

    totals = {"Numbers": 0, "Planetary": 0, "Zodiac": 0}

    # Count Numbers
    number_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebaseNumberMeanings")
    if os.path.exists(number_path):
        print("📊 Counting Number insights...")
        for filename in os.listdir(number_path):
            if filename.endswith(".json"):
                try:
                    with open(os.path.join(number_path, filename), "r") as f:
                        data = json.load(f)

                    file_count = 0
                    for number_str, content in data.items():
                        if number_str.isdigit():
                            insights = content.get("insight", [])
                            file_count += len(insights)

                    totals["Numbers"] += file_count
                    print(f"   {filename}: {file_count:,} insights")
                except Exception as e:
                    print(f"   ❌ Error in {filename}: {e}")

    # Count Planetary
    planetary_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebasePlanetaryMeanings")
    if os.path.exists(planetary_path):
        print("\n🪐 Counting Planetary insights...")
        for filename in os.listdir(planetary_path):
            if filename.endswith(".json"):
                try:
                    with open(os.path.join(planetary_path, filename), "r") as f:
                        data = json.load(f)

                    file_count = 0
                    if "insights" in data:
                        file_count = len(data["insights"])
                    elif isinstance(data, list):
                        file_count = len(data)

                    totals["Planetary"] += file_count
                    print(f"   {filename}: {file_count:,} insights")
                except Exception as e:
                    print(f"   ❌ Error in {filename}: {e}")

    # Count Zodiac
    zodiac_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebaseZodiacMeanings")
    if os.path.exists(zodiac_path):
        print("\n♈ Counting Zodiac insights...")
        for filename in os.listdir(zodiac_path):
            if filename.endswith(".json"):
                try:
                    with open(os.path.join(zodiac_path, filename), "r") as f:
                        data = json.load(f)

                    file_count = 0
                    if "insights" in data:
                        file_count = len(data["insights"])
                    elif isinstance(data, list):
                        file_count = len(data)

                    totals["Zodiac"] += file_count
                    print(f"   {filename}: {file_count:,} insights")
                except Exception as e:
                    print(f"   ❌ Error in {filename}: {e}")

    # Summary
    total = sum(totals.values())

    print("\n📊 INSIGHT SUMMARY:")
    print(f"   Numbers: {totals['Numbers']:,}")
    print(f"   Planetary: {totals['Planetary']:,}")
    print(f"   Zodiac: {totals['Zodiac']:,}")
    print(f"   TOTAL: {total:,}")

    print("\n💰 COST ESTIMATES:")
    print(f"   Full import: ~${total * 0.0000018:.4f}")
    print(f"   Monthly reads (10k users): ~${total * 0.0000006:.4f}")

    return total


if __name__ == "__main__":
    count_insights()
