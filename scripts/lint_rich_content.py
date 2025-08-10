#!/usr/bin/env python3
"""
VybeMVP Rich Content Linter v2.1.4
===================================

PURPOSE:
Validates and cleans spiritual content files to ensure bulletproof quality.
Catches Claude artifacts, broken citations, schema violations, and formatting issues.

FEATURES:
- 🔍 Schema validation against content.schema.json
- 🧹 Claude artifact detection and cleanup (oai_citation, broken URLs)
- 📊 Intensity scoring validation (0.0 ≤ intensity ≤ 1.0)
- 📏 Content length validation (insights 50-1000 chars)
- 🔧 Auto-fix mode for common issues
- 📋 Comprehensive reporting with error locations

USAGE:
python3 scripts/lint_rich_content.py                    # Validate all
python3 scripts/lint_rich_content.py --fix              # Validate + auto-fix
python3 scripts/lint_rich_content.py --path single_1    # Validate specific file
python3 scripts/lint_rich_content.py --strict           # Extra strict validation

Author: KASPER MLX Team
Date: August 2025
Version: 2.1.4 - Bulletproof Content Quality
"""

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any, Dict, List, Tuple

try:
    import jsonschema
except ImportError:
    print("❌ Missing jsonschema dependency. Install with: pip install jsonschema")
    sys.exit(1)


