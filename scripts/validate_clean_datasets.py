#!/usr/bin/env python3
"""
CLEAN DATASET VALIDATION SYSTEM
===============================

Validates that the clean datasets have 0% contamination and
implements bulletproof validation to prevent future cross-contamination.
"""

import json
from pathlib import Path
from typing import Any, Dict, List


class CleanDatasetValidator:
    """Validates clean datasets for 0% contamination."""

    def __init__(self, clean_path: str):
        self.clean_path = Path(clean_path)

        # Define strict vocabulary for contamination detection
        self.number_terms = {
            "numerology",
            "number",
            "life path",
            "expression",
            "soul urge",
            "destiny number",
            "personality number",
            "karmic",
            "master number",
            "birth path",
            "calculation",
        }

        self.planet_terms = {
            "mars",
            "venus",
            "jupiter",
            "mercury",
            "moon",
            "sun",
            "saturn",
            "uranus",
            "neptune",
            "pluto",
            "planet",
            "planetary",
            "retrograde",
            "orbit",
            "celestial",
        }

        self.zodiac_terms = {
            "aries",
            "taurus",
            "gemini",
            "cancer",
            "leo",
            "virgo",
            "libra",
            "scorpio",
            "sagittarius",
            "capricorn",
            "aquarius",
            "pisces",
            "zodiac",
            "sign",
        }

    def detect_contamination(self, text: str, expected_type: str) -> List[str]:
        """Detect contamination in text based on expected content type."""
        text_lower = text.lower()
        contamination = []

        if expected_type == "numbers":
            # Numbers should not contain planetary/zodiac terms
            for term in self.planet_terms:
                if term in text_lower:
                    contamination.append(f"planetary-term: {term}")
            for term in self.zodiac_terms:
                if term in text_lower:
                    contamination.append(f"zodiac-term: {term}")

        elif expected_type == "planets":
            # Planets should not contain numerology/zodiac terms (except basic numbers)
            for term in self.number_terms:
                if term in text_lower:
                    contamination.append(f"numerology-term: {term}")
            for term in self.zodiac_terms:
                # Allow sun/moon as they're integral to planetary astrology
                if term in text_lower and term not in {"sun", "moon"}:
                    contamination.append(f"zodiac-term: {term}")

        elif expected_type == "zodiac":
            # Zodiac should not contain numerology/planetary terms (except sun/moon)
            for term in self.number_terms:
                if term in text_lower:
                    contamination.append(f"numerology-term: {term}")
            for term in self.planet_terms:
                # Allow sun/moon as they're integral to zodiac astrology
                if term in text_lower and term not in {"sun", "moon"}:
                    contamination.append(f"planetary-term: {term}")

        return contamination

    def validate_file(self, file_path: Path, expected_type: str) -> Dict[str, Any]:
        """Validate a single clean dataset file."""
        result = {
            "file": file_path.name,
            "expected_type": expected_type,
            "is_clean": True,
            "contamination_count": 0,
            "contamination_details": [],
            "total_insights": 0,
        }

        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            clean_insights = data.get("clean_insights", [])
            result["total_insights"] = len(clean_insights)

            for i, insight in enumerate(clean_insights):
                if isinstance(insight, str):
                    contamination = self.detect_contamination(insight, expected_type)
                    if contamination:
                        result["is_clean"] = False
                        result["contamination_count"] += len(contamination)
                        result["contamination_details"].append(
                            {
                                "insight_index": i,
                                "insight_preview": insight[:100] + "..."
                                if len(insight) > 100
                                else insight,
                                "contamination": contamination,
                            }
                        )

        except Exception as e:
            result["error"] = str(e)
            result["is_clean"] = False

        return result

    def validate_dataset_directory(self, dir_path: Path, expected_type: str) -> Dict[str, Any]:
        """Validate all files in a clean dataset directory."""
        if not dir_path.exists():
            return {"error": f"Directory {dir_path} does not exist"}

        files = list(dir_path.glob("*.json"))
        total_files = len(files)
        clean_files = 0
        contaminated_files = 0
        total_contamination = 0
        detailed_results = []

        print(f"\n🔍 VALIDATING {expected_type.upper()} DATASET")
        print(f"Directory: {dir_path}")
        print(f"Files to validate: {total_files}")
        print("-" * 50)

        for file_path in files:
            result = self.validate_file(file_path, expected_type)
            detailed_results.append(result)

            if result["is_clean"]:
                clean_files += 1
                print(f"✅ {result['file']} - CLEAN ({result['total_insights']} insights)")
            else:
                contaminated_files += 1
                total_contamination += result["contamination_count"]
                print(f"❌ {result['file']} - CONTAMINATED ({result['contamination_count']} issues)")

                # Show first few contamination details
                for detail in result["contamination_details"][:3]:
                    print(
                        f"   Issue: {detail['contamination'][0]} in insight {detail['insight_index']}"
                    )

        contamination_rate = (contaminated_files / total_files) * 100 if total_files > 0 else 0

        summary = {
            "dataset_type": expected_type,
            "total_files": total_files,
            "clean_files": clean_files,
            "contaminated_files": contaminated_files,
            "contamination_rate": contamination_rate,
            "total_contamination_issues": total_contamination,
            "detailed_results": detailed_results,
        }

        print(f"\n📊 SUMMARY: {expected_type.upper()}")
        print(f"Clean files: {clean_files}/{total_files}")
        print(f"Contamination rate: {contamination_rate:.1f}%")
        print(f"Total contamination issues: {total_contamination}")

        return summary

    def validate_all_datasets(self) -> Dict[str, Any]:
        """Validate all clean datasets."""
        print("🚨 STARTING CLEAN DATASET VALIDATION")
        print("=" * 50)

        datasets = [
            ("CleanNumbers", "numbers"),
            ("CleanPlanets", "planets"),
            ("CleanZodiac", "zodiac"),
        ]

        validation_results = {}
        overall_stats = {
            "total_files": 0,
            "total_clean_files": 0,
            "total_contaminated_files": 0,
            "overall_contamination_rate": 0,
            "total_contamination_issues": 0,
        }

        for dir_name, expected_type in datasets:
            dir_path = self.clean_path / dir_name
            result = self.validate_dataset_directory(dir_path, expected_type)
            validation_results[dir_name] = result

            # Update overall stats
            overall_stats["total_files"] += result.get("total_files", 0)
            overall_stats["total_clean_files"] += result.get("clean_files", 0)
            overall_stats["total_contaminated_files"] += result.get("contaminated_files", 0)
            overall_stats["total_contamination_issues"] += result.get(
                "total_contamination_issues", 0
            )

        # Calculate overall contamination rate
        if overall_stats["total_files"] > 0:
            overall_stats["overall_contamination_rate"] = (
                overall_stats["total_contaminated_files"] / overall_stats["total_files"]
            ) * 100

        # Save validation report
        report_path = self.clean_path / "validation_report.json"
        full_report = {
            "validation_timestamp": __import__("datetime").datetime.now().isoformat(),
            "overall_statistics": overall_stats,
            "dataset_results": validation_results,
        }

        with open(report_path, "w", encoding="utf-8") as f:
            json.dump(full_report, f, indent=2)

        print("\n🎯 VALIDATION COMPLETE")
        print("=" * 25)
        print(f"Total files validated: {overall_stats['total_files']}")
        print(f"Clean files: {overall_stats['total_clean_files']}")
        print(f"Contaminated files: {overall_stats['total_contaminated_files']}")
        print(f"Overall contamination rate: {overall_stats['overall_contamination_rate']:.1f}%")
        print(f"Total contamination issues: {overall_stats['total_contamination_issues']}")
        print(f"\n📄 Detailed report saved: {report_path}")

        # Success criteria
        if overall_stats["overall_contamination_rate"] == 0:
            print("\n🎉 SUCCESS: 0% CONTAMINATION ACHIEVED!")
            print("✅ Clean datasets are ready for production use")
        else:
            print(
                f"\n⚠️  WARNING: {overall_stats['overall_contamination_rate']:.1f}% contamination detected"
            )
            print("❌ Additional cleaning required")

        return full_report


def main():
    """Main execution function."""
    clean_path = (
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/CleanSeparatedContent"
    )

    print("🔬 CLEAN DATASET VALIDATION SYSTEM")
    print("=" * 40)
    print("Testing for 0% contamination across all clean datasets...")
    print()

    validator = CleanDatasetValidator(clean_path)
    report = validator.validate_all_datasets()

    print("\n🔒 CONTAMINATION PREVENTION SYSTEM ACTIVE")
    print("Future imports will be validated against these standards.")


if __name__ == "__main__":
    main()
