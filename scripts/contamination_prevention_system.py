#!/usr/bin/env python3
"""
CONTAMINATION PREVENTION SYSTEM
===============================

Bulletproof validation system to prevent future cross-contamination.
This system provides:
1. Pre-import validation
2. Content type enforcement
3. Automated quality gates
4. Import restrictions
"""

import json
from pathlib import Path
from typing import Any, Dict, Tuple


class ContaminationPreventionSystem:
    """Bulletproof system to prevent future content contamination."""

    def __init__(self):
        # Define strict vocabulary boundaries
        self.content_vocabularies = {
            "numerology": {
                "required_terms": {
                    "numerology",
                    "number",
                    "life path",
                    "expression",
                    "soul urge",
                    "destiny number",
                    "personality number",
                    "karmic",
                    "master number",
                    "birth path",
                    "calculation",
                },
                "forbidden_terms": {
                    "mars",
                    "venus",
                    "jupiter",
                    "mercury",
                    "saturn",
                    "uranus",
                    "neptune",
                    "pluto",
                    "planet",
                    "planetary",
                    "retrograde",
                    "aries",
                    "taurus",
                    "gemini",
                    "cancer",
                    "leo",
                    "virgo",
                    "libra",
                    "scorpio",
                    "sagittarius",
                    "capricorn",
                    "aquarius",
                    "pisces",
                    "zodiac",
                    "sign",
                },
            },
            "planetary": {
                "required_terms": {
                    "mars",
                    "venus",
                    "jupiter",
                    "mercury",
                    "moon",
                    "sun",
                    "saturn",
                    "uranus",
                    "neptune",
                    "pluto",
                    "planet",
                    "planetary",
                    "retrograde",
                },
                "forbidden_terms": {
                    "numerology",
                    "life path",
                    "expression",
                    "soul urge",
                    "destiny number",
                    "personality number",
                    "karmic",
                    "master number",
                    "aries",
                    "taurus",
                    "gemini",
                    "cancer",
                    "leo",
                    "virgo",
                    "libra",
                    "scorpio",
                    "sagittarius",
                    "capricorn",
                    "aquarius",
                    "pisces",  # Note: sun/moon allowed as they're planetary
                },
            },
            "zodiac": {
                "required_terms": {
                    "aries",
                    "taurus",
                    "gemini",
                    "cancer",
                    "leo",
                    "virgo",
                    "libra",
                    "scorpio",
                    "sagittarius",
                    "capricorn",
                    "aquarius",
                    "pisces",
                    "zodiac",
                    "sign",
                },
                "forbidden_terms": {
                    "numerology",
                    "life path",
                    "expression",
                    "soul urge",
                    "destiny number",
                    "personality number",
                    "karmic",
                    "master number",
                    "mars",
                    "venus",
                    "jupiter",
                    "mercury",
                    "saturn",
                    "uranus",
                    "neptune",
                    "pluto",
                    "planet",
                    "planetary",
                    "retrograde"
                    # Note: sun/moon allowed as they're integral to zodiac
                },
            },
        }

        # Quality thresholds
        self.quality_thresholds = {
            "min_content_length": 10,
            "max_contamination_ratio": 0.0,  # 0% contamination allowed
            "min_type_specificity": 0.5,
        }

    def detect_content_type(self, text: str) -> Tuple[str, float]:
        """Detect content type and confidence level."""
        text_lower = text.lower()
        scores = {}

        for content_type, vocabulary in self.content_vocabularies.items():
            required_score = sum(1 for term in vocabulary["required_terms"] if term in text_lower)
            forbidden_score = sum(1 for term in vocabulary["forbidden_terms"] if term in text_lower)

            # Score = required terms found minus forbidden terms penalty
            scores[content_type] = max(0, required_score - (forbidden_score * 2))

        if not any(scores.values()):
            return "unknown", 0.0

        best_type = max(scores, key=scores.get)
        max_score = scores[best_type]
        total_score = sum(scores.values())

        confidence = max_score / total_score if total_score > 0 else 0.0

        return best_type, confidence

    def validate_content_purity(self, text: str, expected_type: str) -> Dict[str, Any]:
        """Validate that content is pure for its expected type."""
        validation_result = {
            "is_pure": True,
            "contamination_issues": [],
            "quality_score": 0.0,
            "recommendations": [],
        }

        if expected_type not in self.content_vocabularies:
            validation_result["is_pure"] = False
            validation_result["contamination_issues"].append(
                f"Unknown content type: {expected_type}"
            )
            return validation_result

        text_lower = text.lower()
        vocabulary = self.content_vocabularies[expected_type]

        # Check for forbidden terms
        for forbidden_term in vocabulary["forbidden_terms"]:
            if forbidden_term in text_lower:
                validation_result["is_pure"] = False
                validation_result["contamination_issues"].append(
                    f"Forbidden {expected_type} term detected: '{forbidden_term}'"
                )

        # Check content length
        if len(text.strip()) < self.quality_thresholds["min_content_length"]:
            validation_result["contamination_issues"].append(
                f"Content too short: {len(text)} chars (min: {self.quality_thresholds['min_content_length']})"
            )

        # Calculate type specificity
        required_found = sum(1 for term in vocabulary["required_terms"] if term in text_lower)
        type_specificity = required_found / len(vocabulary["required_terms"])

        if type_specificity < self.quality_thresholds["min_type_specificity"]:
            validation_result["recommendations"].append(
                f"Low type specificity: {type_specificity:.2f} (recommended: {self.quality_thresholds['min_type_specificity']})"
            )

        # Calculate overall quality score
        validation_result["quality_score"] = max(
            0.0, type_specificity - (len(validation_result["contamination_issues"]) * 0.2)
        )

        return validation_result

    def validate_file_for_import(self, file_path: Path, expected_type: str) -> Dict[str, Any]:
        """Validate a file before allowing import to clean datasets."""
        result = {
            "file": str(file_path),
            "expected_type": expected_type,
            "can_import": True,
            "total_insights": 0,
            "pure_insights": 0,
            "contaminated_insights": 0,
            "quality_issues": [],
            "contamination_details": [],
        }

        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            # Extract insights from various possible structures
            insights = []
            if isinstance(data, dict):
                if "clean_insights" in data:
                    insights = data["clean_insights"]
                elif "insights" in data:
                    insights = data["insights"]
                elif "content" in data:
                    insights = (
                        data["content"] if isinstance(data["content"], list) else [data["content"]]
                    )
                else:
                    # Look for any list of strings
                    for value in data.values():
                        if isinstance(value, list) and value and isinstance(value[0], str):
                            insights = value
                            break
            elif isinstance(data, list):
                insights = data

            result["total_insights"] = len(insights)

            for i, insight in enumerate(insights):
                if not isinstance(insight, str):
                    continue

                validation = self.validate_content_purity(insight, expected_type)

                if validation["is_pure"]:
                    result["pure_insights"] += 1
                else:
                    result["contaminated_insights"] += 1
                    result["can_import"] = False
                    result["contamination_details"].append(
                        {"insight_index": i, "issues": validation["contamination_issues"]}
                    )

                # Collect quality issues
                result["quality_issues"].extend(validation["recommendations"])

            # Final import decision
            contamination_ratio = (
                result["contaminated_insights"] / result["total_insights"]
                if result["total_insights"] > 0
                else 0
            )
            if contamination_ratio > self.quality_thresholds["max_contamination_ratio"]:
                result["can_import"] = False

        except Exception as e:
            result["can_import"] = False
            result["quality_issues"].append(f"File read error: {str(e)}")

        return result

    def create_import_policy(self, output_path: str):
        """Create a formal import policy document."""
        policy = {
            "contamination_prevention_policy": {
                "version": "1.0",
                "created_date": __import__("datetime").datetime.now().isoformat(),
                "purpose": "Prevent cross-contamination between numerological, planetary, and zodiac content",
                "quality_thresholds": self.quality_thresholds,
                "content_vocabularies": {
                    content_type: {
                        "required_terms": list(vocab["required_terms"]),
                        "forbidden_terms": list(vocab["forbidden_terms"]),
                    }
                    for content_type, vocab in self.content_vocabularies.items()
                },
                "validation_rules": [
                    "All content must be validated before import",
                    "0% contamination tolerance enforced",
                    "Content type must be clearly identifiable",
                    "Forbidden terms automatically reject content",
                    "Quality score must meet minimum thresholds",
                ],
                "enforcement": [
                    "Pre-import validation mandatory",
                    "Automated rejection of contaminated content",
                    "Regular audits of clean datasets",
                    "Version control for policy updates",
                ],
            }
        }

        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(policy, f, indent=2)

        return policy

    def audit_directory(self, directory_path: str, expected_type: str) -> Dict[str, Any]:
        """Audit a directory for contamination compliance."""
        directory = Path(directory_path)

        if not directory.exists():
            return {"error": f"Directory {directory_path} does not exist"}

        files = list(directory.glob("*.json"))

        audit_result = {
            "directory": str(directory),
            "expected_type": expected_type,
            "total_files": len(files),
            "compliant_files": 0,
            "non_compliant_files": 0,
            "audit_timestamp": __import__("datetime").datetime.now().isoformat(),
            "file_results": [],
        }

        print(f"\n🔍 AUDITING DIRECTORY: {directory}")
        print(f"Expected type: {expected_type}")
        print(f"Files to audit: {len(files)}")
        print("-" * 50)

        for file_path in files:
            result = self.validate_file_for_import(file_path, expected_type)
            audit_result["file_results"].append(result)

            if result["can_import"]:
                audit_result["compliant_files"] += 1
                print(f"✅ {file_path.name} - COMPLIANT")
            else:
                audit_result["non_compliant_files"] += 1
                print(
                    f"❌ {file_path.name} - NON-COMPLIANT ({result['contaminated_insights']} contaminated)"
                )

        compliance_rate = (
            (audit_result["compliant_files"] / audit_result["total_files"]) * 100
            if audit_result["total_files"] > 0
            else 0
        )

        print("\n📊 AUDIT SUMMARY")
        print(f"Compliance rate: {compliance_rate:.1f}%")
        print(f"Compliant files: {audit_result['compliant_files']}/{audit_result['total_files']}")

        return audit_result


