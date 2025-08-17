#!/usr/bin/env python3
"""
Final Duplicate Hunter - Target the last 7 duplicates for 98%+ uniqueness
Identifies exact remaining duplicates and eliminates them with surgical precision
"""

import json
from difflib import SequenceMatcher
from pathlib import Path


def similarity(a, b):
    """Calculate similarity between two strings"""
    return SequenceMatcher(None, a.lower(), b.lower()).ratio()


def load_archetypal_files():
    """Load all archetypal JSON files"""
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


def categorize_duplicates(duplicates):
    """Categorize duplicates by system"""
    categorized = {"numbers": {}, "planets": {}, "zodiac": {}, "cross_system": {}}

    for insight, locations in duplicates.items():
        systems = set()
        for loc in locations:
            if loc["file"].startswith("number_"):
                systems.add("numbers")
            elif loc["file"].startswith("planet_"):
                systems.add("planets")
            elif loc["file"].startswith("zodiac_"):
                systems.add("zodiac")

        if len(systems) == 1:
            system = list(systems)[0]
            categorized[system][insight] = locations
        else:
            categorized["cross_system"][insight] = locations

    return categorized


def generate_unique_transformations():
    """Generate unique transformation templates for each archetype"""
    transformations = {
        "planets": {
            "sun": [
                "solar radiance illuminates",
                "luminous consciousness awakens",
                "stellar wisdom reveals",
                "golden light activates",
                "divine solar force manifests",
            ],
            "moon": [
                "lunar wisdom flows",
                "intuitive cycles guide",
                "emotional tides reveal",
                "silver light illuminates",
                "mystical feminine awakens",
            ],
            "mercury": [
                "mental agility sparks",
                "communication flows",
                "intellectual bridges form",
                "mercurial energy dances",
                "swift thought connects",
            ],
            "venus": [
                "heart harmony blooms",
                "aesthetic beauty emerges",
                "loving connection flows",
                "venusian grace unfolds",
                "magnetic attraction draws",
            ],
            "mars": [
                "warrior spirit ignites",
                "decisive action launches",
                "fiery determination burns",
                "martial courage rises",
                "dynamic force propels",
            ],
            "jupiter": [
                "expansive wisdom grows",
                "philosophical truth emerges",
                "abundant blessing flows",
                "jupiterian insight expands",
                "optimistic vision soars",
            ],
            "saturn": [
                "structured wisdom builds",
                "disciplined mastery forms",
                "karmic lessons crystallize",
                "saturnian patience endures",
                "authoritative foundation sets",
            ],
            "uranus": [
                "revolutionary insight strikes",
                "innovative breakthrough sparks",
                "electric awakening jolts",
                "uranian rebellion frees",
                "eccentric genius emerges",
            ],
            "neptune": [
                "mystical vision dissolves",
                "spiritual compassion flows",
                "psychic intuition opens",
                "neptunian dreams inspire",
                "oceanic consciousness merges",
            ],
            "pluto": [
                "transformative power erupts",
                "deep regeneration begins",
                "plutonian truth penetrates",
                "phoenix energy rises",
                "shadow integration completes",
            ],
        },
        "zodiac": {
            "aries": [
                "pioneering fire ignites",
                "cardinal initiation begins",
                "ram's courage charges",
                "spring energy bursts",
                "leadership spirit emerges",
            ],
            "taurus": [
                "earthly stability roots",
                "sensual beauty manifests",
                "bull's determination stands",
                "material abundance grows",
                "fixed earth wisdom holds",
            ],
            "gemini": [
                "mercurial twins dance",
                "intellectual curiosity sparks",
                "air sign communication flows",
                "mutable thought connects",
                "mental agility adapts",
            ],
            "cancer": [
                "nurturing moon cradles",
                "emotional tides flow",
                "cardinal water protects",
                "home sanctuary creates",
                "maternal instinct guides",
            ],
            "leo": [
                "royal sun blazes",
                "creative heart radiates",
                "lion's pride shines",
                "fixed fire commands",
                "generous spirit performs",
            ],
            "virgo": [
                "perfectionist earth refines",
                "analytical wisdom sorts",
                "maiden's service heals",
                "mutable detail organizes",
                "practical magic manifests",
            ],
            "libra": [
                "harmonious scales balance",
                "aesthetic beauty creates",
                "cardinal air relates",
                "diplomatic grace flows",
                "partnership energy connects",
            ],
            "scorpio": [
                "transformative water penetrates",
                "phoenix power regenerates",
                "fixed intensity burns",
                "psychological depth explores",
                "scorpion's truth stings",
            ],
            "sagittarius": [
                "philosophical archer aims",
                "mutable fire seeks",
                "centaur wisdom gallops",
                "adventure spirit roams",
                "truth arrow flies",
            ],
            "capricorn": [
                "mountain goat climbs",
                "cardinal earth builds",
                "structured ambition rises",
                "authoritative wisdom commands",
                "practical mastery achieves",
            ],
            "aquarius": [
                "humanitarian water pours",
                "fixed air innovates",
                "eccentric genius flows",
                "collective consciousness awakens",
                "futuristic vision emerges",
            ],
            "pisces": [
                "mystical fish swims",
                "mutable water dissolves",
                "compassionate dreams flow",
                "psychic intuition opens",
                "oceanic oneness merges",
            ],
        },
    }
    return transformations


def main():
    """Main execution function"""
    print("🎯 FINAL DUPLICATE HUNTER - Surgical Precision Mode")
    print("=" * 60)

    # Find exact duplicates
    duplicates, files_data = find_exact_duplicates()
    categorized = categorize_duplicates(duplicates)

    print("\n📊 EXACT DUPLICATES FOUND:")
    total_duplicates = 0
    for system, system_dups in categorized.items():
        count = len(system_dups)
        total_duplicates += count
        if count > 0:
            print(f"  {system.upper()}: {count} duplicates")
            for insight, locations in system_dups.items():
                print(f"    • '{insight[:50]}...' - {len(locations)} instances")
                for loc in locations:
                    print(f"      - {loc['file']} (index {loc['index']})")

    print(f"\n🎯 TOTAL EXACT DUPLICATES TO ELIMINATE: {total_duplicates}")

    # Calculate current uniqueness by system
    print("\n📈 CURRENT UNIQUENESS BY SYSTEM:")

    for system in ["numbers", "planets", "zodiac"]:
        system_files = {k: v for k, v in files_data.items() if k.startswith(f"{system[:-1]}_")}
        all_system_insights = []
        for file_data in system_files.values():
            all_system_insights.extend(file_data["insights"])

        unique_insights = len(set(all_system_insights))
        total_insights = len(all_system_insights)
        uniqueness = unique_insights / total_insights if total_insights > 0 else 0

        system_duplicates = len(categorized[system])
        print(
            f"  {system.upper()}: {uniqueness:.1%} ({unique_insights}/{total_insights} unique) - {system_duplicates} duplicates"
        )

    print("\n🎯 Target: Eliminate remaining duplicates to achieve 98%+ in all systems")
    return duplicates, categorized, files_data


if __name__ == "__main__":
    main()
