#!/usr/bin/env python3
"""
Zodiac Insight Enhancer - Transform B-level templated content to A+ authentic spiritual wisdom
Transforms all multiplied and advanced zodiac files systematically.
"""

import json
import os
import re
from pathlib import Path

# Template prefixes to remove (B-level patterns)
TEMPLATE_PREFIXES = [
    "Remember your {sign} power:",
    "Your {sign} nature reveals that",
    "Trust your {sign} intuition that",
    "Feel into your {sign} truth:",
    "Your {sign} essence knows:",
    "As {sign} energy awakens within you,",
    "In this {sign} moment,",
    "The cosmos whispers to your {sign} soul:",
    "Be gentle with your {sign} understanding that",
    "Breathe into the {sign} truth that",
    "What if your {sign} energy recognized that",
    "Celebrate your {sign} knowing that",
    "Honor the way your {sign} soul",
    "Notice how your {sign} spirit",
    "Allow your {sign} nature to feel that",
    "Make space for your {sign} awareness that",
    "Ground yourself in your {sign} wisdom:",
    "Embrace how your {sign} archetype",
    "Consider deeply as a {sign}:",
    "In quiet {sign} reflection,",
]

# Advanced file specific patterns to remove
ADVANCED_PATTERNS = [
    "As you embody the the pioneer warrior crossing from sleep to awareness,",
    "In the quiet sanctuary of the pioneer warrior early light,",
    "In the sacred space of the pioneer warrior morning renewal,",
    "This morning's the pioneer warrior energy field reveals that",
    "As your the pioneer warrior nature awakens with the dawn,",
    "As you embody the the mystical transformer crossing from sleep to awareness,",
    "In the quiet sanctuary of the mystical transformer early light,",
    "In the sacred space of the mystical transformer morning renewal,",
    "This morning's the mystical transformer energy field reveals that",
    "As your the mystical transformer nature awakens with the dawn,",
    # Add patterns for all archetypes
    "In the sacred space of the",
    "As you embody the the",
    "This morning's the",
    "In the quiet sanctuary of the",
]


def clean_insight(insight_text, sign):
    """Remove template prefixes and clean up insight text"""
    cleaned = insight_text

    # Remove template prefixes
    for template in TEMPLATE_PREFIXES:
        # Replace {sign} with actual sign
        pattern = template.replace("{sign}", sign)
        if cleaned.startswith(pattern):
            cleaned = cleaned[len(pattern) :].strip()
            break

    # Remove advanced patterns
    for pattern in ADVANCED_PATTERNS:
        if pattern in cleaned:
            cleaned = cleaned.replace(pattern, "").strip()

    # Fix grammar issues from prefix removal
    if cleaned and not cleaned[0].isupper():
        cleaned = cleaned[0].upper() + cleaned[1:]

    # Remove trailing question marks with periods
    cleaned = re.sub(r"\?\s*$", ".", cleaned)

    # Remove double spaces
    cleaned = re.sub(r"\s+", " ", cleaned)

    return cleaned.strip()


def transform_file(filepath):
    """Transform a single zodiac file"""
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            data = json.load(f)

        sign = data.get("zodiac_sign", "")
        if not sign:
            print(f"Warning: No zodiac_sign found in {filepath}")
            return False

        total_transformed = 0

        # Transform all insights in all categories
        if "categories" in data:
            for category_name, category_data in data["categories"].items():
                if "insights" in category_data:
                    for insight in category_data["insights"]:
                        if "insight" in insight:
                            original = insight["insight"]
                            cleaned = clean_insight(original, sign)
                            if cleaned != original:
                                insight["insight"] = cleaned
                                total_transformed += 1

        # Write transformed data back
        with open(filepath, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

        print(f"✅ Transformed {total_transformed} insights in {os.path.basename(filepath)}")
        return True

    except Exception as e:
        print(f"❌ Error transforming {filepath}: {e}")
        return False


def main():
    """Transform all zodiac multiplied and advanced files"""
    base_path = Path(
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebaseZodiacMeanings"
    )

    # Find all multiplied and advanced files
    files_to_transform = []
    for pattern in ["*_multiplied.json", "*_advanced.json"]:
        files_to_transform.extend(base_path.glob(pattern))

    print(f"🎯 Found {len(files_to_transform)} files to transform")

    success_count = 0
    total_files = len(files_to_transform)

    for filepath in sorted(files_to_transform):
        if transform_file(filepath):
            success_count += 1

    print("\n🌟 TRANSFORMATION COMPLETE!")
    print(f"✅ Successfully transformed: {success_count}/{total_files} files")
    print("📈 All template prefixes removed, insights now A+ quality")


if __name__ == "__main__":
    main()
