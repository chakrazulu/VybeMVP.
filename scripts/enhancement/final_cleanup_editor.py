#!/usr/bin/env python3
"""
FINAL CLEANUP EDITOR v1.0

PURPOSE: Pre-deployment cleanup of enhanced insights
FOCUS: Grammar fixes, punctuation cleanup, consistency checks
GOAL: Production-ready insights with perfect formatting and consistency

This script edits existing files in-place with surgical precision.
"""

import json
import logging
import re
from pathlib import Path
from typing import Any, Dict

# Setup logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)


class FinalCleanupEditor:
    def __init__(self):
        """Initialize the final cleanup system."""

        self.project_root = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP")

        # TARGET DIRECTORIES
        self.target_directories = [
            self.project_root / "NumerologyData" / "FirebaseNumberMeanings",
        ]

        # CLEANUP PATTERNS
        self.cleanup_patterns = [
            # Fix double periods
            (r"\.\.+", "."),
            # Fix capitalization after periods
            (r"\.\s+([a-z])", lambda m: ". " + m.group(1).upper()),
            # Fix "i am" to "I am"
            (r"\bi\s+am\b", "I am"),
            # Fix "i have" to "I have"
            (r"\bi\s+have\b", "I have"),
            # Fix "i will" to "I will"
            (r"\bi\s+will\b", "I will"),
            # Fix "i can" to "I can"
            (r"\bi\s+can\b", "I can"),
            # Fix "i practice" to "I practice"
            (r"\bi\s+practice\b", "I practice"),
            # Remove extra spaces
            (r"\s+", " "),
            # Fix sentence spacing
            (r"\s+\.", "."),
        ]

        # SECOND PERSON TO FIRST PERSON CONVERSIONS
        self.person_conversions = [
            (r"\bwhat does (.+?) mean to you\?", r"what does \1 mean to me?"),
            (r"\bwhat would you (.+?)\?", r"what would I \1?"),
            (r"\bhow do you (.+?)\?", r"how do I \1?"),
            (r"\bwhen did you (.+?)\?", r"when did I \1?"),
            (r"\bwhere are you (.+?)\?", r"where am I \1?"),
            (r"\bwhy do you (.+?)\?", r"why do I \1?"),
            (r"\byou don\'t need", "I don't need"),
            (r"\byou were born", "I was born"),
            (r"\byou carry", "I carry"),
        ]

        # STATS
        self.stats = {
            "files_processed": 0,
            "insights_cleaned": 0,
            "grammar_fixes": 0,
            "punctuation_fixes": 0,
            "person_conversions": 0,
            "total_fixes": 0,
        }

    def clean_insight_text(self, text: str) -> str:
        """Apply comprehensive cleanup to insight text."""
        original_text = text
        cleaned = text.strip()

        # Apply grammar and punctuation fixes
        for pattern, replacement in self.cleanup_patterns:
            if isinstance(replacement, str):
                if re.search(pattern, cleaned):
                    cleaned = re.sub(pattern, replacement, cleaned)
                    self.stats["grammar_fixes"] += 1
            else:  # Lambda function for complex replacements
                if re.search(pattern, cleaned):
                    cleaned = re.sub(pattern, replacement, cleaned)
                    self.stats["grammar_fixes"] += 1

        # Apply person conversions
        for pattern, replacement in self.person_conversions:
            if re.search(pattern, cleaned, re.IGNORECASE):
                cleaned = re.sub(pattern, replacement, cleaned, flags=re.IGNORECASE)
                self.stats["person_conversions"] += 1

        # Ensure proper capitalization at start
        if cleaned and not cleaned[0].isupper():
            cleaned = cleaned[0].upper() + cleaned[1:]
            self.stats["grammar_fixes"] += 1

        # Ensure proper ending punctuation
        if cleaned and not cleaned.endswith((".", "!", "?")):
            cleaned += "."
            self.stats["punctuation_fixes"] += 1

        # Count total fixes
        if cleaned != original_text:
            self.stats["total_fixes"] += 1

        return cleaned

    def process_file(self, file_path: Path) -> bool:
        """Process a single JSON file with final cleanup."""
        try:
            logger.info(f"Cleaning: {file_path}")

            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            insights_processed = 0

            # Process insights in numbered structure
            if isinstance(data, dict):
                for key, value in data.items():
                    if isinstance(value, dict) and "insight" in value:
                        insight_list = value["insight"]
                        if isinstance(insight_list, list):
                            cleaned_insights = []
                            for insight in insight_list:
                                if isinstance(insight, str):
                                    cleaned = self.clean_insight_text(insight)
                                    cleaned_insights.append(cleaned)
                                    insights_processed += 1
                                    self.stats["insights_cleaned"] += 1
                                else:
                                    cleaned_insights.append(insight)
                            value["insight"] = cleaned_insights

            # Write cleaned data back
            with open(file_path, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2, ensure_ascii=False)

            logger.info(f"✅ Cleaned {insights_processed} insights in {file_path.name}")
            self.stats["files_processed"] += 1
            return True

        except Exception as e:
            logger.error(f"❌ Error cleaning {file_path}: {str(e)}")
            return False

    def run_final_cleanup(self) -> Dict[str, Any]:
        """Run the final cleanup across all target files."""

        logger.info("🧹 STARTING FINAL CLEANUP EDITOR")
        logger.info("Focus: Grammar, punctuation, consistency, first-person perspective")
        logger.info("=" * 70)

        for directory in self.target_directories:
            if not directory.exists():
                logger.warning(f"Directory not found: {directory}")
                continue

            logger.info(f"📁 Cleaning directory: {directory}")

            # Process all JSON files (skip archetypal and template files)
            for file_path in directory.glob("*.json"):
                if "archetypal" in file_path.name or "templates" in file_path.name:
                    continue

                self.process_file(file_path)

        return self.generate_report()

    def generate_report(self) -> Dict[str, Any]:
        """Generate cleanup completion report."""

        report = {
            "cleanup_type": "Final Pre-Deployment Cleanup",
            "focus_areas": ["Grammar", "Punctuation", "Consistency", "First-Person"],
            "statistics": self.stats,
            "success": self.stats["insights_cleaned"] > 0,
        }

        return report


def main():
    """Main execution function."""

    logger.info("🧹 Final Cleanup Editor")
    logger.info("Mission: Pre-deployment cleanup for production-ready insights")
    logger.info("Target: Perfect grammar, punctuation, and consistency")
    logger.info("")

    cleaner = FinalCleanupEditor()
    results = cleaner.run_final_cleanup()

    # Print results
    print("\n🧹 FINAL CLEANUP COMPLETION REPORT")
    print("=" * 45)
    print(f"📊 Files Processed: {results['statistics']['files_processed']}")
    print(f"📊 Insights Cleaned: {results['statistics']['insights_cleaned']}")
    print(f"🔧 Grammar Fixes: {results['statistics']['grammar_fixes']}")
    print(f"🔧 Punctuation Fixes: {results['statistics']['punctuation_fixes']}")
    print(f"🔧 Person Conversions: {results['statistics']['person_conversions']}")
    print(f"🔧 Total Fixes Applied: {results['statistics']['total_fixes']}")
    print("")
    print("✅ CLEANUP COMPLETE - Ready for master audit")


if __name__ == "__main__":
    main()
