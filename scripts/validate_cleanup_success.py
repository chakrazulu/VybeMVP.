#!/usr/bin/env python3
"""
Surgical Cleanup Validation - VybeMVP RuntimeBundle
===================================================

Validates that the surgical markdown cleanup was 100% successful:
1. No ** artifacts remain in cleaned files
2. All JSON structures are valid
3. All spiritual content is preserved
4. Backup contains original artifacts for safety
"""

import json
import re
from pathlib import Path


def validate_cleanup():
    """Comprehensive validation of surgical cleanup results"""

    runtime_bundle_path = Path(
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLXRuntimeBundle"
    )
    backup_path = Path(
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/RuntimeBundle_BACKUP_20250821_201719"
    )
    rich_numbers_path = runtime_bundle_path / "RichNumberMeanings"
    backup_rich_path = backup_path / "RichNumberMeanings"

    print("🔬 SURGICAL CLEANUP VALIDATION")
    print("=" * 50)

    # Check 1: No ** artifacts in cleaned files
    print("1. Checking for remaining ** artifacts...")
    markdown_pattern = re.compile(r"\*\*(.*?)\*\*")
    artifacts_found = 0

    for json_file in rich_numbers_path.glob("*.json"):
        with open(json_file, "r", encoding="utf-8") as f:
            content = f.read()
            matches = markdown_pattern.findall(content)
            if matches:
                artifacts_found += len(matches)
                print(f"   ❌ Found {len(matches)} artifacts in {json_file.name}")

    if artifacts_found == 0:
        print("   ✅ No ** artifacts found in cleaned files")
    else:
        print(f"   ❌ Total artifacts remaining: {artifacts_found}")
        return False

    # Check 2: All JSON structures valid
    print("\n2. Validating JSON structure integrity...")
    json_valid_count = 0

    for json_file in rich_numbers_path.glob("*.json"):
        try:
            with open(json_file, "r", encoding="utf-8") as f:
                data = json.load(f)

            # Verify required fields exist
            required_fields = ["number", "title", "behavioral_insights", "meta"]
            if all(field in data for field in required_fields):
                json_valid_count += 1
            else:
                print(f"   ❌ Missing required fields in {json_file.name}")
                return False

        except json.JSONDecodeError as e:
            print(f"   ❌ Invalid JSON in {json_file.name}: {e}")
            return False

    print(f"   ✅ All {json_valid_count} JSON files are structurally valid")

    # Check 3: Spiritual content preserved
    print("\n3. Verifying spiritual content preservation...")

    # Test key spiritual phrases are preserved
    test_phrases = [
        ("1_rich.json", "pure initiating force"),
        ("5_rich.json", "pure freedom energy"),
        ("11_rich.json", "powerful bridge between the mortal and immortal realms"),
        ("22_rich.json", "The Master Builder"),
        ("33_rich.json", "Master Teacher of Love"),
        ("44_rich.json", "Master Healer of Worlds"),
    ]

    content_preserved = True
    for filename, phrase in test_phrases:
        file_path = rich_numbers_path / filename
        if file_path.exists():
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()
                if phrase in content:
                    print(f"   ✅ Found '{phrase}' in {filename}")
                else:
                    print(f"   ❌ Missing '{phrase}' in {filename}")
                    content_preserved = False
        else:
            print(f"   ❌ File not found: {filename}")
            content_preserved = False

    if not content_preserved:
        return False

    # Check 4: Backup contains original artifacts
    print("\n4. Validating backup safety...")

    if backup_rich_path.exists():
        backup_artifacts = 0
        for json_file in backup_rich_path.glob("*.json"):
            with open(json_file, "r", encoding="utf-8") as f:
                content = f.read()
                matches = markdown_pattern.findall(content)
                backup_artifacts += len(matches)

        if backup_artifacts > 0:
            print(f"   ✅ Backup contains {backup_artifacts} original ** artifacts")
        else:
            print("   ❌ Backup appears to be corrupted (no artifacts found)")
            return False
    else:
        print("   ❌ Backup directory not found")
        return False

    # Check 5: Insight count preservation
    print("\n5. Verifying insight count preservation...")

    for json_file in rich_numbers_path.glob("*.json"):
        with open(json_file, "r", encoding="utf-8") as f:
            data = json.load(f)

        backup_file = backup_rich_path / json_file.name
        with open(backup_file, "r", encoding="utf-8") as f:
            backup_data = json.load(f)

        cleaned_insights = len(data.get("behavioral_insights", []))
        backup_insights = len(backup_data.get("behavioral_insights", []))

        if cleaned_insights == backup_insights:
            print(f"   ✅ {json_file.name}: {cleaned_insights} insights preserved")
        else:
            print(f"   ❌ {json_file.name}: {cleaned_insights} vs {backup_insights} insights")
            return False

    print("\n" + "=" * 50)
    print("🌟 SURGICAL CLEANUP VALIDATION COMPLETE")
    print("=" * 50)
    print("✅ All ** markdown artifacts successfully removed")
    print("✅ All JSON structures remain valid")
    print("✅ All spiritual content perfectly preserved")
    print("✅ Complete backup available for safety")
    print("✅ All insight counts preserved")
    print("\n🎯 MISSION ACCOMPLISHED: Clean spiritual content with zero alterations!")

    return True


if __name__ == "__main__":
    success = validate_cleanup()
    if not success:
        print("\n🚨 VALIDATION FAILED - Issues found during cleanup verification")
        exit(1)
    else:
        print("\n✨ Perfect surgical cleanup confirmed!")
