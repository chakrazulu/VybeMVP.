#!/usr/bin/env python3

import json
from pathlib import Path


def convert_lifepath_to_v2(input_file: Path, output_file: Path, number: int, title: str):
    """Convert Life Path v1.x to v2.0 behavioral format"""

    print(f"Converting Life Path {number}: {input_file.name} -> {output_file.name}")

    try:
        # Read v1.x file
        with open(input_file, "r", encoding="utf-8") as f:
            v1_data = json.load(f)

        # Extract behavioral data from v1.x format
        profile = v1_data["profiles"][0]  # First profile
        behavioral = profile.get("behavioral", {})

        # Build v2.0 format
        v2_data = {
            "number": number,
            "title": title,
            "behavioral_category": "life_path_behavioral_analysis",
            "intensity_scoring": {
                "min_range": 0.6,
                "max_range": 0.9,
                "note": "Higher intensity indicates stronger behavioral tendency",
            },
            "behavioral_insights": [],
        }

        # Process each behavioral category
        for category, insights in behavioral.items():
            if not isinstance(insights, list):
                continue

            for insight in insights:
                if isinstance(insight, dict) and "text" in insight:
                    behavioral_insight = {
                        "category": category,
                        "insight": insight["text"],
                        "intensity": insight.get("intensity", 0.7),
                        "triggers": insight.get("triggers", []),
                        "supports": insight.get("supports", []),
                        "challenges": insight.get("challenges", []),
                    }
                    v2_data["behavioral_insights"].append(behavioral_insight)
                elif isinstance(insight, str):
                    # Handle string-only insights
                    behavioral_insight = {
                        "category": category,
                        "insight": insight,
                        "intensity": 0.7,
                        "triggers": [],
                        "supports": [],
                        "challenges": [],
                    }
                    v2_data["behavioral_insights"].append(behavioral_insight)

        # Write v2.0 file
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(v2_data, f, indent=2, ensure_ascii=False)

        print(f"✅ Successfully converted {input_file.name} to {output_file.name}")
        print(f"   Generated {len(v2_data['behavioral_insights'])} behavioral insights")
        return True

    except Exception as e:
        print(f"❌ Error converting {input_file.name}: {str(e)}")
        return False


def main():
    """Convert missing Life Path numbers 4, 5, 6, 7, 8"""

    print("🔮 KASPER MLX Life Path Conversion - Missing Numbers 4, 5, 6, 7, 8")
    print("=" * 70)

    # File paths
    input_dir = Path(
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLX/MLXTraining/ContentRefinery/Incoming/LifePathContent"
    )
    output_dir = Path(
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLX/MLXTraining/ContentRefinery/Approved"
    )

    # Life Path mappings
    conversions = [
        (4, "The Builder", "lifePath_04_v1.1.json", "lifePath_04_v2.0_converted.json"),
        (5, "The Explorer", "lifePath_05_v1.1.json", "lifePath_05_v2.0_converted.json"),
        (6, "The Nurturer", "lifePath_06_v1.2.json", "lifePath_06_v2.0_converted.json"),
        (7, "The Seeker", "lifePath_07_v1.0.json", "lifePath_07_v2.0_converted.json"),
        (8, "The Achiever", "lifePath_08_v1.0.json", "lifePath_08_v2.0_converted.json"),
    ]

    success_count = 0
    total_count = len(conversions)

    for number, title, input_filename, output_filename in conversions:
        input_file = input_dir / input_filename
        output_file = output_dir / output_filename

        if not input_file.exists():
            print(f"⚠️  Input file not found: {input_filename}")
            continue

        if convert_lifepath_to_v2(input_file, output_file, number, title):
            success_count += 1

        print()  # Add spacing

    print("=" * 70)
    print(f"🎯 KASPER MLX Conversion Complete: {success_count}/{total_count} files converted")

    if success_count == total_count:
        print("✅ All missing Life Path numbers successfully converted to v2.0 format!")
        print("🚀 KASPER training corpus now complete: 1-9, 11, 22, 33, 44")
    else:
        print("⚠️  Some conversions failed - check output above")


if __name__ == "__main__":
    main()
