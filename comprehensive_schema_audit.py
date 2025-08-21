#!/usr/bin/env python3
"""
COMPREHENSIVE SCHEMA AUDIT - Final Verification
Validates all schemas in KASPERMLXRuntimeBundle and provides deployment readiness report
"""

import json
import os
import re
from collections import defaultdict


def analyze_file_schema(file_path):
    """
    Analyze a JSON file and determine its schema type

    Returns:
        dict: Schema analysis with type, validity, and details
    """
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        filename = os.path.basename(file_path)

        # Detect schema type based on structure
        if isinstance(data, dict):
            # Check for persona_with_categories schema
            if "number" in data and "categories" in data and isinstance(data["categories"], dict):
                return {
                    "schema_type": "persona_with_categories",
                    "valid": True,
                    "number": data.get("number"),
                    "categories_count": len(data["categories"]),
                    "issues": [],
                }

            # Check for number_keyed_direct_categories schema
            elif any(key.isdigit() for key in data.keys()):
                number_keys = [k for k in data.keys() if k.isdigit()]
                if len(number_keys) == 1:
                    number = int(number_keys[0])
                    number_data = data[number_keys[0]]
                    if isinstance(number_data, dict):
                        return {
                            "schema_type": "number_keyed_direct_categories",
                            "valid": True,
                            "number": number,
                            "categories_count": len(number_data),
                            "issues": [],
                        }

            # Check for categories_wrapper schema (planetary/zodiac)
            elif "categories" in data and "number" not in data:
                return {
                    "schema_type": "categories_wrapper",
                    "valid": True,
                    "number": None,  # Not applicable for planetary/zodiac
                    "categories_count": len(data["categories"]),
                    "issues": [],
                }

            # Check for behavioral_insights schema
            elif "behavioral_insights" in data:
                insights = data["behavioral_insights"]
                return {
                    "schema_type": "behavioral_insights",
                    "valid": True,
                    "number": data.get("number"),
                    "insights_count": len(insights) if isinstance(insights, list) else 0,
                    "issues": [],
                }

            # Unknown schema
            else:
                return {
                    "schema_type": "unknown",
                    "valid": False,
                    "number": data.get("number"),
                    "issues": [f"Unrecognized schema structure in {filename}"],
                }

        else:
            return {
                "schema_type": "invalid",
                "valid": False,
                "number": None,
                "issues": [f"Root is not an object in {filename}"],
            }

    except json.JSONDecodeError as e:
        return {
            "schema_type": "corrupted",
            "valid": False,
            "number": None,
            "issues": [f"JSON parse error in {filename}: {e}"],
        }
    except Exception as e:
        return {
            "schema_type": "error",
            "valid": False,
            "number": None,
            "issues": [f"Unexpected error in {filename}: {e}"],
        }


def audit_directory(directory_path):
    """
    Audit all JSON files in a directory

    Returns:
        dict: Summary of findings
    """
    if not os.path.exists(directory_path):
        return {"error": f"Directory not found: {directory_path}"}

    results = {
        "total_files": 0,
        "valid_files": 0,
        "invalid_files": 0,
        "schemas": defaultdict(int),
        "issues": [],
        "files": {},
    }

    for filename in os.listdir(directory_path):
        if filename.endswith(".json"):
            file_path = os.path.join(directory_path, filename)
            analysis = analyze_file_schema(file_path)

            results["total_files"] += 1
            results["files"][filename] = analysis
            results["schemas"][analysis["schema_type"]] += 1

            if analysis["valid"]:
                results["valid_files"] += 1
            else:
                results["invalid_files"] += 1
                results["issues"].extend(analysis["issues"])

    return results


