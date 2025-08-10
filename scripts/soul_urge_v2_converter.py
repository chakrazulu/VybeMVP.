#!/usr/bin/env python3
"""
Soul Urge v2.0 Converter - Divine Triangle Consistency
Converts Soul Urge MD files to v2.0 behavioral JSON format
Maintains Soul Urge focus: WHAT you desire vs HOW you express it
"""

import json
import re
from pathlib import Path
from typing import Any, Dict


class SoulUrgeV2Converter:
    def __init__(self):
        self.input_dir = Path(
            "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/ImportedContent/SoulUrgeContent"
        )
        self.output_dir = Path(
            "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLX/MLXTraining/ContentRefinery/Approved"
        )

        # Soul Urge to behavioral context mapping
        self.soul_urge_context = {
            1: "Inner drive for independence and leadership",
            2: "Deep desire for partnership and cooperation",
            3: "Soul craving for creative expression and joy",
            4: "Inner need for security and systematic building",
            5: "Soul yearning for freedom and adventure",
            6: "Deep desire to nurture and serve others",
            7: "Inner seeking for truth and spiritual understanding",
            8: "Soul drive for material mastery and recognition",
            9: "Deep desire to heal and serve humanity",
            11: "Soul mission of spiritual inspiration and illumination",
            22: "Inner drive to build lasting foundations for others",
            33: "Soul calling to teach and heal through compassion",
            44: "Deep desire to create systems that serve generations",
        }

    def clean_json_content(self, content: str) -> str:
        """Clean malformed JSON with escaped brackets and newlines"""
        # Remove the MD header
        content = re.sub(r"^# SU\d+\n*## SU\d+\n*", "", content)

        # Fix escaped brackets
        content = content.replace("\\[", "[").replace("\\]", "]")

        # Remove extra newlines between JSON properties
        lines = content.split("\n")
        cleaned_lines = []

        for line in lines:
            stripped = line.strip()
            if stripped:  # Only keep non-empty lines
                cleaned_lines.append(stripped)

        return "\n".join(cleaned_lines)

    def convert_to_v2_format(self, soul_urge_data: Dict, number: int) -> Dict[str, Any]:
        """Convert Soul Urge v1 to v2.0 behavioral format"""

        # Extract original behavioral data
        original_behavioral = soul_urge_data["profiles"][0]["behavioral"]

        # Create v2.0 structure with Soul Urge focus
        v2_data = {
            "number": number,
            "title": f"Soul Urge {number}",
            "behavioral_category": "soul_urge_behavioral_analysis",
            "core_desire": self.soul_urge_context.get(number, "Inner soul motivation"),
            "intensity_scoring": {
                "min_range": 0.6,
                "max_range": 0.9,
                "note": "Higher intensity indicates stronger soul urge manifestation",
            },
            "divine_triangle_integration": {
                "role": "WHAT you deeply desire and are motivated by internally",
                "relationship_to_life_path": "Soul Urge drives the motivation behind Life Path journey",
                "relationship_to_expression": "Soul Urge provides the inner fuel for external Expression",
                "calculation": "Sum of vowels in full birth name, reduced to single digit or master number",
            },
            "behavioral_insights": [],
        }

        # Convert behavioral categories with Soul Urge focus
        categories = [
            "decisionMaking",
            "stressResponse",
            "communication",
            "relationships",
            "productivity",
            "financial",
            "creative",
            "learning",
            "wellness",
            "spiritual",
            "shadow",
            "transitions",
        ]

        for category in categories:
            if category in original_behavioral:
                insights = original_behavioral[category]

                # Convert each insight with Soul Urge framing
                for insight in insights:
                    converted_insight = self.convert_insight_to_soul_urge_focus(
                        insight, category, number
                    )
                    v2_data["behavioral_insights"].append(converted_insight)

        return v2_data

    def convert_insight_to_soul_urge_focus(
        self, insight: Dict, category: str, number: int
    ) -> Dict[str, Any]:
        """Convert insight with Soul Urge focus (what drives you internally)"""

        # Base structure
        converted = {
            "category": category,
            "text": insight["text"],
            "intensity": insight.get("intensity", 0.75),
            "soul_urge_context": f"Driven by Soul Urge {number} desires",
        }

        # Add detailed fields if present
        if "triggers" in insight:
            converted["triggers"] = insight["triggers"]
        if "supports" in insight:
            converted["supports"] = insight["supports"]
        if "challenges" in insight:
            converted["challenges"] = insight["challenges"]

        # Add soul urge framing based on category
        soul_urge_frames = {
            "decisionMaking": "Inner desires influencing choices",
            "stressResponse": "How soul needs react under pressure",
            "communication": "Expressing your deepest motivations",
            "relationships": "What you seek from deep connections",
            "productivity": "Inner drives affecting work patterns",
            "financial": "Soul desires around security and abundance",
            "creative": "Core creative urges and inspirations",
            "learning": "What knowledge your soul craves",
            "wellness": "Inner needs for physical and mental health",
            "spiritual": "Deep spiritual longings and practices",
            "shadow": "When soul desires become distorted",
            "transitions": "How core desires shift through life changes",
        }

        converted["soul_urge_theme"] = soul_urge_frames.get(category, "Inner soul motivation")

        return converted

    def convert_file(self, input_file: Path) -> bool:
        """Convert single Soul Urge MD file to v2.0 JSON"""
        try:
            print(f"Converting {input_file.name}...")

            # Extract number from filename (SU1.md -> 1)
            number_match = re.search(r"SU(\d+)", input_file.name)
            if not number_match:
                print(f"Could not extract number from {input_file.name}")
                return False

            number = int(number_match.group(1))

            # Read and clean content
            content = input_file.read_text(encoding="utf-8")
            cleaned_content = self.clean_json_content(content)

            # Parse JSON
            try:
                soul_urge_data = json.loads(cleaned_content)
            except json.JSONDecodeError as e:
                print(f"JSON parsing failed for {input_file.name}: {e}")
                return False

            # Convert to v2.0 format
            v2_data = self.convert_to_v2_format(soul_urge_data, number)

            # Write output file
            output_filename = f"soulUrge_{number:02d}_v2.0_converted.json"
            output_file = self.output_dir / output_filename

            with open(output_file, "w", encoding="utf-8") as f:
                json.dump(v2_data, f, indent=2, ensure_ascii=False)

            print(f"✅ Created {output_filename}")
            print(f"   {len(v2_data['behavioral_insights'])} behavioral insights converted")

            return True

        except Exception as e:
            print(f"❌ Error converting {input_file.name}: {e}")
            return False

    def convert_all_files(self):
        """Convert all Soul Urge MD files"""
        print("🔮 SOUL URGE V2.0 CONVERTER - Divine Triangle Consistency")
        print("=" * 60)

        # Find all SU*.md files
        md_files = list(self.input_dir.glob("SU*.md"))

        if not md_files:
            print("❌ No Soul Urge MD files found")
            return

        print(f"Found {len(md_files)} Soul Urge files to convert")

        # Ensure output directory exists
        self.output_dir.mkdir(parents=True, exist_ok=True)

        # Convert each file
        successful = 0
        failed = 0

        for md_file in sorted(md_files):
            if self.convert_file(md_file):
                successful += 1
            else:
                failed += 1

        print("\n" + "=" * 60)
        print("🎯 CONVERSION COMPLETE")
        print(f"✅ Successful: {successful}")
        print(f"❌ Failed: {failed}")
        print(f"📁 Output: {self.output_dir}")

        if successful > 0:
            total_insights = successful * 144  # Approximate 144 insights per file
            print(f"🧠 Total behavioral insights: ~{total_insights}")
            print("🔮 Soul Urge v2.0 behavioral corpus ready for KASPER MLX!")


def main():
    converter = SoulUrgeV2Converter()
    converter.convert_all_files()


if __name__ == "__main__":
    main()
