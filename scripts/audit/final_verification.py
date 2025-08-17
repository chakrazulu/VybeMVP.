#!/usr/bin/env python3
"""
Final Verification - Comprehensive uniqueness check with correct file structures
"""

import json
from difflib import SequenceMatcher
from pathlib import Path


def similarity(a, b):
    """Calculate similarity between two strings"""
    return SequenceMatcher(None, a.lower(), b.lower()).ratio()


def load_archetypal_files():
    """Load all archetypal JSON files with correct structures"""
    files_data = {}
    base_path = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData")

    # Numbers files
    numbers_path = base_path / "FirebaseNumberMeanings"
    for i in range(10):
        file_path = numbers_path / f"NumberMessages_Complete_{i}_archetypal.json"
        if file_path.exists():
            with open(file_path, "r") as f:
                data = json.load(f)
                files_data[f"number_{i}"] = {
                    "path": str(file_path),
                    "insights": [item["insight"] for item in data[str(i)]["insight"]],
                }

    # Planets files
    planets_path = base_path / "FirebasePlanetaryMeanings"
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
    for planet in planets:
        file_path = planets_path / f"PlanetaryInsights_{planet}_archetypal.json"
        if file_path.exists():
            with open(file_path, "r") as f:
                data = json.load(f)
                files_data[f"planet_{planet.lower()}"] = {
                    "path": str(file_path),
                    "insights": [item["insight"] for item in data["archetypal_insights"]],
                }

    # Zodiac files
    zodiac_path = base_path / "FirebaseZodiacMeanings"
    zodiacs = [
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
    for zodiac in zodiacs:
        file_path = zodiac_path / f"ZodiacInsights_{zodiac}_archetypal.json"
        if file_path.exists():
            with open(file_path, "r") as f:
                data = json.load(f)
                files_data[f"zodiac_{zodiac.lower()}"] = {
                    "path": str(file_path),
                    "insights": [item["insight"] for item in data["archetypal_insights"]],
                }

    return files_data


def find_exact_duplicates():
    """Find all exact duplicate insights"""
    files_data = load_archetypal_files()
    all_insights = []
    insight_locations = {}

    # Collect all insights with their locations
    for file_key, file_data in files_data.items():
        for idx, insight in enumerate(file_data["insights"]):
            clean_insight = insight.strip()
            all_insights.append(clean_insight)

            if clean_insight not in insight_locations:
                insight_locations[clean_insight] = []
            insight_locations[clean_insight].append(
                {"file": file_key, "index": idx, "path": file_data["path"]}
            )

    # Find duplicates
    duplicates = {}
    for insight, locations in insight_locations.items():
        if len(locations) > 1:
            duplicates[insight] = locations

    return duplicates, files_data


def calculate_system_uniqueness(files_data):
    """Calculate uniqueness for each system"""
    systems = {"numbers": [], "planets": [], "zodiac": []}

    # Collect insights by system
    for file_key, file_data in files_data.items():
        if file_key.startswith("number_"):
            systems["numbers"].extend(file_data["insights"])
        elif file_key.startswith("planet_"):
            systems["planets"].extend(file_data["insights"])
        elif file_key.startswith("zodiac_"):
            systems["zodiac"].extend(file_data["insights"])

    # Calculate uniqueness for each system
    results = {}
    for system, insights in systems.items():
        if len(insights) > 0:
            unique_insights = len(set(insights))
            total_insights = len(insights)
            uniqueness = unique_insights / total_insights

            results[system] = {
                "unique": unique_insights,
                "total": total_insights,
                "uniqueness": uniqueness,
                "duplicates": total_insights - unique_insights,
            }
        else:
            results[system] = {"unique": 0, "total": 0, "uniqueness": 0.0, "duplicates": 0}

    return results


def main():
    """Main verification function"""
    print("📊 FINAL VERIFICATION - Complete Uniqueness Audit")
    print("=" * 60)

    # Find exact duplicates
    duplicates, files_data = find_exact_duplicates()

    print("\n🔍 EXACT DUPLICATES REMAINING:")
    total_duplicates = len(duplicates)
    if total_duplicates == 0:
        print("   ✅ NO DUPLICATES FOUND - Perfect uniqueness achieved!")
    else:
        print(f"   ⚠️  {total_duplicates} duplicates still exist:")
        for insight, locations in duplicates.items():
            print(f"    • '{insight[:50]}...' - {len(locations)} instances")
            for loc in locations:
                print(f"      - {loc['file']} (index {loc['index']})")

    # Calculate system uniqueness
    results = calculate_system_uniqueness(files_data)

    print("\n📈 UNIQUENESS BY SYSTEM:")
    all_pass = True

    for system, stats in results.items():
        if stats["total"] > 0:
            status = "✅ PASS" if stats["uniqueness"] >= 0.98 else "❌ FAIL"
            if stats["uniqueness"] < 0.98:
                all_pass = False

            print(
                f"  {system.upper()}: {stats['uniqueness']:.1%} ({stats['unique']}/{stats['total']} unique) - {stats['duplicates']} duplicates {status}"
            )
        else:
            print(f"  {system.upper()}: No files found")

    # Overall summary
    all_insights = []
    for file_data in files_data.values():
        all_insights.extend(file_data["insights"])

    if len(all_insights) > 0:
        total_unique = len(set(all_insights))
        total_count = len(all_insights)
        overall_uniqueness = total_unique / total_count

        print("\n🌟 OVERALL SYSTEM UNIQUENESS:")
        overall_status = "✅ PASS" if overall_uniqueness >= 0.98 else "❌ FAIL"
        print(f"   {overall_uniqueness:.1%} ({total_unique}/{total_count} unique) {overall_status}")

    print(
        f"\n{'🎉 MISSION ACCOMPLISHED!' if all_pass and total_duplicates == 0 else '⚠️  WORK REMAINING'}"
    )

    if all_pass and total_duplicates == 0:
        print("   ✅ All systems at 98%+ uniqueness")
        print("   ✅ Zero duplicates across all content")
        print("   ✅ Ready for production deployment")
    else:
        if not all_pass:
            print("   ❌ Some systems below 98% uniqueness threshold")
        if total_duplicates > 0:
            print(f"   ❌ {total_duplicates} duplicates still need elimination")

    return all_pass and total_duplicates == 0


if __name__ == "__main__":
    main()
