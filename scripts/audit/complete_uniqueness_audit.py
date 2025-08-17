#!/usr/bin/env python3
"""
COMPLETE UNIQUENESS AUDIT - Final System Analysis
Comprehensive analysis of uniqueness across ALL 32 archetypal files
"""

import glob
import json
import os
from collections import defaultdict
from difflib import SequenceMatcher


def similarity(a, b):
    """Calculate similarity between two strings"""
    return SequenceMatcher(None, a.lower(), b.lower()).ratio()


def extract_insights_with_metadata(file_path):
    """Extract insights with complete metadata from all file types"""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        insights = []

        # Handle Number files structure: {"0": {"insight": [...]}}
        if any(key.isdigit() for key in data.keys()):
            for key, category in data.items():
                if isinstance(category, dict) and "insight" in category:
                    insight_array = category["insight"]
                    if isinstance(insight_array, list):
                        for i, insight_data in enumerate(insight_array):
                            if isinstance(insight_data, dict) and "insight" in insight_data:
                                insights.append(
                                    {
                                        "text": insight_data["insight"],
                                        "file_path": file_path,
                                        "file": os.path.basename(file_path),
                                        "category": insight_data.get("archetypal_fusion", key),
                                        "persona": insight_data.get("persona", "unknown"),
                                        "context": insight_data.get("context", "unknown"),
                                        "uniqueness_score": insight_data.get(
                                            "uniqueness_score", 0.0
                                        ),
                                        "quality_grade": insight_data.get(
                                            "quality_grade", "unknown"
                                        ),
                                        "spiritual_accuracy": insight_data.get(
                                            "spiritual_accuracy", 0.0
                                        ),
                                    }
                                )

        # Handle Planetary files structure: {"planet": "Sun", "archetypal_insights": [...]}
        elif "archetypal_insights" in data:
            insight_array = data["archetypal_insights"]
            if isinstance(insight_array, list):
                for i, insight_data in enumerate(insight_array):
                    if isinstance(insight_data, dict) and "insight" in insight_data:
                        insights.append(
                            {
                                "text": insight_data["insight"],
                                "file_path": file_path,
                                "file": os.path.basename(file_path),
                                "category": insight_data.get(
                                    "archetypal_essence", data.get("planet", "unknown")
                                ),
                                "persona": insight_data.get("persona", "unknown"),
                                "context": insight_data.get("context", "unknown"),
                                "uniqueness_score": insight_data.get("uniqueness_score", 0.0),
                                "quality_grade": insight_data.get("quality_grade", "unknown"),
                                "spiritual_accuracy": insight_data.get("spiritual_accuracy", 0.0),
                            }
                        )

        # Handle Zodiac files structure: {"sign": "Aries", "archetypal_insights": [...]}
        elif "sign" in data and isinstance(data.get("archetypal_insights"), list):
            insight_array = data["archetypal_insights"]
            for i, insight_data in enumerate(insight_array):
                if isinstance(insight_data, dict) and "insight" in insight_data:
                    insights.append(
                        {
                            "text": insight_data["insight"],
                            "file_path": file_path,
                            "file": os.path.basename(file_path),
                            "category": insight_data.get(
                                "archetypal_essence", data.get("sign", "unknown")
                            ),
                            "persona": insight_data.get("persona", "unknown"),
                            "context": insight_data.get("context", "unknown"),
                            "uniqueness_score": insight_data.get("uniqueness_score", 0.0),
                            "quality_grade": insight_data.get("quality_grade", "unknown"),
                            "spiritual_accuracy": insight_data.get("spiritual_accuracy", 0.0),
                        }
                    )

        return insights
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return []


