#!/usr/bin/env python3

"""
🪐 SIMPLE Planetary Insights Multiplier
Multiply planetary insights with simple variations - maintaining planetary-specific structure
"""

import json
import os
import random
from datetime import datetime


def multiply_planetary_insights():
    """Multiply Planetary insights from original files"""
    print("🪐 Simple Planetary Insights Multiplication...")

    base_dir = "NumerologyData/FirebasePlanetaryMeanings"

    # All 10 planets
    planets = [
        "Sun",
        "Moon",
        "Mercury",
        "Venus",
        "Mars",
        "Jupiter",
        "Saturn",
        "Uranus",
        "Neptune",
        "Pluto",
    ]

    # Process each planet
    for planet in planets:
        input_file = f"{base_dir}/PlanetaryInsights_{planet}_original.json"
        output_file = f"{base_dir}/PlanetaryInsights_{planet}_multiplied.json"

        if not os.path.exists(input_file):
            print(f"❌ Skipping {planet} - file not found")
            continue

        print(f"🪐 Processing {planet}...")

        # Load source
        with open(input_file, "r") as f:
            data = json.load(f)

        # Create multiplied structure
        multiplied_data = {
            "planet": data["planet"],
            "symbol": data.get("symbol", ""),
            "element": data.get("element", ""),
            "archetype": data["archetype"],
            "psychological_focus": data["psychological_focus"],
            "ruling_signs": data.get("ruling_signs", []),
            "base_insights": data.get("base_insights", 0),
            "target_insights_post_multiplication": data.get(
                "target_insights_post_multiplication", 0
            ),
            "total_multiplied_insights": 0,  # Will be calculated
            "categories": {},
            "meta": {
                "type": "planetary_multiplied",
                "generation_date": datetime.now().isoformat(),
                "source_file": f"PlanetaryInsights_{planet}_original.json",
                "note": "Contains ONLY new multiplied insights - NO originals",
            },
        }

        total_count = 0

        # Multiply each category
        for category_name, category_data in data["categories"].items():
            if "insights" in category_data:
                multiplied_insights = multiply_planetary_category(
                    category_data["insights"], planet, category_name
                )

                multiplied_data["categories"][category_name] = {
                    "description": category_data["description"],
                    "insights": multiplied_insights,
                }

                total_count += len(multiplied_insights)

        # Update total count
        multiplied_data["total_multiplied_insights"] = total_count

        # Save multiplied file
        with open(output_file, "w") as f:
            json.dump(multiplied_data, f, indent=2)

        print(f"✅ Generated {total_count} insights for {planet}")

    print("🎉 Planetary insights multiplication complete!")


def multiply_planetary_category(base_insights, planet, category):
    """Multiply insights for a single planetary category"""
    multiplied = []

    # Planet-specific variation templates
    contexts = [
        "As {planet} energy awakens within you, {insight}",
        "In this {planet} moment, {insight}",
        "Your {planet} nature reveals that {insight}",
        "Consider deeply through {planet} wisdom: {insight}",
        "The cosmos speaks through {planet}: {insight}",
        "Your {planet} consciousness knows: {insight}",
        "In quiet {planet} reflection, {insight}",
        "Trust your {planet} guidance that {insight}",
        "Feel into your {planet} truth: {insight}",
        "Remember your {planet} power: {insight}",
    ]

    styles = [
        "What if your {planet} energy recognized that {insight}?",
        "Notice how your {planet} influence {insight}",
        "Allow your {planet} nature to feel that {insight}",
        "Breathe into the {planet} truth that {insight}",
        "Honor the way your {planet} archetype {insight}",
        "Embrace how your {planet} psychology {insight}",
        "Be gentle with your {planet} understanding that {insight}",
        "Celebrate your {planet} knowing that {insight}",
        "Make space for your {planet} awareness that {insight}",
        "Ground yourself in your {planet} wisdom: {insight}",
    ]

    # Generate 3-4 variations per original insight
    for base_insight in base_insights:
        # Clean the base insight text
        clean_base = clean_planetary_insight(base_insight["insight"], planet)

        # Create contextual variations (2 per original)
        for _ in range(2):
            template = random.choice(contexts)
            variation_text = template.format(planet=planet, insight=clean_base.lower())

            # Create new insight with preserved metadata
            variation = create_planetary_variation(base_insight, variation_text, "multiplied")
            if variation not in [m["insight"] for m in multiplied]:
                multiplied.append(variation)

        # Create style variations (2 per original)
        for _ in range(2):
            template = random.choice(styles)
            variation_text = template.format(planet=planet, insight=clean_base.lower())

            # Create new insight with preserved metadata
            variation = create_planetary_variation(base_insight, variation_text, "multiplied")
            if variation not in [m["insight"] for m in multiplied]:
                multiplied.append(variation)

    return multiplied


def clean_planetary_insight(insight, planet):
    """Clean insight by removing planet references"""
    clean = insight.replace(f"{planet}", "this planetary energy")
    clean = clean.replace(f"Through {planet}", "through this energy")
    clean = clean.replace(f"With {planet}", "with this energy")
    clean = clean.replace("this planetary energy energy", "this planetary energy")
    clean = clean.replace("this energy this energy", "this energy")

    # Clean up grammar
    if clean.startswith("is "):
        clean = clean[3:]
    if clean.startswith("teaches "):
        clean = clean[8:]
    if clean.startswith("reveals "):
        clean = clean[8:]

    clean = clean.strip()

    # Ensure proper capitalization
    if clean and not clean[0].isupper():
        clean = clean[0].lower() + clean[1:]

    return clean


def create_planetary_variation(base_insight, new_text, tier):
    """Create a new planetary insight variation preserving metadata"""
    return {
        "planet": base_insight["planet"],
        "context": base_insight["context"],
        "persona": base_insight["persona"],
        "intensity": base_insight["intensity"],
        "wisdom_focus": base_insight["wisdom_focus"],
        "category": base_insight["category"],
        "insight": new_text,
        "behavioral_focus": base_insight["behavioral_focus"],
        "integration_practice": base_insight["integration_practice"],
        "quality_score": round(
            base_insight["quality_score"] - 0.05, 2
        ),  # Slightly lower for multiplied
        "tier": tier,
    }


if __name__ == "__main__":
    multiply_planetary_insights()
