#!/usr/bin/env python3
"""
🔍 Structure Validator - Test insights format before Firebase
Validates that NumerologyData can be properly converted to Firebase format
"""

import hashlib
import json
import os

# Configuration
NUMEROLOGY_DATA_PATH = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData"


def generate_insight_id(text, number):
    """Generate consistent ID for insights"""
    content = f"{text}_{number}_test"
    return f"test_{hashlib.md5(content.encode()).hexdigest()[:8]}"


def determine_category(text):
    """Simple category determination"""
    text_lower = text.lower()
    if "reflect" in text_lower or "contemplate" in text_lower:
        return "reflection"
    elif "manifest" in text_lower or "create" in text_lower:
        return "manifestation"
    elif "challenge" in text_lower or "difficult" in text_lower:
        return "challenge"
    else:
        return "insight"


def determine_context(text):
    """Simple context determination"""
    text_lower = text.lower()
    if "morning" in text_lower or "dawn" in text_lower:
        return "morning_awakening"
    elif "evening" in text_lower or "night" in text_lower:
        return "evening_integration"
    else:
        return "daily"


def validate_structure():
    """Validate structure without Firebase connection"""
    print("🔍 Validating NumerologyData → Firebase format conversion")
    print("=" * 60)

    # Find a number file to test with
    number_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebaseNumberMeanings")
    test_file = None

    if not os.path.exists(number_path):
        print(f"❌ Path not found: {number_path}")
        return

    for filename in os.listdir(number_path):
        if filename.endswith(".json") and "Complete_1" in filename:
            test_file = os.path.join(number_path, filename)
            break

    if not test_file:
        print("❌ No test file found")
        return

    print(f"📁 Testing with: {os.path.basename(test_file)}")

    # Load and process test file
    try:
        with open(test_file, "r") as f:
            data = json.load(f)
        print("✅ File loaded successfully")
    except Exception as e:
        print(f"❌ Failed to load file: {e}")
        return

    # Validate structure
    if "1" not in data:
        print("❌ Number '1' not found in data")
        return

    insights_list = data["1"].get("insight", [])
    if not insights_list:
        print("❌ No insights found in number '1'")
        return

    print(f"✅ Found {len(insights_list)} insights for number 1")

    # Process first 3 insights as examples
    converted_insights = []

    for i, insight_text in enumerate(insights_list[:3]):
        if not insight_text or len(insight_text.strip()) < 5:
            continue

        insight_id = generate_insight_id(insight_text, 1)

        # Create document matching your exact Firebase structure
        doc_data = {
            "category": determine_category(insight_text),
            "context": determine_context(insight_text),
            "number": 1,
            "persona": "oracle",
            "quality_score": 0.95,
            "system": "number",
            "text": insight_text.strip(),
            "tier": "archetypal",
        }

        converted_insights.append({"id": insight_id, "data": doc_data})

        print(f"\n📝 Example {i+1}:")
        print(f"   ID: {insight_id}")
        print(f"   Text: {insight_text[:50]}...")
        print(f"   Category: {doc_data['category']}")
        print(f"   Context: {doc_data['context']}")

    print("\n✅ Structure validation complete!")
    print(f"📊 Sample conversion successful for {len(converted_insights)} insights")

    # Estimate total insights
    total_insights = 0

    # Count Number insights
    if os.path.exists(number_path):
        for filename in os.listdir(number_path):
            if filename.endswith(".json"):
                try:
                    filepath = os.path.join(number_path, filename)
                    with open(filepath, "r") as f:
                        file_data = json.load(f)

                    for number_str, content in file_data.items():
                        if number_str.isdigit():
                            insights = content.get("insight", [])
                            total_insights += len(insights)
                except Exception:
                    continue

    # Count Planetary insights
    planetary_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebasePlanetaryMeanings")
    if os.path.exists(planetary_path):
        for filename in os.listdir(planetary_path):
            if filename.endswith(".json"):
                try:
                    filepath = os.path.join(planetary_path, filename)
                    with open(filepath, "r") as f:
                        file_data = json.load(f)

                    if "insights" in file_data:
                        total_insights += len(file_data["insights"])
                    elif isinstance(file_data, list):
                        total_insights += len(file_data)
                except Exception:
                    continue

    # Count Zodiac insights
    zodiac_path = os.path.join(NUMEROLOGY_DATA_PATH, "FirebaseZodiacMeanings")
    if os.path.exists(zodiac_path):
        for filename in os.listdir(zodiac_path):
            if filename.endswith(".json"):
                try:
                    filepath = os.path.join(zodiac_path, filename)
                    with open(filepath, "r") as f:
                        file_data = json.load(f)

                    if "insights" in file_data:
                        total_insights += len(file_data["insights"])
                    elif isinstance(file_data, list):
                        total_insights += len(file_data)
                except Exception:
                    continue

    print("\n📊 ESTIMATED IMPORT VOLUME:")
    print(f"   Total insights found: ~{total_insights:,}")
    print(f"   Estimated Firebase reads: {total_insights} (for upload)")
    print(f"   Estimated cost: ~${total_insights * 0.0000018:.4f}")

    print("\n🎯 NEXT STEPS:")
    print("1. Set up Firebase Admin SDK credentials")
    print("2. Run test import of 10 insights")
    print("3. Verify structure in Firebase Console")
    print("4. Run full import of all insights")
    print("5. Wire insights into your Swift app")

    return True


if __name__ == "__main__":
    validate_structure()