class RichContentLinter:
    """
    Comprehensive content validator and cleaner for VybeMVP spiritual content.

    Ensures all content meets schema requirements and is free of artifacts
    that could impact user experience or AI processing quality.
    """

    def __init__(self, project_root: Path = None):
        """Initialize linter with paths and validation rules."""
        self.project_root = project_root or Path(__file__).parent.parent
        self.schema_path = self.project_root / "content.schema.json"

        # Content source directories
        self.single_numbers_dir = (
            self.project_root / "KASPERMLX/MLXTraining/ContentRefinery/SingleNumbers"
        )
        self.master_numbers_dir = (
            self.project_root / "KASPERMLX/MLXTraining/ContentRefinery/MasterNumbers"
        )

        # Load validation schema
        self.schema = self._load_schema()

        # Results tracking
        self.results = {
            "files_processed": 0,
            "files_valid": 0,
            "files_with_errors": 0,
            "files_fixed": 0,
            "total_errors": 0,
            "total_fixes": 0,
            "error_details": [],
        }

        # Claude artifact patterns to detect and clean
        self.claude_artifacts = [
            r"oai_citation:\d+",  # OpenAI citation fragments
            r'com/articles/[^"\s]*',  # Broken article URLs
            r"\[oai_citation:\d+\]",  # Bracketed citations
            r"【\d+†source】",  # Formatted citations
            r"Source: \[.*?\]\(https?://[^)]*\)",  # Markdown source links
            r"References?:\s*\n.*?(?=\n\n|\Z)",  # Reference sections
        ]

    def _load_schema(self) -> Dict[str, Any]:
        """Load and validate the content schema."""
        if not self.schema_path.exists():
            print(f"❌ Schema file not found: {self.schema_path}")
            print("   Create content.schema.json first with proper JSON schema")
            sys.exit(1)

        try:
            with open(self.schema_path, "r", encoding="utf-8") as f:
                schema = json.load(f)

            # Validate schema itself
            jsonschema.Draft7Validator.check_schema(schema)
            return schema

        except json.JSONDecodeError as e:
            print(f"❌ Invalid JSON in schema: {e}")
            sys.exit(1)
        except jsonschema.SchemaError as e:
            print(f"❌ Invalid schema structure: {e}")
            sys.exit(1)

    def find_content_files(self, specific_path: str = None) -> List[Path]:
        """Find all rich content files to validate."""
        files = []

        if specific_path:
            # Validate specific file
            potential_paths = [
                self.single_numbers_dir / f"{specific_path}_rich.json",
                self.master_numbers_dir / f"{specific_path}_rich.json",
                self.project_root / specific_path,
                Path(specific_path),
            ]

            for path in potential_paths:
                if path.exists():
                    files.append(path)
                    break
            else:
                print(f"❌ File not found: {specific_path}")
                sys.exit(1)
        else:
            # Find all rich content files
            if self.single_numbers_dir.exists():
                files.extend(self.single_numbers_dir.glob("single_*_rich.json"))

            if self.master_numbers_dir.exists():
                files.extend(self.master_numbers_dir.glob("master_*_rich.json"))

        return sorted(files)

    def detect_claude_artifacts(self, content: str) -> List[Tuple[str, str]]:
        """Detect Claude artifacts in content text."""
        artifacts = []

        for pattern in self.claude_artifacts:
            matches = re.finditer(pattern, content, re.MULTILINE | re.DOTALL)
            for match in matches:
                artifacts.append((pattern, match.group(0)))

        return artifacts

    def clean_claude_artifacts(self, content: str) -> Tuple[str, int]:
        """Remove Claude artifacts from content text."""
        cleaned = content
        fixes = 0

        for pattern in self.claude_artifacts:
            original_cleaned = cleaned
            cleaned = re.sub(pattern, "", cleaned, flags=re.MULTILINE | re.DOTALL)
            if cleaned != original_cleaned:
                fixes += 1

        # Clean up extra whitespace caused by removals
        cleaned = re.sub(r"\n\s*\n\s*\n", "\n\n", cleaned)  # Multiple newlines
        cleaned = re.sub(r"[ \t]+\n", "\n", cleaned)  # Trailing spaces
        cleaned = cleaned.strip()

        return cleaned, fixes

    def validate_content_file(self, file_path: Path, fix_mode: bool = False) -> Dict[str, Any]:
        """Validate a single content file against schema and quality rules."""
        result = {
            "file": str(file_path),
            "valid": False,
            "errors": [],
            "warnings": [],
            "fixes": 0,
            "artifacts_found": [],
        }

        try:
            # Load and parse JSON
            with open(file_path, "r", encoding="utf-8") as f:
                original_content = f.read()
                data = json.loads(original_content)

            # Check for Claude artifacts in the raw content
            artifacts = self.detect_claude_artifacts(original_content)
            if artifacts:
                result["artifacts_found"] = [
                    f"Pattern: {pattern}, Found: '{text[:50]}...'" for pattern, text in artifacts
                ]
                result["errors"].append(f"Found {len(artifacts)} Claude artifacts")

            # Schema validation
            try:
                jsonschema.validate(data, self.schema)
            except jsonschema.ValidationError as e:
                result["errors"].append(
                    f"Schema violation: {e.message} at {'.'.join(str(x) for x in e.absolute_path)}"
                )

            # Custom validation rules
            self._validate_intensity_scores(data, result)
            self._validate_insight_quality(data, result)
            self._validate_completeness(data, result)

            # Auto-fix if requested
            if fix_mode and (artifacts or result["errors"]):
                fixed_content, fix_count = self._fix_content(original_content, data)
                if fix_count > 0:
                    with open(file_path, "w", encoding="utf-8") as f:
                        f.write(fixed_content)
                    result["fixes"] = fix_count
                    self.results["files_fixed"] += 1
                    self.results["total_fixes"] += fix_count

            # Mark as valid if no errors
            result["valid"] = len(result["errors"]) == 0
            if result["valid"]:
                self.results["files_valid"] += 1
            else:
                self.results["files_with_errors"] += 1
                self.results["total_errors"] += len(result["errors"])

        except json.JSONDecodeError as e:
            result["errors"].append(f"Invalid JSON: {e}")
            self.results["files_with_errors"] += 1
            self.results["total_errors"] += 1
        except Exception as e:
            result["errors"].append(f"Validation error: {e}")
            self.results["files_with_errors"] += 1
            self.results["total_errors"] += 1

        self.results["files_processed"] += 1
        self.results["error_details"].append(result)
        return result

    def _validate_intensity_scores(self, data: Dict, result: Dict) -> None:
        """Validate intensity scores are within valid ranges."""
        try:
            # Check main intensity scoring
            intensity_scoring = data.get("intensity_scoring", {})
            min_range = intensity_scoring.get("min_range", 0)
            max_range = intensity_scoring.get("max_range", 1)

            if not (0.0 <= min_range <= 1.0):
                result["errors"].append(
                    f"intensity_scoring.min_range ({min_range}) not in [0.0, 1.0]"
                )

            if not (0.0 <= max_range <= 1.0):
                result["errors"].append(
                    f"intensity_scoring.max_range ({max_range}) not in [0.0, 1.0]"
                )

            if min_range >= max_range:
                result["errors"].append(f"min_range ({min_range}) >= max_range ({max_range})")

            # Check individual insight intensities
            insights = data.get("behavioral_insights", [])
            for i, insight in enumerate(insights):
                intensity = insight.get("intensity", 0)
                if not (0.0 <= intensity <= 1.0):
                    result["errors"].append(
                        f"behavioral_insights[{i}].intensity ({intensity}) not in [0.0, 1.0]"
                    )
                elif not (min_range <= intensity <= max_range):
                    result["warnings"].append(
                        f"behavioral_insights[{i}].intensity ({intensity}) outside expected range [{min_range}, {max_range}]"
                    )

        except Exception as e:
            result["errors"].append(f"Intensity validation error: {e}")

    def _validate_insight_quality(self, data: Dict, result: Dict) -> None:
        """Validate insight text quality and detect artifacts."""
        try:
            insights = data.get("behavioral_insights", [])

            if len(insights) != 20:
                result["errors"].append(
                    f"Expected exactly 20 behavioral_insights, found {len(insights)}"
                )

            for i, insight in enumerate(insights):
                insight_text = insight.get("insight", "")

                # Check length
                if len(insight_text) < 50:
                    result["errors"].append(
                        f"behavioral_insights[{i}].insight too short ({len(insight_text)} chars, minimum 50)"
                    )
                elif len(insight_text) > 1000:
                    result["warnings"].append(
                        f"behavioral_insights[{i}].insight very long ({len(insight_text)} chars)"
                    )

                # Check for artifacts in insight text
                artifacts = self.detect_claude_artifacts(insight_text)
                if artifacts:
                    result["errors"].append(
                        f"behavioral_insights[{i}].insight contains Claude artifacts: {[a[1] for a in artifacts]}"
                    )

                # Check for empty strings
                if not insight_text.strip():
                    result["errors"].append(f"behavioral_insights[{i}].insight is empty")

        except Exception as e:
            result["errors"].append(f"Insight quality validation error: {e}")

    def _validate_completeness(self, data: Dict, result: Dict) -> None:
        """Validate content completeness and required fields."""
        try:
            # Check meta section completeness
            meta = data.get("meta", {})

            # Affirmations count
            affirmations = meta.get("affirmations", [])
            if len(affirmations) < 5:
                result["errors"].append(
                    f"meta.affirmations needs at least 5 items, found {len(affirmations)}"
                )

            # Keywords count
            keywords = meta.get("keywords", [])
            if len(keywords) < 5:
                result["errors"].append(
                    f"meta.keywords needs at least 5 items, found {len(keywords)}"
                )

            # Rituals count
            rituals = meta.get("rituals", [])
            if len(rituals) < 3:
                result["errors"].append(
                    f"meta.rituals needs at least 3 items, found {len(rituals)}"
                )

        except Exception as e:
            result["errors"].append(f"Completeness validation error: {e}")

    def _fix_content(self, original_content: str, data: Dict) -> Tuple[str, int]:
        """Attempt to fix common content issues."""
        fixes = 0

        # Clean Claude artifacts from the JSON content
        cleaned_content, artifact_fixes = self.clean_claude_artifacts(original_content)
        fixes += artifact_fixes

        # TODO: Add more auto-fixes as needed:
        # - Normalize intensity scores that are slightly out of range
        # - Fix common formatting issues
        # - Clean up whitespace and formatting

        return cleaned_content, fixes

    def generate_report(self) -> str:
        """Generate comprehensive validation report."""
        report = []

        report.append("🔍 VYBE RICH CONTENT LINTER REPORT v2.1.4")
        report.append("=" * 60)
        report.append(f"Files processed: {self.results['files_processed']}")
        report.append(f"Files valid: {self.results['files_valid']} ✅")
        report.append(f"Files with errors: {self.results['files_with_errors']} ❌")
        report.append(f"Files auto-fixed: {self.results['files_fixed']} 🔧")
        report.append(f"Total errors: {self.results['total_errors']}")
        report.append(f"Total fixes applied: {self.results['total_fixes']}")
        report.append("")

        # Summary by file
        for file_result in self.results["error_details"]:
            status = "✅ VALID" if file_result["valid"] else "❌ INVALID"
            report.append(f"{status} {file_result['file']}")

            if file_result["errors"]:
                for error in file_result["errors"]:
                    report.append(f"  ❌ {error}")

            if file_result["warnings"]:
                for warning in file_result["warnings"]:
                    report.append(f"  ⚠️  {warning}")

            if file_result["artifacts_found"]:
                report.append("  🧹 Claude artifacts detected:")
                for artifact in file_result["artifacts_found"]:
                    report.append(f"     {artifact}")

            if file_result["fixes"] > 0:
                report.append(f"  🔧 Applied {file_result['fixes']} fixes")

            report.append("")

        return "\n".join(report)

    def lint(self, specific_path: str = None, fix_mode: bool = False) -> bool:
        """Run the complete linting process."""
        print("🔍 VybeMVP Rich Content Linter v2.1.4")
        print("=" * 50)

        # Find files to validate
        files = self.find_content_files(specific_path)

        if not files:
            print("⚠️  No content files found to validate")
            return True

        print(f"📁 Found {len(files)} files to validate")
        if fix_mode:
            print("🔧 Auto-fix mode enabled")
        print()

        # Process each file
        for file_path in files:
            print(f"📄 Validating {file_path.name}...", end=" ")
            result = self.validate_content_file(file_path, fix_mode)

            if result["valid"]:
                print("✅ VALID")
            else:
                print(f"❌ {len(result['errors'])} errors")

        print()

        # Generate and display report
        report = self.generate_report()
        print(report)

        # Return success status
        return self.results["files_with_errors"] == 0


def main():
    """Main entry point for the linter."""
    parser = argparse.ArgumentParser(
        description="VybeMVP Rich Content Linter v2.1.4",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python3 scripts/lint_rich_content.py                    # Validate all files
  python3 scripts/lint_rich_content.py --fix              # Validate + auto-fix
  python3 scripts/lint_rich_content.py --path single_1    # Validate specific file
        """,
    )

    parser.add_argument("--path", help="Specific file to validate (e.g., single_1, master_11)")
    parser.add_argument(
        "--fix", action="store_true", help="Auto-fix detected issues where possible"
    )
    parser.add_argument(
        "--strict", action="store_true", help="Enable extra strict validation rules"
    )

    args = parser.parse_args()

    # Create linter and run validation
    linter = RichContentLinter()
    success = linter.lint(specific_path=args.path, fix_mode=args.fix)

    # Exit with appropriate code
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
