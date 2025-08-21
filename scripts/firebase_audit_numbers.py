#!/usr/bin/env python3
"""
🚨 FIREBASE NUMBER AUDIT - CRITICAL DATA INTEGRITY CHECK
=======================================================

PURPOSE: Audit all Firebase documents to verify number field matches insight content
DISCOVERED: Insights for number 0 being served for number 7 - CRITICAL MISMATCH!

This script will:
1. Read all documents in insights_staging collection
2. Analyze insight text to determine what number it's actually about
3. Compare with the stored 'number' field
4. Report all mismatches for immediate correction
5. Generate repair script for fixing incorrect mappings
"""

import os
import re
from typing import Any, Dict

from google.cloud import firestore


class FirebaseNumberAuditor:
    """Audits Firebase insights for number field accuracy"""

    def __init__(self):
        """Initialize Firebase client"""
        os.environ["FIRESTORE_EMULATOR_HOST"] = "127.0.0.1:8080"
        self.db = firestore.Client(project="vybemvp")

        # Number detection patterns for insight content analysis
        self.number_patterns = {
            0: [
                r"\bzero\b",
                r"\b0\b",
                r"void",
                r"infinite potential",
                r"wholeness",
                r"everything and nothing",
                r"cosmic egg",
                r"source energy",
            ],
            1: [
                r"\bone\b",
                r"\b1\b",
                r"leadership",
                r"independence",
                r"pioneer",
                r"initiation",
                r"first",
                r"beginning",
                r"start",
                r"individual",
            ],
            2: [
                r"\btwo\b",
                r"\b2\b",
                r"partnership",
                r"cooperation",
                r"balance",
                r"harmony",
                r"diplomacy",
                r"second",
                r"duality",
            ],
            3: [
                r"\bthree\b",
                r"\b3\b",
                r"creativity",
                r"expression",
                r"communication",
                r"joy",
                r"third",
                r"triangle",
                r"artistic",
            ],
            4: [
                r"\bfour\b",
                r"\b4\b",
                r"stability",
                r"foundation",
                r"hard work",
                r"discipline",
                r"fourth",
                r"structure",
                r"practical",
            ],
            5: [
                r"\bfive\b",
                r"\b5\b",
                r"freedom",
                r"adventure",
                r"change",
                r"versatility",
                r"fifth",
                r"travel",
                r"dynamic",
            ],
            6: [
                r"\bsix\b",
                r"\b6\b",
                r"nurturing",
                r"responsibility",
                r"family",
                r"healing",
                r"sixth",
                r"care",
                r"service",
            ],
            7: [
                r"\bseven\b",
                r"\b7\b",
                r"spiritual",
                r"mystical",
                r"introspection",
                r"wisdom",
                r"seventh",
                r"inner",
                r"contemplation",
            ],
            8: [
                r"\beight\b",
                r"\b8\b",
                r"material success",
                r"power",
                r"authority",
                r"achievement",
                r"eighth",
                r"business",
                r"ambition",
            ],
            9: [
                r"\bnine\b",
                r"\b9\b",
                r"completion",
                r"universal love",
                r"humanitarian",
                r"wisdom",
                r"ninth",
                r"ending",
                r"service to humanity",
            ],
        }

    def audit_all_insights(self) -> Dict[str, Any]:
        """Audit all insights in Firebase for number accuracy"""
        print("🔍 STARTING FIREBASE NUMBER ACCURACY AUDIT")
        print("=" * 60)

        # Get all documents from insights_staging
        collection_ref = self.db.collection("insights_staging")
        docs = collection_ref.stream()

        audit_results = {
            "total_documents": 0,
            "correct_mappings": 0,
            "incorrect_mappings": 0,
            "undetectable": 0,
            "mismatches": [],
            "field_analysis": {},
            "by_stored_number": {i: 0 for i in range(10)},
            "by_content_number": {i: 0 for i in range(10)},
        }

        print("📊 Analyzing all documents...")

        for doc in docs:
            doc_data = doc.to_dict()
            audit_results["total_documents"] += 1

            # Get stored number and insight text
            stored_number = doc_data.get("number")
            insight_text = doc_data.get("text") or doc_data.get("insight", "")

            if stored_number is not None:
                audit_results["by_stored_number"][stored_number] += 1

            # Analyze insight content to determine actual number
            detected_number = self.detect_number_from_content(insight_text)

            if detected_number is not None:
                audit_results["by_content_number"][detected_number] += 1

                # Check if stored number matches detected number
                if stored_number == detected_number:
                    audit_results["correct_mappings"] += 1
                else:
                    audit_results["incorrect_mappings"] += 1
                    audit_results["mismatches"].append(
                        {
                            "document_id": doc.id,
                            "stored_number": stored_number,
                            "detected_number": detected_number,
                            "insight_preview": insight_text[:100] + "..."
                            if len(insight_text) > 100
                            else insight_text,
                            "source_file": doc_data.get("source_file", "unknown"),
                        }
                    )
            else:
                audit_results["undetectable"] += 1

            # Track field usage patterns
            for field in ["text", "insight", "number", "category", "quality_score"]:
                if field not in audit_results["field_analysis"]:
                    audit_results["field_analysis"][field] = 0
                if field in doc_data:
                    audit_results["field_analysis"][field] += 1

        return audit_results

    def detect_number_from_content(self, text: str) -> int:
        """Analyze insight text to detect which number it's actually about"""
        if not text:
            return None

        text_lower = text.lower()

        # Score each number based on pattern matches
        scores = {i: 0 for i in range(10)}

        for number, patterns in self.number_patterns.items():
            for pattern in patterns:
                matches = len(re.findall(pattern, text_lower, re.IGNORECASE))
                scores[number] += matches

        # Return number with highest score, or None if no clear winner
        max_score = max(scores.values())
        if max_score == 0:
            return None

        # Get all numbers with max score
        winners = [num for num, score in scores.items() if score == max_score]

        # If tie, return None (ambiguous)
        if len(winners) > 1:
            return None

        return winners[0]

    def generate_audit_report(self, results: Dict[str, Any]) -> str:
        """Generate detailed audit report"""
        total = results["total_documents"]
        correct = results["correct_mappings"]
        incorrect = results["incorrect_mappings"]
        undetectable = results["undetectable"]

        accuracy_rate = (correct / total * 100) if total > 0 else 0

        report = f"""
🚨 FIREBASE NUMBER ACCURACY AUDIT REPORT
========================================

📊 SUMMARY STATISTICS:
Total Documents: {total:,}
Correct Mappings: {correct:,} ({accuracy_rate:.1f}%)
Incorrect Mappings: {incorrect:,} ({incorrect/total*100 if total > 0 else 0:.1f}%)
Undetectable: {undetectable:,} ({undetectable/total*100 if total > 0 else 0:.1f}%)

📈 DOCUMENTS BY STORED NUMBER:
"""

        for num in range(10):
            count = results["by_stored_number"][num]
            report += f"Number {num}: {count:,} documents\n"

        report += "\n📈 DOCUMENTS BY DETECTED CONTENT:\n"
        for num in range(10):
            count = results["by_content_number"][num]
            report += f"Number {num}: {count:,} insights (content analysis)\n"

        if results["mismatches"]:
            report += f"\n🚨 CRITICAL MISMATCHES ({len(results['mismatches'])} found):\n"
            report += "=" * 50 + "\n"

            for i, mismatch in enumerate(results["mismatches"][:20]):  # Show first 20
                report += f"{i+1}. Document: {mismatch['document_id']}\n"
                report += f"   Stored as: Number {mismatch['stored_number']}\n"
                report += f"   Content is: Number {mismatch['detected_number']}\n"
                report += f"   Preview: {mismatch['insight_preview']}\n"
                report += f"   Source: {mismatch['source_file']}\n\n"

            if len(results["mismatches"]) > 20:
                report += f"... and {len(results['mismatches']) - 20} more mismatches\n"

        report += "\n📊 FIELD USAGE ANALYSIS:\n"
        for field, count in results["field_analysis"].items():
            report += f"{field}: {count:,} documents ({count/total*100 if total > 0 else 0:.1f}%)\n"

        return report

    def generate_repair_script(self, results: Dict[str, Any]) -> str:
        """Generate repair script to fix mismatches"""
        script = """#!/usr/bin/env python3
# AUTO-GENERATED REPAIR SCRIPT FOR FIREBASE NUMBER MISMATCHES

import os
from google.cloud import firestore

def repair_number_mismatches():
    os.environ["FIRESTORE_EMULATOR_HOST"] = "127.0.0.1:8080"
    db = firestore.Client(project="vybemvp")
    collection_ref = db.collection('insights_staging')

    repairs = [
"""

        for mismatch in results["mismatches"]:
            script += f"""        {{
            'doc_id': '{mismatch['document_id']}',
            'correct_number': {mismatch['detected_number']},
            'comment': 'Fixed: was {mismatch['stored_number']}, should be {mismatch['detected_number']}'
        }},
"""

        script += """    ]

    for repair in repairs:
        doc_ref = collection_ref.document(repair['doc_id'])
        doc_ref.update({'number': repair['correct_number']})
        print(f"✅ Fixed {repair['doc_id']}: {repair['comment']}")

    print(f"🎉 Repaired {len(repairs)} documents!")

if __name__ == "__main__":
    repair_number_mismatches()
"""

        return script


def main():
    """Main audit execution"""
    auditor = FirebaseNumberAuditor()

    print("🔍 Starting Firebase number accuracy audit...")
    results = auditor.audit_all_insights()

    # Generate and save report
    report = auditor.generate_audit_report(results)

    with open("firebase_number_audit_report.txt", "w") as f:
        f.write(report)

    print(report)

    # Generate repair script if mismatches found
    if results["mismatches"]:
        repair_script = auditor.generate_repair_script(results)
        with open("firebase_number_repair.py", "w") as f:
            f.write(repair_script)
        print("💾 Repair script saved as: firebase_number_repair.py")

    print("\n📊 AUDIT COMPLETE:")
    print(f"Total: {results['total_documents']:,} documents")
    print(
        f"Accuracy: {results['correct_mappings']/results['total_documents']*100 if results['total_documents'] > 0 else 0:.1f}%"
    )
    print(f"Mismatches: {results['incorrect_mappings']:,}")


if __name__ == "__main__":
    main()
