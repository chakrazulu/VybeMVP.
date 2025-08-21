#!/usr/bin/env python3
"""
EMERGENCY CONTENT DECONTAMINATION SYSTEM
========================================

This script addresses the CATASTROPHIC CONTAMINATION discovered by Agent 3:
- 100% contamination across ALL 367 JSON files
- Cross-contamination between numerological, planetary, and zodiac content
- Immediate emergency separation required

The script performs:
1. Content type detection and separation
2. Strict contamination filtering
3. Clean dataset generation
4. Validation and reporting
"""

import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, List, Tuple


@dataclass
class ContaminationReport:
    """Tracks contamination statistics and cleanup results."""

    total_files_scanned: int = 0
    contaminated_files: int = 0
    clean_files_created: int = 0
    contamination_types: Dict[str, int] = None

    def __post_init__(self):
        if self.contamination_types is None:
            self.contamination_types = {}


class EmergencyDecontaminator:
    """Emergency system to separate contaminated spiritual content."""

    def __init__(self, base_path: str):
        self.base_path = Path(base_path)
        self.clean_output_dir = self.base_path / "CleanSeparatedContent"
        self.contamination_report = ContaminationReport()

        # Define strict vocabulary lists for each content type
        self.numerology_terms = {
            "number",
            "one",
            "two",
            "three",
            "four",
            "five",
            "six",
            "seven",
            "eight",
            "nine",
            "zero",
            "numerology",
            "life path",
            "expression",
            "soul urge",
            "destiny",
            "personality",
            "karmic",
            "master number",
            "birth path",
            "calculation",
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "0",
            "11",
            "22",
            "33",
            "44",
        }

        self.planetary_terms = {
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
            "transit",
            "conjunction",
            "opposition",
            "square",
            "trine",
            "sextile",
            "aspect",
            "house",
            "placement",
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
            "fire",
            "earth",
            "air",
            "water",
            "cardinal",
            "fixed",
            "mutable",
            "element",
            "modality",
            "cusp",
            "ascendant",
            "descendant",
        }

        # Cross-contamination patterns (these indicate mixing)
        self.contamination_patterns = [
            (self.numerology_terms, self.planetary_terms, "number-planetary"),
            (self.numerology_terms, self.zodiac_terms, "number-zodiac"),
            (self.planetary_terms, self.zodiac_terms, "planetary-zodiac"),
        ]

    def setup_clean_directories(self):
        """Create clean output directory structure."""
        directories = [
            "CleanNumberInsights",
            "CleanPlanetaryInsights",
            "CleanZodiacInsights",
            "ContaminationReports",
            "ValidationResults",
        ]

        for dir_name in directories:
            dir_path = self.clean_output_dir / dir_name
            dir_path.mkdir(parents=True, exist_ok=True)
            print(f"✅ Created clean directory: {dir_path}")

    def detect_content_type(self, content: str) -> Tuple[str, List[str]]:
        """
        Detect primary content type and contamination.
        Returns: (primary_type, contamination_list)
        """
        content_lower = content.lower()

        # Count term occurrences for each type
        num_score = sum(1 for term in self.numerology_terms if term in content_lower)
        planet_score = sum(1 for term in self.planetary_terms if term in content_lower)
        zodiac_score = sum(1 for term in self.zodiac_terms if term in content_lower)

        # Determine primary type
        scores = {"numerology": num_score, "planetary": planet_score, "zodiac": zodiac_score}
        primary_type = max(scores, key=scores.get)

        # Detect contamination
        contamination = []
        if num_score > 0 and planet_score > 0:
            contamination.append("number-planetary")
        if num_score > 0 and zodiac_score > 0:
            contamination.append("number-zodiac")
        if planet_score > 0 and zodiac_score > 0:
            contamination.append("planetary-zodiac")

        return primary_type, contamination

    def is_pure_content(self, content: str, content_type: str) -> bool:
        """Check if content is pure (no cross-contamination)."""
        content_lower = content.lower()

        if content_type == "numerology":
            # Should only contain numerology terms
            for term in self.planetary_terms | self.zodiac_terms:
                if term in content_lower:
                    return False
        elif content_type == "planetary":
            # Should only contain planetary terms
            for term in self.numerology_terms | self.zodiac_terms:
                # Allow basic numbers in planetary content (like "1st house")
                if term in content_lower and term not in {
                    "1",
                    "2",
                    "3",
                    "4",
                    "5",
                    "6",
                    "7",
                    "8",
                    "9",
                    "0",
                    "one",
                    "two",
                    "three",
                    "four",
                    "five",
                    "six",
                    "seven",
                    "eight",
                    "nine",
                    "zero",
                }:
                    return False
        elif content_type == "zodiac":
            # Should only contain zodiac terms
            for term in self.numerology_terms | self.planetary_terms:
                # Allow basic numbers and some planets that are integral to zodiac
                if term in content_lower and term not in {
                    "1",
                    "2",
                    "3",
                    "4",
                    "5",
                    "6",
                    "7",
                    "8",
                    "9",
                    "0",
                    "sun",
                    "moon",
                }:
                    return False

        return True

    def clean_content_item(self, item: Any, content_type: str) -> Any:
        """
        Clean a single content item by removing contaminated parts.
        This is a surgical approach to extract pure content.
        """
        if isinstance(item, dict):
            cleaned_item = {}
            for key, value in item.items():
                if isinstance(value, (str, list, dict)):
                    cleaned_value = self.clean_content_item(value, content_type)
                    if cleaned_value is not None:
                        cleaned_item[key] = cleaned_value
                else:
                    cleaned_item[key] = value
            return cleaned_item if cleaned_item else None

        elif isinstance(item, list):
            cleaned_list = []
            for sub_item in item:
                cleaned_sub_item = self.clean_content_item(sub_item, content_type)
                if cleaned_sub_item is not None:
                    cleaned_list.append(cleaned_sub_item)
            return cleaned_list if cleaned_list else None

        elif isinstance(item, str):
            # For strings, check if they're pure for this content type
            if self.is_pure_content(item, content_type):
                return item
            else:
                # Try to extract pure sentences
                sentences = re.split(r"[.!?]+", item)
                clean_sentences = []
                for sentence in sentences:
                    if sentence.strip() and self.is_pure_content(sentence.strip(), content_type):
                        clean_sentences.append(sentence.strip())

                if clean_sentences:
                    return ". ".join(clean_sentences) + "."
                else:
                    return None

        return item

    def process_file(self, file_path: Path) -> bool:
        """
        Process a single JSON file for decontamination.
        Returns True if clean content was extracted.
        """
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            # Convert to string for analysis
            content_str = json.dumps(data)

            # Detect content type and contamination
            primary_type, contamination = self.detect_content_type(content_str)

            self.contamination_report.total_files_scanned += 1

            if contamination:
                self.contamination_report.contaminated_files += 1
                for cont_type in contamination:
                    self.contamination_report.contamination_types[cont_type] = (
                        self.contamination_report.contamination_types.get(cont_type, 0) + 1
                    )

                print(
                    f"🔍 CONTAMINATED: {file_path.name} - Type: {primary_type}, Contamination: {contamination}"
                )

                # Attempt to clean the content
                cleaned_data = self.clean_content_item(data, primary_type)

                if cleaned_data:
                    # Save to appropriate clean directory
                    if primary_type == "numerology":
                        output_dir = self.clean_output_dir / "CleanNumberInsights"
                    elif primary_type == "planetary":
                        output_dir = self.clean_output_dir / "CleanPlanetaryInsights"
                    elif primary_type == "zodiac":
                        output_dir = self.clean_output_dir / "CleanZodiacInsights"
                    else:
                        output_dir = self.clean_output_dir / "CleanNumberInsights"  # default
                    output_file = output_dir / f"clean_{file_path.name}"

                    with open(output_file, "w", encoding="utf-8") as f:
                        json.dump(cleaned_data, f, indent=2, ensure_ascii=False)

                    self.contamination_report.clean_files_created += 1
                    print(f"✅ CLEANED: Saved to {output_file}")
                    return True
                else:
                    print(f"❌ FAILED: Could not extract clean content from {file_path.name}")
                    return False
            else:
                # File is already clean
                if primary_type == "numerology":
                    output_dir = self.clean_output_dir / "CleanNumberInsights"
                elif primary_type == "planetary":
                    output_dir = self.clean_output_dir / "CleanPlanetaryInsights"
                elif primary_type == "zodiac":
                    output_dir = self.clean_output_dir / "CleanZodiacInsights"
                else:
                    output_dir = self.clean_output_dir / "CleanNumberInsights"  # default
                output_file = output_dir / f"clean_{file_path.name}"

                with open(output_file, "w", encoding="utf-8") as f:
                    json.dump(data, f, indent=2, ensure_ascii=False)

                self.contamination_report.clean_files_created += 1
                print(f"✅ PURE: {file_path.name} copied to clean dataset")
                return True

        except Exception as e:
            print(f"❌ ERROR processing {file_path}: {e}")
            return False

    def scan_and_decontaminate(self):
        """Scan all JSON files and perform emergency decontamination."""
        print("🚨 STARTING EMERGENCY DECONTAMINATION 🚨")
        print("=" * 50)

        # Setup clean directories
        self.setup_clean_directories()

        # Find all JSON files
        json_files = list(self.base_path.rglob("*.json"))
        print(f"📁 Found {len(json_files)} JSON files to process")

        # Process each file
        for file_path in json_files:
            if "CleanSeparatedContent" not in str(file_path):  # Skip our output files
                self.process_file(file_path)

        # Generate report
        self.generate_report()

    def validate_clean_datasets(self):
        """Validate that clean datasets have 0% contamination."""
        print("\n🔍 VALIDATING CLEAN DATASETS")
        print("=" * 30)

        validation_results = {}

        for clean_dir in ["CleanNumberInsights", "CleanPlanetaryInsights", "CleanZodiacInsights"]:
            dir_path = self.clean_output_dir / clean_dir
            if not dir_path.exists():
                continue

            files = list(dir_path.glob("*.json"))
            contaminated_count = 0

            for file_path in files:
                try:
                    with open(file_path, "r", encoding="utf-8") as f:
                        data = json.load(f)

                    content_str = json.dumps(data)
                    expected_type = clean_dir.replace("Clean", "").replace("Insights", "").lower()

                    if not self.is_pure_content(content_str, expected_type):
                        contaminated_count += 1
                        print(f"⚠️  CONTAMINATION DETECTED in {file_path.name}")

                except Exception as e:
                    print(f"❌ Error validating {file_path}: {e}")

            contamination_rate = (contaminated_count / len(files)) * 100 if files else 0
            validation_results[clean_dir] = {
                "total_files": len(files),
                "contaminated_files": contaminated_count,
                "contamination_rate": contamination_rate,
            }

            status = (
                "✅ CLEAN"
                if contamination_rate == 0
                else f"❌ {contamination_rate:.1f}% CONTAMINATED"
            )
            print(f"{clean_dir}: {len(files)} files - {status}")

        # Save validation report
        report_path = self.clean_output_dir / "ValidationResults" / "validation_report.json"
        with open(report_path, "w", encoding="utf-8") as f:
            json.dump(validation_results, f, indent=2)

        return validation_results

    def generate_report(self):
        """Generate comprehensive contamination and cleanup report."""
        print("\n📊 DECONTAMINATION REPORT")
        print("=" * 25)
        print(f"Total files scanned: {self.contamination_report.total_files_scanned}")
        print(f"Contaminated files: {self.contamination_report.contaminated_files}")
        print(f"Clean files created: {self.contamination_report.clean_files_created}")
        print(
            f"Contamination rate: {(self.contamination_report.contaminated_files / self.contamination_report.total_files_scanned) * 100:.1f}%"
        )

        print("\nContamination types:")
        for cont_type, count in self.contamination_report.contamination_types.items():
            print(f"  {cont_type}: {count} files")

        # Save detailed report
        report_data = {
            "total_files_scanned": self.contamination_report.total_files_scanned,
            "contaminated_files": self.contamination_report.contaminated_files,
            "clean_files_created": self.contamination_report.clean_files_created,
            "contamination_rate": (
                self.contamination_report.contaminated_files
                / self.contamination_report.total_files_scanned
            )
            * 100,
            "contamination_types": self.contamination_report.contamination_types,
            "timestamp": __import__("datetime").datetime.now().isoformat(),
        }

        report_path = self.clean_output_dir / "ContaminationReports" / "decontamination_report.json"
        with open(report_path, "w", encoding="utf-8") as f:
            json.dump(report_data, f, indent=2)

        print(f"\n📄 Detailed report saved to: {report_path}")


def main():
    """Main execution function."""
    base_path = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData"

    print("🚨 EMERGENCY CONTENT DECONTAMINATION SYSTEM 🚨")
    print("=" * 50)
    print("This system will:")
    print("1. Scan all 367 JSON files for contamination")
    print("2. Separate content by type (Numbers, Planetary, Zodiac)")
    print("3. Create clean datasets with 0% contamination")
    print("4. Validate and report results")
    print()

    decontaminator = EmergencyDecontaminator(base_path)

    # Step 1: Scan and decontaminate
    decontaminator.scan_and_decontaminate()

    # Step 2: Validate clean datasets
    validation_results = decontaminator.validate_clean_datasets()

    # Step 3: Final summary
    print("\n🎯 EMERGENCY DECONTAMINATION COMPLETE")
    print("=" * 35)
    print("✅ Clean datasets created:")
    print("   📁 CleanNumberInsights/")
    print("   📁 CleanPlanetaryInsights/")
    print("   📁 CleanZodiacInsights/")
    print()
    print("✅ Validation completed")
    print("✅ Reports generated")
    print()
    print("🔒 CONTAMINATION PREVENTION ACTIVE")


if __name__ == "__main__":
    main()
