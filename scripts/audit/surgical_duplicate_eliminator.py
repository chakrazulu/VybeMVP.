#!/usr/bin/env python3
"""
Surgical Duplicate Eliminator - Final 7 duplicates
Eliminates the exact remaining duplicates with precision transformations
"""

import json
from pathlib import Path


def load_json_file(file_path):
    """Load JSON file"""
    with open(file_path, "r") as f:
        return json.load(f)


def save_json_file(file_path, data):
    """Save JSON file with proper formatting"""
    with open(file_path, "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)


def eliminate_planetary_duplicates():
    """Eliminate the 3 planetary duplicates"""
    base_path = Path(
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebasePlanetaryMeanings"
    )

    transformations = [
        # Moon duplicate 1 (index 6 -> keep, index 8 -> transform)
        {
            "file": "PlanetaryInsights_Moon_archetypal.json",
            "index": 8,
            "new_insight": "The intuitive lunar essence illuminates how receptive awareness creates sacred space for emotional transformation.",
        },
        # Jupiter duplicate 2 (index 2 -> keep, index 7 -> transform)
        {
            "file": "PlanetaryInsights_Jupiter_archetypal.json",
            "index": 7,
            "new_insight": "Jupiter's expansive wisdom reveals that evening synthesis transforms daily experience into philosophical understanding.",
        },
        # Uranus duplicate 3 (index 2 -> keep, index 7 -> transform)
        {
            "file": "PlanetaryInsights_Uranus_archetypal.json",
            "index": 7,
            "new_insight": "Uranus sparks revolutionary breakthrough: twilight innovation synthesizes unconventional wisdom into transformative action.",
        },
    ]

    for transformation in transformations:
        file_path = base_path / transformation["file"]
        if file_path.exists():
            print(f"🔧 Transforming {transformation['file']} index {transformation['index']}")

            data = load_json_file(file_path)
            data["archetypal_insights"][transformation["index"]]["insight"] = transformation[
                "new_insight"
            ]
            save_json_file(file_path, data)

            print(f"   ✅ New insight: {transformation['new_insight'][:60]}...")


def eliminate_zodiac_duplicates():
    """Eliminate the 4 zodiac duplicates"""
    base_path = Path(
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebaseZodiacMeanings"
    )

    transformations = [
        # Taurus duplicate 1 (index 2 -> keep, index 12 -> transform)
        {
            "file": "ZodiacInsights_Taurus_archetypal.json",
            "index": 12,
            "new_insight": "Taurus grounds with unwavering stability: adversity becomes the sculptor of unshakeable inner strength.",
        },
        # Taurus duplicate 2 (index 4 -> keep, index 9 -> transform)
        {
            "file": "ZodiacInsights_Taurus_archetypal.json",
            "index": 9,
            "new_insight": "Steady earth manifestation emerges when patient persistence alchemizes doubt into tangible abundance.",
        },
        # Aquarius duplicate 3 (index 2 -> keep, index 12 -> transform)
        {
            "file": "ZodiacInsights_Aquarius_archetypal.json",
            "index": 12,
            "new_insight": "Aquarius flows with humanitarian genius: routine consciousness awakens to collective transformation potential.",
        },
        # Pisces duplicate 4 (index 5 -> keep, index 10 -> transform)
        {
            "file": "ZodiacInsights_Pisces_archetypal.json",
            "index": 10,
            "new_insight": "Pisces transcends through oceanic empathy: universal compassion dissolves separation into sacred unity.",
        },
    ]

    for transformation in transformations:
        file_path = base_path / transformation["file"]
        if file_path.exists():
            print(f"🔧 Transforming {transformation['file']} index {transformation['index']}")

            data = load_json_file(file_path)
            data["archetypal_insights"][transformation["index"]]["insight"] = transformation[
                "new_insight"
            ]
            save_json_file(file_path, data)

            print(f"   ✅ New insight: {transformation['new_insight'][:60]}...")


def verify_elimination():
    """Verify that all duplicates have been eliminated"""
    from final_duplicate_hunter import categorize_duplicates, find_exact_duplicates

    print("\n🔍 VERIFICATION - Checking for remaining duplicates...")

    duplicates, files_data = find_exact_duplicates()
    categorized = categorize_duplicates(duplicates)

    total_remaining = sum(len(system_dups) for system_dups in categorized.values())

    if total_remaining == 0:
        print("   ✅ SUCCESS: All duplicates eliminated!")
    else:
        print(f"   ⚠️  {total_remaining} duplicates still remain")
        for system, system_dups in categorized.items():
            if len(system_dups) > 0:
                print(f"     {system.upper()}: {len(system_dups)} remaining")

    # Calculate final uniqueness by system
    print("\n📊 FINAL UNIQUENESS BY SYSTEM:")

    for system in ["numbers", "planets", "zodiac"]:
        system_files = {k: v for k, v in files_data.items() if k.startswith(f"{system[:-1]}_")}
        all_system_insights = []
        for file_data in system_files.values():
            all_system_insights.extend(file_data["insights"])

        unique_insights = len(set(all_system_insights))
        total_insights = len(all_system_insights)
        uniqueness = unique_insights / total_insights if total_insights > 0 else 0

        status = "✅ PASS" if uniqueness >= 0.98 else "❌ NEEDS WORK"
        print(
            f"  {system.upper()}: {uniqueness:.1%} ({unique_insights}/{total_insights} unique) {status}"
        )

    return total_remaining == 0


def main():
    """Main execution function"""
    print("🎯 SURGICAL DUPLICATE ELIMINATOR - Final 7 Duplicates")
    print("=" * 60)

    print("\n🔧 ELIMINATING PLANETARY DUPLICATES (3 total)...")
    eliminate_planetary_duplicates()

    print("\n🔧 ELIMINATING ZODIAC DUPLICATES (4 total)...")
    eliminate_zodiac_duplicates()

    # Verify elimination
    success = verify_elimination()

    if success:
        print("\n🎉 MISSION ACCOMPLISHED!")
        print("   All 7 duplicates eliminated")
        print("   All systems now at 98%+ uniqueness")
        print("   Ready for production deployment")
    else:
        print("\n⚠️  MISSION INCOMPLETE - Some duplicates remain")

    return success


if __name__ == "__main__":
    main()
