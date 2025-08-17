#!/usr/bin/env python3

import json
import re
import shutil
from pathlib import Path
from typing import Any, Dict


class SoulUrgeConverterV2:
    """Convert Soul Urge MD files to v2.0 JSON with proper parsing"""

    def __init__(self):
        self.input_dir = Path(
            "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/ImportedContent/SoulUrgeContent"
        )
        self.archive_dir = Path(
            "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLX/MLXTraining/ContentRefinery/Archive"
        )
        self.approved_dir = Path(
            "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLX/MLXTraining/ContentRefinery/Approved"
        )

        # Create directories if needed
        self.archive_dir.mkdir(parents=True, exist_ok=True)
        self.approved_dir.mkdir(parents=True, exist_ok=True)

        # Divine Triangle archetypes for Soul Urge
        self.soul_urge_titles = {
            1: "The Independent Soul",
            2: "The Harmonizing Soul",
            3: "The Expressive Soul",
            4: "The Stable Soul",
            5: "The Adventurous Soul",
            6: "The Nurturing Soul",
            7: "The Seeking Soul",
            8: "The Ambitious Soul",
            9: "The Compassionate Soul",
            11: "The Inspired Soul",
            22: "The Visionary Soul",
            33: "The Healing Soul",
            44: "The Masterful Soul",
        }

    def extract_number_from_filename(self, filename: str) -> int:
        """Extract number from SU1.md, SU11.md, etc."""
        match = re.search(r"SU(\d+)\.md", filename)
        if match:
            return int(match.group(1))
        return 0

    def parse_soul_urge_md(self, file_path: Path) -> Dict[str, Any]:
        """Parse the Soul Urge MD file with escaped brackets"""
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Remove markdown headers
        content = re.sub(r"^#.*$", "", content, flags=re.MULTILINE)

        # Fix escaped brackets
        content = content.replace("\\[", "[").replace("\\]", "]")

        # Clean up the content
        content = content.strip()

        # Find the JSON content (everything between first { and last })
        json_match = re.search(r"\{.*\}", content, re.DOTALL)
        if not json_match:
            print(f"Could not find JSON content in {file_path.name}")
            return None

        json_str = json_match.group(0)

        try:
            # Parse the JSON
            data = json.loads(json_str)
            return data
        except json.JSONDecodeError:
            # Try to fix common JSON issues
            # Remove trailing commas before closing brackets
            json_str = re.sub(r",(\s*[}\]])", r"\1", json_str)

            try:
                data = json.loads(json_str)
                return data
            except json.JSONDecodeError as e2:
                print(f"JSON parsing error in {file_path.name}: {e2}")
                return None

    def convert_to_v2_format(self, data: Dict, number: int) -> Dict[str, Any]:
        """Convert Soul Urge data to v2.0 behavioral format"""

        # Navigate to the behavioral data
        profile = data.get("profiles", [{}])[0]
        behavioral = profile.get("behavioral", {})

        # Initialize v2 structure
        v2_data = {
            "number": number,
            "title": self.soul_urge_titles.get(number, f"Soul Urge {number}"),
            "behavioral_category": "soul_urge_behavioral_analysis",
            "intensity_scoring": {
                "min_range": 0.6,
                "max_range": 0.9,
                "note": "Higher intensity indicates stronger Soul Urge behavioral tendency",
            },
            "behavioral_insights": [],
        }

        # Add core metadata as special insights
        if profile.get("coreEssence"):
            v2_data["behavioral_insights"].append(
                {
                    "category": "core_essence",
                    "insight": profile["coreEssence"],
                    "intensity": 0.9,
                    "triggers": [],
                    "supports": [],
                    "challenges": [],
                }
            )

        if profile.get("lifeLesson"):
            v2_data["behavioral_insights"].append(
                {
                    "category": "life_lesson",
                    "insight": profile["lifeLesson"],
                    "intensity": 0.85,
                    "triggers": [],
                    "supports": [],
                    "challenges": [],
                }
            )

        # Category name mapping for consistency
        category_mapping = {
            "decisionMaking": "decision_making",
            "stressResponse": "stress_response",
            "communication": "communication",
            "relationships": "relationships",
            "productivity": "productivity",
            "financial": "financial",
            "creative": "creative",
            "learning": "learning",
            "wellness": "wellness",
            "spiritual": "spiritual",
            "shadow": "shadow_work",
            "transitions": "transitions",
        }

        # Process each behavioral category
        for orig_category, new_category in category_mapping.items():
            if orig_category in behavioral:
                insights = behavioral[orig_category]
                if isinstance(insights, list):
                    for item in insights:
                        if isinstance(item, dict) and "text" in item:
                            # Structured format with metadata
                            insight_data = {
                                "category": new_category,
                                "insight": item["text"],
                                "intensity": item.get("intensity", 0.7),
                                "triggers": item.get("triggers", []),
                                "supports": item.get("supports", []),
                                "challenges": item.get("challenges", []),
                            }
                        elif isinstance(item, str):
                            # Simple string format
                            insight_data = {
                                "category": new_category,
                                "insight": item,
                                "intensity": 0.7,
                                "triggers": [],
                                "supports": [],
                                "challenges": [],
                            }
                        else:
                            continue

                        # Apply Divine Triangle intensity adjustment for master numbers
                        if number in [11, 22, 33, 44]:
                            insight_data["intensity"] = min(0.9, insight_data["intensity"] + 0.05)

                        v2_data["behavioral_insights"].append(insight_data)

        return v2_data

    def process_all_files(self):
        """Process all Soul Urge MD files"""
        print("🔮 KASPER MLX Soul Urge Conversion v2.0")
        print("=" * 70)

        md_files = sorted(self.input_dir.glob("SU*.md"))
        success_count = 0
        failed_files = []

        for md_file in md_files:
            print(f"\n📖 Processing: {md_file.name}")

            # Extract number
            number = self.extract_number_from_filename(md_file.name)
            if not number:
                print(f"❌ Could not extract number from {md_file.name}")
                failed_files.append(md_file.name)
                continue

            # Parse MD file
            data = self.parse_soul_urge_md(md_file)
            if not data:
                print(f"❌ Could not parse {md_file.name}")
                failed_files.append(md_file.name)
                continue

            # Convert to v2.0 format
            v2_data = self.convert_to_v2_format(data, number)

            # Simple naming convention: soulUrge_01.json, soulUrge_11.json, etc.
            output_filename = f"soulUrge_{number:02d}.json"
            approved_path = self.approved_dir / output_filename

            # Archive original MD with clear naming
            archive_filename = f"SoulUrge_Number_{number}_original.md"
            archive_path = self.archive_dir / archive_filename
            shutil.copy2(md_file, archive_path)

            # Save v2.0 JSON to Approved folder
            with open(approved_path, "w", encoding="utf-8") as f:
                json.dump(v2_data, f, indent=2, ensure_ascii=False)

            print(f"✅ Converted to: {output_filename}")
            print(f"   Generated {len(v2_data['behavioral_insights'])} behavioral insights")
            print(f"   Archived as: {archive_filename}")
            success_count += 1

        # Final report
        print("\n" + "=" * 70)
        print(f"🎯 Conversion Complete: {success_count}/{len(md_files)} files processed")

        if failed_files:
            print(f"\n❌ Failed files: {', '.join(failed_files)}")

        if success_count == len(md_files):
            print("\n✅ All Soul Urge files successfully converted!")
            print("🔮 Divine Triangle consistency maintained")
            print("📂 Files ready in Approved folder with simple naming:")
            print("   Format: soulUrge_01.json through soulUrge_44.json")

        return success_count


def main():
    converter = SoulUrgeConverterV2()
    success_count = converter.process_all_files()

    if success_count > 0:
        print("\n🚀 KASPER MLX now has Soul Urge behavioral data!")


if __name__ == "__main__":
    main()
