#!/usr/bin/env python3

"""
🔥 SIMPLE Firebase Insights Multiplier
Just multiply the existing insights with simple variations - no overcomplications!
"""

import json
import os
import random
from datetime import datetime


def multiply_firebase_insights():
    """Multiply Firebase insights from NumberMeanings files"""
    print("🔥 Simple Firebase Insights Multiplication...")

    base_dir = "NumerologyData/FirebaseNumberMeanings"

    # Process each number file
    for number in range(10):  # 0-9
        input_file = f"{base_dir}/NumberMessages_Complete_{number}.json"
        output_file = f"{base_dir}/NumberMessages_Complete_{number}_multiplied.json"

        if not os.path.exists(input_file):
            print(f"❌ Skipping {number} - file not found")
            continue

        print(f"🔢 Processing Number {number}...")

        # Load source
        with open(input_file, "r") as f:
            data = json.load(f)

        source = data[str(number)]
        multiplied = {}

        # Multiply each category
        for category, insights in source.items():
            if isinstance(insights, list):
                multiplied[category] = multiply_category(insights, category, number)

        # Save multiplied file
        result = {
            str(number): multiplied,
            "meta": {
                "type": "firebase_multiplied",
                "generation_date": datetime.now().isoformat(),
                "source_file": f"NumberMessages_Complete_{number}.json",
                "note": "Contains ONLY new multiplied insights - NO originals",
            },
        }

        with open(output_file, "w") as f:
            json.dump(result, f, indent=2)

        total_count = sum(len(v) for v in multiplied.values() if isinstance(v, list))
        print(f"✅ Generated {total_count} insights for Number {number}")

    print("🎉 Firebase insights multiplication complete!")


def multiply_category(base_insights, category, number):
    """Multiply insights for a single category"""
    multiplied = []

    # Simple variation templates
    contexts = [
        "As you start your day, {}",
        "In this moment, {}",
        "Today's energy reveals that {}",
        "Consider deeply: {}",
        "The universe whispers: {}",
        "Your soul knows: {}",
        "In quiet reflection, {}",
        "Trust that {}",
        "Feel into how {}",
        "Remember: {}",
    ]

    styles = [
        "What if {}?",
        "Notice how {}",
        "Allow yourself to feel that {}",
        "Breathe into the truth that {}",
        "Honor the way {}",
        "Embrace how {}",
        "Be gentle with the fact that {}",
        "Celebrate that {}",
        "Make space for the reality that {}",
        "Ground yourself in knowing {}",
    ]

    # Generate 3-4 variations per original insight
    for base in base_insights:
        # Clean the base insight
        clean_base = clean_insight(base, number)

        # Create contextual variations (2 per original)
        for _ in range(2):
            template = random.choice(contexts)
            variation = template.format(clean_base.lower())
            if variation not in multiplied:
                multiplied.append(variation)

        # Create style variations (2 per original)
        for _ in range(2):
            template = random.choice(styles)
            variation = template.format(clean_base.lower())
            if variation not in multiplied:
                multiplied.append(variation)

    return multiplied


def clean_insight(insight, number):
    """Clean insight by removing number references"""
    # Remove specific number references more carefully
    clean = insight.replace(f"Number {number}", "this energy")
    clean = clean.replace(f"The number {number}", "this energy")
    clean = clean.replace("number One", "this energy")
    clean = clean.replace("Number One", "this energy")
    clean = clean.replace("The number One", "this energy")
    clean = clean.replace("One is", "this energy is")
    clean = clean.replace("One ", "this energy ")

    # Remove other number words more carefully
    number_words = ["Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"]
    for word in number_words:
        clean = clean.replace(f"Number {word}", "this energy")
        clean = clean.replace(f"The number {word}", "this energy")
        clean = clean.replace(f"{word} is", "this energy is")
        clean = clean.replace(f"{word} ", "this energy ")

    # Clean up grammar - be more careful
    if clean.startswith("is "):
        clean = clean[3:]
    if clean.startswith("teaches "):
        clean = clean[8:]

    clean = clean.strip()

    # Ensure proper capitalization
    if clean and not clean[0].isupper():
        clean = clean[0].lower() + clean[1:]

    return clean


if __name__ == "__main__":
    multiply_firebase_insights()