def comprehensive_uniqueness_analysis():
    """Complete uniqueness analysis across all systems"""

    # Get all archetypal files
    base_dir = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP"
    archetypal_files = glob.glob(f"{base_dir}/**/*_archetypal.json", recursive=True)

    print("🔍 COMPREHENSIVE UNIQUENESS AUDIT")
    print("=" * 80)
    print(f"📁 SCANNING {len(archetypal_files)} archetypal files...")

    # Categorize files by system
    number_files = [f for f in archetypal_files if "NumberMessages" in f]
    planet_files = [f for f in archetypal_files if "PlanetaryInsights" in f]
    zodiac_files = [f for f in archetypal_files if "ZodiacInsights" in f]

    print(f"   📊 Number files: {len(number_files)}")
    print(f"   🪐 Planet files: {len(planet_files)}")
    print(f"   ♈ Zodiac files: {len(zodiac_files)}")

    # Collect all insights by system
    all_insights = []
    number_insights = []
    planet_insights = []
    zodiac_insights = []

    for file_path in number_files:
        insights = extract_insights_with_metadata(file_path)
        number_insights.extend(insights)
        all_insights.extend(insights)

    for file_path in planet_files:
        insights = extract_insights_with_metadata(file_path)
        planet_insights.extend(insights)
        all_insights.extend(insights)

    for file_path in zodiac_files:
        insights = extract_insights_with_metadata(file_path)
        zodiac_insights.extend(insights)
        all_insights.extend(insights)

    print("\n📊 INSIGHT DISTRIBUTION:")
    print(f"   📊 Number insights: {len(number_insights)}")
    print(f"   🪐 Planet insights: {len(planet_insights)}")
    print(f"   ♈ Zodiac insights: {len(zodiac_insights)}")
    print(f"   🌟 Total insights: {len(all_insights)}")

    # UNIQUENESS ANALYSIS
    print("\n🎯 UNIQUENESS ANALYSIS BY SYSTEM:")

    def analyze_system_uniqueness(insights, system_name):
        total = len(insights)
        if total == 0:
            return 0.0, 0, 0

        unique_texts = set(insight["text"] for insight in insights)
        unique_count = len(unique_texts)
        duplicates = total - unique_count
        uniqueness_score = unique_count / total

        print(f"   {system_name}:")
        print(f"     Total insights: {total}")
        print(f"     Unique insights: {unique_count}")
        print(f"     Duplicates: {duplicates}")
        print(
            f"     Uniqueness: {uniqueness_score:.3f} ({'✅ PASS' if uniqueness_score >= 0.98 else '❌ FAIL'})"
        )

        return uniqueness_score, unique_count, duplicates

    # Analyze each system
    number_uniqueness, number_unique, number_dups = analyze_system_uniqueness(
        number_insights, "📊 Numbers"
    )
    planet_uniqueness, planet_unique, planet_dups = analyze_system_uniqueness(
        planet_insights, "🪐 Planets"
    )
    zodiac_uniqueness, zodiac_unique, zodiac_dups = analyze_system_uniqueness(
        zodiac_insights, "♈ Zodiac"
    )

    # Overall system analysis
    total_insights = len(all_insights)
    total_unique = len(set(insight["text"] for insight in all_insights))
    overall_uniqueness = total_unique / total_insights if total_insights > 0 else 0
    total_duplicates = total_insights - total_unique

    print("\n🌟 OVERALL SYSTEM UNIQUENESS:")
    print(f"   Total insights: {total_insights}")
    print(f"   Unique insights: {total_unique}")
    print(f"   Total duplicates: {total_duplicates}")
    print(
        f"   Overall uniqueness: {overall_uniqueness:.3f} ({'✅ PASS' if overall_uniqueness >= 0.98 else '❌ FAIL'})"
    )

    # QUALITY ANALYSIS
    print("\n⭐ QUALITY DISTRIBUTION:")
    quality_grades = defaultdict(int)
    spiritual_accuracy_sum = 0.0
    uniqueness_score_sum = 0.0
    scored_insights = 0

    for insight in all_insights:
        grade = insight.get("quality_grade", "unknown")
        quality_grades[grade] += 1

        if insight.get("spiritual_accuracy", 0) > 0:
            spiritual_accuracy_sum += insight["spiritual_accuracy"]
            scored_insights += 1

        if insight.get("uniqueness_score", 0) > 0:
            uniqueness_score_sum += insight["uniqueness_score"]

    for grade, count in sorted(quality_grades.items()):
        percentage = (count / total_insights) * 100
        print(f"   {grade}: {count} insights ({percentage:.1f}%)")

    avg_spiritual_accuracy = spiritual_accuracy_sum / scored_insights if scored_insights > 0 else 0
    avg_uniqueness_score = uniqueness_score_sum / scored_insights if scored_insights > 0 else 0

    print("\n📈 AVERAGE SCORES:")
    print(f"   Spiritual accuracy: {avg_spiritual_accuracy:.3f}")
    print(f"   Individual uniqueness: {avg_uniqueness_score:.3f}")

    # CROSS-SYSTEM SIMILARITY CHECK
    print("\n🔄 CROSS-SYSTEM SIMILARITY ANALYSIS:")

    cross_system_duplicates = []

    # Check Number vs Planet
    for num_insight in number_insights[:20]:  # Sample first 20 for performance
        for planet_insight in planet_insights[:20]:
            sim = similarity(num_insight["text"], planet_insight["text"])
            if sim > 0.8:
                cross_system_duplicates.append(
                    {
                        "similarity": sim,
                        "system1": "Numbers",
                        "system2": "Planets",
                        "text1": num_insight["text"][:50],
                        "text2": planet_insight["text"][:50],
                    }
                )

    # Check Number vs Zodiac
    for num_insight in number_insights[:20]:
        for zodiac_insight in zodiac_insights[:20]:
            sim = similarity(num_insight["text"], zodiac_insight["text"])
            if sim > 0.8:
                cross_system_duplicates.append(
                    {
                        "similarity": sim,
                        "system1": "Numbers",
                        "system2": "Zodiac",
                        "text1": num_insight["text"][:50],
                        "text2": zodiac_insight["text"][:50],
                    }
                )

    # Check Planet vs Zodiac
    for planet_insight in planet_insights[:20]:
        for zodiac_insight in zodiac_insights[:20]:
            sim = similarity(planet_insight["text"], zodiac_insight["text"])
            if sim > 0.8:
                cross_system_duplicates.append(
                    {
                        "similarity": sim,
                        "system1": "Planets",
                        "system2": "Zodiac",
                        "text1": planet_insight["text"][:50],
                        "text2": zodiac_insight["text"][:50],
                    }
                )

    print(f"   Cross-system duplicates found: {len(cross_system_duplicates)}")
    for dup in cross_system_duplicates[:3]:  # Show first 3
        print(f"   ⚠️  {dup['system1']} vs {dup['system2']} (sim: {dup['similarity']:.3f})")
        print(f"      Text 1: '{dup['text1']}...'")
        print(f"      Text 2: '{dup['text2']}...'")

    # FINAL ASSESSMENT
    print("\n" + "=" * 80)
    print("🏆 FINAL UNIQUENESS ASSESSMENT")
    print("=" * 80)

    all_systems_pass = (
        number_uniqueness >= 0.98
        and planet_uniqueness >= 0.98
        and zodiac_uniqueness >= 0.98
        and overall_uniqueness >= 0.98
    )

    status = "✅ SUCCESS" if all_systems_pass else "❌ NEEDS WORK"

    print("🎯 TARGET: 98%+ uniqueness across all systems")
    print(f"📊 ACHIEVEMENT: {status}")
    print(f"🌟 Overall Score: {overall_uniqueness:.3f} ({overall_uniqueness*100:.1f}%)")
    print(f"📋 Total Insights: {total_insights:,}")
    print(f"🎨 Unique Insights: {total_unique:,}")
    print(f"🔄 Remaining Duplicates: {total_duplicates}")

    if all_systems_pass:
        print("\n🎉 DUPLICATE ELIMINATION MISSION ACCOMPLISHED!")
        print("✅ All systems exceed 98% uniqueness threshold")
        print("✅ Ready for A+ quality content generation")
        print("✅ Perfect foundation for Phase 1 fusion system")
    else:
        print("\n🚧 AREAS REQUIRING ATTENTION:")
        if number_uniqueness < 0.98:
            print("   📊 Numbers system needs improvement")
        if planet_uniqueness < 0.98:
            print("   🪐 Planets system needs improvement")
        if zodiac_uniqueness < 0.98:
            print("   ♈ Zodiac system needs improvement")

    return {
        "overall_uniqueness": overall_uniqueness,
        "total_insights": total_insights,
        "unique_insights": total_unique,
        "duplicates": total_duplicates,
        "systems_pass": all_systems_pass,
        "number_uniqueness": number_uniqueness,
        "planet_uniqueness": planet_uniqueness,
        "zodiac_uniqueness": zodiac_uniqueness,
    }


if __name__ == "__main__":
    results = comprehensive_uniqueness_analysis()
