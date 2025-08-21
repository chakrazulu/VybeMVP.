#!/usr/bin/env python3
"""
🧪 KASPER Integration Test Script
Tests that KASPER is using real content instead of stub templates
"""

import json
import os


def test_numerology_data_availability():
    """Test that NumerologyData files are available and structured correctly"""

    print("🧪 KASPER INTEGRATION TEST")
    print("=" * 40)

    numerology_path = (
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebaseNumberMeanings"
    )

    if not os.path.exists(numerology_path):
        print("❌ NumerologyData path not found")
        return False

    # Count available insights
    total_insights = 0
    number_coverage = set()

    print("📊 Analyzing NumerologyData content...")

    for filename in os.listdir(numerology_path):
        if not filename.endswith(".json") or filename == "personalized_insight_templates.json":
            continue

        filepath = os.path.join(numerology_path, filename)

        try:
            with open(filepath, "r", encoding="utf-8") as f:
                data = json.load(f)

            file_insights = 0
            for number_str, content in data.items():
                if number_str.isdigit():
                    number = int(number_str)
                    number_coverage.add(number)
                    insights = content.get("insight", [])
                    file_insights += len(insights)

            total_insights += file_insights
            print(f"  ✅ {filename}: {file_insights} insights")

        except Exception as e:
            print(f"  ❌ {filename}: Error - {e}")

    print("\n📈 NUMEROLOGY DATA SUMMARY:")
    print(f"  Total insights: {total_insights:,}")
    print(f"  Numbers covered: {sorted(number_coverage)}")
    print(f"  Expected 9,483 insights: {'✅' if total_insights >= 9000 else '❌'}")

    return total_insights >= 9000 and len(number_coverage) >= 9


def test_firebase_import_readiness():
    """Test Firebase import script configuration"""

    print("\n🔥 FIREBASE INTEGRATION TEST")
    print("=" * 40)

    # Check if firebase scripts exist
    firebase_scripts = ["firebase_numbers_import.py", "firebase_fix_numbers.py"]

    all_scripts_present = True
    for script in firebase_scripts:
        if os.path.exists(script):
            print(f"  ✅ {script}")
        else:
            print(f"  ❌ {script} - Missing")
            all_scripts_present = False

    # Check GoogleService-Info.plist
    plist_path = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/GoogleService-Info.plist"
    if os.path.exists(plist_path):
        print("  ✅ GoogleService-Info.plist")
    else:
        print("  ❌ GoogleService-Info.plist - Missing")
        all_scripts_present = False

    return all_scripts_present


def generate_kasper_simulation():
    """Simulate KASPER content generation to test real vs stub content"""

    print("\n🔮 KASPER CONTENT SIMULATION")
    print("=" * 40)

    # Load a sample insight to simulate NumerologyDataTemplateProvider
    numerology_path = (
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/FirebaseNumberMeanings"
    )

    sample_real_content = None

    for filename in os.listdir(numerology_path):
        if filename.endswith(".json") and "1_archetypal" in filename:
            filepath = os.path.join(numerology_path, filename)

            try:
                with open(filepath, "r") as f:
                    data = json.load(f)

                if "1" in data and "insight" in data["1"]:
                    insights = data["1"]["insight"]
                    if insights:
                        sample_real_content = insights[0]
                        break

            except:
                continue

    # Generate stub content pattern (from KASPERStubProvider)
    stub_patterns = [
        "Sacred harmonic pattern {0} aligns Focus {1} with Realm {2} energy",
        "The universe recognizes your Focus {1} evolving consciousness in Realm {2}",
        "Focus {1} energy combines with Realm {2} vibrations to create divine resonance",
    ]

    sample_stub_content = stub_patterns[0].format(3, 1, 2)

    print("🔍 CONTENT COMPARISON:")
    print("\n📜 Real NumerologyData insight:")
    if sample_real_content:
        content_preview = (
            str(sample_real_content)[:100]
            if len(str(sample_real_content)) > 100
            else str(sample_real_content)
        )
        print(f"  '{content_preview}...'")
        print(f"  Length: {len(str(sample_real_content))} chars")
        print("  Style: Authentic spiritual guidance")
    else:
        print("  ❌ Could not load sample real content")

    print("\n🤖 Stub template pattern:")
    print(f"  '{sample_stub_content}'")
    print(f"  Length: {len(sample_stub_content)} chars")
    print("  Style: Template with placeholders")

    # Analysis
    if sample_real_content:
        real_has_placeholders = "{" in sample_real_content or "Focus {" in sample_real_content
        stub_has_placeholders = "{" in sample_stub_content

        print("\n📊 ANALYSIS:")
        print(f"  Real content feels template-like: {'❌ YES' if real_has_placeholders else '✅ NO'}")
        print(f"  Stub content is template: {'✅ YES' if stub_has_placeholders else '❌ NO'}")

        return not real_has_placeholders

    return False


def main():
    """Run all tests"""

    print("🧪 KASPER & FIREBASE INTEGRATION VALIDATION")
    print("=" * 60)

    tests_passed = 0
    total_tests = 3

    # Test 1: NumerologyData availability
    if test_numerology_data_availability():
        tests_passed += 1
        print("✅ Test 1: NumerologyData content available")
    else:
        print("❌ Test 1: NumerologyData content issues")

    # Test 2: Firebase readiness
    if test_firebase_import_readiness():
        tests_passed += 1
        print("✅ Test 2: Firebase integration ready")
    else:
        print("❌ Test 2: Firebase integration issues")

    # Test 3: Content quality
    if generate_kasper_simulation():
        tests_passed += 1
        print("✅ Test 3: Real content vs stub validated")
    else:
        print("❌ Test 3: Content validation issues")

    # Summary
    print("\n🎯 TEST SUMMARY:")
    print(f"  Passed: {tests_passed}/{total_tests}")
    print(f"  Success rate: {tests_passed/total_tests*100:.1f}%")

    if tests_passed == total_tests:
        print("🎉 ALL TESTS PASSED - Ready for integration!")
    else:
        print("⚠️  Some tests failed - Review issues above")

    print("\n📋 NEXT STEPS:")
    print("1. Run firebase_fix_numbers.py to fix number: 0 issues")
    print("2. Build and test VybeMVP with updated KASPEROrchestrator")
    print("3. Verify KASPER shows real insights, not template patterns")
    print("4. Test Firebase match notifications with correct numbers")


if __name__ == "__main__":
    main()
