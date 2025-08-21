#!/usr/bin/env python3
"""
Count insights in KASPERMLXRuntimeBundle
"""

import json
import os
from collections import defaultdict


def count_insights_in_file(file_path):
    """Count insights in a single JSON file"""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        total = 0

        # Handle different schema formats
        if isinstance(data, dict):
            # Check for number-based structure (e.g., "1": {...})
            for key, value in data.items():
                if key.isdigit() and isinstance(value, dict):
                    # This is a number-based file
                    for category, insights in value.items():
                        if isinstance(insights, list):
                            total += len(insights)
                elif isinstance(value, list):
                    # Direct category with list of insights
                    total += len(value)
                elif isinstance(value, dict):
                    # Nested structure - look for arrays
                    for sub_key, sub_value in value.items():
                        if isinstance(sub_value, list):
                            total += len(sub_value)
        elif isinstance(data, list):
            # Direct array of insights
            total = len(data)

        return total
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return 0


def main():
    """Count all insights in KASPERMLXRuntimeBundle"""
    print("🔍 Counting insights in KASPERMLXRuntimeBundle...")

    total_insights = 0
    total_files = 0
    persona_counts = defaultdict(int)

    # Walk through all directories
    for root, dirs, files in os.walk("KASPERMLXRuntimeBundle"):
        for file in files:
            if file.endswith(".json"):
                file_path = os.path.join(root, file)
                insights_count = count_insights_in_file(file_path)

                if insights_count > 0:
                    total_insights += insights_count
                    total_files += 1

                    # Extract persona from path
                    persona = "unknown"
                    if "Behavioral" in root:
                        persona_dir = os.path.basename(root)
                        persona = persona_dir
                    elif "FirebaseNumberMeanings" in root:
                        persona = "firebase_numbers"
                    elif "ZodiacMeanings" in root:
                        persona = "zodiac"

                    persona_counts[persona] += insights_count

                    print(f"  📄 {file}: {insights_count} insights")

    print("\n📊 KASPERMLXRuntimeBundle Summary:")
    print(f"  Total files: {total_files}")
    print(f"  Total insights: {total_insights:,}")

    print("\n📈 Insights by Persona/Type:")
    for persona, count in sorted(persona_counts.items()):
        print(f"  {persona}: {count:,} insights")

    return total_insights


if __name__ == "__main__":
    main()
