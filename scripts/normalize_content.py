#!/usr/bin/env python3
"""
VybeMVP Content Normalizer v2.1.4
==================================

PURPOSE:
Normalizes legacy content and Claude-generated files to bulletproof schema compliance.
Fixes snake_case violations, removes artifacts, and ensures consistency.

FEATURES:
- 🐍 Snake_case normalization for all identifiers
- 🧹 Claude artifact removal (oai_citation, broken URLs)
- 📐 Apostrophe and special character handling
- 🔧 Batch processing for entire directories
- 🛡️ Safe backup and recovery options

USAGE:
python3 scripts/normalize_content.py                                    # Normalize all
python3 scripts/normalize_content.py KASPERMLX/MLXTraining/ContentRefinery  # Specific dir
python3 scripts/normalize_content.py --backup                           # Create backups
python3 scripts/normalize_content.py --dry-run                          # Preview changes

Author: KASPER MLX Team
Date: August 2025
Version: 2.1.4 - Bulletproof Content Normalization
"""

import argparse
import json
import pathlib
import re
import shutil
import sys
from typing import Any, Dict


class ContentNormalizer:
    """
    Bulletproof content normalizer for VybeMVP spiritual content.

    Transforms legacy and Claude-generated content into schema-compliant,
    production-ready JSON files with consistent formatting and structure.
    """

    def __init__(self, create_backups: bool = False, dry_run: bool = False):
        """Initialize normalizer with processing options."""
        self.create_backups = create_backups
        self.dry_run = dry_run
        self.stats = {
            "files_processed": 0,
            "files_normalized": 0,
            "snake_case_fixes": 0,
            "artifact_removals": 0,
            "backups_created": 0,
        }

        # Snake_case transformation regex
        self.snake_pattern = re.compile(r"[^a-z0-9_]+")

        # Claude artifact patterns to remove
        self.claude_artifacts = [
            r"oai_citation:\d+",  # OpenAI citation fragments
            r'com/articles/[^"\s]*',  # Broken article URLs
            r"\[oai_citation:\d+\]",  # Bracketed citations
            r"【\d+†source】",  # Formatted citations
            r"Source: \[.*?\]\(https?://[^)]*\)",  # Markdown source links
            r"References?:\s*\n.*?(?=\n\n|\Z)",  # Reference sections
        ]

    def snake_case(self, text: str) -> str:
        """
        Convert text to snake_case following VybeMVP standards.

        Handles special spiritual terms and maintains readability:
        - "11:11 Portal" → "portal_11_11"
        - "Da'at Meditation" → "daath_meditation"
        - "DNA Activation" → "dna_activation"
        """
        if not text:
            return text

        # Handle special cases first
        special_cases = {
            "11:11": "11_11",
            "da'at": "daath",  # curly apostrophe
            "DNA": "dna",
            "ROI": "roi",
            "AI": "ai",
            "UI": "ui",
            "API": "api",
        }

        normalized = text.lower()

        # Apply special case replacements
        for old, new in special_cases.items():
            normalized = normalized.replace(old.lower(), new)

        # Remove apostrophes and special characters
        normalized = normalized.replace("'", "").replace("'", "")
        normalized = normalized.replace(":", "_")

        # Convert non-alphanumeric to underscores
        normalized = re.sub(r"[^a-z0-9_]", "_", normalized)

        # Clean up multiple underscores and trim
        normalized = re.sub(r"__+", "_", normalized).strip("_")

        return normalized

    def clean_claude_artifacts(self, text: str) -> tuple[str, int]:
        """Remove Claude artifacts from text and return cleaned text + removal count."""
        cleaned = text
        removals = 0

        for pattern in self.claude_artifacts:
            original_cleaned = cleaned
            cleaned = re.sub(pattern, "", cleaned, flags=re.MULTILINE | re.DOTALL)
            if cleaned != original_cleaned:
                removals += 1

        # Clean up extra whitespace caused by removals
        cleaned = re.sub(r"\n\s*\n\s*\n", "\n\n", cleaned)
        cleaned = re.sub(r"[ \t]+\n", "\n", cleaned)
        cleaned = cleaned.strip()

        return cleaned, removals

    def normalize_file(self, file_path: pathlib.Path) -> bool:
        """
        Normalize a single rich content file.

        Returns True if file was modified, False if no changes needed.
        """
        try:
            # Read current content
            with open(file_path, "r", encoding="utf-8") as f:
                original_content = f.read()

            # Parse JSON
            data = json.loads(original_content)

            # Track changes
            changes_made = False
            local_snake_fixes = 0
            local_artifact_removals = 0

            # Clean Claude artifacts from raw content
            cleaned_content, artifact_count = self.clean_claude_artifacts(original_content)
            if artifact_count > 0:
                local_artifact_removals = artifact_count
                changes_made = True
                # Re-parse cleaned content
                data = json.loads(cleaned_content)

            # Normalize snake_case fields
            if self.normalize_snake_case_fields(data):
                changes_made = True
                local_snake_fixes += 1

            # Only write if changes were made
            if changes_made and not self.dry_run:
                # Create backup if requested
                if self.create_backups:
                    backup_path = file_path.with_suffix(".json.backup")
                    shutil.copy2(file_path, backup_path)
                    self.stats["backups_created"] += 1

                # Write normalized content
                with open(file_path, "w", encoding="utf-8") as f:
                    json.dump(data, f, indent=2, ensure_ascii=False)

                self.stats["snake_case_fixes"] += local_snake_fixes
                self.stats["artifact_removals"] += local_artifact_removals

            self.stats["files_processed"] += 1
            if changes_made:
                self.stats["files_normalized"] += 1

                print(f"{'[DRY RUN] ' if self.dry_run else ''}✅ Normalized {file_path.name}")
                if local_snake_fixes > 0:
                    print(f"  🐍 Fixed {local_snake_fixes} snake_case issues")
                if local_artifact_removals > 0:
                    print(f"  🧹 Removed {local_artifact_removals} Claude artifacts")
            else:
                print(f"✨ {file_path.name} already compliant")

            return changes_made

        except json.JSONDecodeError as e:
            print(f"❌ Invalid JSON in {file_path.name}: {e}")
            return False
        except Exception as e:
            print(f"❌ Error processing {file_path.name}: {e}")
            return False

    def normalize_snake_case_fields(self, data: Dict[str, Any]) -> bool:
        """Normalize snake_case fields in the JSON data structure."""
        changes_made = False

        # Normalize top-level fields
        if "behavioral_category" in data:
            original = data["behavioral_category"]
            normalized = self.snake_case(original)
            if original != normalized:
                data["behavioral_category"] = normalized
                changes_made = True

        # Normalize behavioral insights
        if "behavioral_insights" in data:
            for insight in data["behavioral_insights"]:
                # Normalize category
                if "category" in insight:
                    original = insight["category"]
                    normalized = self.snake_case(original)
                    if original != normalized:
                        insight["category"] = normalized
                        changes_made = True

                # Normalize array fields
                for field in ["triggers", "supports", "challenges"]:
                    if field in insight and isinstance(insight[field], list):
                        original_array = insight[field][:]
                        insight[field] = [self.snake_case(item) for item in insight[field]]
                        if original_array != insight[field]:
                            changes_made = True

        # Normalize meta section
        if "meta" in data:
            meta = data["meta"]

            # Normalize archetype
            if "archetype" in meta:
                original = meta["archetype"]
                normalized = self.snake_case(original)
                if original != normalized:
                    meta["archetype"] = normalized
                    changes_made = True

            # Normalize keywords
            if "keywords" in meta and isinstance(meta["keywords"], list):
                original_keywords = meta["keywords"][:]
                meta["keywords"] = [self.snake_case(keyword) for keyword in meta["keywords"]]
                if original_keywords != meta["keywords"]:
                    changes_made = True

        return changes_made

    def normalize_directory(self, directory: pathlib.Path) -> None:
        """Normalize all *_rich.json files in a directory recursively."""
        print(f"🔍 Scanning {directory} for rich content files...")

        # Find all rich content files
        rich_files = list(directory.rglob("*_rich.json"))

        if not rich_files:
            print("⚠️  No *_rich.json files found")
            return

        print(f"📁 Found {len(rich_files)} files to process")
        if self.dry_run:
            print("🧪 Running in DRY RUN mode - no files will be modified")

        # Process each file
        for file_path in sorted(rich_files):
            self.normalize_file(file_path)

        # Print summary
        self.print_summary()

    def print_summary(self) -> None:
        """Print processing summary statistics."""
        print("\n" + "=" * 60)
        print("📊 CONTENT NORMALIZATION SUMMARY")
        print("=" * 60)
        print(f"Files processed: {self.stats['files_processed']}")
        print(f"Files normalized: {self.stats['files_normalized']}")
        print(f"Snake_case fixes: {self.stats['snake_case_fixes']}")
        print(f"Artifact removals: {self.stats['artifact_removals']}")

        if self.create_backups:
            print(f"Backups created: {self.stats['backups_created']}")

        if self.stats["files_normalized"] > 0:
            print(f"\n✅ Normalization {'would be ' if self.dry_run else ''}complete!")
            if not self.dry_run:
                print("💡 Run the content linter to verify compliance:")
                print("   python3 scripts/lint_rich_content.py")
        else:
            print("\n✨ All files already compliant - no changes needed!")


