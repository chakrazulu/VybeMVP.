#!/usr/bin/env python3
"""
OPUS Marathon Converter - Batch conversion of spiritual content to JSON format
Handles Claude Deep Content, Grok Multi-Persona, and ChatGPT content
"""

import json
import re
from pathlib import Path
from typing import Any, Dict


class OPUSConverter:
    def __init__(self):
        self.base_path = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP")
        self.import_path = self.base_path / "NumerologyData/ImportedContent"
        self.output_path = self.base_path / "KASPERMLX/MLXTraining/ContentRefinery/Approved"

    def extract_number_from_filename(self, filename: str) -> int:
        """Extract the number from various filename formats"""
        # Handle different patterns: CR1, Number_1, Number_11, etc.
        patterns = [
            r"CR(\d+)",  # Claude format
            r"Number_(\d+)",  # Grok format
            r"ChatGPT_Number_(\d+)",  # ChatGPT format
        ]

        for pattern in patterns:
            match = re.search(pattern, filename)
            if match:
                return int(match.group(1))
        return 0

    def convert_grok_content(self, file_path: Path, persona: str) -> Dict[str, Any]:
        """Convert Grok content which is already in pseudo-JSON format"""
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        number = self.extract_number_from_filename(file_path.name)

        # Extract the JSON portion from the markdown
        json_start = content.find("{")
        json_end = content.rfind("}") + 1

        if json_start != -1 and json_end > json_start:
            json_str = content[json_start:json_end]
            # Fix escaped brackets in the JSON
            json_str = json_str.replace("\\[", "[").replace("\\]", "]")

            try:
                data = json.loads(json_str)

                # Restructure for KASPER training
                return {
                    "source": f"grok_{persona.lower()}",
                    "number": number,
                    "persona": persona,
                    "content_type": "mystical_insights",
                    "generation_info": data.get("generation_info", {}),
                    "insights": {
                        "primary": data.get("insight", []),
                        "reflections": data.get("reflection", []),
                        "contemplations": data.get("contemplation", []),
                        "affirmations": data.get("affirmation", []),
                        "challenges": data.get("challenge", []),
                        "integration": data.get("integration", []),
                        "meditation": data.get("meditation", []),
                        "ritual": data.get("ritual", []),
                        "mantra": data.get("mantra", []),
                        "visualization": data.get("visualization", []),
                        "practice": data.get("practice", []),
                        "shadow_work": data.get("shadow_work", []),
                    },
                    "intensity_scoring": {
                        "min_range": 0.7,
                        "max_range": 0.9,
                        "note": f"{persona} perspective with mystical depth",
                    },
                }
            except json.JSONDecodeError as e:
                print(f"Error parsing JSON from {file_path}: {e}")
                return None
        return None

    def convert_claude_content(self, file_path: Path) -> Dict[str, Any]:
        """Convert Claude deep academic content"""
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        number = self.extract_number_from_filename(file_path.name)

        # Parse sections from the markdown
        sections = {}
        current_section = None
        current_content = []

        for line in content.split("\n"):
            if line.startswith("###"):
                if current_section:
                    sections[current_section] = "\n".join(current_content).strip()
                current_section = line.strip("#").strip().lower().replace(" ", "_")
                current_content = []
            elif line.startswith("##") and not line.startswith("###"):
                if current_section:
                    sections[current_section] = "\n".join(current_content).strip()
                current_section = line.strip("#").strip().lower().replace(" ", "_")
                current_content = []
            elif current_section:
                current_content.append(line)

        if current_section:
            sections[current_section] = "\n".join(current_content).strip()

        return {
            "source": "claude_deep_content",
            "number": number,
            "content_type": "academic_spiritual_analysis",
            "title": f"Deep Analysis of Number {number}",
            "sections": sections,
            "intensity_scoring": {
                "min_range": 0.8,
                "max_range": 0.95,
                "note": "Academic depth with esoteric wisdom",
            },
        }

    def batch_convert_grok_persona(self, persona: str):
        """Convert all files for a specific Grok persona"""
        persona_path = self.import_path / "GrokStructuredContent" / persona
        if not persona_path.exists():
            print(f"Path not found: {persona_path}")
            return

        converted_files = []
        for file_path in sorted(persona_path.glob("*.md")):
            result = self.convert_grok_content(file_path, persona)
            if result:
                output_file = (
                    self.output_path
                    / f"grok_{persona.lower()}_{result['number']:02d}_converted.json"
                )
                with open(output_file, "w", encoding="utf-8") as f:
                    json.dump(result, f, indent=2, ensure_ascii=False)
                converted_files.append(output_file.name)
                print(f"✅ Converted: {file_path.name} → {output_file.name}")

        return converted_files

    def batch_convert_claude(self):
        """Convert all Claude deep content files"""
        claude_path = self.import_path / "ClaudeDeepContent"
        if not claude_path.exists():
            print(f"Path not found: {claude_path}")
            return

        converted_files = []
        for file_path in sorted(claude_path.glob("*.md")):
            result = self.convert_claude_content(file_path)
            if result:
                output_file = (
                    self.output_path / f"claude_{result['number']:02d}_academic_converted.json"
                )
                with open(output_file, "w", encoding="utf-8") as f:
                    json.dump(result, f, indent=2, ensure_ascii=False)
                converted_files.append(output_file.name)
                print(f"✅ Converted: {file_path.name} → {output_file.name}")

        return converted_files


def main():
    converter = OPUSConverter()

    print("🚀 OPUS MARATHON CONVERTER - Starting batch conversion...")
    print("=" * 60)

    # Convert Claude Deep Content
    print("\n📚 Converting Claude Deep Content...")
    claude_files = converter.batch_convert_claude()
    print(f"   Converted {len(claude_files) if claude_files else 0} Claude files")

    # Convert Grok Personas
    personas = ["Oracle", "Psychologist", "MindfulnessCoach", "Philosopher", "NumerologyScholar"]

    for persona in personas:
        print(f"\n🔮 Converting Grok {persona} content...")
        grok_files = converter.batch_convert_grok_persona(persona)
        print(f"   Converted {len(grok_files) if grok_files else 0} {persona} files")

    print("\n" + "=" * 60)
    print("✨ OPUS MARATHON CONVERSION COMPLETE!")
    print("All files saved to ContentRefinery/Approved/")


if __name__ == "__main__":
    main()
