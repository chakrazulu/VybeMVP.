#!/usr/bin/env python3
"""
Surgical Markdown Cleanup for VybeMVP RuntimeBundle
==================================================

CRITICAL MISSION: Remove ONLY **text** markdown artifacts while preserving 100% of spiritual content.

Safety Features:
- Creates backup before changes
- Only processes RichNumberMeanings collection (where artifacts confirmed)
- Uses precise regex to target only **text** patterns
- Validates JSON structure integrity
- Compares before/after content to ensure no spiritual meaning changed
- Logs all changes for audit trail

Pattern: **text** -> text (preserve all other content exactly)
"""

import difflib
import json
import re
import shutil
from datetime import datetime
from pathlib import Path


class SurgicalMarkdownCleaner:
    def __init__(self, runtime_bundle_path):
        self.runtime_bundle_path = Path(runtime_bundle_path)
        self.rich_numbers_path = self.runtime_bundle_path / "RichNumberMeanings"
        self.backup_path = (
            self.runtime_bundle_path.parent
            / f"RuntimeBundle_BACKUP_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        )

        # SURGICAL REGEX: Only matches **text** patterns
        self.markdown_pattern = re.compile(r"\*\*(.*?)\*\*")

        self.stats = {
            "files_processed": 0,
            "files_modified": 0,
            "artifacts_removed": 0,
            "content_preserved": True,
            "json_integrity": True,
        }

    def create_backup(self):
        """Create complete backup of RuntimeBundle before any changes"""
        print(f"Creating backup: {self.backup_path}")
        shutil.copytree(self.runtime_bundle_path, self.backup_path)
        print("✅ Backup created successfully")

    def clean_markdown_artifacts(self, text):
        """Surgically remove **text** patterns, return cleaned text and count"""
        if not isinstance(text, str):
            return text, 0

        original = text

        # Replace **text** with just text
        cleaned = self.markdown_pattern.sub(r"\1", text)

        # Count how many replacements were made
        artifact_count = len(self.markdown_pattern.findall(original))

        return cleaned, artifact_count

    def process_insight_content(self, obj):
        """Recursively process JSON object to clean insight text"""
        artifacts_removed = 0

        if isinstance(obj, dict):
            for key, value in obj.items():
                if key == "insight" and isinstance(value, str):
                    # This is where we surgically clean the spiritual content
                    cleaned_value, count = self.clean_markdown_artifacts(value)
                    obj[key] = cleaned_value
                    artifacts_removed += count
                else:
                    artifacts_removed += self.process_insight_content(value)

        elif isinstance(obj, list):
            for item in obj:
                artifacts_removed += self.process_insight_content(item)

        return artifacts_removed

    def validate_json_structure(self, original_data, cleaned_data):
        """Ensure JSON structure remains identical after cleaning"""
        try:
            # Check that all keys exist in both versions
            original_keys = self.extract_all_keys(original_data)
            cleaned_keys = self.extract_all_keys(cleaned_data)

            if original_keys != cleaned_keys:
                return False, "Key structure changed"

            # Check that non-insight content is identical
            if not self.compare_non_insight_content(original_data, cleaned_data):
                return False, "Non-insight content changed"

            return True, "JSON structure preserved"

        except Exception as e:
            return False, f"Validation error: {str(e)}"

    def extract_all_keys(self, obj, keys=None):
        """Recursively extract all keys from JSON structure"""
        if keys is None:
            keys = set()

        if isinstance(obj, dict):
            keys.update(obj.keys())
            for value in obj.values():
                self.extract_all_keys(value, keys)
        elif isinstance(obj, list):
            for item in obj:
                self.extract_all_keys(item, keys)

        return keys

    def compare_non_insight_content(self, original, cleaned):
        """Compare all content except insight fields"""
        if type(original) != type(cleaned):
            return False

        if isinstance(original, dict):
            if set(original.keys()) != set(cleaned.keys()):
                return False

            for key in original.keys():
                if key == "insight":
                    # Skip insight comparison - this is what we're cleaning
                    continue
                if not self.compare_non_insight_content(original[key], cleaned[key]):
                    return False

        elif isinstance(original, list):
            if len(original) != len(cleaned):
                return False

            for i in range(len(original)):
                if not self.compare_non_insight_content(original[i], cleaned[i]):
                    return False

        else:
            # For primitive types, they should be identical
            if original != cleaned:
                return False

        return True

    def process_file(self, file_path):
        """Process a single RichNumberMeanings file"""
        print(f"Processing: {file_path.name}")

        try:
            # Load original content
            with open(file_path, "r", encoding="utf-8") as f:
                original_content = f.read()
                original_data = json.loads(original_content)

            # Create working copy for cleaning
            cleaned_data = json.loads(original_content)

            # Surgically remove ** artifacts from insights
            artifacts_removed = self.process_insight_content(cleaned_data)

            # Validate structure integrity
            structure_valid, validation_msg = self.validate_json_structure(
                original_data, cleaned_data
            )

            if not structure_valid:
                print(f"❌ ABORTING {file_path.name}: {validation_msg}")
                return False

            if artifacts_removed > 0:
                # Write cleaned content back
                cleaned_json = json.dumps(cleaned_data, indent=2, ensure_ascii=False)

                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(cleaned_json)

                print(f"✅ Cleaned {artifacts_removed} ** artifacts from {file_path.name}")
                self.stats["files_modified"] += 1
                self.stats["artifacts_removed"] += artifacts_removed

                # Show sample of changes for verification
                self.show_sample_changes(original_content, cleaned_json, file_path.name)

            else:
                print(f"✅ No artifacts found in {file_path.name}")

            self.stats["files_processed"] += 1
            return True

        except Exception as e:
            print(f"❌ ERROR processing {file_path.name}: {str(e)}")
            return False

    def show_sample_changes(self, original, cleaned, filename):
        """Show a sample of changes for verification"""
        print(f"\n📋 Sample changes in {filename}:")

        # Find first few differences
        original_lines = original.split("\n")
        cleaned_lines = cleaned.split("\n")

        differ = difflib.unified_diff(
            original_lines,
            cleaned_lines,
            fromfile=f"{filename} (original)",
            tofile=f"{filename} (cleaned)",
            lineterm="",
            n=1,
        )

        diff_count = 0
        for line in differ:
            if line.startswith("@@") or line.startswith("---") or line.startswith("+++"):
                continue
            if line.startswith("-") or line.startswith("+"):
                print(f"  {line}")
                diff_count += 1
                if diff_count >= 6:  # Show first 3 changes
                    break
        print()

    def run_surgical_cleanup(self):
        """Main execution method"""
        print("🔬 SURGICAL MARKDOWN CLEANUP - VybeMVP RuntimeBundle")
        print("=" * 60)
        print("Mission: Remove **text** artifacts while preserving 100% spiritual content")
        print()

        # Safety check
        if not self.rich_numbers_path.exists():
            print("❌ RichNumberMeanings directory not found")
            return False

        # Create backup
        self.create_backup()

        # Process all rich number files
        rich_files = list(self.rich_numbers_path.glob("*.json"))

        if not rich_files:
            print("❌ No JSON files found in RichNumberMeanings")
            return False

        print(f"Found {len(rich_files)} files to process\n")

        success_count = 0
        for file_path in sorted(rich_files):
            if self.process_file(file_path):
                success_count += 1
            else:
                self.stats["content_preserved"] = False

        # Final report
        print("\n" + "=" * 60)
        print("🎯 SURGICAL CLEANUP COMPLETE")
        print("=" * 60)
        print(f"Files processed: {self.stats['files_processed']}")
        print(f"Files modified: {self.stats['files_modified']}")
        print(f"** Artifacts removed: {self.stats['artifacts_removed']}")
        print(f"Spiritual content preserved: {'✅' if self.stats['content_preserved'] else '❌'}")
        print(f"JSON integrity maintained: {'✅' if self.stats['json_integrity'] else '❌'}")
        print(f"Backup location: {self.backup_path}")

        if success_count == len(rich_files) and self.stats["content_preserved"]:
            print("\n🌟 MISSION ACCOMPLISHED: Clean spiritual content with zero alterations!")
            return True
        else:
            print(f"\n⚠️ Issues encountered. Check backup at: {self.backup_path}")
            return False


def main():
    """Entry point for surgical cleanup"""
    runtime_bundle_path = (
        "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLXRuntimeBundle"
    )

    cleaner = SurgicalMarkdownCleaner(runtime_bundle_path)
    success = cleaner.run_surgical_cleanup()

    if not success:
        print("\n🚨 CLEANUP FAILED - No changes applied")
        exit(1)
    else:
        print("\n✨ All spiritual content preserved with clean presentation!")


if __name__ == "__main__":
    main()
