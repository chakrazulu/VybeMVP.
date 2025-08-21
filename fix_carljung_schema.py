#!/usr/bin/env python3
"""
Fix Carl Jung Schema Corruption - CRITICAL BUG FIX
Repairs null number fields in Carl Jung PersonaInsights files
"""

import json
import os
import re


def fix_carljung_number_fields():
    """
    CRITICAL FIX: Repair null number fields in Carl Jung files

    ISSUE: Multiple Carl Jung files have number: null instead of actual numbers
    IMPACT: Will cause runtime crashes when KASPER tries to load these files
    SOLUTION: Extract number from filename and set correct number field
    """
    print("🚨 FIXING CRITICAL CARL JUNG SCHEMA CORRUPTION")
    print("=" * 60)

    # Path to Carl Jung files in RuntimeBundle
    carljung_dir = "KASPERMLXRuntimeBundle/PersonaInsights/CarlJung"

    if not os.path.exists(carljung_dir):
        print(f"❌ Directory not found: {carljung_dir}")
        return

    files_fixed = 0
    files_checked = 0

    # Process each Carl Jung file
    for filename in os.listdir(carljung_dir):
        if not filename.startswith("CarlJungInsights_Number_") or not filename.endswith(".json"):
            continue

        files_checked += 1
        file_path = os.path.join(carljung_dir, filename)

        # Extract expected number from filename using regex
        match = re.search(r"CarlJungInsights_Number_(\d+)\.json", filename)
        if not match:
            print(f"⚠️  Could not extract number from filename: {filename}")
            continue

        expected_number = int(match.group(1))

        # Load and check the file
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            # Check if number field is null or incorrect
            current_number = data.get("number")

            if current_number is None or current_number != expected_number:
                print(f"🔧 FIXING {filename}: number {current_number} → {expected_number}")

                # Fix the number field
                data["number"] = expected_number

                # Write back to file
                with open(file_path, "w", encoding="utf-8") as f:
                    json.dump(data, f, indent=2, ensure_ascii=False)

                files_fixed += 1
            else:
                print(f"✅ {filename}: number field correct ({current_number})")

        except Exception as e:
            print(f"❌ Error processing {filename}: {e}")

    print("\n📊 REPAIR SUMMARY:")
    print(f"  Files checked: {files_checked}")
    print(f"  Files fixed: {files_fixed}")
    print(f"  Status: {'✅ ALL FIXED' if files_fixed == 0 else f'🔧 {files_fixed} REPAIRED'}")


def verify_all_schemas():
    """
    VERIFICATION: Check all PersonaInsights files for schema compliance

    Ensures that:
    1. Alan Watts files have correct number fields
    2. Carl Jung files have correct number fields (after fix)
    3. No other schema corruptions exist
    """
    print("\n🔍 VERIFYING ALL PERSONA SCHEMAS")
    print("=" * 40)

    personas = ["AlanWatts", "CarlJung"]
    total_issues = 0

    for persona in personas:
        persona_dir = f"KASPERMLXRuntimeBundle/PersonaInsights/{persona}"

        if not os.path.exists(persona_dir):
            print(f"⚠️  {persona} directory not found")
            continue

        print(f"\n📋 Checking {persona} files...")
        persona_issues = 0

        for filename in sorted(os.listdir(persona_dir)):
            if not filename.endswith(".json"):
                continue

            file_path = os.path.join(persona_dir, filename)

            # Extract expected number from filename
            match = re.search(rf"{persona}Insights_Number_(\d+)\.json", filename)
            if not match:
                print(f"  ⚠️  Invalid filename format: {filename}")
                continue

            expected_number = int(match.group(1))

            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    data = json.load(f)

                # Check number field
                actual_number = data.get("number")

                if actual_number != expected_number:
                    print(f"  ❌ {filename}: number {actual_number} ≠ {expected_number}")
                    persona_issues += 1
                    total_issues += 1
                else:
                    print(f"  ✅ {filename}: number field correct")

                # Check for required categories
                if "categories" not in data:
                    print(f"  ❌ {filename}: missing categories field")
                    persona_issues += 1
                    total_issues += 1

            except Exception as e:
                print(f"  ❌ {filename}: JSON error - {e}")
                persona_issues += 1
                total_issues += 1

        print(f"  📊 {persona}: {persona_issues} issues found")

    print("\n🎯 OVERALL VERIFICATION RESULT:")
    if total_issues == 0:
        print("  ✅ ALL SCHEMAS VALID - Ready for production")
    else:
        print(f"  ❌ {total_issues} ISSUES REMAIN - Needs more fixing")

    return total_issues == 0


def main():
    """
    Main execution flow:
    1. Fix Carl Jung number field corruption
    2. Verify all schemas are correct
    3. Report final status
    """
    print("🔧 KASPERMLX SCHEMA REPAIR UTILITY")
    print("=" * 50)

    # Step 1: Fix the critical Carl Jung corruption
    fix_carljung_number_fields()

    # Step 2: Verify everything is working
    all_valid = verify_all_schemas()

    # Step 3: Final status
    print("\n🏁 FINAL STATUS:")
    if all_valid:
        print("  🎉 ALL SCHEMAS REPAIRED AND VERIFIED")
        print("  ✅ RuntimeBundle ready for production deployment")
    else:
        print("  ⚠️  ADDITIONAL ISSUES REMAIN")
        print("  🔧 Manual intervention may be required")


if __name__ == "__main__":
    main()
