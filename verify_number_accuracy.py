#!/usr/bin/env python3
"""
CRITICAL VERIFICATION: Ensure every insight has the correct number association
This is CRITICAL - wrong numbers would give users incorrect spiritual guidance
"""

import json
import os
import re


def verify_persona_number_accuracy():
    """
    CRITICAL: Verify that persona files have correct number mappings
    Wrong numbers = wrong spiritual guidance to users
    """
    print("🔍 CRITICAL NUMBER ACCURACY VERIFICATION")
    print("=" * 50)

    personas_dir = "KASPERMLXRuntimeBundle/PersonaInsights"
    total_errors = 0

    for persona in ["AlanWatts", "CarlJung"]:
        persona_path = os.path.join(personas_dir, persona)
        if not os.path.exists(persona_path):
            print(f"❌ {persona} directory not found")
            continue

        print(f"\n📋 Verifying {persona} number accuracy...")
        persona_errors = 0

        for filename in sorted(os.listdir(persona_path)):
            if not filename.endswith(".json"):
                continue

            # Extract expected number from filename
            match = re.search(rf"{persona}Insights_Number_(\d+)\.json", filename)
            if not match:
                print(f"  ⚠️  Invalid filename: {filename}")
                continue

            expected_number = int(match.group(1))
            file_path = os.path.join(persona_path, filename)

            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    data = json.load(f)

                # Check number field in different schema formats
                actual_number = None

                if "number" in data:
                    # persona_with_categories schema
                    actual_number = data["number"]
                elif str(expected_number) in data:
                    # number_keyed_direct_categories schema
                    actual_number = expected_number  # Number is the key
                else:
                    print(f"  ❌ {filename}: No number field found")
                    persona_errors += 1
                    continue

                if actual_number == expected_number:
                    print(f"  ✅ {filename}: Number {expected_number} correct")
                else:
                    print(f"  ❌ {filename}: Expected {expected_number}, got {actual_number}")
                    persona_errors += 1

            except Exception as e:
                print(f"  ❌ {filename}: Error reading file - {e}")
                persona_errors += 1

        print(f"  📊 {persona}: {persona_errors} errors found")
        total_errors += persona_errors

    return total_errors


def verify_enhanced_numbers():
    """Verify Enhanced Numbers have correct associations"""
    print("\n📋 Verifying Enhanced Numbers...")

    enhanced_dir = "KASPERMLXRuntimeBundle/EnhancedNumbers"
    if not os.path.exists(enhanced_dir):
        print("❌ EnhancedNumbers directory not found")
        return 1

    errors = 0
    for filename in sorted(os.listdir(enhanced_dir)):
        if not filename.endswith(".json"):
            continue

        # Extract number from filename
        match = re.search(r"NumberMessages_Complete_(\d+)\.json", filename)
        if not match:
            print(f"  ⚠️  Non-standard filename: {filename}")
            continue

        expected_number = int(match.group(1))
        file_path = os.path.join(enhanced_dir, filename)

        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            # Should have number key
            if str(expected_number) in data:
                print(f"  ✅ {filename}: Number {expected_number} correct")
            else:
                print(f"  ❌ {filename}: Number {expected_number} key missing")
                errors += 1

        except Exception as e:
            print(f"  ❌ {filename}: Error - {e}")
            errors += 1

    return errors


def main():
    """Run complete number accuracy verification"""
    print("🚨 CRITICAL: VERIFYING NUMBER-INSIGHT ACCURACY")
    print("=" * 60)
    print("⚠️  Wrong numbers = wrong spiritual guidance to users!")

    persona_errors = verify_persona_number_accuracy()
    enhanced_errors = verify_enhanced_numbers()

    total_errors = persona_errors + enhanced_errors

    print("\n🏁 FINAL VERIFICATION RESULT:")
    if total_errors == 0:
        print("✅ ALL NUMBERS ACCURATE - Safe for users")
        print("🎯 Every insight correctly mapped to its number")
    else:
        print(f"❌ {total_errors} CRITICAL ERRORS FOUND")
        print("🚨 DO NOT DEPLOY - Users would get wrong guidance")

    return total_errors == 0


if __name__ == "__main__":
    main()
