#!/usr/bin/env python3
"""
Fast Duplicate Detection Agent for VybeMVP Firebase Content
Optimized for speed while finding critical duplicates
"""

import glob
import hashlib
import json
import os
import re


class FastDuplicateDetector:
    def __init__(self, base_path: str):
        self.base_path = base_path
        self.insight_map = {}  # hash -> first occurrence
        self.exact_duplicates = []  # list of duplicate insight info
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

    def get_file_priority(self, file_path: str) -> int:
        """Get priority score for file (higher = keep this one)"""
        file_name = os.path.basename(file_path)
        if "original" in file_name or (
            "advanced" not in file_name and "multiplied" not in file_name
        ):
            return 3  # Highest priority
        elif "advanced" in file_name:
            return 2  # Medium priority
        elif "multiplied" in file_name:
            return 1  # Lowest priority
        return 2  # Default medium

    def process_file(self, file_path: str):
        """Process a single file and find duplicates"""
        try:
            print(f"📄 Processing {os.path.basename(file_path)}")

            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            file_duplicates = []
            modified = False

            # Process based on file structure
            if self.is_number_file(file_path):
                modified = self.process_number_file(data, file_path, file_duplicates)
            elif self.is_zodiac_file(file_path):
                modified = self.process_zodiac_file(data, file_path, file_duplicates)
            elif self.is_planetary_file(file_path):
                modified = self.process_planetary_file(data, file_path, file_duplicates)

            # Save if modified
            if modified:
                with open(file_path, "w", encoding="utf-8") as f:
                    json.dump(data, f, indent=2, ensure_ascii=False)
                self.files_modified.add(file_path)
                print(f"   ✅ Modified: {len(file_duplicates)} duplicates removed")
            else:
                print("   ✅ Clean: No duplicates found")

        except Exception as e:
            print(f"❌ Error processing {file_path}: {e}")

    def is_number_file(self, file_path: str) -> bool:
        return "NumberMeanings" in file_path

    def is_zodiac_file(self, file_path: str) -> bool:
        return "ZodiacMeanings" in file_path

    def is_planetary_file(self, file_path: str) -> bool:
        return "PlanetaryMeanings" in file_path

    def process_number_file(self, data: dict, file_path: str, file_duplicates: list) -> bool:
        """Process number meanings file"""
        modified = False
        file_priority = self.get_file_priority(file_path)

        for number_key, number_data in data.items():
            if isinstance(number_data, dict):
                for section, insights in number_data.items():
                    if isinstance(insights, list):
                        # Process insight array
                        new_insights = []
                        for insight in insights:
                            if isinstance(insight, str):
                                insight_hash = self.get_text_hash(insight)

                                if insight_hash in self.insight_map:
                                    # Duplicate found
                                    existing = self.insight_map[insight_hash]
                                    if file_priority > existing["priority"]:
                                        # Current file has higher priority, remove from existing
                                        print("   🔄 Priority switch: keeping current version")
                                        new_insights.append(insight)
                                        self.insight_map[insight_hash] = {
                                            "file": file_path,
                                            "text": insight,
                                            "priority": file_priority,
                                        }
                                    else:
                                        # Skip this duplicate (existing has higher priority)
                                        print(f"   🗑️  Removing: {insight[:50]}...")
                                        file_duplicates.append(insight)
                                        self.duplicates_removed += 1
                                        modified = True
                                else:
                                    # Not a duplicate, keep it
                                    new_insights.append(insight)
                                    self.insight_map[insight_hash] = {
                                        "file": file_path,
                                        "text": insight,
                                        "priority": file_priority,
                                    }

                        # Update the insights array
                        if len(new_insights) != len(insights):
                            number_data[section] = new_insights
                            modified = True

        return modified

    def process_zodiac_file(self, data: dict, file_path: str, file_duplicates: list) -> bool:
        """Process zodiac insights file"""
        modified = False
        file_priority = self.get_file_priority(file_path)

        if "categories" in data:
            for category_name, category_data in data["categories"].items():
                if "insights" in category_data and isinstance(category_data["insights"], list):
                    new_insights = []

                    for insight_obj in category_data["insights"]:
                        if isinstance(insight_obj, dict) and "insight" in insight_obj:
                            insight_text = insight_obj["insight"]
                            insight_hash = self.get_text_hash(insight_text)

                            if insight_hash in self.insight_map:
                                # Duplicate found
                                existing = self.insight_map[insight_hash]
                                if file_priority > existing["priority"]:
                                    # Keep current, mark existing for removal
                                    new_insights.append(insight_obj)
                                    self.insight_map[insight_hash] = {
                                        "file": file_path,
                                        "text": insight_text,
                                        "priority": file_priority,
                                    }
                                else:
                                    # Skip this duplicate
                                    print(f"   🗑️  Removing: {insight_text[:50]}...")
                                    file_duplicates.append(insight_text)
                                    self.duplicates_removed += 1
                                    modified = True
                            else:
                                # Not a duplicate, keep it
                                new_insights.append(insight_obj)
                                self.insight_map[insight_hash] = {
                                    "file": file_path,
                                    "text": insight_text,
                                    "priority": file_priority,
                                }

                    # Update insights array
                    if len(new_insights) != len(category_data["insights"]):
                        category_data["insights"] = new_insights
                        modified = True

        return modified

    def process_planetary_file(self, data: dict, file_path: str, file_duplicates: list) -> bool:
        """Process planetary insights file (same structure as zodiac)"""
        return self.process_zodiac_file(data, file_path, file_duplicates)

    def scan_and_eliminate_duplicates(self):
        """Scan all files and eliminate duplicates in one pass"""
        print("🔍 Fast duplicate scanning and elimination...")

        directories = [
            "NumerologyData/FirebaseNumberMeanings",
            "NumerologyData/FirebaseZodiacMeanings",
            "NumerologyData/FirebasePlanetaryMeanings",
        ]

        total_files = 0

        # Process files in priority order (original first, then advanced, then multiplied)
        file_order = []

        for directory in directories:
            full_dir = os.path.join(self.base_path, directory)
            if not os.path.exists(full_dir):
                print(f"⚠️  Directory not found: {full_dir}")
                continue

            json_files = glob.glob(os.path.join(full_dir, "*.json"))

            # Sort by priority (original first)
            json_files.sort(key=lambda f: (-self.get_file_priority(f), f))
            file_order.extend(json_files)

        print(f"📁 Processing {len(file_order)} files in priority order...")

        for file_path in file_order:
            self.process_file(file_path)
            total_files += 1

        print(f"\n✅ SCAN COMPLETE: {total_files} files processed")

    def generate_report(self) -> str:
        """Generate duplicate elimination report"""
        report = []
        report.append("🔍 FAST DUPLICATE ELIMINATION REPORT")
        report.append("=" * 50)

        report.append("\n📊 RESULTS:")
        report.append(
            f"   📁 Files processed: {len(glob.glob(os.path.join(self.base_path, 'NumerologyData/Firebase*/*.json')))}"
        )
        report.append(f"   💭 Unique insights tracked: {len(self.insight_map)}")
        report.append(f"   🗑️  Duplicates eliminated: {self.duplicates_removed}")
        report.append(f"   📝 Files modified: {len(self.files_modified)}")

        if self.files_modified:
            report.append("\n📁 MODIFIED FILES:")
            for file_path in sorted(self.files_modified):
                report.append(f"   📄 {os.path.basename(file_path)}")

        # Calculate uniqueness score
        total_insights = len(self.insight_map) + self.duplicates_removed
        uniqueness_score = (
            (len(self.insight_map) / total_insights) * 100 if total_insights > 0 else 100
        )

        report.append(f"\n🏆 FINAL UNIQUENESS SCORE: {uniqueness_score:.1f}%")
        report.append(f"   💭 Unique insights: {len(self.insight_map)}")
        report.append(f"   🗑️  Duplicates removed: {self.duplicates_removed}")

        return "\n".join(report)

    def run(self) -> str:
        """Run the fast duplicate detection and elimination"""
        print("🤖 FAST DUPLICATE DETECTION AGENT ACTIVATED")
        print("=" * 50)

        self.scan_and_eliminate_duplicates()
        return self.generate_report()


def main():
    base_path = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP"

    detector = FastDuplicateDetector(base_path)
    report = detector.run()

    print("\n" + report)

    # Save report
    report_path = os.path.join(base_path, "fast_duplicate_elimination_report.txt")
    with open(report_path, "w", encoding="utf-8") as f:
        f.write(report)

    print(f"\n📄 Report saved to: {report_path}")


if __name__ == "__main__":
    main()