def main():
    """Main entry point for the content normalizer."""
    parser = argparse.ArgumentParser(
        description="VybeMVP Content Normalizer v2.1.4",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python3 scripts/normalize_content.py                                    # Normalize all
  python3 scripts/normalize_content.py KASPERMLX/MLXTraining/ContentRefinery  # Specific dir
  python3 scripts/normalize_content.py --backup                           # Create backups
  python3 scripts/normalize_content.py --dry-run                          # Preview changes
        """,
    )

    parser.add_argument(
        "directory",
        nargs="?",
        default=".",
        help="Directory to scan for *_rich.json files (default: current directory)",
    )
    parser.add_argument(
        "--backup", action="store_true", help="Create .backup files before modifying originals"
    )
    parser.add_argument(
        "--dry-run", action="store_true", help="Preview changes without modifying files"
    )

    args = parser.parse_args()

    # Validate directory
    directory = pathlib.Path(args.directory)
    if not directory.exists():
        print(f"❌ Directory not found: {directory}")
        sys.exit(1)

    if not directory.is_dir():
        print(f"❌ Path is not a directory: {directory}")
        sys.exit(1)

    # Create normalizer and process
    print("🔄 VybeMVP Content Normalizer v2.1.4")
    print("=" * 50)

    normalizer = ContentNormalizer(create_backups=args.backup, dry_run=args.dry_run)

    normalizer.normalize_directory(directory)


if __name__ == "__main__":
    main()
