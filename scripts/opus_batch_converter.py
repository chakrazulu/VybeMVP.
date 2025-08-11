#!/usr/bin/env python3
"""
OPUS Batch Converter - Complete MD to JSON conversion for KASPER MLX Training
Handles ALL content types: ChatGPT, Claude Deep Content, and Grok Multi-Persona
Creates JSON versions and optionally replaces MD files
"""

import json
import re
from pathlib import Path
from typing import Any, Dict, List


class OPUSBatchConverter:
    def __init__(self, replace_originals=False):
        self.base_path = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP")
        self.import_path = self.base_path / "NumerologyData/ImportedContent"
        self.output_path = self.base_path / "KASPERMLX/MLXTraining/ContentRefinery/Approved"
        self.replace_originals = replace_originals

    def extract_number_from_filename(self, filename: str) -> int:
        """Extract the number from various filename formats"""
        patterns = [r"CR(\d+)", r"Number_(\d+)", r"ChatGPT_Number_(\d+)"]

        for pattern in patterns:
            match = re.search(pattern, filename)
            if match:
                return int(match.group(1))
        return 0

    def clean_json_content(self, content: str) -> str:
        """Clean malformed JSON content"""
        # Fix common JSON issues in Grok content
        json_start = content.find("{")
        json_end = content.rfind("}") + 1

        if json_start != -1 and json_end > json_start:
            json_str = content[json_start:json_end]
            # Fix escaped brackets
            json_str = json_str.replace("\\[", "[").replace("\\]", "]")
            # Fix malformed quotes and other common issues
            json_str = re.sub(r'(?<!\\)"([^"]*)"(?=\s*:)', r'"\1"', json_str)
            return json_str
        return content

    def convert_grok_content(self, file_path: Path, persona: str) -> Dict[str, Any]:
        """Convert Grok content with better error handling"""
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()

            number = self.extract_number_from_filename(file_path.name)
            json_str = self.clean_json_content(content)

            try:
                data = json.loads(json_str)
            except json.JSONDecodeError as e:
                print(f"⚠️  JSON parse error in {file_path.name}: {e}")
                # Create fallback structure from markdown sections
                return self.create_fallback_grok_structure(content, number, persona)

            return {
                "source": f"grok_{persona.lower()}",
                "number": number,
                "persona": persona,
                "content_type": "mystical_insights",
                "generation_info": data.get("generation_info", {}),
                "spiritual_categories": {
                    "primary_insights": data.get("insight", []),
                    "reflection_questions": data.get("reflection", []),
                    "contemplation_themes": data.get("contemplation", []),
                    "affirmations": data.get("affirmation", []),
                    "challenges": data.get("challenge", []),
                    "integration_practices": data.get("integration", []),
                    "meditation_guidance": data.get("meditation", []),
                    "ritual_suggestions": data.get("ritual", []),
                    "mantras": data.get("mantra", []),
                    "visualizations": data.get("visualization", []),
                    "daily_practices": data.get("practice", []),
                    "shadow_work": data.get("shadow_work", []),
                },
                "intensity_scoring": {
                    "min_range": 0.7,
                    "max_range": 0.9,
                    "note": f"{persona} mystical perspective with high spiritual depth",
                },
            }

        except Exception as e:
            print(f"❌ Error processing {file_path}: {e}")
            return None

    def create_fallback_grok_structure(
        self, content: str, number: int, persona: str
    ) -> Dict[str, Any]:
        """Create fallback structure when JSON parsing fails"""
        # Extract content between quotes as insights
        insights = re.findall(r'"([^"]+)"', content)

        return {
            "source": f"grok_{persona.lower()}",
            "number": number,
            "persona": persona,
            "content_type": "mystical_insights",
            "fallback": True,
            "spiritual_categories": {
                "primary_insights": insights[:15] if len(insights) > 15 else insights,
                "reflection_questions": [],
                "contemplation_themes": [],
                "note": "Fallback conversion - original JSON was malformed",
            },
            "intensity_scoring": {
                "min_range": 0.7,
                "max_range": 0.9,
                "note": f"{persona} content recovered from malformed source",
            },
        }

    def convert_claude_content(self, file_path: Path) -> Dict[str, Any]:
        """Convert Claude deep academic content with enhanced parsing"""
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()

            number = self.extract_number_from_filename(file_path.name)

            # Enhanced section parsing
            sections = {}
            current_section = None
            current_content = []

            for line in content.split("\n"):
                if line.startswith("###"):
                    if current_section:
                        sections[current_section] = "\n".join(current_content).strip()
                    current_section = (
                        line.strip("#").strip().lower().replace(" ", "_").replace("-", "_")
                    )
                    current_content = []
                elif line.startswith("##") and not line.startswith("###"):
                    if current_section:
                        sections[current_section] = "\n".join(current_content).strip()
                    current_section = (
                        line.strip("#").strip().lower().replace(" ", "_").replace("-", "_")
                    )
                    current_content = []
                elif current_section and line.strip():
                    current_content.append(line)

            if current_section:
                sections[current_section] = "\n".join(current_content).strip()

            return {
                "source": "claude_deep_content",
                "number": number,
                "content_type": "academic_spiritual_analysis",
                "title": f"Deep Spiritual Analysis of Number {number}",
                "academic_sections": sections,
                "intensity_scoring": {
                    "min_range": 0.8,
                    "max_range": 0.95,
                    "note": "Academic depth with esoteric wisdom and philosophical insight",
                },
                "keywords": self.extract_keywords_from_sections(sections),
            }

        except Exception as e:
            print(f"❌ Error processing Claude file {file_path}: {e}")
            return None

    def extract_keywords_from_sections(self, sections: Dict[str, str]) -> List[str]:
        """Extract key spiritual and academic terms"""
        keywords = set()
        spiritual_terms = [
            "monad",
            "chakra",
            "divine",
            "sacred",
            "mystical",
            "spiritual",
            "consciousness",
            "enlightenment",
            "meditation",
            "energy",
            "vibration",
            "cosmic",
            "universal",
        ]

        for content in sections.values():
            words = content.lower().split()
            for term in spiritual_terms:
                if term in words:
                    keywords.add(term)

        return list(keywords)

    def convert_chatgpt_content(self, file_path: Path) -> Dict[str, Any]:
        """Convert original ChatGPT content (not v2)"""
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()

            number = self.extract_number_from_filename(file_path.name)

            # Parse sections from markdown
            sections = {}
            current_section = None
            current_content = []

            for line in content.split("\n"):
                if line.startswith("##") and not line.startswith("###"):
                    if current_section:
                        sections[current_section] = current_content
                    current_section = line.strip("#").strip().lower().replace(" ", "_")
                    current_content = []
                elif current_section and line.strip():
                    current_content.append(line.strip())

            if current_section:
                sections[current_section] = current_content

            return {
                "source": "chatgpt_original",
                "number": number,
                "content_type": "practical_guidance",
                "title": f"ChatGPT Insights for Number {number}",
                "guidance_sections": sections,
                "intensity_scoring": {
                    "min_range": 0.6,
                    "max_range": 0.85,
                    "note": "Practical life guidance with spiritual wisdom",
                },
            }

        except Exception as e:
            print(f"❌ Error processing ChatGPT file {file_path}: {e}")
            return None

    def batch_convert_all(self):
        """Convert ALL remaining MD files"""
        conversion_stats = {"chatgpt": 0, "claude": 0, "grok": 0, "errors": 0}

        print("🚀 OPUS BATCH CONVERTER - Converting ALL remaining MD files...")
        print("=" * 60)

        # Convert ChatGPT files
        chatgpt_path = self.import_path / "ChatGPTContent"
        if chatgpt_path.exists():
            print("\n📝 Converting ChatGPT Original Content...")
            for file_path in sorted(chatgpt_path.glob("*.md")):
                result = self.convert_chatgpt_content(file_path)
                if result:
                    output_file = (
                        self.output_path / f"chatgpt_original_{result['number']:02d}_converted.json"
                    )
                    self.save_and_optionally_replace(result, output_file, file_path)
                    conversion_stats["chatgpt"] += 1
                    print(f"✅ {file_path.name} → {output_file.name}")
                else:
                    conversion_stats["errors"] += 1

        # Convert Claude files
        claude_path = self.import_path / "ClaudeDeepContent"
        if claude_path.exists():
            print("\n📚 Converting Claude Deep Content...")
            for file_path in sorted(claude_path.glob("*.md")):
                result = self.convert_claude_content(file_path)
                if result:
                    output_file = (
                        self.output_path / f"claude_{result['number']:02d}_academic_converted.json"
                    )
                    self.save_and_optionally_replace(result, output_file, file_path)
                    conversion_stats["claude"] += 1
                    print(f"✅ {file_path.name} → {output_file.name}")
                else:
                    conversion_stats["errors"] += 1

        # Convert all Grok personas
        personas = [
            "Oracle",
            "Psychologist",
            "MindfulnessCoach",
            "Philosopher",
            "NumerologyScholar",
        ]
        for persona in personas:
            persona_path = self.import_path / "GrokStructuredContent" / persona
            if persona_path.exists():
                print(f"\n🔮 Converting Grok {persona} Content...")
                for file_path in sorted(persona_path.glob("*.md")):
                    result = self.convert_grok_content(file_path, persona)
                    if result:
                        output_file = (
                            self.output_path
                            / f"grok_{persona.lower()}_{result['number']:02d}_converted.json"
                        )
                        self.save_and_optionally_replace(result, output_file, file_path)
                        conversion_stats["grok"] += 1
                        print(f"✅ {file_path.name} → {output_file.name}")
                    else:
                        conversion_stats["errors"] += 1

        print("\n" + "=" * 60)
        print("✨ CONVERSION COMPLETE!")
        print(f"📊 ChatGPT: {conversion_stats['chatgpt']} files")
        print(f"📚 Claude: {conversion_stats['claude']} files")
        print(f"🔮 Grok: {conversion_stats['grok']} files")
        print(f"❌ Errors: {conversion_stats['errors']} files")
        print(
            f"📈 Total: {sum(conversion_stats.values()) - conversion_stats['errors']} JSON files created!"
        )

        return conversion_stats

    def save_and_optionally_replace(
        self, data: Dict[str, Any], output_file: Path, original_file: Path
    ):
        """Save JSON and optionally replace original MD file"""
        # Save JSON version
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

        # Optionally replace original MD with JSON
        if self.replace_originals:
            json_replacement = original_file.with_suffix(".json")
            with open(json_replacement, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            # Remove original MD file
            original_file.unlink()
            print(f"🔄 Replaced {original_file.name} with {json_replacement.name}")


def main():
    # Ask user if they want to replace original files
    replace_originals = False  # Set to True if you want to replace MD files with JSON

    converter = OPUSBatchConverter(replace_originals=replace_originals)
    _stats = converter.batch_convert_all()  # Keep stats for potential future use

    print("\nAll converted files saved to:")
    print(f"📁 {converter.output_path}")

    if replace_originals:
        print("🔄 Original MD files have been replaced with JSON versions")
    else:
        print("📝 Original MD files preserved - JSON files created separately")


if __name__ == "__main__":
    main()
