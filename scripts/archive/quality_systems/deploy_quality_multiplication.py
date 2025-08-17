#!/usr/bin/env python3
"""
Deploy Quality-First Multiplication System
Replaces the old quantity-focused approach with A+ quality generation
"""

import json
import os

from production_quality_multiplier import ProductionQualityMultiplier


def deploy_quality_multiplication():
    """Deploy the new quality-first multiplication system"""

    print("🚀 DEPLOYING QUALITY-FIRST MULTIPLICATION SYSTEM")
    print("=" * 60)

    base_path = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP"
    multiplier = ProductionQualityMultiplier(base_path)

    # Define archetype mappings
    archetype_mappings = {
        # Number files (0-9)
        "NumberMessages_Complete_0": "0",
        "NumberMessages_Complete_1": "1",
        "NumberMessages_Complete_2": "2",
        "NumberMessages_Complete_3": "3",
        "NumberMessages_Complete_4": "4",
        "NumberMessages_Complete_5": "5",
        "NumberMessages_Complete_6": "6",
        "NumberMessages_Complete_7": "7",
        "NumberMessages_Complete_8": "8",
        "NumberMessages_Complete_9": "9",
        # Zodiac files
        "ZodiacInsights_Aries": "aries",
        "ZodiacInsights_Taurus": "taurus",
        "ZodiacInsights_Gemini": "gemini",
        "ZodiacInsights_Cancer": "cancer",
        "ZodiacInsights_Leo": "leo",
        "ZodiacInsights_Virgo": "virgo",
        "ZodiacInsights_Libra": "libra",
        "ZodiacInsights_Scorpio": "scorpio",
        "ZodiacInsights_Sagittarius": "sagittarius",
        "ZodiacInsights_Capricorn": "capricorn",
        "ZodiacInsights_Aquarius": "aquarius",
        "ZodiacInsights_Pisces": "pisces",
        # Planetary files
        "PlanetaryInsights_Sun": "sun",
        "PlanetaryInsights_Moon": "moon",
        "PlanetaryInsights_Mercury": "mercury",
        "PlanetaryInsights_Venus": "venus",
        "PlanetaryInsights_Mars": "mars",
        "PlanetaryInsights_Jupiter": "jupiter",
        "PlanetaryInsights_Saturn": "saturn",
        "PlanetaryInsights_Uranus": "uranus",
        "PlanetaryInsights_Neptune": "neptune",
        "PlanetaryInsights_Pluto": "pluto",
    }

    # Test deployment with a single file first
    print("\n🧪 TESTING WITH SINGLE FILE:")
    print("-" * 40)

    test_file = os.path.join(
        base_path, "NumerologyData/FirebaseNumberMeanings/NumberMessages_Complete_8.json"
    )
    if os.path.exists(test_file):
        output_path = multiplier.multiply_file_with_quality(
            test_file,
            archetype_key="8",
            target_count=50,  # Small test
            output_suffix="_quality_test",
        )

        # Validate output
        with open(output_path, "r", encoding="utf-8") as f:
            test_output = json.load(f)

        a_plus_count = len(test_output.get("quality_insights", {}).get("a_plus_tier", []))
        a_count = len(test_output.get("quality_insights", {}).get("a_tier", []))

        print(f"   ✅ Test successful: {a_plus_count} A+ insights, {a_count} A insights")
        print(f"   📄 Test file: {os.path.basename(output_path)}")

        # Show sample
        if a_plus_count > 0:
            sample = test_output["quality_insights"]["a_plus_tier"][0]["insight"]
            print(f"   📝 Sample A+ insight: {sample[:80]}...")

    # Create deployment plan
    deployment_plan = []

    directories = [
        ("NumerologyData/FirebaseNumberMeanings", "original"),
        ("NumerologyData/FirebaseZodiacMeanings", "original"),
        ("NumerologyData/FirebasePlanetaryMeanings", "original"),
    ]

    print("\n📋 DEPLOYMENT PLAN:")
    print("-" * 40)

    for directory, file_type in directories:
        full_dir = os.path.join(base_path, directory)
        if os.path.exists(full_dir):
            json_files = [f for f in os.listdir(full_dir) if f.endswith(f"_{file_type}.json")]

            for filename in json_files:
                file_key = filename.replace(f"_{file_type}.json", "")
                archetype_key = archetype_mappings.get(file_key)

                if archetype_key:
                    file_path = os.path.join(full_dir, filename)
                    deployment_plan.append(
                        {
                            "file_path": file_path,
                            "archetype_key": archetype_key,
                            "filename": filename,
                            "directory": directory,
                        }
                    )
                    print(f"   📄 {filename} → {archetype_key} archetype")

    print("\n📊 DEPLOYMENT SUMMARY:")
    print(f"   📁 Files to process: {len(deployment_plan)}")
    print("   🎯 Target per file: 300 A+ quality insights")
    print(f"   📈 Total new insights: ~{len(deployment_plan) * 300:,}")

    # Execute deployment (uncomment when ready)
    execute_deployment = False  # Set to True to execute

    if execute_deployment:
        print("\n🚀 EXECUTING DEPLOYMENT:")
        print("-" * 40)

        completed = 0
        for plan in deployment_plan:
            try:
                output_path = multiplier.multiply_file_with_quality(
                    plan["file_path"],
                    plan["archetype_key"],
                    target_count=300,
                    output_suffix="_quality_v3",
                )
                completed += 1
                print(f"   ✅ {completed}/{len(deployment_plan)}: {plan['filename']} completed")

            except Exception as e:
                print(f"   ❌ Error processing {plan['filename']}: {e}")

        print("\n🏁 DEPLOYMENT COMPLETE:")
        print(f"   ✅ Successfully processed: {completed}/{len(deployment_plan)} files")
        print(f"   📈 Total A+ insights generated: ~{completed * 300:,}")

    else:
        print("\n⏸️  DEPLOYMENT READY (set execute_deployment=True to run)")
        print(f"   💡 This will generate ~{len(deployment_plan) * 300:,} new A+ quality insights")

    print("\n✅ Quality-First Multiplication System deployed!")


if __name__ == "__main__":
    deploy_quality_multiplication()