def verify_filename_number_consistency():
    """
    Verify that filenames with numbers match their internal number fields

    Critical for persona files where filename number must match content number
    """
    print("\n🔍 VERIFYING FILENAME-NUMBER CONSISTENCY")
    print("=" * 50)

    personas_dir = "KASPERMLXRuntimeBundle/PersonaInsights"
    if not os.path.exists(personas_dir):
        print("⚠️  PersonaInsights directory not found")
        return

    total_inconsistencies = 0

    for persona in os.listdir(personas_dir):
        persona_path = os.path.join(personas_dir, persona)
        if not os.path.isdir(persona_path):
            continue

        print(f"\n📋 Checking {persona}...")
        persona_issues = 0

        for filename in sorted(os.listdir(persona_path)):
            if not filename.endswith(".json"):
                continue

            # Extract number from filename
            match = re.search(rf"{persona}Insights_Number_(\d+)\.json", filename)
            if not match:
                print(f"  ⚠️  Invalid filename format: {filename}")
                continue

            expected_number = int(match.group(1))
            file_path = os.path.join(persona_path, filename)

            analysis = analyze_file_schema(file_path)

            if analysis["valid"]:
                actual_number = analysis.get("number")

                if actual_number == expected_number:
                    print(f"  ✅ {filename}: number consistency verified ({expected_number})")
                else:
                    print(f"  ❌ {filename}: filename={expected_number}, content={actual_number}")
                    persona_issues += 1
                    total_inconsistencies += 1
            else:
                print(f"  ❌ {filename}: schema invalid")
                persona_issues += 1
                total_inconsistencies += 1

        print(f"  📊 {persona}: {persona_issues} inconsistencies")

    return total_inconsistencies


def generate_deployment_report():
    """
    Generate comprehensive deployment readiness report
    """
    print("\n🎯 KASPERMLX RUNTIMEBUNDLE DEPLOYMENT READINESS REPORT")
    print("=" * 70)

    # Audit each major directory
    directories = [
        ("PersonaInsights/AlanWatts", "Alan Watts Persona"),
        ("PersonaInsights/CarlJung", "Carl Jung Persona"),
        ("PlanetaryInsights", "Planetary Archetypes"),
        ("ZodiacInsights", "Zodiac Signs"),
        ("EnhancedNumbers", "Enhanced Number Meanings"),
        ("Behavioral", "Legacy Behavioral Insights"),
        ("RichNumberMeanings", "Rich Number Content"),
        ("MegaCorpus", "Core Astrological Data"),
    ]

    overall_status = "✅ READY"
    total_issues = 0

    for subdir, description in directories:
        full_path = f"KASPERMLXRuntimeBundle/{subdir}"
        print(f"\n📂 {description} ({subdir})")
        print("-" * 40)

        results = audit_directory(full_path)

        if "error" in results:
            print(f"  ⚠️  {results['error']}")
            continue

        print(
            f"  📊 Files: {results['total_files']} total, {results['valid_files']} valid, {results['invalid_files']} invalid"
        )

        if results["schemas"]:
            print("  📋 Schemas found:")
            for schema_type, count in results["schemas"].items():
                status_icon = (
                    "✅"
                    if schema_type
                    in [
                        "persona_with_categories",
                        "number_keyed_direct_categories",
                        "categories_wrapper",
                        "behavioral_insights",
                    ]
                    else "⚠️"
                )
                print(f"    {status_icon} {schema_type}: {count} files")

        if results["issues"]:
            print(f"  ❌ Issues ({len(results['issues'])}):")
            for issue in results["issues"][:3]:  # Show first 3 issues
                print(f"    - {issue}")
            if len(results["issues"]) > 3:
                print(f"    ... and {len(results['issues']) - 3} more")

            total_issues += len(results["issues"])
            overall_status = "⚠️ NEEDS ATTENTION"

    # Check filename consistency
    consistency_issues = verify_filename_number_consistency()
    if consistency_issues > 0:
        total_issues += consistency_issues
        overall_status = "⚠️ NEEDS ATTENTION"

    # Final verdict
    print(f"\n🏁 FINAL DEPLOYMENT STATUS: {overall_status}")
    print(f"📊 Total Issues Found: {total_issues}")

    if total_issues == 0:
        print("🎉 RuntimeBundle is READY for production deployment!")
        print("✅ All schemas valid, all numbers consistent, all files accessible")
    else:
        print("⚠️  RuntimeBundle needs attention before deployment")
        print("🔧 Address the issues above before going live")

    return total_issues == 0


def main():
    """
    Main comprehensive audit execution
    """
    print("🔍 COMPREHENSIVE KASPERMLX RUNTIMEBUNDLE SCHEMA AUDIT")
    print("=" * 60)
    print("📋 Validating schemas, numbers, and deployment readiness...")

    # Generate full deployment report
    is_ready = generate_deployment_report()

    print("\n" + "=" * 60)
    if is_ready:
        print("🚀 AUDIT COMPLETE - DEPLOYMENT AUTHORIZED")
    else:
        print("🛑 AUDIT COMPLETE - FIX ISSUES BEFORE DEPLOYMENT")


if __name__ == "__main__":
    main()
