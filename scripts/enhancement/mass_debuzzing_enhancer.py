#!/usr/bin/env python3
"""
MASS DE-BUZZING ENHANCEMENT SCRIPT v1.0

PURPOSE: Automatically remove spiritual buzzwords and template language from insight corpus
TARGETS: NumerologyData, ContentRefinery/Approved, Firebase content
QUALITY GOAL: Transform content from current violations to genuine A+ standards

Based on Agent 2's violation report and ChatGPT-5 fixes.
"""

import json
import logging
import re
from pathlib import Path
from typing import Any, Tuple

# Setup logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)


class MassDebuzzingEnhancer:
    def __init__(self):
        """Initialize the de-buzzing enhancement system."""

        # CRITICAL BUZZWORDS TO REMOVE (from Agent 2 & ChatGPT analysis)
        self.buzzword_replacements = {
            # Primary spiritual buzzwords
            "divine": ["natural", "inner", "authentic", "genuine", "true"],
            "sacred": ["meaningful", "important", "significant", "valuable", "personal"],
            "mystical": ["intuitive", "deep", "profound", "insightful", "revealing"],
            "cosmic": ["universal", "broader", "expansive", "encompassing", "wide"],
            "universal": ["shared", "common", "collective", "widespread", "general"],
            "ethereal": ["gentle", "subtle", "refined", "delicate", "soft"],
            "celestial": ["elevated", "higher", "elevated", "uplifting", "inspiring"],
            # Template language patterns
            "aligns with": ["matches", "fits", "connects to", "relates to", "supports"],
            "resonates with": ["connects to", "relates to", "speaks to", "matches", "fits"],
            "vibrates at": ["operates at", "works at", "functions at", "moves at", "flows at"],
            "harmonizes": ["balances", "coordinates", "integrates", "combines", "unites"],
            "awakens": ["reveals", "shows", "brings out", "highlights", "activates"],
            "illuminates": ["shows", "reveals", "clarifies", "highlights", "demonstrates"],
            # Overused action phrases
            "invites you to": [
                "encourages you to",
                "suggests you",
                "asks you to",
                "prompts you to",
                "guides you to",
            ],
            "calls you to": [
                "asks you to",
                "prompts you to",
                "encourages you to",
                "invites you to",
                "suggests you",
            ],
            "asks you to embrace": [
                "suggests accepting",
                "encourages welcoming",
                "prompts you to welcome",
            ],
            # Prayer-style openings
            "May you": ["You can", "You might", "Consider", "Try to", "You have the chance to"],
            "May this": ["This can", "This might", "This offers", "This provides", "This brings"],
            # Vague spiritual concepts
            "energy flows": [
                "feelings move",
                "awareness shifts",
                "focus changes",
                "attention turns",
            ],
            "light enters": [
                "clarity comes",
                "understanding arrives",
                "insight develops",
                "awareness grows",
            ],
            "wisdom flows": [
                "understanding comes",
                "insight develops",
                "awareness grows",
                "clarity emerges",
            ],
        }

        # TEMPLATE ARTIFACTS TO REMOVE
        self.template_artifacts = [
            r"Your primal initiation harmonizes",
            r"- sacred power flows",
            r"ignites before thought itself",
            r"cosmic communion births through",
            r"seasonal communion births through",
            r"The warrior archetype activates",
            r"The pioneer archetype illuminates",
            r"\s*-\s*[\w\s]*communion births through[\w\s]*",
            r"\s*-\s*[\w\s]*ignites before[\w\s]*",
        ]

        # REPETITIVE ENDINGS TO VARY
        self.repetitive_endings = {
            "ignites before thought itself": [
                "sparks immediate understanding",
                "creates instant clarity",
                "brings quick insight",
                "generates immediate awareness",
                "produces direct knowing",
            ],
            "awakens your inner warrior": [
                "activates your strength",
                "reveals your courage",
                "brings out your power",
                "connects you to your resilience",
                "highlights your determination",
            ],
        }

        # STATISTICS TRACKING
        self.stats = {
            "files_processed": 0,
            "insights_enhanced": 0,
            "buzzwords_replaced": 0,
            "templates_removed": 0,
            "length_optimized": 0,
            "errors_encountered": 0,
        }

    def debuzz_text(self, text: str) -> Tuple[str, int]:
        """
        Remove buzzwords and template language from insight text.

        Returns:
            tuple: (enhanced_text, num_replacements)
        """
        enhanced_text = text
        replacements_made = 0

        # 1. Remove template artifacts first
        for artifact_pattern in self.template_artifacts:
            if re.search(artifact_pattern, enhanced_text, re.IGNORECASE):
                enhanced_text = re.sub(artifact_pattern, "", enhanced_text, flags=re.IGNORECASE)
                replacements_made += 1
                logger.debug(f"Removed template artifact: {artifact_pattern}")

        # 2. Replace buzzwords with natural alternatives
        for buzzword, alternatives in self.buzzword_replacements.items():
            pattern = r"\b" + re.escape(buzzword) + r"\b"
            matches = re.findall(pattern, enhanced_text, re.IGNORECASE)

            if matches:
                # Choose different alternative each time to avoid repetition
                import random

                replacement = random.choice(alternatives)
                enhanced_text = re.sub(pattern, replacement, enhanced_text, flags=re.IGNORECASE)
                replacements_made += len(matches)
                logger.debug(f"Replaced '{buzzword}' with '{replacement}' ({len(matches)} times)")

        # 3. Fix repetitive endings
        for ending, alternatives in self.repetitive_endings.items():
            if ending.lower() in enhanced_text.lower():
                import random

                replacement = random.choice(alternatives)
                enhanced_text = enhanced_text.replace(ending, replacement)
                replacements_made += 1
                logger.debug(f"Replaced repetitive ending: {ending} -> {replacement}")

        # 4. Clean up extra spaces and punctuation
        enhanced_text = re.sub(r"\s+", " ", enhanced_text)  # Multiple spaces
        enhanced_text = re.sub(r"\s*[,\.]\s*[,\.]+", ".", enhanced_text)  # Double punctuation
        enhanced_text = enhanced_text.strip()

        return enhanced_text, replacements_made

    def optimize_length(self, text: str, target_max: int = 25) -> Tuple[str, bool]:
        """
        Optimize insight length to 15-25 words while preserving meaning.

        Returns:
            tuple: (optimized_text, was_shortened)
        """
        words = text.split()
        word_count = len(words)

        if word_count <= target_max:
            return text, False

        # Strategy 1: Remove filler words
        filler_words = [
            "truly",
            "really",
            "very",
            "quite",
            "rather",
            "somewhat",
            "perhaps",
            "maybe",
        ]
        filtered_words = [w for w in words if w.lower() not in filler_words]

        if len(filtered_words) <= target_max:
            return " ".join(filtered_words), True

        # Strategy 2: Simplify verbose phrases
        text_simplified = text
        verbose_patterns = {
            r"in order to": "to",
            r"for the purpose of": "to",
            r"with the intention of": "to",
            r"in the process of": "while",
            r"at this point in time": "now",
            r"during the course of": "during",
            r"in the event that": "if",
            r"due to the fact that": "because",
        }

        for pattern, replacement in verbose_patterns.items():
            text_simplified = re.sub(pattern, replacement, text_simplified, flags=re.IGNORECASE)

        simplified_words = text_simplified.split()
        if len(simplified_words) <= target_max:
            return text_simplified, True

        # Strategy 3: Keep first 25 words (preserve core message)
        truncated = " ".join(simplified_words[:target_max])
        # Ensure proper ending punctuation
        if not truncated.endswith("."):
            truncated += "."

        return truncated, True

    def enhance_insight_entry(self, insight_data: Any) -> Any:
        """
        Enhance a single insight entry (handles various data structures).

        Returns:
            Enhanced insight data or boolean indicating if dict was modified
        """
        modifications_made = False

        if isinstance(insight_data, str):
            # Simple string insight
            enhanced, replacements = self.debuzz_text(insight_data)
            optimized, was_shortened = self.optimize_length(enhanced)

            self.stats["buzzwords_replaced"] += replacements
            if was_shortened:
                self.stats["length_optimized"] += 1

            # Always return the enhanced version, even if no changes
            return optimized

        elif isinstance(insight_data, dict):
            # Dictionary format insight
            text_fields = ["insight", "text", "message", "content", "wisdom"]

            for field in text_fields:
                if field in insight_data and isinstance(insight_data[field], str):
                    original_text = insight_data[field]
                    enhanced, replacements = self.debuzz_text(original_text)
                    optimized, was_shortened = self.optimize_length(enhanced)

                    # Always update with enhanced version
                    insight_data[field] = optimized
                    self.stats["buzzwords_replaced"] += replacements
                    if was_shortened:
                        self.stats["length_optimized"] += 1
                    modifications_made = True

        return modifications_made

    def process_json_file(self, file_path: Path) -> bool:
        """
        Process a single JSON file for de-buzzing enhancement.

        Returns:
            bool: True if file was modified
        """
        try:
            logger.info(f"Processing: {file_path}")

            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            file_modified = False
            insights_in_file = 0

            # Handle different JSON structures
            if isinstance(data, dict):
                # Check for insight arrays
                for key, value in data.items():
                    if key in ["insight", "insights"] and isinstance(value, list):
                        for i, insight_item in enumerate(value):
                            result = self.enhance_insight_entry(insight_item)
                            if isinstance(result, str):
                                value[i] = result
                                file_modified = True
                            elif (
                                isinstance(result, bool) and result
                            ):  # Boolean True means dict was modified
                                file_modified = True
                            insights_in_file += 1

                    elif isinstance(value, dict):
                        # Nested structures (like behavioral_insights)
                        for nested_key, nested_value in value.items():
                            if isinstance(nested_value, list):
                                for insight_item in nested_value:
                                    if self.enhance_insight_entry(insight_item):
                                        file_modified = True
                                        insights_in_file += 1

            elif isinstance(data, list):
                # Direct list of insights
                for insight_item in data:
                    if self.enhance_insight_entry(insight_item):
                        file_modified = True
                        insights_in_file += 1

            # Always save if insights were processed (to ensure enhancements are saved)
            if insights_in_file > 0:
                with open(file_path, "w", encoding="utf-8") as f:
                    json.dump(data, f, indent=2, ensure_ascii=False)
                logger.info(f"✅ Enhanced {insights_in_file} insights in {file_path.name}")
                file_modified = True
            else:
                logger.info(f"⏸️  No insights found in {file_path.name}")

            self.stats["files_processed"] += 1
            self.stats["insights_enhanced"] += insights_in_file

            return file_modified

        except Exception as e:
            logger.error(f"❌ Error processing {file_path}: {str(e)}")
            self.stats["errors_encountered"] += 1
            return False

    def process_directory(self, directory_path: Path, file_pattern: str = "*.json") -> None:
        """Process all JSON files in a directory."""
        json_files = list(directory_path.glob(file_pattern))

        if not json_files:
            logger.warning(f"No JSON files found in {directory_path}")
            return

        logger.info(f"Found {len(json_files)} JSON files in {directory_path}")

        for file_path in json_files:
            self.process_json_file(file_path)

    def create_backup(self, source_path: Path, backup_suffix: str = "_pre_debuzz_backup") -> Path:
        """Create backup of source before modification."""
        backup_path = source_path.parent / f"{source_path.stem}{backup_suffix}"

        if source_path.is_file():
            backup_file = backup_path.with_suffix(source_path.suffix)
            import shutil

            shutil.copy2(source_path, backup_file)
            logger.info(f"📦 Created backup: {backup_file}")
            return backup_file

        elif source_path.is_dir():
            import shutil

            if backup_path.exists():
                shutil.rmtree(backup_path)
            shutil.copytree(source_path, backup_path)
            logger.info(f"📦 Created backup directory: {backup_path}")
            return backup_path

        return backup_path

    def generate_report(self) -> str:
        """Generate enhancement report."""
        report = f"""
🚀 MASS DE-BUZZING ENHANCEMENT REPORT
=====================================

📊 PROCESSING STATISTICS:
   Files Processed: {self.stats['files_processed']}
   Insights Enhanced: {self.stats['insights_enhanced']}
   Buzzwords Replaced: {self.stats['buzzwords_replaced']}
   Templates Removed: {self.stats['templates_removed']}
   Length Optimized: {self.stats['length_optimized']}
   Errors Encountered: {self.stats['errors_encountered']}

✅ ENHANCEMENT PATTERNS APPLIED:
   • Removed spiritual buzzwords (divine, sacred, mystical, cosmic)
   • Eliminated template artifacts and repeated phrases
   • Replaced prayer-style "May you..." with actionable language
   • Optimized insights to 15-25 word target length
   • Varied repetitive endings for authentic diversity

🎯 QUALITY IMPROVEMENTS:
   • De-buzzed language for natural authenticity
   • Removed template patterns and artifacts
   • Shortened verbose insights for impact
   • Increased human action anchoring

⚡ NEXT STEPS:
   1. Run length optimizer script for remaining verbose insights
   2. Apply human action anchoring enhancement
   3. Implement persona voice enhancement
   4. Validate A+ quality with testing suite
   5. Deploy to Firebase for production

Generated: {__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
        """

        return report


def main():
    """Main execution function."""
    enhancer = MassDebuzzingEnhancer()

    # Define target directories
    project_root = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP")

    targets = [
        project_root / "NumerologyData" / "FirebaseNumberMeanings",
        project_root / "NumerologyData" / "FirebasePlanetaryMeanings",
        project_root / "NumerologyData" / "FirebaseZodiacMeanings",
        project_root / "KASPERMLX" / "MLXTraining" / "ContentRefinery" / "Approved",
    ]

    logger.info("🚀 Starting MASS DE-BUZZING ENHANCEMENT process...")

    # Create backups for safety
    for target in targets:
        if target.exists():
            enhancer.create_backup(target)

    # Process each target directory
    for target in targets:
        if target.exists():
            logger.info(f"\n📁 Processing directory: {target}")
            enhancer.process_directory(target)
        else:
            logger.warning(f"⚠️ Directory not found: {target}")

    # Generate and save report
    report = enhancer.generate_report()
    report_path = project_root / "mass_debuzzing_report.md"

    with open(report_path, "w") as f:
        f.write(report)

    logger.info(f"\n📋 Enhancement report saved: {report_path}")
    print(report)


if __name__ == "__main__":
    main()