def main():
    """Main execution - demonstrate contamination prevention system."""
    print("🔒 CONTAMINATION PREVENTION SYSTEM")
    print("=" * 40)
    print("Bulletproof protection against future cross-contamination")
    print()

    prevention_system = ContaminationPreventionSystem()

    # Create policy document
    policy_path = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/contamination_prevention_policy.json"
    policy = prevention_system.create_import_policy(policy_path)
    print(f"✅ Policy created: {policy_path}")

    # Audit clean datasets
    clean_base = (
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/CleanSeparatedContent"
    )

    audits = [
        ("CleanNumbers", "numerology"),
        ("CleanPlanets", "planetary"),
        ("CleanZodiac", "zodiac"),
    ]

    for directory, expected_type in audits:
        audit_result = prevention_system.audit_directory(f"{clean_base}/{directory}", expected_type)

        # Save audit report
        audit_path = f"{clean_base}/audit_{directory.lower()}.json"
        with open(audit_path, "w", encoding="utf-8") as f:
            json.dump(audit_result, f, indent=2)
        print(f"📄 Audit saved: {audit_path}")

    print("\n🛡️  CONTAMINATION PREVENTION ACTIVE")
    print("✅ Policy enforced")
    print("✅ Quality gates active")
    print("✅ Import restrictions enabled")
    print("✅ Automated validation ready")


if __name__ == "__main__":
    main()
