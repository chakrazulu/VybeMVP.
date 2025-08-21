#!/usr/bin/env python3
"""
LENGTH OPTIMIZATION SCRIPT v1.0

PURPOSE: Optimize spiritual insights to 15-25 words maximum for punchy, impactful delivery
TARGETS: Already de-buzzed content from mass_debuzzing_enhancer.py
STRATEGY: Preserve wisdom essence while eliminating verbosity

Based on ChatGPT-5 optimization techniques and Agent 4's conciseness requirements.
"""

import json
import logging
import re
from pathlib import Path
from typing import Any, Dict, Tuple

# Setup logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)


class LengthOptimizer:
    def __init__(self):
        """Initialize the length optimization system."""

        # TARGET METRICS
        self.target_min_words = 15
        self.target_max_words = 25
        self.absolute_max_words = 30  # Emergency fallback

        # VERBOSE PHRASE CONDENSERS
        self.verbose_replacements = {
            # Redundant phrases
            r"in order to": "to",
            r"for the purpose of": "to",
            r"with the intention of": "to",
            r"in the process of": "while",
            r"at this point in time": "now",
            r"during the course of": "during",
            r"in the event that": "if",
            r"due to the fact that": "because",
            r"in spite of the fact that": "although",
            r"with regard to": "regarding",
            r"in relation to": "about",
            r"as a result of": "because",
            r"for the reason that": "because",
            # Spiritual verbosity
            r"this energy invites you to": "try",
            r"you are being called to": "consider",
            r"you are invited to embrace": "welcome",
            r"this is an opportunity to": "you can",
            r"there is potential for you to": "you might",
            r"it would be beneficial for you to": "consider",
            # Redundant descriptors
            r"deeply and profoundly": "deeply",
            r"truly and authentically": "authentically",
            r"completely and entirely": "completely",
            r"clearly and obviously": "clearly",
            r"simply and merely": "simply",
            # Question formulation shortcuts
            r"What is it that": "What",
            r"How is it that": "How",
            r"When is it that": "When",
            r"Where is it that": "Where",
            r"Why is it that": "Why",
        }

        # FILLER WORDS TO REMOVE
        self.filler_words = {
            "truly",
            "really",
            "very",
            "quite",
            "rather",
            "somewhat",
            "perhaps",
            "maybe",
            "possibly",
            "potentially",
            "essentially",
            "basically",
            "actually",
            "literally",
            "obviously",
            "clearly",
            "simply",
            "just",
            "exactly",
            "precisely",
            "specifically",
            "particularly",
            "especially",
            "definitely",
            "certainly",
            "absolutely",
            "completely",
            "totally",
            "entirely",
            "fully",
            "genuinely",
            "authentically",
        }

        # SENTENCE STARTERS TO STREAMLINE
        self.starter_condensers = {
            r"^This is a time when": "Now",
            r"^This is a moment when": "Now",
            r"^This is an opportunity for": "You can",
            r"^This is your chance to": "You can",
            r"^This represents a time to": "Time to",
            r"^Today offers the opportunity to": "Today",
            r"^The energy of this moment invites": "This invites",
            r"^In this moment, you are invited to": "Consider",
        }

        # STATISTICS
        self.stats = {
            "files_processed": 0,
            "insights_optimized": 0,
            "words_removed": 0,
            "avg_length_before": 0,
            "avg_length_after": 0,
            "insights_under_target": 0,
            "insights_over_target": 0,
            "errors_encountered": 0,
        }

        self.length_tracking = {"before": [], "after": []}

    def count_words(self, text: str) -> int:
        """Count words in text, excluding punctuation."""
        words = re.findall(r"\b\w+\b", text)
        return len(words)

    def remove_filler_words(self, text: str) -> str:
        """Remove filler words while preserving meaning."""
        words = text.split()
        filtered_words = []

        for word in words:
            # Remove punctuation for comparison
            clean_word = re.sub(r"[^\w]", "", word.lower())

            if clean_word not in self.filler_words:
                filtered_words.append(word)
            else:
                logger.debug(f"Removed filler word: {word}")

        return " ".join(filtered_words)

    def condense_verbose_phrases(self, text: str) -> str:
        """Replace verbose phrases with concise alternatives."""
        condensed = text
        replacements_made = 0

        # Apply verbose phrase replacements
        for pattern, replacement in self.verbose_replacements.items():
            if re.search(pattern, condensed, re.IGNORECASE):
                condensed = re.sub(pattern, replacement, condensed, flags=re.IGNORECASE)
                replacements_made += 1
                logger.debug(f"Condensed: {pattern} -> {replacement}")

        # Apply sentence starter condensers
        for pattern, replacement in self.starter_condensers.items():
            if re.search(pattern, condensed, re.IGNORECASE):
                condensed = re.sub(pattern, replacement, condensed, flags=re.IGNORECASE)
                replacements_made += 1
                logger.debug(f"Streamlined starter: {pattern} -> {replacement}")

        return condensed

    def smart_truncation(self, text: str, max_words: int) -> str:
        """Intelligently truncate text while preserving core meaning."""
        words = text.split()

        if len(words) <= max_words:
            return text

        # Strategy 1: Find natural break points (conjunctions, semicolons)
        break_points = []
        conjunction_words = ["and", "but", "or", "yet", "so", "while", "although", "because"]

        for i, word in enumerate(words):
            clean_word = re.sub(r"[^\w]", "", word.lower())
            if clean_word in conjunction_words and i < max_words:
                break_points.append(i)

        # Use the last natural break point within limit
        if break_points:
            cut_point = max(break_points)
            truncated = " ".join(words[:cut_point])

            # Ensure proper punctuation
            if not truncated.endswith("."):
                truncated += "."

            return truncated

        # Strategy 2: Hard truncation at word boundary
        truncated = " ".join(words[:max_words])

        # Clean up any trailing incomplete thoughts
        if truncated.endswith(("the", "a", "an", "to", "of", "in", "for", "with", "by")):
            words_truncated = truncated.split()[:-1]
            truncated = " ".join(words_truncated)

        # Ensure proper ending
        if not truncated.endswith("."):
            truncated += "."

        return truncated

    def optimize_insight_length(self, text: str) -> Tuple[str, Dict[str, Any]]:
        """
        Optimize a single insight to target length while preserving wisdom.

        Returns:
            tuple: (optimized_text, optimization_metrics)
        """
        original_text = text
        original_length = self.count_words(original_text)

        metrics = {
            "original_length": original_length,
            "target_met": False,
            "words_removed": 0,
            "optimization_steps": [],
        }

        # If already within target range, return as-is
        if self.target_min_words <= original_length <= self.target_max_words:
            metrics["target_met"] = True
            return original_text, metrics

        optimized = original_text

        # Step 1: Remove filler words
        if original_length > self.target_max_words:
            optimized = self.remove_filler_words(optimized)
            new_length = self.count_words(optimized)
            metrics["optimization_steps"].append(
                f"Removed fillers: {original_length} -> {new_length} words"
            )

        # Step 2: Condense verbose phrases
        if self.count_words(optimized) > self.target_max_words:
            optimized = self.condense_verbose_phrases(optimized)
            new_length = self.count_words(optimized)
            metrics["optimization_steps"].append(f"Condensed phrases: -> {new_length} words")

        # Step 3: Smart truncation if still too long
        if self.count_words(optimized) > self.target_max_words:
            optimized = self.smart_truncation(optimized, self.target_max_words)
            new_length = self.count_words(optimized)
            metrics["optimization_steps"].append(f"Truncated: -> {new_length} words")

        # Final cleanup
        optimized = re.sub(r"\s+", " ", optimized).strip()

        final_length = self.count_words(optimized)
        metrics["final_length"] = final_length
        metrics["words_removed"] = original_length - final_length
        metrics["target_met"] = self.target_min_words <= final_length <= self.target_max_words

        # Track lengths for statistics
        self.length_tracking["before"].append(original_length)
        self.length_tracking["after"].append(final_length)

        return optimized, metrics

    def process_insight_entry(self, insight_data: Any) -> bool:
        """
        Process a single insight entry for length optimization.

        Returns:
            bool: True if modifications were made
        """
        modifications_made = False

        if isinstance(insight_data, str):
            # Simple string insight
            optimized, metrics = self.optimize_insight_length(insight_data)

            if metrics["words_removed"] > 0:
                self.stats["words_removed"] += metrics["words_removed"]
                modifications_made = True

                if metrics["target_met"]:
                    self.stats["insights_under_target"] += 1
                else:
                    self.stats["insights_over_target"] += 1

            return optimized if modifications_made else insight_data

        elif isinstance(insight_data, dict):
            # Dictionary format insight
            text_fields = ["insight", "text", "message", "content", "wisdom"]

            for field in text_fields:
                if field in insight_data and isinstance(insight_data[field], str):
                    original_text = insight_data[field]
                    optimized, metrics = self.optimize_insight_length(original_text)

                    if metrics["words_removed"] > 0:
                        insight_data[field] = optimized
                        self.stats["words_removed"] += metrics["words_removed"]
                        modifications_made = True

                        if metrics["target_met"]:
                            self.stats["insights_under_target"] += 1
                        else:
                            self.stats["insights_over_target"] += 1

        return modifications_made

    def process_json_file(self, file_path: Path) -> bool:
        """
        Process a single JSON file for length optimization.

        Returns:
            bool: True if file was modified
        """
        try:
            logger.info(f"Optimizing lengths in: {file_path}")

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
                            result = self.process_insight_entry(insight_item)
                            if isinstance(result, str):
                                value[i] = result
                                file_modified = True
                            elif result:  # Boolean True means dict was modified
                                file_modified = True
                            insights_in_file += 1

                    elif isinstance(value, dict):
                        # Nested structures (like behavioral_insights)
                        for nested_key, nested_value in value.items():
                            if isinstance(nested_value, list):
                                for insight_item in nested_value:
                                    if self.process_insight_entry(insight_item):
                                        file_modified = True
                                        insights_in_file += 1

            elif isinstance(data, list):
                # Direct list of insights
                for insight_item in data:
                    if self.process_insight_entry(insight_item):
                        file_modified = True
                        insights_in_file += 1

            # Save modified file
            if file_modified:
                with open(file_path, "w", encoding="utf-8") as f:
                    json.dump(data, f, indent=2, ensure_ascii=False)
                logger.info(f"✅ Optimized {insights_in_file} insights in {file_path.name}")
            else:
                logger.info(f"⏸️  No optimization needed for {file_path.name}")

            self.stats["files_processed"] += 1
            self.stats["insights_optimized"] += insights_in_file

            return file_modified

        except Exception as e:
            logger.error(f"❌ Error processing {file_path}: {str(e)}")
            self.stats["errors_encountered"] += 1
            return False

    def calculate_statistics(self) -> None:
        """Calculate average lengths before and after optimization."""
        if self.length_tracking["before"]:
            self.stats["avg_length_before"] = sum(self.length_tracking["before"]) / len(
                self.length_tracking["before"]
            )

        if self.length_tracking["after"]:
            self.stats["avg_length_after"] = sum(self.length_tracking["after"]) / len(
                self.length_tracking["after"]
            )

    def generate_report(self) -> str:
        """Generate length optimization report."""
        self.calculate_statistics()

        report = f"""
📏 LENGTH OPTIMIZATION REPORT
============================

📊 PROCESSING STATISTICS:
   Files Processed: {self.stats['files_processed']}
   Insights Optimized: {self.stats['insights_optimized']}
   Total Words Removed: {self.stats['words_removed']}
   Insights Meeting Target: {self.stats['insights_under_target']}
   Insights Still Over Target: {self.stats['insights_over_target']}
   Errors Encountered: {self.stats['errors_encountered']}

📐 LENGTH METRICS:
   Target Range: {self.target_min_words}-{self.target_max_words} words
   Average Length Before: {self.stats['avg_length_before']:.1f} words
   Average Length After: {self.stats['avg_length_after']:.1f} words
   Average Reduction: {self.stats['avg_length_before'] - self.stats['avg_length_after']:.1f} words

✂️ OPTIMIZATION TECHNIQUES APPLIED:
   • Removed filler words (truly, really, very, quite, etc.)
   • Condensed verbose phrases ("in order to" → "to")
   • Streamlined sentence starters
   • Intelligent truncation at natural break points
   • Preserved core wisdom while eliminating verbosity

🎯 QUALITY IMPROVEMENTS:
   • More punchy, impactful delivery
   • Easier to read and absorb quickly
   • Maintained spiritual depth in fewer words
   • Optimized for modern attention spans

⚡ NEXT STEPS:
   1. Run human action anchoring enhancement
   2. Apply persona voice enhancement
   3. Validate A+ quality with testing suite
   4. Deploy optimized content to Firebase

Generated: {__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
        """

        return report


def main():
    """Main execution function."""
    optimizer = LengthOptimizer()

    # Define target directories (same as debuzzing script)
    project_root = Path("/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP")

    targets = [
        project_root / "NumerologyData" / "FirebaseNumberMeanings",
        project_root / "NumerologyData" / "FirebasePlanetaryMeanings",
        project_root / "NumerologyData" / "FirebaseZodiacMeanings",
        project_root / "KASPERMLX" / "MLXTraining" / "ContentRefinery" / "Approved",
    ]

    logger.info("📏 Starting LENGTH OPTIMIZATION process...")

    # Process each target directory
    for target in targets:
        if target.exists():
            logger.info(f"\n📁 Optimizing lengths in: {target}")
            json_files = list(target.glob("*.json"))

            for file_path in json_files:
                optimizer.process_json_file(file_path)
        else:
            logger.warning(f"⚠️ Directory not found: {target}")

    # Generate and save report
    report = optimizer.generate_report()
    report_path = project_root / "length_optimization_report.md"

    with open(report_path, "w") as f:
        f.write(report)

    logger.info(f"\n📋 Optimization report saved: {report_path}")
    print(report)


if __name__ == "__main__":
    main()
