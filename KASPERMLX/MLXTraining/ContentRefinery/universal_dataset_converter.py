#!/usr/bin/env python3
"""
KASPER MLX Universal Dataset Converter v2.0
Handles ALL JSON structures in ContentRefinery/Approved folder

Supported Input Formats:
1. Grok files: spiritual_categories → behavioral_insights ✅
2. Expression files: profiles[].behavioral.{category}[] → behavioral_insights
3. SoulUrge files: profiles[].behavioral.{category}[] → behavioral_insights
4. ChatGPT files: (structure TBD based on inspection)
5. LifePath files: existing behavioral_insights format (passthrough)

Claude: This is the definitive solution to achieve 95%+ conversion success rate!
"""

import json
import sys
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Tuple


class UniversalKASPERConverter:
    def __init__(self, approved_folder: str):
        self.approved_folder = Path(approved_folder)
        self.stats = {
            "total_processed": 0,
            "successful_conversions": 0,
            "already_converted": 0,
            "conversion_failures": 0,
            "structure_types": {},
        }

        # Standard behavioral categories for KASPER MLX
        self.behavioral_categories = [
            "spiritual_guidance",
            "inner_wisdom",
            "life_purpose",
            "relationships",
            "career_path",
            "personal_growth",
            "challenges",
            "gifts",
            "manifestation",
            "healing",
            "creativity",
            "service",
            "contemplation",
        ]

    def detect_file_structure(self, data: Dict[str, Any], filename: str) -> str:
        """
        Detect the JSON structure type to apply appropriate conversion

        Returns:
        - 'behavioral_insights' - Already in correct format
        - 'spiritual_categories' - Grok format (should be converted already)
        - 'profiles_behavioral' - Expression/SoulUrge complex format
        - 'chatgpt_original' - ChatGPT format (structure TBD)
        - 'unknown' - Unable to detect structure
        """

        # Already in correct format
        if "behavioral_insights" in data and isinstance(data["behavioral_insights"], list):
            return "behavioral_insights"

        # Grok spiritual_categories format
        if "spiritual_categories" in data:
            return "spiritual_categories"

        # Expression/SoulUrge profiles format
        if "profiles" in data and isinstance(data["profiles"], list) and len(data["profiles"]) > 0:
            profile = data["profiles"][0]
            if "behavioral" in profile and isinstance(profile["behavioral"], dict):
                return "profiles_behavioral"

        # ChatGPT format
        if "guidance_sections" in data and isinstance(data["guidance_sections"], dict):
            return "chatgpt_original"

        # Claude format
        if "academic_sections" in data and isinstance(data["academic_sections"], dict):
            return "claude_academic"

        return "unknown"

    def convert_profiles_behavioral_to_insights(self, data: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Convert Expression/SoulUrge profiles[].behavioral structure to behavioral_insights

        Input structure: profiles[0].behavioral.{category}[{text, intensity, triggers, supports, challenges}]
        Output structure: behavioral_insights[{category, insight, intensity, triggers, supports, challenges}]
        """
        insights = []

        if "profiles" not in data or not data["profiles"]:
            return insights

        profile = data["profiles"][0]  # Take first profile
        behavioral = profile.get("behavioral", {})

        for category, items in behavioral.items():
            if not isinstance(items, list):
                continue

            # Map category names to KASPER standard categories
            kasper_category = self.map_to_kasper_category(category)

            for item in items:
                if isinstance(item, dict) and "text" in item:
                    insight = {
                        "category": kasper_category,
                        "insight": item["text"],
                        "intensity": item.get("intensity", 0.75),
                        "triggers": item.get("triggers", []),
                        "supports": item.get("supports", []),
                        "challenges": item.get("challenges", []),
                    }
                    insights.append(insight)

        return insights

    def map_to_kasper_category(self, original_category: str) -> str:
        """Map Expression/SoulUrge categories to KASPER standard categories"""

        category_mapping = {
            # Direct mappings
            "spiritual": "spiritual_guidance",
            "relationships": "relationships",
            "challenges": "challenges",
            "creative": "creativity",
            "wellness": "healing",
            "learning": "inner_wisdom",
            "productivity": "career_path",
            "financial": "manifestation",
            "shadow": "challenges",
            "transitions": "personal_growth",
            "communication": "inner_wisdom",
            # Compound mappings
            "decisionMaking": "life_purpose",
            "stressResponse": "challenges",
        }

        # Try direct mapping first
        if original_category in category_mapping:
            return category_mapping[original_category]

        # Default to personal_growth for unmapped categories
        return "personal_growth"

    def convert_chatgpt_to_insights(self, data: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Convert ChatGPT guidance_sections format to behavioral_insights

        Input structure: guidance_sections.{section}[text_items]
        Output structure: behavioral_insights[{category, insight, intensity, triggers, supports, challenges}]
        """
        insights = []
        guidance_sections = data.get("guidance_sections", {})

        # Map ChatGPT sections to KASPER categories
        section_mappings = {
            "core_essence": "spiritual_guidance",
            "daily_practical_guidance": "personal_growth",
            "relationship_wisdom": "relationships",
            "career_&_purpose_alignment": "career_path",
            "personal_growth_challenges": "challenges",
            "spiritual_gifts_&_talents": "gifts",
            "healing_&_wellness": "healing",
            "creative_expression": "creativity",
            "meditation_&_mindfulness": "inner_wisdom",
            "shadow_work_&_integration": "challenges",
            "manifestation_power": "manifestation",
            "life_transitions_&_timing": "personal_growth",
        }

        for section_name, items in guidance_sections.items():
            if not isinstance(items, list):
                continue

            kasper_category = section_mappings.get(section_name, "personal_growth")

            for i, item in enumerate(items):
                if isinstance(item, str) and len(item.strip()) > 20:
                    # Generate progressive intensity scores
                    intensity = min(0.9, 0.65 + (i * 0.02))

                    insight = {
                        "category": kasper_category,
                        "insight": item.strip(),
                        "intensity": intensity,
                        "triggers": ["chatgpt_guidance"],
                        "supports": ["daily_practice", "mindful_application"],
                        "challenges": ["consistency", "integration"],
                    }
                    insights.append(insight)

        return insights

    def convert_claude_to_insights(self, data: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Convert Claude academic_sections format to behavioral_insights

        Input structure: academic_sections.{numbered_key}[academic_content]
        Output structure: behavioral_insights[{category, insight, intensity, triggers, supports, challenges}]
        """
        insights = []
        academic_sections = data.get("academic_sections", {})

        # Extract insights from each academic section
        for section_key, content in academic_sections.items():
            if isinstance(content, str):
                # Parse the content to extract meaningful insights
                insights.extend(self.extract_insights_from_academic_text(content, section_key))

        return insights

    def extract_insights_from_academic_text(
        self, text: str, section_key: str
    ) -> List[Dict[str, Any]]:
        """
        Extract insights from Claude's academic text content
        """
        insights = []

        # Split text into meaningful segments (sentences or paragraphs)
        segments = []

        # Handle JSON content within text
        if text.startswith("{") and text.endswith("}"):
            try:
                json_data = json.loads(text)
                if isinstance(json_data, dict):
                    segments.extend(self.extract_from_json_content(json_data))
                else:
                    segments = [text]
            except json.JSONDecodeError:
                # If JSON parsing fails, treat as regular text
                import re

                sentences = re.split(r"[.!?]+", text)
                segments = [s.strip() for s in sentences if len(s.strip()) > 30]
        else:
            # Split regular text by sentences or key phrases
            import re

            sentences = re.split(r"[.!?]+", text)
            segments = [s.strip() for s in sentences if len(s.strip()) > 30]

        # Convert segments to insights
        for i, segment in enumerate(segments[:12]):  # Limit to 12 insights per section
            if len(segment.strip()) > 20:
                # Determine category based on content keywords
                category = self.categorize_academic_content(segment, section_key)
                intensity = min(0.85, 0.70 + (i * 0.01))

                insight = {
                    "category": category,
                    "insight": segment.strip(),
                    "intensity": intensity,
                    "triggers": ["claude_analysis", "deep_study"],
                    "supports": ["contemplation", "spiritual_study"],
                    "challenges": ["complexity", "integration"],
                }
                insights.append(insight)

        return insights

    def extract_from_json_content(self, json_data: Dict[str, Any]) -> List[str]:
        """
        Extract meaningful text segments from JSON content
        """
        segments = []

        # Extract core content fields
        for key, value in json_data.items():
            if isinstance(value, str) and len(value.strip()) > 30:
                segments.append(value.strip())
            elif isinstance(value, list):
                for item in value:
                    if isinstance(item, str) and len(item.strip()) > 30:
                        segments.append(item.strip())
            elif isinstance(value, dict):
                segments.extend(self.extract_from_nested_dict(value))

        return segments

    def extract_from_nested_dict(self, nested_dict: Dict[str, Any]) -> List[str]:
        """
        Recursively extract strings from nested dictionaries
        """
        segments = []

        for key, value in nested_dict.items():
            if isinstance(value, str) and len(value.strip()) > 30:
                segments.append(value.strip())
            elif isinstance(value, list):
                for item in value:
                    if isinstance(item, str) and len(item.strip()) > 30:
                        segments.append(item.strip())

        return segments

    def categorize_academic_content(self, content: str, section_key: str) -> str:
        """
        Categorize academic content based on keywords and context
        """
        content_lower = content.lower()

        # Keyword-based categorization
        if any(
            word in content_lower for word in ["relationship", "love", "partnership", "connection"]
        ):
            return "relationships"
        elif any(word in content_lower for word in ["career", "work", "professional", "job"]):
            return "career_path"
        elif any(
            word in content_lower for word in ["challenge", "shadow", "difficult", "struggle"]
        ):
            return "challenges"
        elif any(word in content_lower for word in ["gift", "talent", "strength", "ability"]):
            return "gifts"
        elif any(word in content_lower for word in ["spiritual", "divine", "sacred", "meditation"]):
            return "spiritual_guidance"
        elif any(word in content_lower for word in ["healing", "health", "wellness", "therapy"]):
            return "healing"
        elif any(word in content_lower for word in ["creative", "art", "expression", "innovation"]):
            return "creativity"
        elif any(word in content_lower for word in ["manifest", "create", "achieve", "accomplish"]):
            return "manifestation"
        elif any(
            word in content_lower for word in ["wisdom", "knowledge", "understanding", "insight"]
        ):
            return "inner_wisdom"
        elif any(word in content_lower for word in ["purpose", "meaning", "destiny", "calling"]):
            return "life_purpose"
        else:
            return "personal_growth"

    def generate_conversion_metadata(
        self, original_data: Dict[str, Any], insights_count: int, conversion_type: str
    ) -> Dict[str, Any]:
        """Generate metadata about the conversion process"""

        return {
            "conversion_date": datetime.utcnow().isoformat(),
            "conversion_type": conversion_type,
            "original_structure": conversion_type,
            "converted_insights_count": insights_count,
            "conversion_tool": "UniversalKASPERConverter_v2.0",
        }

    def convert_single_file(self, file_path: Path) -> Tuple[bool, str]:
        """
        Convert a single JSON file to KASPER behavioral_insights format

        Returns:
        - (True, "success_message") if conversion successful
        - (False, "error_message") if conversion failed
        """

        try:
            # Read original file
            with open(file_path, "r", encoding="utf-8") as f:
                original_data = json.load(f)

            # Detect structure type
            structure_type = self.detect_file_structure(original_data, file_path.name)

            # Track structure types
            self.stats["structure_types"][structure_type] = (
                self.stats["structure_types"].get(structure_type, 0) + 1
            )

            # Skip if already in correct format
            if structure_type == "behavioral_insights":
                return True, "Already in behavioral_insights format"

            # Convert based on detected structure
            insights = []

            if structure_type == "spiritual_categories":
                # This should already be handled by previous script
                return False, "Spiritual_categories should already be converted"

            elif structure_type == "profiles_behavioral":
                insights = self.convert_profiles_behavioral_to_insights(original_data)
                conversion_type = "profiles_behavioral_to_behavioral_insights"

            elif structure_type == "chatgpt_original":
                insights = self.convert_chatgpt_to_insights(original_data)
                conversion_type = "chatgpt_original_to_behavioral_insights"

            elif structure_type == "claude_academic":
                insights = self.convert_claude_to_insights(original_data)
                conversion_type = "claude_academic_to_behavioral_insights"

            else:
                return False, f"Unknown structure type: {structure_type}"

            if not insights:
                return False, f"No insights generated for {structure_type}"

            # Extract core metadata from original
            number = original_data.get("number", original_data.get("meta", {}).get("number", 1))

            # Determine source and persona from filename
            filename = file_path.stem
            if "expression" in filename:
                source_type = "expression"
                persona = "ExpressionMaster"
            elif "soulUrge" in filename:
                source_type = "soulUrge"
                persona = "SoulUrgeGuide"
            elif "chatgpt" in filename:
                source_type = "chatgpt"
                persona = "ChatGPTAnalyst"
            elif "claude" in filename:
                source_type = "claude"
                persona = "ClaudeAcademic"
            else:
                source_type = "unknown"
                persona = "UniversalGuide"

            # Create new KASPER-compatible structure
            converted_data = {
                "number": number,
                "title": f"The {persona}",
                "source": source_type,
                "persona": persona,
                "behavioral_category": "spiritual_insights",
                "intensity_scoring": {
                    "min_range": 0.60,
                    "max_range": 0.90,
                    "note": f"{persona} insights with universal intensity range",
                },
                "behavioral_insights": insights,
                "generation_info": self.generate_conversion_metadata(
                    original_data, len(insights), conversion_type
                ),
            }

            # Write converted file back
            with open(file_path, "w", encoding="utf-8") as f:
                json.dump(converted_data, f, indent=2, ensure_ascii=False)

            return True, f"Converted {len(insights)} insights from {structure_type}"

        except Exception as e:
            return False, f"Conversion error: {str(e)}"

    def validate_behavioral_insights(self, file_path: Path) -> Tuple[bool, str]:
        """
        Validate that a file has correct behavioral_insights structure

        Returns:
        - (True, "validation_message") if valid
        - (False, "error_message") if invalid
        """

        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            # Check required fields
            required_fields = ["number", "behavioral_insights"]
            for field in required_fields:
                if field not in data:
                    return False, f"Missing required field: {field}"

            # Validate behavioral_insights structure
            insights = data["behavioral_insights"]
            if not isinstance(insights, list):
                return False, "behavioral_insights must be a list"

            if len(insights) < 5:
                return False, f"Too few insights: {len(insights)}, expected at least 5"

            # Validate individual insights
            for i, insight in enumerate(insights):
                if not isinstance(insight, dict):
                    return False, f"Insight {i} is not an object"

                if "category" not in insight:
                    return False, f"Insight {i} missing category"

                if "insight" not in insight:
                    return False, f"Insight {i} missing insight text"

                if "intensity" not in insight:
                    return False, f"Insight {i} missing intensity"

                # Validate intensity range
                intensity = insight["intensity"]
                if not isinstance(intensity, (int, float)) or not (0.6 <= intensity <= 0.9):
                    return False, f"Insight {i} invalid intensity: {intensity}"

            return True, f"Valid: {len(insights)} insights"

        except Exception as e:
            return False, f"Validation error: {str(e)}"

    def run_universal_conversion(self) -> None:
        """
        Run universal conversion on all JSON files in Approved folder
        """

        print("🚀 KASPER MLX UNIVERSAL DATASET CONVERTER v2.0")
        print("=" * 60)
        print(f"📁 Processing folder: {self.approved_folder}")

        # Find all JSON files
        json_files = list(self.approved_folder.glob("*.json"))

        if not json_files:
            print("❌ No JSON files found in Approved folder")
            return

        print(f"📊 Found {len(json_files)} JSON files")
        print()

        # Process each file
        conversion_results = []
        validation_results = []

        for file_path in json_files:
            print(f"🔄 Processing: {file_path.name}")
            self.stats["total_processed"] += 1

            # Try conversion
            success, message = self.convert_single_file(file_path)

            if success:
                if "Already in" in message:
                    self.stats["already_converted"] += 1
                    print(f"  ✅ {message}")
                else:
                    self.stats["successful_conversions"] += 1
                    print(f"  🔄 {message}")
            else:
                self.stats["conversion_failures"] += 1
                print(f"  ❌ {message}")
                conversion_results.append((file_path.name, message))
                continue

            # Validate result
            valid, validation_msg = self.validate_behavioral_insights(file_path)
            if valid:
                print(f"  ✅ {validation_msg}")
            else:
                print(f"  ❌ Validation failed: {validation_msg}")
                validation_results.append((file_path.name, validation_msg))

        # Report results
        print()
        print("📊 CONVERSION RESULTS")
        print("=" * 30)
        print(f"Total files processed: {self.stats['total_processed']}")
        print(f"Already converted: {self.stats['already_converted']}")
        print(f"Successful conversions: {self.stats['successful_conversions']}")
        print(f"Conversion failures: {self.stats['conversion_failures']}")

        # Structure type breakdown
        print()
        print("📈 STRUCTURE BREAKDOWN")
        for structure, count in self.stats["structure_types"].items():
            print(f"  {structure}: {count} files")

        # Calculate success rate
        total_valid = self.stats["already_converted"] + self.stats["successful_conversions"]
        success_rate = (
            (total_valid / self.stats["total_processed"]) * 100
            if self.stats["total_processed"] > 0
            else 0
        )

        print()
        print(
            f"🎯 FINAL SUCCESS RATE: {success_rate:.1f}% ({total_valid}/{self.stats['total_processed']})"
        )

        if success_rate >= 95.0:
            print("🎉 SUCCESS! Achieved 95%+ conversion rate!")
        elif success_rate >= 90.0:
            print("⚡ GOOD! Close to target - minor fixes needed")
        else:
            print("🚨 NEEDS WORK! Still below 90% success rate")

        # Report failures
        if conversion_results:
            print()
            print("❌ CONVERSION FAILURES:")
            for filename, error in conversion_results:
                print(f"  • {filename}: {error}")

        if validation_results:
            print()
            print("❌ VALIDATION FAILURES:")
            for filename, error in validation_results:
                print(f"  • {filename}: {error}")


def main():
    """Main entry point"""

    # Get script directory and find Approved folder
    script_dir = Path(__file__).parent
    approved_folder = script_dir / "Approved"

    if not approved_folder.exists():
        print(f"❌ Approved folder not found: {approved_folder}")
        sys.exit(1)

    # Run conversion
    converter = UniversalKASPERConverter(approved_folder)
    converter.run_universal_conversion()


if __name__ == "__main__":
    main()
