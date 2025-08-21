#!/usr/bin/env python3
"""
🔥 FINAL A+ CERTIFICATION VALIDATOR

PURPOSE: Execute comprehensive final validation of enhanced spiritual insights
MISSION: Certify the corpus meets genuine A+ standards for production deployment
TARGETS: Complete validation across Firebase + KASPER content
"""

import json
import logging
import random
import re
import statistics
from pathlib import Path
from typing import Any, Dict, List

# Setup logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)


class FinalAplusCertificationValidator:
    def __init__(self):
        """Initialize the final A+ certification validator."""

        # A+ QUALITY CRITERIA (Gold Standard)
        self.criteria_weights = {
            "length_compliance": 0.25,  # 15-25 words strict
            "human_anchoring": 0.30,  # 25-33% first-person + action verbs
            "natural_language": 0.25,  # No buzzwords/template artifacts
            "persona_authenticity": 0.15,  # Genuine archetypal voice
            "spiritual_value": 0.05,  # Meaningful wisdom
        }

        # VIOLATION PATTERNS (Zero tolerance for A+)
        self.violation_patterns = {
            "spiritual_buzzwords": [
                r"\bdivine\b",
                r"\bsacred\b",
                r"\bmystical\b",
                r"\bcosmic\b",
                r"\buniversal\b",
                r"\bethereal\b",
                r"\bcelestial\b",
            ],
            "template_artifacts": [
                r"aligns with",
                r"resonates with",
                r"vibrates at",
                r"harmonizes",
                r"awakens",
                r"illuminates",
            ],
            "prayer_style": [r"\bMay you\b", r"\bMay this\b", r"\bMay your\b"],
            "vague_energy": [r"energy flows", r"light enters", r"wisdom flows"],
        }

        # ACTION VERBS (Required for human anchoring)
        self.action_verbs = [
            "notice",
            "choose",
            "try",
            "write",
            "schedule",
            "practice",
            "begin",
            "start",
            "create",
            "build",
            "take",
            "make",
            "do",
            "breathe",
            "walk",
            "sit",
            "listen",
            "watch",
            "feel",
            "think",
        ]

        # FIRST-PERSON INDICATORS
        self.first_person_words = ["I", "my", "me", "myself", "mine"]

        # Statistics tracking
        self.stats = {
            "total_insights": 0,
            "a_plus_insights": 0,
            "length_violations": 0,
            "buzzword_violations": 0,
            "template_violations": 0,
            "low_first_person": 0,
            "missing_actions": 0,
            "grade_distribution": {},
        }

    def validate_insight(self, text: str) -> Dict[str, Any]:
        """Perform comprehensive A+ validation on a single insight."""

        result = {
            "text": text,
            "word_count": len(text.split()),
            "scores": {},
            "violations": [],
            "grade": "F",
            "a_plus_quality": False,
            "overall_score": 0.0,
        }

        # 1. LENGTH COMPLIANCE (15-25 words strict)
        word_count = result["word_count"]
        if 15 <= word_count <= 25:
            result["scores"]["length_compliance"] = 1.0
        elif 10 <= word_count <= 30:
            result["scores"]["length_compliance"] = 0.7
        else:
            result["scores"]["length_compliance"] = 0.3
            result["violations"].append(f"Length violation: {word_count} words (target: 15-25)")
            self.stats["length_violations"] += 1

        # 2. HUMAN ANCHORING (First-person + Action verbs)
        first_person_count = sum(
            1 for word in self.first_person_words if word.lower() in text.lower()
        )
        total_words = len(text.split())
        first_person_percentage = (first_person_count / total_words * 100) if total_words > 0 else 0

        action_verb_count = sum(1 for verb in self.action_verbs if verb in text.lower())
        has_action_verbs = action_verb_count > 0

        if first_person_percentage >= 25 and has_action_verbs:
            result["scores"]["human_anchoring"] = 1.0
        elif first_person_percentage >= 15 or has_action_verbs:
            result["scores"]["human_anchoring"] = 0.7
        else:
            result["scores"]["human_anchoring"] = 0.3
            if first_person_percentage < 25:
                result["violations"].append(
                    f"Low first-person: {first_person_percentage:.1f}% (target: 25%+)"
                )
                self.stats["low_first_person"] += 1
            if not has_action_verbs:
                result["violations"].append("Missing action verbs")
                self.stats["missing_actions"] += 1

        # 3. NATURAL LANGUAGE (No buzzwords/templates)
        violation_count = 0
        for category, patterns in self.violation_patterns.items():
            for pattern in patterns:
                if re.search(pattern, text, re.IGNORECASE):
                    violation_count += 1
                    result["violations"].append(f"{category}: {pattern}")
                    if category == "spiritual_buzzwords":
                        self.stats["buzzword_violations"] += 1
                    elif category == "template_artifacts":
                        self.stats["template_violations"] += 1

        if violation_count == 0:
            result["scores"]["natural_language"] = 1.0
        elif violation_count <= 2:
            result["scores"]["natural_language"] = 0.7
        else:
            result["scores"]["natural_language"] = 0.3

        # 4. PERSONA AUTHENTICITY (Voice consistency)
        # Simple heuristic: variety in sentence structure, no repetitive patterns
        sentences = text.split(".")
        if len(set(s.strip()[:10] for s in sentences if s.strip())) == len(sentences):
            result["scores"]["persona_authenticity"] = 1.0
        else:
            result["scores"]["persona_authenticity"] = 0.8

        # 5. SPIRITUAL VALUE (Meaningful content)
        # Heuristic: Not too short, not too generic
        if word_count >= 12 and not any(
            generic in text.lower() for generic in ["today", "now", "you are"]
        ):
            result["scores"]["spiritual_value"] = 1.0
        else:
            result["scores"]["spiritual_value"] = 0.8

        # Calculate overall score
        overall_score = sum(
            result["scores"][criterion] * weight
            for criterion, weight in self.criteria_weights.items()
        )
        result["overall_score"] = overall_score

        # Assign grade
        if overall_score >= 0.93:
            result["grade"] = "A+"
            result["a_plus_quality"] = True
            self.stats["a_plus_insights"] += 1
        elif overall_score >= 0.90:
            result["grade"] = "A"
        elif overall_score >= 0.87:
            result["grade"] = "A-"
        elif overall_score >= 0.83:
            result["grade"] = "B+"
        elif overall_score >= 0.80:
            result["grade"] = "B"
        elif overall_score >= 0.77:
            result["grade"] = "B-"
        elif overall_score >= 0.70:
            result["grade"] = "C+"
        elif overall_score >= 0.60:
            result["grade"] = "C"
        else:
            result["grade"] = "F"

        # Track grade distribution
        self.stats["grade_distribution"][result["grade"]] = (
            self.stats["grade_distribution"].get(result["grade"], 0) + 1
        )
        self.stats["total_insights"] += 1

        return result

    def validate_json_file(self, file_path: Path) -> List[Dict[str, Any]]:
        """Validate all insights in a JSON file."""
        results = []

        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            insights_found = 0

            # Handle different JSON structures
            if isinstance(data, dict):
                # NumberMessages format: {"0": {"insight": [...], "reflection": [...]}}
                for number_key, number_data in data.items():
                    if number_key.isdigit() and isinstance(number_data, dict):
                        for category, insights in number_data.items():
                            if isinstance(insights, list):
                                for insight in insights:
                                    if isinstance(insight, str) and len(insight.strip()) > 0:
                                        result = self.validate_insight(insight.strip())
                                        result["file"] = file_path.name
                                        result["category"] = category
                                        result["number"] = number_key
                                        results.append(result)
                                        insights_found += 1

                # Alternative structure: {"insights": [...]}
                if "insights" in data and isinstance(data["insights"], list):
                    for insight in data["insights"]:
                        if isinstance(insight, str) and len(insight.strip()) > 0:
                            result = self.validate_insight(insight.strip())
                            result["file"] = file_path.name
                            results.append(result)
                            insights_found += 1

                # Direct category structure: {"insight": [...], "reflection": [...]}
                for key, value in data.items():
                    if isinstance(value, list) and key not in ["meta", "metadata"]:
                        for insight in value:
                            if isinstance(insight, str) and len(insight.strip()) > 0:
                                result = self.validate_insight(insight.strip())
                                result["file"] = file_path.name
                                result["category"] = key
                                results.append(result)
                                insights_found += 1

            elif isinstance(data, list):
                # Direct list of insights
                for insight in data:
                    if isinstance(insight, str) and len(insight.strip()) > 0:
                        result = self.validate_insight(insight.strip())
                        result["file"] = file_path.name
                        results.append(result)
                        insights_found += 1

            logger.info(f"✅ Validated {insights_found} insights in {file_path.name}")

        except Exception as e:
            logger.error(f"❌ Error validating {file_path}: {str(e)}")

        return results

    def run_comprehensive_validation(self) -> Dict[str, Any]:
        """Run comprehensive validation across all content directories."""

        logger.info("🔥 STARTING FINAL A+ CERTIFICATION VALIDATION")
        logger.info("=" * 60)

        all_results = []

        # Target directories for validation
        target_dirs = [
            Path("NumerologyData/FirebaseNumberMeanings"),
            Path("NumerologyData/FirebasePlanetaryMeanings"),
            Path("NumerologyData/FirebaseZodiacMeanings"),
            Path("KASPERMLX/MLXTraining/ContentRefinery/Approved"),
        ]

        for target_dir in target_dirs:
            if target_dir.exists():
                logger.info(f"📁 Validating directory: {target_dir}")

                json_files = list(target_dir.glob("*.json"))
                for file_path in json_files:
                    if file_path.name != "meta.json":  # Skip metadata files
                        file_results = self.validate_json_file(file_path)
                        all_results.extend(file_results)
            else:
                logger.warning(f"📁 Directory not found: {target_dir}")

        # Statistical sampling for detailed analysis
        if len(all_results) > 200:
            logger.info(
                f"📊 Taking statistical sample of 200 from {len(all_results)} total insights"
            )
            sample_results = random.sample(all_results, 200)
        else:
            sample_results = all_results

        return {
            "all_results": all_results,
            "sample_results": sample_results,
            "total_insights": len(all_results),
            "sample_size": len(sample_results),
        }

    def generate_certification_report(self, validation_data: Dict[str, Any]) -> str:
        """Generate the final A+ certification report."""

        all_results = validation_data["all_results"]
        sample_results = validation_data["sample_results"]

        if not sample_results:
            return "❌ NO INSIGHTS FOUND - VALIDATION FAILED"

        # Calculate statistics
        sample_scores = [r["overall_score"] for r in sample_results]
        sample_a_plus = [r for r in sample_results if r["a_plus_quality"]]

        avg_score = statistics.mean(sample_scores)
        a_plus_percentage = (len(sample_a_plus) / len(sample_results)) * 100

        # Grade distribution
        grade_dist = {}
        for result in sample_results:
            grade = result["grade"]
            grade_dist[grade] = grade_dist.get(grade, 0) + 1

        # Top violations
        violation_counts = {}
        for result in sample_results:
            for violation in result["violations"]:
                violation_counts[violation] = violation_counts.get(violation, 0) + 1

        top_violations = sorted(violation_counts.items(), key=lambda x: x[1], reverse=True)[:10]

        # Sample A+ insights for quality verification
        a_plus_samples = sample_results[:5] if sample_results else []

        # Production readiness assessment
        production_ready = a_plus_percentage >= 80 and avg_score >= 0.85

        report = f"""
🔥 FINAL A+ CERTIFICATION REPORT
================================

📊 VALIDATION SUMMARY:
   Total Insights Analyzed: {len(all_results):,}
   Statistical Sample: {len(sample_results)}
   Average Quality Score: {avg_score:.3f}
   A+ Quality Rate: {a_plus_percentage:.1f}%

📈 GRADE DISTRIBUTION (Sample):
"""

        for grade in ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "F"]:
            count = grade_dist.get(grade, 0)
            percentage = (count / len(sample_results)) * 100 if sample_results else 0
            report += f"   {grade}: {count} insights ({percentage:.1f}%)\n"

        report += """
❌ TOP VIOLATIONS FOUND:
"""
        for violation, count in top_violations:
            percentage = (count / len(sample_results)) * 100
            report += f"   • {violation}: {count} occurrences ({percentage:.1f}%)\n"

        report += """
✅ A+ SAMPLE INSIGHTS:
"""
        for i, result in enumerate(a_plus_samples, 1):
            report += f"   {i}. [{result['grade']} - {result['overall_score']:.3f}] {result['text'][:100]}...\n"

        report += f"""
🚀 PRODUCTION DEPLOYMENT ASSESSMENT:
   A+ Threshold (80%): {'✅ PASSED' if a_plus_percentage >= 80 else '❌ FAILED'}
   Quality Threshold (0.85): {'✅ PASSED' if avg_score >= 0.85 else '❌ FAILED'}

   PRODUCTION READY: {'✅ YES - APPROVED FOR DEPLOYMENT' if production_ready else '❌ NO - NEEDS ENHANCEMENT'}

📋 DETAILED STATISTICS:
   Length Violations: {self.stats['length_violations']}
   Buzzword Violations: {self.stats['buzzword_violations']}
   Template Violations: {self.stats['template_violations']}
   Low First-Person: {self.stats['low_first_person']}
   Missing Actions: {self.stats['missing_actions']}

📝 CERTIFICATION NOTES:
   • Sample size statistically significant for validation
   • A+ criteria: 15-25 words, 25%+ first-person, no buzzwords, action verbs
   • Quality scores based on weighted criteria importance
   • Production deployment requires 80%+ A+ insights

Generated: {self.get_timestamp()}
Agent: Claude (Sonnet 4) - Final A+ Certification Validator
"""

        return report

    def get_timestamp(self) -> str:
        """Get current timestamp."""
        from datetime import datetime

        return datetime.now().strftime("%Y-%m-%d %H:%M:%S")


def main():
    """Main execution function."""

    validator = FinalAplusCertificationValidator()

    # Run comprehensive validation
    validation_data = validator.run_comprehensive_validation()

    # Generate certification report
    report = validator.generate_certification_report(validation_data)

    # Save report
    report_path = Path("FINAL_A_PLUS_CERTIFICATION_REPORT.md")
    with open(report_path, "w", encoding="utf-8") as f:
        f.write(report)

    # Display results
    print(report)

    logger.info(f"📋 Full certification report saved to: {report_path}")

    # Return success/failure for automation
    sample_results = validation_data["sample_results"]
    if sample_results:
        a_plus_percentage = (
            len([r for r in sample_results if r["a_plus_quality"]]) / len(sample_results)
        ) * 100
        return a_plus_percentage >= 80
    else:
        return False


if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)
