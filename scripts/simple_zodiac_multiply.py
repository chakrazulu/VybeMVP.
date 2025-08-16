#!/usr/bin/env python3

"""
🔥 SIMPLE Zodiac Insights Multiplier
Multiply zodiac insights with simple variations - maintaining zodiac-specific structure
"""

import json
import os
import random
from datetime import datetime


def multiply_zodiac_insights():
    """Multiply Zodiac insights from original files"""
    print("🔥 Simple Zodiac Insights Multiplication...")

    base_dir = "NumerologyData/FirebaseZodiacMeanings"

    # All 12 zodiac signs
    zodiac_signs = [
        "Aries",
        "Taurus",
        "Gemini",
        "Cancer",
        "Leo",
        "Virgo",
        "Libra",
        "Scorpio",
        "Sagittarius",
        "Capricorn",
        "Aquarius",
        "Pisces",
    ]

    # Process each zodiac sign
    for sign in zodiac_signs:
        input_file = f"{base_dir}/ZodiacInsights_{sign}_original.json"
        output_file = f"{base_dir}/ZodiacInsights_{sign}_multiplied.json"

        if not os.path.exists(input_file):
            print(f"❌ Skipping {sign} - file not found")
            continue

        print(f"♈ Processing {sign}...")

        # Load source
        with open(input_file, "r") as f:
            data = json.load(f)

        # Create multiplied structure
        multiplied_data = {
            "zodiac_sign": data["zodiac_sign"],
            "element": data["element"],
            "modality": data["modality"],
            "archetype": data["archetype"],
            "ruling_planet": data["ruling_planet"],
            "total_insights": 0,  # Will be calculated
            "categories": {},
            "meta": {
                "type": "zodiac_multiplied",
                "generation_date": datetime.now().isoformat(),
                "source_file": f"ZodiacInsights_{sign}_original.json",
                "note": "Contains ONLY new multiplied insights - NO originals",
            },
        }

        total_count = 0

        # Multiply each category
        for category_name, category_data in data["categories"].items():
            if "insights" in category_data:
                multiplied_insights = multiply_zodiac_category(
                    category_data["insights"], sign, category_name
                )

                multiplied_data["categories"][category_name] = {
                    "description": category_data["description"],
                    "insights": multiplied_insights,
                }

                total_count += len(multiplied_insights)

        # Update total count
        multiplied_data["total_insights"] = total_count

        # Save multiplied file
        with open(output_file, "w") as f:
            json.dump(multiplied_data, f, indent=2)

        print(f"✅ Generated {total_count} insights for {sign}")

    print("🎉 Zodiac insights multiplication complete!")


def multiply_zodiac_category(base_insights, sign, category):
    """Multiply insights for a single zodiac category"""
    multiplied = []

    # Zodiac-specific variation templates
    contexts = [
        "As {sign} energy awakens within you, {insight}",
        "In this {sign} moment, {insight}",
        "Your {sign} nature reveals that {insight}",
        "Consider deeply as a {sign}: {insight}",
        "The cosmos whispers to your {sign} soul: {insight}",
        "Your {sign} essence knows: {insight}",
        "In quiet {sign} reflection, {insight}",
        "Trust your {sign} intuition that {insight}",
        "Feel into your {sign} truth: {insight}",
        "Remember your {sign} power: {insight}",
    ]

    styles = [
        "What if your {sign} energy recognized that {insight}?",
        "Notice how your {sign} spirit {insight}",
        "Allow your {sign} nature to feel that {insight}",
        "Breathe into the {sign} truth that {insight}",
        "Honor the way your {sign} soul {insight}",
        "Embrace how your {sign} archetype {insight}",
        "Be gentle with your {sign} understanding that {insight}",
        "Celebrate your {sign} knowing that {insight}",
        "Make space for your {sign} awareness that {insight}",
        "Ground yourself in your {sign} wisdom: {insight}",
    ]

    # Generate 3-4 variations per original insight
    for base_insight in base_insights:
        # Clean the base insight text
        clean_base = clean_zodiac_insight(base_insight["insight"], sign)

        # Create contextual variations (2 per original)
        for _ in range(2):
            template = random.choice(contexts)
            variation_text = template.format(sign=sign, insight=clean_base.lower())

            # Create new insight with preserved metadata
            variation = create_zodiac_variation(base_insight, variation_text, "multiplied")
            if variation not in [m["insight"] for m in multiplied]:
                multiplied.append(variation)

        # Create style variations (2 per original)
        for _ in range(2):
            template = random.choice(styles)
            variation_text = template.format(sign=sign, insight=clean_base.lower())

            # Create new insight with preserved metadata
            variation = create_zodiac_variation(base_insight, variation_text, "multiplied")
            if variation not in [m["insight"] for m in multiplied]:
                multiplied.append(variation)

    return multiplied


def clean_zodiac_insight(insight, sign):
    """Clean insight by removing sign references"""
    clean = insight.replace(f"{sign}", "your essence")
    clean = clean.replace(f"As an {sign}", "as you")
    clean = clean.replace(f"As a {sign}", "as you")
    clean = clean.replace("you you", "you")
    clean = clean.replace("your essence essence", "your essence")

    # Clean up grammar
    if clean.startswith("is "):
        clean = clean[3:]
    if clean.startswith("teaches "):
        clean = clean[8:]

    clean = clean.strip()

    # Ensure proper capitalization
    if clean and not clean[0].isupper():
        clean = clean[0].lower() + clean[1:]

    return clean


def create_zodiac_variation(base_insight, new_text, tier):
    """Create a new zodiac insight variation preserving metadata"""
    return {
        "sign": base_insight["sign"],
        "element": base_insight["element"],
        "modality": base_insight["modality"],
        "context": base_insight["context"],
        "persona": base_insight["persona"],
        "intensity": base_insight["intensity"],
        "wisdom_focus": base_insight["wisdom_focus"],
        "category": base_insight["category"],
        "insight": new_text,
        "quality_score": round(
            base_insight["quality_score"] - 0.05, 2
        ),  # Slightly lower for multiplied
        "tier": tier,
    }


if __name__ == "__main__":
    multiply_zodiac_insights()
