#!/usr/bin/env python3
"""
Duplicate Detection Agent for VybeMVP Firebase Content
Mission: Find and eliminate ALL duplicate insights across all files
"""

import glob
import hashlib
import json
import os
import re
from collections import defaultdict
from difflib import SequenceMatcher
from typing import Any, Dict, List


class DuplicateDetector:
    def __init__(self, base_path: str):
        self.base_path = base_path
        self.all_insights = []  # All insights with metadata
        self.exact_duplicates = defaultdict(list)  # hash -> list of (file, path, insight)
        self.near_duplicates = []  # list of similar insight pairs
        self.files_modified = set()
        self.duplicates_removed = 0

    def normalize_text(self, text: str) -> str:
        """Normalize text for comparison"""
        # Remove extra whitespace, normalize punctuation
        text = re.sub(r"\s+", " ", text.strip())
        text = re.sub(r"[" '"]', "'", text)  # Normalize quotes
        text = re.sub(r"[–—]", "-", text)  # Normalize dashes
        return text.lower()

    def get_text_hash(self, text: str) -> str:
        """Get hash for exact duplicate detection"""
        normalized = self.normalize_text(text)
        return hashlib.md5(normalized.encode()).hexdigest()

    def text_similarity(self, text1: str, text2: str) -> float:
        """Calculate text similarity (0-1)"""
        norm1 = self.normalize_text(text1)
        norm2 = self.normalize_text(text2)
        return SequenceMatcher(None, norm1, norm2).ratio()

    def extract_insights_from_data(
        self, data: Any, file_path: str, json_path: str = ""
    ) -> List[Dict]:
        """Recursively extract all insight texts from JSON data"""
        insights = []

        if isinstance(data, dict):
            for key, value in data.items():
                current_path = f"{json_path}.{key}" if json_path else key

                # Check if this is an insight field
                if key == "insight" and isinstance(value, str):
                    insights.append(
                        {
                            "text": value,
                            "file_path": file_path,
                            "json_path": current_path,
                            "hash": self.get_text_hash(value),
                            "parent_data": data,  # Reference to modify later
                        }
                    )
                elif key == "insights" and isinstance(value, list):
                    # Handle insight arrays in zodiac/planetary files
                    for i, item in enumerate(value):
                        if isinstance(item, dict) and "insight" in item:
                            insight_path = f"{current_path}[{i}].insight"
                            insights.append(
                                {
                                    "text": item["insight"],
                                    "file_path": file_path,
                                    "json_path": insight_path,
                                    "hash": self.get_text_hash(item["insight"]),
                                    "parent_data": item,
                                    "array_index": i,
                                    "array_ref": value,
                                }
                            )
                elif isinstance(value, (dict, list)):
                    insights.extend(self.extract_insights_from_data(value, file_path, current_path))

        elif isinstance(data, list):
            for i, item in enumerate(data):
                current_path = f"{json_path}[{i}]"
                if isinstance(item, str):
                    # Handle direct insight arrays (like in number meanings)
                    insights.append(
                        {
                            "text": item,
                            "file_path": file_path,
                            "json_path": current_path,
                            "hash": self.get_text_hash(item),
                            "array_index": i,
                            "array_ref": data,
                        }
                    )
                elif isinstance(item, (dict, list)):
                    insights.extend(self.extract_insights_from_data(item, file_path, current_path))

        return insights

    def scan_all_files(self):
        """Scan all Firebase content files for insights"""
        print("🔍 Scanning all Firebase content files...")

        directories = [
            "NumerologyData/FirebaseNumberMeanings",
            "NumerologyData/FirebaseZodiacMeanings",
            "NumerologyData/FirebasePlanetaryMeanings",
        ]

        total_files = 0
        total_insights = 0

        for directory in directories:
            full_dir = os.path.join(self.base_path, directory)
            if not os.path.exists(full_dir):
                print(f"⚠️  Directory not found: {full_dir}")
                continue

            json_files = glob.glob(os.path.join(full_dir, "*.json"))
            print(f"📁 {directory}: {len(json_files)} files")

            for file_path in json_files:
                try:
                    with open(file_path, "r", encoding="utf-8") as f:
                        data = json.load(f)

                    file_insights = self.extract_insights_from_data(data, file_path)
                    self.all_insights.extend(file_insights)
                    total_insights += len(file_insights)
                    total_files += 1

                    print(f"  📄 {os.path.basename(file_path)}: {len(file_insights)} insights")

                except Exception as e:
                    print(f"❌ Error reading {file_path}: {e}")

        print("\n📊 SCAN COMPLETE:")
        print(f"   📁 Files scanned: {total_files}")
        print(f"   💭 Total insights: {total_insights}")

    def find_exact_duplicates(self):
        """Find exact duplicate insights"""
        print("\n🎯 Finding exact duplicates...")

        hash_map = defaultdict(list)

        for insight in self.all_insights:
            hash_map[insight["hash"]].append(insight)

        exact_count = 0
        for hash_key, insights in hash_map.items():
            if len(insights) > 1:
                self.exact_duplicates[hash_key] = insights
                exact_count += len(insights) - 1  # Count duplicates, not originals

        print(f"   🔍 Found {len(self.exact_duplicates)} sets of exact duplicates")
        print(f"   🗑️  Total duplicate insights: {exact_count}")

    def find_near_duplicates(self):
        """Find near-duplicate insights (95%+ similarity)"""
        print("\n🎯 Finding near duplicates (95%+ similarity)...")

        near_count = 0
        checked_pairs = set()

        for i, insight1 in enumerate(self.all_insights):
            for j, insight2 in enumerate(self.all_insights[i + 1 :], i + 1):
                # Skip if already exact duplicates
                if insight1["hash"] == insight2["hash"]:
                    continue

                # Create a pair key to avoid checking twice
                pair_key = tuple(sorted([insight1["hash"], insight2["hash"]]))
                if pair_key in checked_pairs:
                    continue
                checked_pairs.add(pair_key)

                similarity = self.text_similarity(insight1["text"], insight2["text"])
                if similarity >= 0.95:
                    self.near_duplicates.append(
                        {"similarity": similarity, "insight1": insight1, "insight2": insight2}
                    )
                    near_count += 1

        print(f"   🔍 Found {len(self.near_duplicates)} near-duplicate pairs")

    def determine_best_insight(self, insights: List[Dict]) -> Dict:
        """Determine which insight to keep based on priority order"""
        # Priority: original > advanced > multiplied

        priorities = {"original": 3, "advanced": 2, "multiplied": 1}

        best_insight = insights[0]
        best_priority = 0

        for insight in insights:
            file_name = os.path.basename(insight["file_path"])

            # Determine tier from filename
            if "_original" in file_name or (
                "_advanced" not in file_name and "_multiplied" not in file_name
            ):
                tier = "original"
            elif "_advanced" in file_name:
                tier = "advanced"
            elif "_multiplied" in file_name:
                tier = "multiplied"
            else:
                tier = "original"  # Default

            priority = priorities.get(tier, 0)

            if priority > best_priority:
                best_priority = priority
                best_insight = insight

        return best_insight

    def remove_duplicate_insight(self, insight: Dict):
        """Remove a duplicate insight from its file"""
        try:
            # Load the file
            with open(insight["file_path"], "r", encoding="utf-8") as f:
                data = json.load(f)

            # Remove the insight based on its location
            if "array_ref" in insight:
                # It's in an array
                array_ref = insight["array_ref"]
                if "array_index" in insight and insight["array_index"] < len(array_ref):
                    array_ref.pop(insight["array_index"])

                    # Update indices for remaining insights in same array
                    for other_insight in self.all_insights:
                        if (
                            other_insight["file_path"] == insight["file_path"]
                            and "array_ref" in other_insight
                            and other_insight["array_ref"] is array_ref
                            and "array_index" in other_insight
                            and other_insight["array_index"] > insight["array_index"]
                        ):
                            other_insight["array_index"] -= 1

            # Save the modified file
            with open(insight["file_path"], "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2, ensure_ascii=False)

            self.files_modified.add(insight["file_path"])
            self.duplicates_removed += 1

        except Exception as e:
            print(f"❌ Error removing duplicate from {insight['file_path']}: {e}")

    def eliminate_exact_duplicates(self):
        """Remove exact duplicate insights"""
        print("\n🗑️  Eliminating exact duplicates...")

        for hash_key, insights in self.exact_duplicates.items():
            if len(insights) <= 1:
                continue

            # Keep the best one based on priority
            best_insight = self.determine_best_insight(insights)

            # Remove all others
            for insight in insights:
                if insight != best_insight:
                    print(
                        f"   🗑️  Removing from {os.path.basename(insight['file_path'])}: {insight['text'][:60]}..."
                    )
                    self.remove_duplicate_insight(insight)

    def eliminate_near_duplicates(self):
        """Remove near-duplicate insights"""
        print("\n🗑️  Eliminating near duplicates...")

        removed_hashes = set()

        for dup_pair in self.near_duplicates:
            insight1 = dup_pair["insight1"]
            insight2 = dup_pair["insight2"]

            # Skip if either was already removed
            if insight1["hash"] in removed_hashes or insight2["hash"] in removed_hashes:
                continue

            # Determine which to keep
            best_insight = self.determine_best_insight([insight1, insight2])
            to_remove = insight2 if best_insight == insight1 else insight1

            print(
                f"   🗑️  Removing near-duplicate ({dup_pair['similarity']:.2%}): {to_remove['text'][:60]}..."
            )
            self.remove_duplicate_insight(to_remove)
            removed_hashes.add(to_remove["hash"])

    def generate_report(self) -> str:
        """Generate detailed duplicate elimination report"""
        report = []
        report.append("🔍 DUPLICATE DETECTION AND ELIMINATION REPORT")
        report.append("=" * 60)

        report.append("\n📊 SCAN RESULTS:")
        report.append(
            f"   📁 Total files scanned: {len(set(insight['file_path'] for insight in self.all_insights))}"
        )
        report.append(f"   💭 Total insights analyzed: {len(self.all_insights)}")

        report.append("\n🎯 DUPLICATES FOUND:")
        report.append(f"   🔍 Exact duplicate sets: {len(self.exact_duplicates)}")
        exact_count = sum(len(insights) - 1 for insights in self.exact_duplicates.values())
        report.append(f"   🗑️  Exact duplicates removed: {exact_count}")
        report.append(f"   🔍 Near duplicate pairs: {len(self.near_duplicates)}")

        report.append("\n🗑️  ELIMINATION RESULTS:")
        report.append(f"   📝 Files modified: {len(self.files_modified)}")
        report.append(f"   🗑️  Total duplicates removed: {self.duplicates_removed}")

        if self.files_modified:
            report.append("\n📁 MODIFIED FILES:")
            for file_path in sorted(self.files_modified):
                report.append(f"   📄 {os.path.basename(file_path)}")

        # Show examples of duplicates found
        if self.exact_duplicates:
            report.append("\n🔍 EXAMPLE EXACT DUPLICATES ELIMINATED:")
            count = 0
            for hash_key, insights in list(self.exact_duplicates.items())[:3]:
                if len(insights) > 1:
                    report.append(f"\n   Duplicate Set {count + 1}:")
                    report.append(f"   Text: \"{insights[0]['text'][:100]}...\"")
                    report.append(f"   Found in {len(insights)} locations:")
                    for insight in insights:
                        report.append(f"     - {os.path.basename(insight['file_path'])}")
                    count += 1

        if self.near_duplicates:
            report.append("\n🔍 EXAMPLE NEAR DUPLICATES ELIMINATED:")
            for i, dup_pair in enumerate(self.near_duplicates[:3]):
                report.append(
                    f"\n   Near Duplicate {i + 1} ({dup_pair['similarity']:.2%} similar):"
                )
                report.append(f"   Text 1: \"{dup_pair['insight1']['text'][:80]}...\"")
                report.append(f"   Text 2: \"{dup_pair['insight2']['text'][:80]}...\"")

        # Calculate final uniqueness score
        remaining_insights = len(self.all_insights) - self.duplicates_removed
        uniqueness_score = (
            (remaining_insights / len(self.all_insights)) * 100 if self.all_insights else 100
        )

        report.append(f"\n🏆 FINAL UNIQUENESS SCORE: {uniqueness_score:.1f}%")
        report.append(f"   💭 Unique insights remaining: {remaining_insights}")
        report.append(f"   🗑️  Duplicates eliminated: {self.duplicates_removed}")

        return "\n".join(report)

    def run_full_detection(self) -> str:
        """Run complete duplicate detection and elimination process"""
        print("🤖 DUPLICATE DETECTION AGENT ACTIVATED")
        print("=" * 50)

        # Step 1: Scan all files
        self.scan_all_files()

        # Step 2: Find exact duplicates
        self.find_exact_duplicates()

        # Step 3: Find near duplicates
        self.find_near_duplicates()

        # Step 4: Eliminate exact duplicates
        self.eliminate_exact_duplicates()

        # Step 5: Eliminate near duplicates
        self.eliminate_near_duplicates()

        # Step 6: Generate report
        return self.generate_report()


def main():
    base_path = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP"

    detector = DuplicateDetector(base_path)
    report = detector.run_full_detection()

    print("\n" + report)

    # Save report to file
    report_path = os.path.join(base_path, "duplicate_elimination_report.txt")
    with open(report_path, "w", encoding="utf-8") as f:
        f.write(report)

    print(f"\n📄 Report saved to: {report_path}")


if __name__ == "__main__":
    main()
