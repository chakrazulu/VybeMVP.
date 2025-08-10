#!/usr/bin/env python3
"""
Soul Urge Manual Converter - Direct file processing
Manually converts each Soul Urge file by reading and cleaning content
"""

import json
import re
from pathlib import Path


def manual_convert_soul_urge():
    """Manually convert each Soul Urge file"""

    input_dir = Path(
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/ImportedContent/SoulUrgeContent"
    )
    output_dir = Path(
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLX/MLXTraining/ContentRefinery/Approved"
    )

    # Numbers to process (excluding ones already done)
    numbers_to_process = [2, 3, 4, 5, 11, 22, 33, 44]

    output_dir.mkdir(parents=True, exist_ok=True)

    print("🔮 SOUL URGE MANUAL CONVERTER")
    print("=" * 50)

    successful = 0

    for number in numbers_to_process:
        input_file = input_dir / f"SU{number}.md"
        output_file = output_dir / f"soulUrge_{number:02d}_v2.0_converted.json"

        if not input_file.exists():
            print(f"❌ File not found: SU{number}.md")
            continue

        try:
            print(f"Processing SU{number}.md...")

            # Read raw content
            content = input_file.read_text(encoding="utf-8")

            # Remove MD header
            content = re.sub(r"^# SU\d+\s*\n\s*## SU\d+\s*\n", "", content)

            # Fix escaped brackets
            content = content.replace("\\[", "[").replace("\\]", "]")

            # Remove newlines between every JSON property
            # Strategy: Keep only lines with actual content
            lines = []
            for line in content.split("\n"):
                stripped = line.strip()
                if stripped:
                    lines.append(stripped)

            # Join without extra spaces to create compact JSON
            compact_json = "".join(lines)

            # Fix JSON formatting issues
            # Add spaces after colons and commas for readability
            compact_json = re.sub(r'":"', '": "', compact_json)
            compact_json = re.sub(r'":(\d)', r'": \1', compact_json)
            compact_json = re.sub(r'":({|\[)', r'": \1', compact_json)
            compact_json = re.sub(r'",("|\})', r'", \1', compact_json)

            # Try to parse
            soul_urge_data = json.loads(compact_json)

            # Convert to v2.0 format (simplified - keep original structure)
            profile = soul_urge_data["profiles"][0]

            v2_data = {
                "number": number,
                "title": f"Soul Urge {number}",
                "behavioral_category": "soul_urge_behavioral_analysis",
                "meta": soul_urge_data.get("meta", {}),
                "profile": profile,
                "behavioral_insights": [],
            }

            # Extract behavioral insights
            if "behavioral" in profile:
                for category, insights in profile["behavioral"].items():
                    for insight in insights:
                        behavioral_insight = {
                            "category": category,
                            "text": insight["text"],
                            "intensity": insight.get("intensity", 0.75),
                        }

                        # Add optional fields
                        for field in ["triggers", "supports", "challenges"]:
                            if field in insight:
                                behavioral_insight[field] = insight[field]

                        v2_data["behavioral_insights"].append(behavioral_insight)

            # Write output
            with open(output_file, "w", encoding="utf-8") as f:
                json.dump(v2_data, f, indent=2, ensure_ascii=False)

            insight_count = len(v2_data["behavioral_insights"])
            print(f"✅ Created soulUrge_{number:02d}_v2.0_converted.json")
            print(f"   {insight_count} behavioral insights")

            successful += 1

        except Exception as e:
            print(f"❌ Error processing SU{number}.md: {e}")
            continue

    print("\n" + "=" * 50)
    print("🎯 MANUAL CONVERSION COMPLETE")
    print(f"✅ Successfully converted: {successful} files")
    print(f"📁 Total Soul Urge files ready: {successful + 5}")  # +5 for the ones already copied
    print("🔮 Soul Urge behavioral corpus ready for KASPER MLX!")


if __name__ == "__main__":
    manual_convert_soul_urge()
