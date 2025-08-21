#!/usr/bin/env python3
"""
SIMPLE CONTENT SEPARATOR
========================

Separates the 367 contaminated JSON files into clean, type-specific datasets.
This is a surgical approach to extract authentic content by type.
"""

import json
from pathlib import Path
from typing import Any, Dict, List


class SimpleContentSeparator:
    """Separates contaminated content into clean type-specific datasets."""

    def __init__(self, base_path: str):
        self.base_path = Path(base_path)
        self.output_dir = self.base_path / "CleanSeparatedContent"

        # Define strict keywords for each content type
        self.number_keywords = {
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
        }

        self.planet_keywords = {
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
        }

        self.zodiac_keywords = {
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

    def setup_output_dirs(self):
        """Create output directories."""
        dirs = ["CleanNumbers", "CleanPlanets", "CleanZodiac", "Reports"]
        for dir_name in dirs:
            (self.output_dir / dir_name).mkdir(parents=True, exist_ok=True)
        print(f"✅ Setup complete: {self.output_dir}")

    def detect_primary_type(self, content: str) -> str:
        """Detect the primary content type based on keyword frequency."""
        content_lower = content.lower()

        num_count = sum(1 for kw in self.number_keywords if kw in content_lower)
        planet_count = sum(1 for kw in self.planet_keywords if kw in content_lower)
        zodiac_count = sum(1 for kw in self.zodiac_keywords if kw in content_lower)

        if num_count >= planet_count and num_count >= zodiac_count:
            return "numbers"
        elif planet_count >= zodiac_count:
            return "planets"
        else:
            return "zodiac"

    def extract_clean_insights(self, data: Dict[str, Any], target_type: str) -> List[str]:
        """Extract clean insights that match the target type."""
        clean_insights = []

        def extract_from_value(value):
            if isinstance(value, str):
                if self.is_clean_for_type(value, target_type):
                    clean_insights.append(value)
            elif isinstance(value, list):
                for item in value:
                    if isinstance(item, str) and self.is_clean_for_type(item, target_type):
                        clean_insights.append(item)
                    elif isinstance(item, dict):
                        extract_from_dict(item)
            elif isinstance(value, dict):
                extract_from_dict(value)

        def extract_from_dict(d):
            for v in d.values():
                extract_from_value(v)

        extract_from_dict(data)
        return clean_insights

    def is_clean_for_type(self, text: str, target_type: str) -> bool:
        """Check if text is clean for the target content type."""
        text_lower = text.lower()

        if target_type == "numbers":
            # Should contain numerology terms but no planetary/zodiac terms
            has_num_terms = any(kw in text_lower for kw in self.number_keywords)
            has_planet_terms = any(kw in text_lower for kw in self.planet_keywords)
            has_zodiac_terms = any(kw in text_lower for kw in self.zodiac_keywords)
            return has_num_terms and not has_planet_terms and not has_zodiac_terms

        elif target_type == "planets":
            # Should contain planetary terms but no numerology/zodiac terms
            has_planet_terms = any(kw in text_lower for kw in self.planet_keywords)
            has_num_terms = any(kw in text_lower for kw in self.number_keywords)
            has_zodiac_terms = any(kw in text_lower for kw in self.zodiac_keywords)
            return has_planet_terms and not has_num_terms and not has_zodiac_terms

        elif target_type == "zodiac":
            # Should contain zodiac terms but no numerology/planetary terms
            has_zodiac_terms = any(kw in text_lower for kw in self.zodiac_keywords)
            has_num_terms = any(kw in text_lower for kw in self.number_keywords)
            has_planet_terms = any(kw in text_lower for kw in self.planet_keywords)
            return has_zodiac_terms and not has_num_terms and not has_planet_terms

        return False

    def process_file(self, file_path: Path) -> Dict[str, int]:
        """Process a single file and extract clean content by type."""
        result = {"numbers": 0, "planets": 0, "zodiac": 0}

        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            # Extract clean insights for each type
            for content_type in ["numbers", "planets", "zodiac"]:
                clean_insights = self.extract_clean_insights(data, content_type)

                if clean_insights:
                    # Create output file
                    output_file = (
                        self.output_dir
                        / f"Clean{content_type.capitalize()}"
                        / f"{file_path.stem}_{content_type}.json"
                    )

                    output_data = {
                        "source_file": str(file_path),
                        "content_type": content_type,
                        "clean_insights": clean_insights,
                        "total_clean_insights": len(clean_insights),
                    }

                    with open(output_file, "w", encoding="utf-8") as f:
                        json.dump(output_data, f, indent=2, ensure_ascii=False)

                    result[content_type] = len(clean_insights)
                    print(
                        f"  ✅ {content_type}: {len(clean_insights)} clean insights -> {output_file.name}"
                    )

        except Exception as e:
            print(f"  ❌ Error processing {file_path.name}: {e}")

        return result

    def separate_all_content(self):
        """Process all JSON files and separate content by type."""
        print("🚨 STARTING CONTENT SEPARATION")
        print("=" * 40)

        self.setup_output_dirs()

        # Find all JSON files
        json_files = list(self.base_path.rglob("*.json"))
        json_files = [f for f in json_files if "CleanSeparatedContent" not in str(f)]

        print(f"📁 Processing {len(json_files)} files...")

        total_stats = {"numbers": 0, "planets": 0, "zodiac": 0, "files_processed": 0}

        for file_path in json_files:
            print(f"\n🔍 Processing: {file_path.name}")
            file_stats = self.process_file(file_path)

            for content_type in ["numbers", "planets", "zodiac"]:
                total_stats[content_type] += file_stats[content_type]
            total_stats["files_processed"] += 1

        # Save summary report
        report = {
            "total_files_processed": total_stats["files_processed"],
            "clean_insights_extracted": {
                "numbers": total_stats["numbers"],
                "planets": total_stats["planets"],
                "zodiac": total_stats["zodiac"],
            },
            "total_clean_insights": sum(
                [total_stats["numbers"], total_stats["planets"], total_stats["zodiac"]]
            ),
        }

        report_file = self.output_dir / "Reports" / "separation_report.json"
        with open(report_file, "w", encoding="utf-8") as f:
            json.dump(report, f, indent=2)

        print("\n📊 SEPARATION COMPLETE")
        print("=" * 20)
        print(f"Files processed: {total_stats['files_processed']}")
        print(f"Clean number insights: {total_stats['numbers']}")
        print(f"Clean planetary insights: {total_stats['planets']}")
        print(f"Clean zodiac insights: {total_stats['zodiac']}")
        print(
            f"Total clean insights: {sum([total_stats['numbers'], total_stats['planets'], total_stats['zodiac']])}"
        )
        print(f"📄 Report saved: {report_file}")

        return report


def main():
    """Main execution function."""
    base_path = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData"

    print("🧹 SIMPLE CONTENT SEPARATOR")
    print("=" * 30)
    print("Extracting clean insights from 367 contaminated files...")
    print()

    separator = SimpleContentSeparator(base_path)
    report = separator.separate_all_content()

    print("\n✅ EMERGENCY DECONTAMINATION COMPLETE!")
    print("Clean datasets available in CleanSeparatedContent/")


if __name__ == "__main__":
    main()
